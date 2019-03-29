// To parse this JSON data, do
//
//     final mediaReactionVotesRelationships = mediaReactionVotesRelationshipsFromJson(jsonString);

import 'dart:convert';
import 'links.dart';

MediaReactionVotesRelationships mediaReactionVotesRelationshipsFromJson(String str) {
  final jsonData = json.decode(str);
  return MediaReactionVotesRelationships.fromJson(jsonData);
}

String mediaReactionVotesRelationshipsToJson(MediaReactionVotesRelationships data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class MediaReactionVotesRelationships {
  Links links;
  List<Datum> data;

  MediaReactionVotesRelationships({
    this.links,
    this.data,
  });

  factory MediaReactionVotesRelationships.fromJson(Map<String, dynamic> json) => new MediaReactionVotesRelationships(
    links: Links.fromJson(json["links"]),
    data: new List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "links": links.toJson(),
    "data": new List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Type type;
  String id;

  Datum({
    this.type,
    this.id,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => new Datum(
    type: typeValues.map[json["type"]],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "type": typeValues.reverse[type],
    "id": id,
  };
}

enum Type { MEDIA_REACTION_VOTES }

final typeValues = new EnumValues({
  "mediaReactionVotes": Type.MEDIA_REACTION_VOTES
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
