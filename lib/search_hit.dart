
class SearchHit {

  final String objectID;
  final String name;
  final String image;
  final List<String> image_urls;

  SearchHit(this.objectID, this.name, this.image, this.image_urls);

  static SearchHit fromJson(Map<String, dynamic> json) {
    return SearchHit(json['objectID'], json['name'], json['image_urls'][0], List<String>.from(json['image_urls']));
  }
}