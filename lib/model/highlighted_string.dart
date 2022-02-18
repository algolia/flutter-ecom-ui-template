class HighlightedString {
  HighlightedString(this.string, this.isHighlighted);

  String string;
  bool isHighlighted;

  @override
  String toString() {
    return (isHighlighted ? ">" : "") + string;
  }
}
