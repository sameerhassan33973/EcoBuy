class Category {
  String? title;
  String? image;

  Category({required this.title, this.image});
}

List<Category> categories = [
  Category(title: "Grocery", image: "assets/c_images/grocery.jpg"),
  Category(title: "Cosmetics", image: "assets/c_images/cosmetics.jpg"),
  Category(title: "Garments", image: "assets/c_images/garments.jpg"),
  Category(title: "Electronics", image: "assets/c_images/electronics.jpg"),
  Category(title: "Pharmacy", image: "assets/c_images/pharmacy.jpg"),
];
