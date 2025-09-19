class BreadCrumb {
  const BreadCrumb({required this.label, this.caption});

  final String label;
  final String? caption;

  static List<BreadCrumb> fromList(List<String> labels) {
    return labels.map((item) => BreadCrumb(label: item)).toList();
  }
}
