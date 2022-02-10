
class SearchHit {

  final String objectID;
  final String name;
  final String image;

  SearchHit(this.objectID, this.name, this.image);

  static SearchHit fromJson(Map<String, dynamic> json) {
    return SearchHit(json['objectID'], json['name'], json['image_urls'][0]);
  }
}