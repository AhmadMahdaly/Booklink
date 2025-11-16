import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { create } from "https://deno.land/x/djwt@v2.8/mod.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";  
import { corsHeaders } from "../_shared/cors.ts";

// إنشاء عميل Supabase خاص بالخادم
const supabaseAdmin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

// متغيرات المصادقة مع Google
let accessToken: string | null = null;
let tokenExpiry: Date | null = null;

/**
 * تحويل مفتاح الخدمة إلى CryptoKey
 */
async function importPrivateKey(pem: string): Promise<CryptoKey> {
  const pemContents = pem.replace(/-----BEGIN PRIVATE KEY-----/, "")
    .replace(/-----END PRIVATE KEY-----/, "")
    .replace(/\s+/g, "");

  const binaryDer = Uint8Array.from(atob(pemContents), (c) =>
    c.charCodeAt(0)
  );

  return await crypto.subtle.importKey(
    "pkcs8",
    binaryDer.buffer,
    {
      name: "RSASSA-PKCS1-v1_5",
      hash: "SHA-256",
    },
    false,
    ["sign"],
  );
}

async function getAccessToken(): Promise<string> {
  if (accessToken && tokenExpiry && new Date() < tokenExpiry) return accessToken;

  console.log("🔑 Generating new Google OAuth2 access token...");

  const serviceAccount = JSON.parse(
    Deno.env.get("GOOGLE_SERVICE_ACCOUNT_JSON")!,
  );

  const now = Math.floor(Date.now() / 1000);
  const privateKeyPem = serviceAccount.private_key.replace(/\\n/g, "\n");
  const cryptoKey = await importPrivateKey(privateKeyPem);

  const jwt = await create(
    { alg: "RS256", typ: "JWT" },
    {
      iss: serviceAccount.client_email,
      // 💡 ملاحظة: الكود الخاص بك يستخدم 'firebase.messaging'، الكود السابق كان 'cloud-platform'
      // كلاهما يجب أن يعمل، لكن 'firebase.messaging' هو الـ scope الأصح.
      scope: "https://www.googleapis.com/auth/firebase.messaging",
      aud: "https://oauth2.googleapis.com/token",
      exp: now + 3500,
      iat: now,
    },
    cryptoKey,
  );

  const response = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body:
      `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${jwt}`,
  });

  if (!response.ok) {
    throw new Error(`Failed to get access token: ${await response.text()}`);
  }

  const data = await response.json();
  accessToken = data.access_token;
  tokenExpiry = new Date(Date.now() + (data.expires_in * 1000) - 10000);

  console.log("✅ Successfully generated new access token.");
  return accessToken!;
}


async function getFcmTokenFromSupabase(recipientId: string): Promise<string> {
  console.log(`📱 Fetching FCM token for user: ${recipientId}`);

  // 💡 ملاحظة: تأكد من أن جدول `fcm_tokens` موجود وأنك تحفظ الـ tokens فيه
  // الكود السابق كان يحفظ في جدول `users`.
  const { data, error } = await supabaseAdmin
    .from("fcm_tokens") // هذا هو الجدول الصحيح بناءً على الكود الجديد
    .select("token, platform, updated_at")
    .eq("user_id", recipientId)
    .order("updated_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (error) {
    console.error("❌ Supabase query error:", error);
    throw new Error(
      `Supabase DB error for user ${recipientId}: ${error.message}`,
    );
  }

  if (!data || !data.token) {
    console.error(`❌ FCM token not found for user ${recipientId}`);
    throw new Error(`FCM token not found in Supabase DB for user ${recipientId}.`);
  }

  console.log(`✅ FCM token found for user ${recipientId} (${data.platform})`);
  return data.token;
}

