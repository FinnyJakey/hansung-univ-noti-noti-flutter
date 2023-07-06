class NonSubjectModel {
  final String title;
  final String? coverUrl;
  final String dept;
  final String link;
  final String dayRemain;
  final int? point;
  final String dateApply;
  final String dateOperate;
  final String admitted;

  const NonSubjectModel({
    required this.title,
    this.coverUrl,
    required this.dept,
    required this.link,
    required this.dayRemain,
    this.point,
    required this.dateApply,
    required this.dateOperate,
    required this.admitted,
  });
}
