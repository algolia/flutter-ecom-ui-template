enum SortIndex {
  mostPopular(
    'Most popular',
    'STAGING_native_ecom_demo_products',
  ),
  priceLowToHigh(
    'Price Low to High',
    'STAGING_native_ecom_demo_products_products_price_asc',
  ),
  priceHighToLow(
    'Price High to Low',
    'STAGING_native_ecom_demo_products_products_price_desc',
  );

  const SortIndex(this.title, this.indexName);

  final String title;
  final String indexName;

  static SortIndex of(String name) {
    return SortIndex.values.firstWhere((element) => element.indexName == name);
  }
}
