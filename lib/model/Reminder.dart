class Reminder{
  String title;
  String time;
  String userId;
  String date;
  late String id;

  Reminder({required this.title, required this.time, required this.userId, required this.date}){
    id = userId + DateTime.now().millisecondsSinceEpoch.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time,
      'userId': userId,
      'date': date,
    };
  }
  static Reminder fromJson(Map<String, dynamic> json) {
    return Reminder(title: json['title'], time: json['time'], userId: json['userId'], date: json['date']);
  }
}