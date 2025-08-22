class ContactModel {
  final String title;
  final String address;
  final String phone;
  final String email;
  final String workingHours;

  ContactModel({
    required this.title,
    required this.address,
    required this.phone,
    required this.email,
    required this.workingHours,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      title: json['title'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      workingHours: json['working_hours'] ?? '',
    );
  }
}
