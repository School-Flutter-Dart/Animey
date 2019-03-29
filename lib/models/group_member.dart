// To parse this JSON data, do
//
//     final groupMember = groupMemberFromJson(jsonString);

import 'dart:convert';
import 'link.dart';
import 'links.dart';
import 'group.dart';

GroupMember groupMemberFromJson(String str) {
  final jsonData = json.decode(str);
  return GroupMember.fromJson(jsonData);
}

String groupMemberToJson(GroupMember data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class GroupMember {
  String id;
  String type;
  Link link;
  Attributes attributes;
  Relationships relationships;
  Group group;

  GroupMember({
    this.id,
    this.type,
    this.link,
    this.attributes,
    this.relationships,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) => new GroupMember(
    id: json["id"] == null ? null : json["id"],
    type: json["type"] == null ? null : json["type"],
    link: json["links"] == null ? null : Link.fromJson(json["links"]),
    attributes: json["attributes"] == null ? null : Attributes.fromJson(json["attributes"]),
    relationships: json["relationships"] == null ? null : Relationships.fromJson(json["relationships"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "type": type == null ? null : type,
    "links": link == null ? null : link.toJson(),
    "attributes": attributes == null ? null : attributes.toJson(),
    "relationships": relationships == null ? null : relationships.toJson(),
  };
}

class Attributes {
  int unreadCount;

  Attributes({
    this.unreadCount,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => new Attributes(
    unreadCount: json["unreadCount"] == null ? null : json["unreadCount"],
  );

  Map<String, dynamic> toJson() => {
    "unreadCount": unreadCount == null ? null : unreadCount,
  };
}

class Relationships {
  Relationship group;

  Relationships({
    this.group,
  });

  factory Relationships.fromJson(Map<String, dynamic> json) => new Relationships(
    group: json["group"] == null ? null : Relationship.fromJson(json["group"]),
  );

  Map<String, dynamic> toJson() => {
    "group": group == null ? null : group.toJson(),
  };
}

class Relationship {
  Links links;
  Data data;

  Relationship({
    this.links,
    this.data,
  });

  factory Relationship.fromJson(Map<String, dynamic> json) => new Relationship(
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "links": links == null ? null : links.toJson(),
    "data": data == null ? null : data.toJson(),
  };
}

class Data {
  String type;
  String id;

  Data({
    this.type,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => new Data(
    type: json["type"] == null ? null : json["type"],
    id: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toJson() => {
    "type": type == null ? null : type,
    "id": id == null ? null : id,
  };
}
