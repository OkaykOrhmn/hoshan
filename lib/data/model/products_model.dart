import 'package:hoshan/core/gen/assets.gen.dart';

class ProductsModel {
  final String title;
  final String description;
  final AssetGenImage image;
  final String? link;

  ProductsModel(
      {required this.title,
      required this.description,
      required this.image,
      this.link});
}
