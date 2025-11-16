class BookModel {
  BookModel({
    required this.userName,
    required this.userCity,
    required this.userImage,
    required this.coverImageUrlI,
    required this.userId,
    required this.coverImageUrl,
    required this.title,
    required this.author,
    required this.category,
    required this.description,
    required this.condition,
    required this.offerType,
    required this.userCountry,
    required this.userCreatedAt,
    required this.url,
    required this.favLocation,
    this.price,
  });
  final int? price;
  final String userId;
  final String userCity;
  final String coverImageUrl;
  final String coverImageUrlI;
  final String userName;
  final String userImage;
  final String title;
  final String author;
  final String category;
  final String description;
  final String condition;
  final String offerType;
  final String userCountry;
  final String userCreatedAt;
  final String url;
  final String favLocation;

  Map<String, dynamic> toJson() {
    return {
      'country': userCountry,
      'city': userCity,
      'price': price,
      'user_image': userImage,
      'user_name': userName,
      'user_id': userId,
      'cover_image_url': coverImageUrl,
      'title': title,
      'author': author,
      'category': category,
      'description': description,
      'condition': condition,
      'offer_type': offerType,
      'cover_book_url2': coverImageUrlI,
      'user_created_at': userCreatedAt,
      'fav_location': favLocation,
      'location_url': url,
    };
  }
}
