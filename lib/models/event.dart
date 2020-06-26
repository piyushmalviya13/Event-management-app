import 'package:firebase_database/firebase_database.dart';

class Newevent {
  String key;
  String date;
  String time;
  String venue;
  String topic;
  String audience;
  String speaker;
  bool permission;
  bool eventReport;
  String details;
  String imageUrl;

  Newevent(
      this.date,
      this.time,
      this.venue,
      this.topic,
      this.audience,
      this.permission,
      this.eventReport,
      this.speaker,
      this.details,
      this.imageUrl);

  Newevent.fromEvent(Newevent event) {
    this.date = event.date;
    this.time = event.time;
    this.venue = event.venue;
    this.topic = event.topic;
    this.audience = event.audience;
    this.permission = event.permission;
    this.eventReport = event.eventReport;
    this.speaker = event.speaker;
    this.details = event.details;
    this.imageUrl = event.imageUrl;
  }

  Newevent.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        date = snapshot.value["date"],
        time = snapshot.value["time"],
        venue = snapshot.value["venue"],
        audience = snapshot.value["audience"],
        topic = snapshot.value["topic"],
        permission = snapshot.value["permission"],
        eventReport = snapshot.value["eventReport"],
        speaker = snapshot.value["speaker"],
        details = snapshot.value["details"],
        imageUrl = snapshot.value["imageUrl"];

  toJson() {
    return {
      "date": date,
      "time": time,
      "venue": venue,
      "topic": topic,
      "audience": audience,
      "permission": permission,
      "eventReport": eventReport,
      "speaker": speaker,
      "details": details,
      "imageUrl": imageUrl,
    };
  }
}