async function sendFcmMessageWithRetry(
  fcmToken: string,
  messageData: { [key: string]: string },
  priority: "high" | "normal" = "high",
  retries = 3
) {
  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      return await sendFcmMessage(fcmToken, messageData, priority);
    } catch (error) {
      if (attempt === retries) throw error;
      await new Promise(resolve => setTimeout(resolve, 1000 * attempt)); 
    }
  }
}
async function sendFcmMessage(
  fcmToken: string,
  messageData: { [key: string]: string },
  priority: "high" | "normal" = "high"
) {
  const googleAuthToken = await getAccessToken();
  // 💡 تأكد من إضافة GOOGLE_PROJECT_ID إلى الأسرار (Secrets) في Supabase
  const projectId = Deno.env.get("GOOGLE_PROJECT_ID")!;
  const fcmApiUrl = `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`;

  let androidConfig = {};
  let apnsConfig = {};
  
  if (messageData.type === 'incoming_call') {
    // ... (الكود الخاص بك للمكالمات كما هو) ...
    androidConfig = {
      // priority: "high",
      ttl: "30s",
      notification: {
        channel_id: "incoming_call_channel",
        visibility: "public",
        sound: "ringtone",
      },
      data: messageData,
    };
    apnsConfig = {
      headers: {
        "apns-priority": "10",
        "apns-push-type": "alert",
      },
      payload: {
        aps: {
          alert: {
            title: "مكالمة واردة",
            body: `مكالمة من ${messageData.callerName || 'Unknown'}`,
          },
          badge: 1,
          sound: "ringtone.caf",
          category: "call_category",
          "interruption-level": "critical",
        },
        data: messageData,
      },
    };
  } else {
    // --- ⬇️ بداية التعديل ⬇️ ---
    // هنا نحدد العنوان والنص بناءً على نوع الإشعار
    
    let alertTitle = "تحديث"; // عنوان افتراضي
    let alertBody = "لديك تحديث جديد"; // نص افتراضي

    if (messageData.type === 'new_chat_message') {
      alertTitle = messageData.sender_name || 'رسالة جديدة';
      alertBody = messageData.content || '...';
    } else if (messageData.title || messageData.body) {
      // هذا يعالج 'lesson_update' وأي نوع آخر يرسل title/body
      alertTitle = messageData.title || alertTitle;
      alertBody = messageData.body || alertBody;
    }
    // --- ⬆️ نهاية التعديل ⬆️ ---

    androidConfig = {
      priority: priority,
      notification: {
        channel_id: "high_importance_channel",
        // priority: "high",
        // --- ⬇️ إضافة ⬇️ ---
        // إضافة العنوان والنص للأندرويد أيضاً
        title: alertTitle,
        body: alertBody,
        sound: "default",
        // --- ⬆️ نهاية الإضافة ⬆️ ---
      },
      data: messageData,
    };

    apnsConfig = {
      headers: {
        "apns-priority": "5", // 5 (normal) or 10 (high)
      },
      payload: {
        aps: {
          alert: {
            // --- ⬇️ تعديل ⬇️ ---
            title: alertTitle,
            body: alertBody,
            // --- ⬆️ نهاية التعديل ⬆️ ---
          },
          badge: 1,
          sound: "default",
        },
        data: messageData,
      },
    };
  }

  const messagePayload = {
    message: {
      token: fcmToken,
      data: messageData,
      // --- ⬇️ تعديل ⬇️ ---
      // إرسال إعدادات Android و APNS لكل الرسائل
      // (الكود الأصلي كان يرسلها فقط في messagePayload منفصل)
      android: androidConfig,
      apns: apnsConfig,
      // --- ⬆️ نهاية التعديل ⬆️ ---
    },
  };

  console.log("📤 Sending FCM message:", JSON.stringify(messagePayload, null, 2));

  const fcmResponse = await fetch(fcmApiUrl, {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${googleAuthToken}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(messagePayload),
  });

  if (!fcmResponse.ok) {
    const errorText = await fcmResponse.text();
    console.error("❌ FCM API Error:", errorText);
    throw new Error(`FCM API Error: ${errorText}`);
  }

  const responseData = await fcmResponse.json();
  console.log("✅ FCM message sent successfully:", responseData);
  return responseData;
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const body = await req.json();
    console.log("📥 Received request body:", body);
    
    const { recipientId, type } = body;

    if (!recipientId) throw new Error("Recipient ID is required.");
    if (!type) throw new Error("Notification type is required.");

    const fcmToken = await getFcmTokenFromSupabase(recipientId);

    let messageData: { [key: string]: string } = { type };
    let priority: "high" | "normal" = "normal";

    if (type === 'incoming_call') {
      const { callerName, offerSdp, callerId, lessonId } = body;
      if (!callerId) throw new Error("callerId is required for incoming_call");

      messageData = {
        ...messageData,
        callerId: String(callerId),
        callerName: String(callerName ?? "مكالمة واردة"),
        offerSdp: String(offerSdp ?? ""),
        lessonId: String(lessonId ?? ""),
        calleeId: String(recipientId),
      };
      priority = "high";
    } else if (type === 'lesson_update') {
      const { title, body: messageBody } = body;
      messageData = {
        ...messageData,
        title: String(title ?? "تحديث الدرس"),
        body: String(messageBody ?? "لديك تحديث جديد في الدرس"),
      };
    } else if (type === 'call_answered') {
      const { answererId } = body;
      if (!answererId) throw new Error("answererId is required for call_answered");
      
      messageData = {
        ...messageData,
        answererId: String(answererId),
        status: 'answered',
      };
      priority = "high";
    } else if (type === 'hangup') {
      const { callerId, reason } = body;
      if (!callerId) throw new Error("callerId is required for hangup");

      messageData = {
        ...messageData,
        callerId: String(callerId),
        reason: String(reason ?? "ended"),
        calleeId: String(recipientId),
      };
      priority = "high";
      
    } else if (type === 'ring_sequence') {
      // ... (الكود الخاص بك لـ ring_sequence كما هو) ...
      const { callerId, callerName, lessonId, repeatCount = 5, intervalMs = 5000 } = body;

      if (!callerId) throw new Error("callerId is required for ring_sequence");

      messageData = {
        type: 'incoming_call', // لا يزال يستخدم نوع مكالمة واردة
        callerId: String(callerId),
        callerName: String(callerName ?? "مكالمة واردة"),
        lessonId: String(lessonId ?? ""),
        calleeId: String(recipientId),
      };

      priority = "high";

      console.log(`🔔 بدء إرسال ${repeatCount} رنات متتابعة للمستخدم ${recipientId}`);

      for (let i = 0; i < repeatCount; i++) {
        try {
          await sendFcmMessageWithRetry(fcmToken, messageData, priority);
          console.log(`✅ تم إرسال الرنة رقم ${i + 1}`);
        } catch (err) {
          console.error(`❌ فشل في الرنة رقم ${i + 1}:`, err);
        }
        if (i < repeatCount - 1) {
          await new Promise((resolve) => setTimeout(resolve, intervalMs));
        }
      }

      return new Response(
        JSON.stringify({
          success: true,
          message: `تم إرسال ${repeatCount} رنة متتابعة للمستخدم ${recipientId}`,
        }),
        {
          headers: { ...corsHeaders, "Content-Type": "application/json" },
          status: 200,
        },
      );
    
    // --- ⬇️ بداية الإضافة ⬇️ ---
    } else if (type === 'new_chat_message') {
      const { sender_name, content, conversation_id } = body;
      if (!sender_name) throw new Error("sender_name is required for new_chat_message");
      if (!content) throw new Error("content is required for new_chat_message");
      if (!conversation_id) throw new Error("conversation_id is required for new_chat_message");

      messageData = {
        ...messageData,
        sender_name: String(sender_name),
        content: String(content),
        conversation_id: String(conversation_id),
        screen: 'chat_conversation', // اسم الشاشة لفتحها في فلاتر
      };
      priority = "high"; // رسائل الشات ذات أولوية عالية
    // --- ⬆️ نهاية الإضافة ⬆️ ---

    } else {
      throw new Error(`Unsupported notification type: ${type}`);
    }

    const fcmResult = await sendFcmMessageWithRetry(fcmToken, messageData, priority);

    // ... (الكود الخاص بك لتسجيل الإشعارات كما هو) ...
    try {
      await supabaseAdmin.from('notification_logs').insert({
        recipient_id: recipientId,
        notification_type: type,
        status: 'sent',
        fcm_response: fcmResult,
        sent_at: new Date().toISOString(),
      });
    } catch (logError) {
      console.warn("⚠️ Failed to log notification:", logError);
    }

    return new Response(
      JSON.stringify({ 
        success: true, 
        data: fcmResult,
        message: `Notification sent successfully to ${recipientId}` 
      }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 200 },
    );
  } catch (error) {
    console.error("❌ Error in FCM function:", error);
    
    // ... (الكود الخاص بك لتسجيل الأخطاء كما هو) ...
    try {
      // حاول قراءة الجسم مرة أخرى، قد يفشل إذا لم يكن JSON صالحاً
      let reqBody = {};
      try { reqBody = await req.json(); } catch(e) { /* ignore */ }
      
      await supabaseAdmin.from('notification_logs').insert({
        recipient_id: reqBody.recipientId || 'unknown',
        notification_type: reqBody.type || 'unknown',
        status: 'failed',
        error_message: error.message,
        sent_at: new Date().toISOString(),
      });
    } catch (logError) {
      console.warn("⚠️ Failed to log error:", logError);
    }

    return new Response(
      JSON.stringify({ 
        success: false, 
        error: error.message,
        timestamp: new Date().toISOString() 
      }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 500 },
    );
  }
});