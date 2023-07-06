class NoticeModel {
  final String title;
  final bool fixed;
  final String number;
  final String link;
  final String dept;
  final String date;
  final bool newPost;

  const NoticeModel({
    required this.title,
    required this.fixed,
    required this.number,
    required this.link,
    required this.dept,
    required this.date,
    required this.newPost,
  });
}
