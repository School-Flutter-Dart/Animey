// To parse this JSON data, do
//
//     final group = groupFromJson(jsonString);

import 'dart:convert';
import 'link.dart';

Group groupFromJson(String str) {
  final jsonData = json.decode(str);
  return Group.fromJson(jsonData);
}

String groupToJson(Group data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Group {
  String id;
  String type;
  Link link;
  Attributes attributes;

  Group({
    this.id,
    this.type,
    this.link,
    this.attributes,
  });

  factory Group.fromJson(Map<String, dynamic> json) => new Group(
    id: json["id"] == null ? null : json["id"],
    type: json["type"] == null ? null : json["type"],
    link: json["links"] == null ? null : Link.fromJson(json["links"]),
    attributes: json["attributes"] == null ? null : Attributes.fromJson(json["attributes"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "type": type == null ? null : type,
    "links": link == null ? null : link.toJson(),
    "attributes": attributes == null ? null : attributes.toJson(),
  };
}

class Attributes {
  String name;
  String slug;
  Avatar avatar;

  Attributes({
    this.name,
    this.slug,
    this.avatar,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => new Attributes(
    name: json["name"] == null ? null : json["name"],
    slug: json["slug"] == null ? null : json["slug"],
    avatar: json["avatar"] == null ? null : Avatar.fromJson(json["avatar"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "slug": slug == null ? null : slug,
    "avatar": avatar == null ? null : avatar.toJson(),
  };
}

class Avatar {
  String tiny;
  String small;
  String medium;
  String large;
  String original;
  Meta meta;

  Avatar({
    this.tiny,
    this.small,
    this.medium,
    this.large,
    this.original,
    this.meta,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) => new Avatar(
    tiny: json["tiny"] == null ? null : json["tiny"],
    small: json["small"] == null ? null : json["small"],
    medium: json["medium"] == null ? null : json["medium"],
    large: json["large"] == null ? null : json["large"],
    original: json["original"] == null ? null : json["original"],
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "tiny": tiny == null ? null : tiny,
    "small": small == null ? null : small,
    "medium": medium == null ? null : medium,
    "large": large == null ? null : large,
    "original": original == null ? null : original,
    "meta": meta == null ? null : meta.toJson(),
  };
}

class Meta {
  Dimensions dimensions;

  Meta({
    this.dimensions,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => new Meta(
    dimensions: json["dimensions"] == null ? null : Dimensions.fromJson(json["dimensions"]),
  );

  Map<String, dynamic> toJson() => {
    "dimensions": dimensions == null ? null : dimensions.toJson(),
  };
}

class Dimensions {
  Large tiny;
  Large small;
  Large medium;
  Large large;

  Dimensions({
    this.tiny,
    this.small,
    this.medium,
    this.large,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) => new Dimensions(
    tiny: json["tiny"] == null ? null : Large.fromJson(json["tiny"]),
    small: json["small"] == null ? null : Large.fromJson(json["small"]),
    medium: json["medium"] == null ? null : Large.fromJson(json["medium"]),
    large: json["large"] == null ? null : Large.fromJson(json["large"]),
  );

  Map<String, dynamic> toJson() => {
    "tiny": tiny == null ? null : tiny.toJson(),
    "small": small == null ? null : small.toJson(),
    "medium": medium == null ? null : medium.toJson(),
    "large": large == null ? null : large.toJson(),
  };
}

class Large {
  dynamic width;
  dynamic height;

  Large({
    this.width,
    this.height,
  });

  factory Large.fromJson(Map<String, dynamic> json) => new Large(
    width: json["width"],
    height: json["height"],
  );

  Map<String, dynamic> toJson() => {
    "width": width,
    "height": height,
  };
}
