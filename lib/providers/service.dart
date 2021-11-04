import '../providers/sub_category.dart';

class Service {
  final String name;
  final String subtitle;
  final String imageUrl;
  final String categoryName;
  final List<SubCategory> subCategory;
  final String subCategoryTitle;

  Service({
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    required this.categoryName,
    required this.subCategory,
    required this.subCategoryTitle,
  });
}
