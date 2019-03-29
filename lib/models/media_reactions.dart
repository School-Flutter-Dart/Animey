// To parse this JSON data, do
//
//     final mediaReactions = mediaReactionsFromJson(jsonString);

import 'dart:convert';
import 'links.dart';

MediaReactions mediaReactionsFromJson(String str) {
  final jsonData = json.decode(str);
  return MediaReactions.fromJson(jsonData);
}

String mediaReactionsToJson(MediaReactions data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class MediaReactions {
  List<Reaction> reactions;
  Meta meta;
  MediaReactionsLinks links;

  MediaReactions({
    this.reactions,
    this.meta,
    this.links,
  });

  factory MediaReactions.fromJson(Map<String, dynamic> json) => new MediaReactions(
    reactions: json["data"] == null ? null : new List<Reaction>.from(json["data"].map((x) => Reaction.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    links: json["links"] == null ? null : MediaReactionsLinks.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "data": reactions == null ? null : new List<dynamic>.from(reactions.map((x) => x.toJson())),
    "meta": meta == null ? null : meta.toJson(),
    "links": links == null ? null : links.toJson(),
  };
}

class Reaction {
  String id;
  String type;
  ReactionLinks links;
  Attributes attributes;
  Relationships relationships;

  Reaction({
    this.id,
    this.type,
    this.links,
    this.attributes,
    this.relationships,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) => new Reaction(
    id: json["id"] == null ? null : json["id"],
    type: json["type"] == null ? null : json["type"],
    links: json["links"] == null ? null : ReactionLinks.fromJson(json["links"]),
    attributes: json["attributes"] == null ? null : Attributes.fromJson(json["attributes"]),
    relationships: json["relationships"] == null ? null : Relationships.fromJson(json["relationships"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "type": type == null ? null : type,
    "links": links == null ? null : links.toJson(),
    "attributes": attributes == null ? null : attributes.toJson(),
    "relationships": relationships == null ? null : relationships.toJson(),
  };
}

class Attributes {
  String createdAt;
  String updatedAt;
  String reaction;
  int upVotesCount;

  Attributes({
    this.createdAt,
    this.updatedAt,
    this.reaction,
    this.upVotesCount,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => new Attributes(
    createdAt: json["createdAt"] == null ? null : json["createdAt"],
    updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
    reaction: json["reaction"] == null ? null : json["reaction"],
    upVotesCount: json["upVotesCount"] == null ? null : json["upVotesCount"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt == null ? null : createdAt,
    "updatedAt": updatedAt == null ? null : updatedAt,
    "reaction": reaction == null ? null : reaction,
    "upVotesCount": upVotesCount == null ? null : upVotesCount,
  };
}

class ReactionLinks {
  String self;

  ReactionLinks({
    this.self,
  });

  factory ReactionLinks.fromJson(Map<String, dynamic> json) => new ReactionLinks(
    self: json["self"] == null ? null : json["self"],
  );

  Map<String, dynamic> toJson() => {
    "self": self == null ? null : self,
  };
}

class Relationships {
  Media anime;
  Media drama;
  Media manga;
  Media user;
  Media libraryEntry;
  Media votes;

  Relationships({
    this.anime,
    this.drama,
    this.manga,
    this.user,
    this.libraryEntry,
    this.votes,
  });

  factory Relationships.fromJson(Map<String, dynamic> json) => new Relationships(
    anime: json["anime"] == null ? null : Media.fromJson(json["anime"]),
    drama: json["drama"] == null ? null : Media.fromJson(json["drama"]),
    manga: json["manga"] == null ? null : Media.fromJson(json["manga"]),
    user: json["user"] == null ? null : Media.fromJson(json["user"]),
    libraryEntry: json["libraryEntry"] == null ? null : Media.fromJson(json["libraryEntry"]),
    votes: json["votes"] == null ? null : Media.fromJson(json["votes"]),
  );

  Map<String, dynamic> toJson() => {
    "anime": anime == null ? null : anime.toJson(),
    "drama": drama == null ? null : drama.toJson(),
    "manga": manga == null ? null : manga.toJson(),
    "user": user == null ? null : user.toJson(),
    "libraryEntry": libraryEntry == null ? null : libraryEntry.toJson(),
    "votes": votes == null ? null : votes.toJson(),
  };
}

class Media {
  Links links;

  Media({
    this.links,
  });

  factory Media.fromJson(Map<String, dynamic> json) => new Media(
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "links": links == null ? null : links.toJson(),
  };
}

class MediaReactionsLinks {
  String first;
  String last;

  MediaReactionsLinks({
    this.first,
    this.last,
  });

  factory MediaReactionsLinks.fromJson(Map<String, dynamic> json) => new MediaReactionsLinks(
    first: json["first"] == null ? null : json["first"],
    last: json["last"] == null ? null : json["last"],
  );

  Map<String, dynamic> toJson() => {
    "first": first == null ? null : first,
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
