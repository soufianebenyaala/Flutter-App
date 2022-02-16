class PopularModel {
  String image;
  int color;

  PopularModel(this.image, this.color);
}

List<int> categoriesColors = [0xFFFEF1ED, 0xFFEDF6FE, 0xFFFEF6E8, 0xFFEAF8E8];

List<PopularModel> populars = [
  PopularModel("assets/images/img_beach.png", 0xFFFEF1ED),
  PopularModel("assets/images/img_mountain.png", 0xFFEDF6FE),
  PopularModel("assets/images/img_lake.png", 0xFFFEF6E8),
  PopularModel("assets/images/img_river.png", 0xFFEAF8E8),
];
var popularsData = [
  {"image": "assets/images/img_beach.png", "color": 0xFFFEF1ED},
  {"image": "assets/images/img_mountain.png", "color": 0xFFEDF6FE},
  {"image": "assets/images/img_lake.png", "color": 0xFFFEF6E8},
  {"image": "assets/images/img_river.png", "color": 0xFFEAF8E8},
];
