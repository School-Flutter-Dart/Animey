// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'links.dart';
import 'link.dart';


///The "type" from Kitsu API is "users" instead of "user", weird

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

const String NullAvatarUrl = "https://kitsu.io/images/default_avatar-ff0fd0e960e61855f9fc4a2c5d994379.png";


class User {
  String id;
  String type;
  Link link;
  Attributes attributes;
  Map<String, Relationship> relationships;

  ///to know whether or not this user has been followed
  bool isFollowed = false;
  String followId = "";


  User({
    this.id,
    this.type,
    this.link,
    this.attributes,
    this.relationships,
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
    id: json["id"] == null ? null : json["id"],
    type: json["type"] == null ? null : json["type"],
    link: json["links"] == null ? null : Link.fromJson(json["links"]),
    attributes: json["attributes"] == null ? null : Attributes.fromJson(json["attributes"]),
    relationships: json["relationships"] == null ? null : new Map.from(json["relationships"]).map((k, v) => new MapEntry<String, Relationship>(k, Relationship.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "type": type == null ? null : type,
    "links": link == null ? null : link.toJson(),
    "attributes": attributes == null ? null : attributes.toJson(),
    "relationships": relationships == null ? null : new Map.from(relationships).map((k, v) => new MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class Attributes {
  String createdAt;
  String updatedAt;
  String name;
  List<dynamic> pastNames;
  String slug;
  String about;
  String location;
  String waifuOrHusbando;
  int followersCount;
  int followingCount;
  int lifeSpentOnAnime;
  dynamic birthday;
  dynamic gender;
  int commentsCount;
  int favoritesCount;
  int likesGivenCount;
  int reviewsCount;
  int likesReceivedCount;
  int postsCount;
  int ratingsCount;
  int mediaReactionsCount;
  String proExpiresAt;
  dynamic title;
  bool profileCompleted;
  bool feedCompleted;
  String website;
  Avatar avatar;
  CoverImage coverImage;
  String status;
  bool subscribedToNewsletter;

  Attributes({
    this.createdAt,
    this.updatedAt,
    this.name,
    this.pastNames,
    this.slug,
    this.about,
    this.location,
    this.waifuOrHusbando,
    this.followersCount,
    this.followingCount,
    this.lifeSpentOnAnime,
    this.birthday,
    this.gender,
    this.commentsCount,
    this.favoritesCount,
    this.likesGivenCount,
    this.reviewsCount,
    this.likesReceivedCount,
    this.postsCount,
    this.ratingsCount,
    this.mediaReactionsCount,
    this.proExpiresAt,
    this.title,
    this.profileCompleted,
    this.feedCompleted,
    this.website,
    this.avatar,
    this.coverImage,
    this.status,
    this.subscribedToNewsletter,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => new Attributes(
    createdAt: json["createdAt"] == null ? null : json["createdAt"],
    updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
    name: json["name"] == null ? null : json["name"],
    pastNames: json["pastNames"] == null ? null : new List<dynamic>.from(json["pastNames"].map((x) => x)),
    slug: json["slug"] == null ? null : json["slug"],
    about: json["about"] == null ? null : json["about"],
    location: json["location"] == null ? null : json["location"],
    waifuOrHusbando: json["waifuOrHusbando"] == null ? null : json["waifuOrHusbando"],
    followersCount: json["followersCount"] == null ? null : json["followersCount"],
    followingCount: json["followingCount"] == null ? null : json["followingCount"],
    lifeSpentOnAnime: json["lifeSpentOnAnime"] == null ? null : json["lifeSpentOnAnime"],
    birthday: json["birthday"],
    gender: json["gender"],
    commentsCount: json["commentsCount"] == null ? null : json["commentsCount"],
    favoritesCount: json["favoritesCount"] == null ? null : json["favoritesCount"],
    likesGivenCount: json["likesGivenCount"] == null ? null : json["likesGivenCount"],
    reviewsCount: json["reviewsCount"] == null ? null : json["reviewsCount"],
    likesReceivedCount: json["likesReceivedCount"] == null ? null : json["likesReceivedCount"],
    postsCount: json["postsCount"] == null ? null : json["postsCount"],
    ratingsCount: json["ratingsCount"] == null ? null : json["ratingsCount"],
    mediaReactionsCount: json["mediaReactionsCount"] == null ? null : json["mediaReactionsCount"],
    proExpiresAt: json["proExpiresAt"] == null ? null : json["proExpiresAt"],
    title: json["title"],
    profileCompleted: json["profileCompleted"] == null ? null : json["profileCompleted"],
    feedCompleted: json["feedCompleted"] == null ? null : json["feedCompleted"],
    website: json["website"] == null ? null : json["website"],
    avatar: json["avatar"] == null ? Avatar(small: NullAvatarUrl, medium: NullAvatarUrl, large: NullAvatarUrl, original: NullAvatarUrl) : Avatar.fromJson(json["avatar"]),
    coverImage: json["coverImage"] == null ? null : CoverImage.fromJson(json["coverImage"]),
    status: json["status"] == null ? null : json["status"],
    subscribedToNewsletter: json["subscribedToNewsletter"] == null ? null : json["subscribedToNewsletter"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt == null ? null : createdAt,
    "updatedAt": updatedAt == null ? null : updatedAt,
    "name": name == null ? null : name,
    "pastNames": pastNames == null ? null : new List<dynamic>.from(pastNames.map((x) => x)),
    "slug": slug == null ? null : slug,
    "about": about == null ? null : about,
    "location": location == null ? null : location,
    "waifuOrHusbando": waifuOrHusbando == null ? null : waifuOrHusbando,
    "followersCount": followersCount == null ? null : followersCount,
    "followingCount": followingCount == null ? null : followingCount,
    "lifeSpentOnAnime": lifeSpentOnAnime == null ? null : lifeSpentOnAnime,
    "birthday": birthday,
    "gender": gender,
    "commentsCount": commentsCount == null ? null : commentsCount,
    "favoritesCount": favoritesCount == null ? null : favoritesCount,
    "likesGivenCount": likesGivenCount == null ? null : likesGivenCount,
    "reviewsCount": reviewsCount == null ? null : reviewsCount,
    "likesReceivedCount": likesReceivedCount == null ? null : likesReceivedCount,
    "postsCount": postsCount == null ? null : postsCount,
    "ratingsCount": ratingsCount == null ? null : ratingsCount,
    "mediaReactionsCount": mediaReactionsCount == null ? null : mediaReactionsCount,
    "proExpiresAt": proExpiresAt == null ? null : proExpiresAt,
    "title": title,
    "profileCompleted": profileCompleted == null ? null : profileCompleted,
    "feedCompleted": feedCompleted == null ? null : feedCompleted,
    "website": website == null ? null : website,
    "avatar": avatar == null ? null : avatar.toJson(),
    "coverImage": coverImage == null ? null : coverImage.toJson(),
    "status": status == null ? null : status,
    "subscribedToNewsletter": subscribedToNewsletter == null ? null : subscribedToNewsletter,
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

class CoverImage {
  String tiny;
  String small;
  String large;
  String original;
  Meta meta;

  CoverImage({
    this.tiny,
    this.small,
    this.large,
    this.original,
    this.meta,
  });

  factory CoverImage.fromJson(Map<String, dynamic> json) => new CoverImage(
    tiny: json["tiny"] == null ? null : json["tiny"],
    small: json["small"] == null ? null : json["small"],
    large: json["large"] == null ? null : json["large"],
    original: json["original"] == null ? null : json["original"],
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "tiny": tiny == null ? null : tiny,
    "small": small == null ? null : small,
    "large": large == null ? null : large,
    "original": original == null ? null : original,
    "meta": meta == null ? null : meta.toJson(),
  };
}

class Relationship {
  Links links;

  Relationship({
    this.links,
  });

  factory Relationship.fromJson(Map<String, dynamic> json) => new Relationship(
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
  );

  Map<String, dynamic> toJson() => {
    "links": links == null ? null : links.toJson(),
  };
}

