class Survey {
  final String title;
  final String subject;
  final String createdAt;
  List<String> like;
  List<String> dislike;

  Survey({this.title, this.subject, this.createdAt, this.like, this.dislike});

  factory Survey.fromJson(Map<String, dynamic> map, {String id}) => Survey(
      title: map["titre"],
      subject: map["subject"],
      createdAt: map["createdAt"],
      like: map["likes"] == null
          ? []
          : map["likes"].map<String>((i) => i as String).toList(),
      dislike: map["dislike"] == null
          ? []
          : map["dislike"].map<String>((i) => i as String).toList());

  Map<String, dynamic> toMap() {
    return {
      "titre": title,
      "subject": subject,
      "createdAt": createdAt,
      "like": like,
      "dislike": dislike,
    };
  }
}