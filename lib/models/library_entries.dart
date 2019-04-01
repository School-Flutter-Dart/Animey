// To parse this JSON data, do
//
//     final libraryEntriesData = libraryEntriesDataFromJson(jsonString);

import 'dart:convert';
import 'anime.dart';
import 'link.dart';
import 'links.dart';

LibraryEntriesData libraryEntriesDataFromJson(String str) {
  final jsonData = json.decode(str);
  return LibraryEntriesData.fromJson(jsonData);
}

String libraryEntriesDataToJson(LibraryEntriesData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class LibraryEntriesData {
  List<LibraryEntry> data;
  Meta meta;
  LibraryEntriesDataLinks links;

  LibraryEntriesData({
    this.data,
    this.meta,
    this.links,
  });

  factory LibraryEntriesData.fromJson(Map<String, dynamic> json) => new LibraryEntriesData(
    data: json["data"] == null ? null : new List<LibraryEntry>.from(json["data"].map((x) => LibraryEntry.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    links: json["links"] == null ? null : LibraryEntriesDataLinks.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : new List<dynamic>.from(data.map((x) => x.toJson())),
    "meta": meta == null ? null : meta.toJson(),
    "links": links == null ? null : links.toJson(),
  };
}

class LibraryEntry {
  String id;
  Type type;
  Link link;
  Attributes attributes;
  Relationships relationships;
  Anime anime;

  LibraryEntry({
    this.id,
    this.type,
    this.link,
    this.attributes,
    this.relationships,
  });

  factory LibraryEntry.fromJson(Map<String, dynamic> json) => new LibraryEntry(
    id: json["id"] == null ? null : json["id"],
    type: json["type"] == null ? null : typeValues.map[json["type"]],
    link: json["links"] == null ? null : Link.fromJson(json["links"]),
    attributes: json["attributes"] == null ? null : Attributes.fromJson(json["attributes"]),
    relationships: json["relationships"] == null ? null : Relationships.fromJson(json["relationships"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "type": type == null ? null : typeValues.reverse[type],
    "links": link == null ? null : link.toJson(),
    "attributes": attributes == null ? null : attributes.toJson(),
    "relationships": relationships == null ? null : relationships.toJson(),
  };
}

class Attributes {
  String createdAt;
  String updatedAt;
  Status status;
  int progress;
  int volumesOwned;
  bool reconsuming;
  int reconsumeCount;
  dynamic notes;
  bool private;
  ReactionSkipped reactionSkipped;
  String progressedAt;
  String startedAt;
  String finishedAt;
  String rating;
  dynamic ratingTwenty;

  Attributes({
    this.createdAt,
    this.updatedAt,
    this.status,
    this.progress,
    this.volumesOwned,
    this.reconsuming,
    this.reconsumeCount,
    this.notes,
    this.private,
    this.reactionSkipped,
    this.progressedAt,
    this.startedAt,
    this.finishedAt,
    this.rating,
    this.ratingTwenty,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => new Attributes(
    createdAt: json["createdAt"] == null ? null : json["createdAt"],
    updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
    status: json["status"] == null ? null : statusValues.map[json["status"]],
    progress: json["progress"] == null ? null : json["progress"],
    volumesOwned: json["volumesOwned"] == null ? null : json["volumesOwned"],
    reconsuming: json["reconsuming"] == null ? null : json["reconsuming"],
    reconsumeCount: json["reconsumeCount"] == null ? null : json["reconsumeCount"],
    notes: json["notes"],
    private: json["private"] == null ? null : json["private"],
    reactionSkipped: json["reactionSkipped"] == null ? null : reactionSkippedValues.map[json["reactionSkipped"]],
    progressedAt: json["progressedAt"] == null ? null : json["progressedAt"],
    startedAt: json["startedAt"] == null ? null : json["startedAt"],
    finishedAt: json["finishedAt"] == null ? null : json["finishedAt"],
    rating: json["rating"] == null ? null : json["rating"],
    ratingTwenty: json["ratingTwenty"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt == null ? null : createdAt,
    "updatedAt": updatedAt == null ? null : updatedAt,
    "status": status == null ? null : statusValues.reverse[status],
    "progress": progress == null ? null : progress,
    "volumesOwned": volumesOwned == null ? null : volumesOwned,
    "reconsuming": reconsuming == null ? null : reconsuming,
    "reconsumeCount": reconsumeCount == null ? null : reconsumeCount,
    "notes": notes,
    "private": private == null ? null : private,
    "reactionSkipped": reactionSkipped == null ? null : reactionSkippedValues.reverse[reactionSkipped],
    "progressedAt": progressedAt == null ? null : progressedAt,
    "startedAt": startedAt == null ? null : startedAt,
    "finishedAt": finishedAt == null ? null : finishedAt,
    "rating": rating == null ? null : rating,
    "ratingTwenty": ratingTwenty,
  };
}

enum ReactionSkipped { UNSKIPPED }

final reactionSkippedValues = new EnumValues({
  "unskipped": ReactionSkipped.UNSKIPPED
});

enum Status { COMPLETED, ONHOLD, CURRENT, DROPPED , PLANNED}
const Map<Status,String> StatusToStringMap={
  Status.COMPLETED:'Complete',
  Status.ONHOLD:'On Hold',
  Status.CURRENT:'Current',
  Status.DROPPED:'Dropped',
  Status.PLANNED:'Planned'
};

final statusValues = new EnumValues({
  "completed": Status.COMPLETED,
  "on_hold":Status.ONHOLD,
  "current":Status.CURRENT,
  "dropped":Status.DROPPED,
  "planned":Status.PLANNED,
});

class Relationships {
  Links user;
  Links anime;
  String animeId;
  Links manga;
  Links drama;
  Links review;
  Links mediaReaction;
  Links media;
  Links unit;
  Links nextUnit;

  Relationships({
    this.user,
    this.anime,
    this.animeId,
    this.manga,
    this.drama,
    this.review,
    this.mediaReaction,
    this.media,
    this.unit,
    this.nextUnit,
  });

  factory Relationships.fromJson(Map<String, dynamic> json) => new Relationships(
    user: json["user"] == null ? null : Links.fromJson(json["user"]["links"]),
    anime: json["anime"] == null ? null : Links.fromJson(json["anime"]["links"]),
    animeId: json["anime"]['data'] == null ? null : json["anime"]["data"]["id"],
    manga: json["manga"] == null ? null : Links.fromJson(json["manga"]["links"]),
    drama: json["drama"] == null ? null : Links.fromJson(json["drama"]["links"]),
    review: json["review"] == null ? null : Links.fromJson(json["review"]["links"]),
    mediaReaction: json["mediaReaction"] == null ? null : Links.fromJson(json["mediaReaction"]["links"]),
    media: json["media"] == null ? null : Links.fromJson(json["media"]["links"]),
    unit: json["unit"] == null ? null : Links.fromJson(json["unit"]["links"]),
    nextUnit: json["nextUnit"] == null ? null : Links.fromJson(json["nextUnit"]["links"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user == null ? null : user.toJson(),
    "anime": anime == null ? null : anime.toJson(),
    "manga": manga == null ? null : manga.toJson(),
    "drama": drama == null ? null : drama.toJson(),
    "review": review == null ? null : review.toJson(),
    "mediaReaction": mediaReaction == null ? null : mediaReaction.toJson(),
    "media": media == null ? null : media.toJson(),
    "unit": unit == null ? null : unit.toJson(),
    "nextUnit": nextUnit == null ? null : nextUnit.toJson(),
  };
}

enum Type { LIBRARY_ENTRIES }

final typeValues = new EnumValues({
  "libraryEntries": Type.LIBRARY_ENTRIES
});

class LibraryEntriesDataLinks {
  String first;
  String next;
  String last;

  LibraryEntriesDataLinks({
    this.first,
    this.next,
    this.last,
  });

  factory LibraryEntriesDataLinks.fromJson(Map<String, dynamic> json) => new LibraryEntriesDataLinks(
    first: json["first"] == null ? null : json["first"],
    next: json["next"] == null ? null : json["next"],
    last: json["last"] == null ? null : json["last"],
  );

  Map<String, dynamic> toJson() => {
    "first": first == null ? null : first,
    "next": next == null ? null : next,
    "last": last == null ? null : last,
  };
}

class Meta {
  int count;

  Meta({
    this.count,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => new Meta(
    count: json["count"] == null ? null : json["count"],
  );

  Map<String, dynamic> toJson() => {
    "count": count == null ? null : count,
  };
}

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
