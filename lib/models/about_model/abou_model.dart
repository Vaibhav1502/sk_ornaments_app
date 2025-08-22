class AboutData {
  final String title;
  final String content;
  final String mission;
  final String vision;

  AboutData({
    required this.title,
    required this.content,
    required this.mission,
    required this.vision,
  });

  factory AboutData.fromJson(Map<String, dynamic> json) {
    return AboutData(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      mission: json['mission'] ?? '',
      vision: json['vision'] ?? '',
    );
  }
}
