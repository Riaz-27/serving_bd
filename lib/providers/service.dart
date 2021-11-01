import '../providers/sub_category.dart';

class Service {
  final String name;
  final String imageUrl;
  final String categoryName;
  final List<SubCategory> subCategory;

  Service({
    required this.name,
    required this.imageUrl,
    required this.categoryName,
    required this.subCategory,
  });
}
