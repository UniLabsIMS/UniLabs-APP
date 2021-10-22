class Item {
  String id;
  String state;
  String parentDisplayItemName;
  String parentDisplayItemImageURL;
  String parentDisplayItemDescription;
  String categoryName;
  String labName;

  Item({
    this.id,
    this.state,
    this.parentDisplayItemName,
    this.parentDisplayItemImageURL,
    this.parentDisplayItemDescription,
    this.categoryName,
    this.labName,
  });

  Item clone() {
    return Item(
      id: id,
      state: state,
      parentDisplayItemName: parentDisplayItemName,
      parentDisplayItemImageURL: parentDisplayItemImageURL,
      parentDisplayItemDescription: parentDisplayItemDescription,
      categoryName: categoryName,
      labName: labName,
    );
  }
}
