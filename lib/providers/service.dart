import '../providers/sub_category.dart';

class Service {
  final String name;
  final String subtitle;
  final String imageUrl;
  final int categoryIndex;
  final List<SubCategory> subCategory;
  final String subCategoryTitle;
  final int serviceIndex;

  Service({
    required this.name,
    required this.subtitle,
    required this.imageUrl,
    required this.categoryIndex,
    required this.subCategory,
    required this.subCategoryTitle,
    required this.serviceIndex,
  });
}
