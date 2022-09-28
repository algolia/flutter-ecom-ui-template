enum Sorting {
  mostPopular(
    'STAGING_native_ecom_demo_products',
    'Most popular',
  ),
  priceLowToHigh(
    'STAGING_native_ecom_demo_products_products_price_asc',
    'Price Low to High',
  ),
  priceHighToLow(
    'STAGING_native_ecom_demo_products_products_price_desc',
    'Price High to Low',
  );

  const Sorting(this.indexName, this.title);

  final String indexName;
  final String title;

  static Sorting of(String name) {
    return Sorting.values.firstWhere((element) => element.indexName == name);
  }
}
