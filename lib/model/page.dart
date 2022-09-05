

class Page<T> {

  const Page(this.items, this.nextPageKey);

  final List<T> items;
  final int? nextPageKey;

}