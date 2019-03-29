// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:animey/database/database.dart';

import 'links.dart';

//Future<List<Data>> getTrendingAnimes() async{
//  var url = "https://kitsu.io/api/edge/trending/anime";
//  var response = await http.get(url);
//  var parsedData = welcomesFromJson(response.body);
//  parsedData.forEach((data)=>data.getGenre());
//  Future.;
//  return Future(parsedData);
//}


List<Anime> animesFromJson(String str){
  final jsonData = json.decode(str);
  List<Anime> animes =  (jsonData["data"] as List).map((data){ return Anime.fromJson(data);}).toList();
  return animes;
}

List<AnimeData> datasFromJson(String str){
  final jsonData = json.decode(str);
  List<AnimeData> datas =  (jsonData["data"]);
  return datas;
}

AnimeData dataFromJson(String str) {
  final jsonData = json.decode(str);
  return AnimeData.fromJson(jsonData);
}

String dataToJson(AnimeData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class AnimeData {
  int id;//an id is for local database use only
  Anime anime;
  DateTime finishDate;

  AnimeData({
    this.id,
    this.anime,
    this.finishDate
  });

  factory AnimeData.fromJson(Map<String, dynamic> json) => new AnimeData(
    id: json["id"]??0,
    anime: json["data"] == null ? null : Anime.fromJson(json["data"]),
    finishDate:json["finishDate"]==null?null:DateTime.parse(json["finishDate"]).toLocal()
  );

  factory AnimeData.fromDbJson(Map<String, dynamic> json)=> AnimeData(
      id: json["id"]??0,
      anime: json["data"] == null ? null : Anime.fromJson(jsonDecode(json["data"])),
      finishDate:json["finishDate"]==null?null:DateTime.parse(json["finishDate"]).toLocal()
  );

  Map<String, dynamic> toJson() => {
    "id":id,
    "data": anime == null ? null : jsonEncode(anime.toJson()),
    "finishDate":DateTime.now().toUtc().toString()
  };
}

class Anime {
  String id;
  String type;
  Links links;
  Attributes attributes;
  Map<String, Relationship> relationships;

  Anime({
    this.id,
    this.type,
    this.links,
    this.attributes,
    this.relationships,
  });
  

  factory Anime.fromJson(Map<String, dynamic> json) => new Anime(
    id: json["id"] == null ? null : json["id"],
    type: json["type"] == null ? null : json["type"],
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
    attributes: json["attributes"] == null ? null : Attributes.fromJson(json["attributes"]),
    relationships: json["relationships"] == null ? null : new Map.from(json["relationships"]).map((k, v) => new MapEntry<String, Relationship>(k, Relationship.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "type": type == null ? null : type,
    "links": links == null ? null : links.toJson(),
    "attributes": attributes == null ? null : attributes.toJson(),
    "relationships": relationships == null ? null : new Map.from(relationships).map((k, v) => new MapEntry<String, dynamic>(k, v.toJson())),
  };
}

class Attributes {
  String createdAt;
  String updatedAt;
  String slug;
  String synopsis;
  int coverImageTopOffset;
  Titles titles;
  String canonicalTitle;
  List<String> abbreviatedTitles;
  String averageRating;
  Map<String, String> ratingFrequencies;
  int userCount;
  int favoritesCount;
  String startDate;
  String endDate;
  dynamic nextRelease;
  int popularityRank;
  int ratingRank;
  String ageRating;
  String ageRatingGuide;
  String subtype;
  String status;
  String tba;
  PosterImage posterImage;
  CoverImage coverImage;
  int episodeCount;
  int episodeLength;
  int totalLength;
  String youtubeVideoId;
  String showType;
  bool nsfw;

  Attributes({
    this.createdAt,
    this.updatedAt,
    this.slug,
    this.synopsis,
    this.coverImageTopOffset,
    this.titles,
    this.canonicalTitle,
    this.abbreviatedTitles,
    this.averageRating,
    this.ratingFrequencies,
    this.userCount,
    this.favoritesCount,
    this.startDate,
    this.endDate,
    this.nextRelease,
    this.popularityRank,
    this.ratingRank,
    this.ageRating,
    this.ageRatingGuide,
    this.subtype,
    this.status,
    this.tba,
    this.posterImage,
    this.coverImage,
    this.episodeCount,
    this.episodeLength,
    this.totalLength,
    this.youtubeVideoId,
    this.showType,
    this.nsfw,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => new Attributes(
    createdAt: json["createdAt"] == null ? null : json["createdAt"],
    updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
    slug: json["slug"] == null ? null : json["slug"],
    synopsis: json["synopsis"] == null ? null : json["synopsis"],
    coverImageTopOffset: json["coverImageTopOffset"] == null ? null : json["coverImageTopOffset"],
    titles: json["titles"] == null ? null : Titles.fromJson(json["titles"]),
    canonicalTitle: json["canonicalTitle"] == null ? null : json["canonicalTitle"],
    abbreviatedTitles: json["abbreviatedTitles"] == null ? null : new List<String>.from(json["abbreviatedTitles"].map((x) => x)),
    averageRating: json["averageRating"] == null ? null : json["averageRating"],
    ratingFrequencies: json["ratingFrequencies"] == null ? null : new Map.from(json["ratingFrequencies"]).map((k, v) => new MapEntry<String, String>(k, v)),
    userCount: json["userCount"] == null ? null : json["userCount"],
    favoritesCount: json["favoritesCount"] == null ? null : json["favoritesCount"],
    startDate: json["startDate"] == null ? null : json["startDate"],
    endDate: json["endDate"] == null ? null : json["endDate"],
    nextRelease: json["nextRelease"],
    popularityRank: json["popularityRank"] == null ? null : json["popularityRank"],
    ratingRank: json["ratingRank"] == null ? null : json["ratingRank"],
    ageRating: json["ageRating"] == null ? null : json["ageRating"],
    ageRatingGuide: json["ageRatingGuide"] == null ? null : json["ageRatingGuide"],
    subtype: json["subtype"] == null ? null : json["subtype"],
    status: json["status"] == null ? null : json["status"],
    tba: json["tba"] == null ? null : json["tba"],
    posterImage: json["posterImage"] == null ? null : PosterImage.fromJson(json["posterImage"]),
    coverImage: json["coverImage"] == null ? null : CoverImage.fromJson(json["coverImage"]),
    episodeCount: json["episodeCount"] == null ? null : json["episodeCount"],
    episodeLength: json["episodeLength"] == null ? null : json["episodeLength"],
    totalLength: json["totalLength"] == null ? null : json["totalLength"],
    youtubeVideoId: json["youtubeVideoId"] == null ? null : json["youtubeVideoId"],
    showType: json["showType"] == null ? null : json["showType"],
    nsfw: json["nsfw"] == null ? null : json["nsfw"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt == null ? null : createdAt,
    "updatedAt": updatedAt == null ? null : updatedAt,
    "slug": slug == null ? null : slug,
    "synopsis": synopsis == null ? null : synopsis,
    "coverImageTopOffset": coverImageTopOffset == null ? null : coverImageTopOffset,
    "titles": titles == null ? null : titles.toJson(),
    "canonicalTitle": canonicalTitle == null ? null : canonicalTitle,
    "abbreviatedTitles": abbreviatedTitles == null ? null : new List<dynamic>.from(abbreviatedTitles.map((x) => x)),
    "averageRating": averageRating == null ? null : averageRating,
    "ratingFrequencies": ratingFrequencies == null ? null : new Map.from(ratingFrequencies).map((k, v) => new MapEntry<String, dynamic>(k, v)),
    "userCount": userCount == null ? null : userCount,
    "favoritesCount": favoritesCount == null ? null : favoritesCount,
    "startDate": startDate == null ? null : startDate,
    "endDate": endDate == null ? null : endDate,
    "nextRelease": nextRelease,
    "popularityRank": popularityRank == null ? null : popularityRank,
    "ratingRank": ratingRank == null ? null : ratingRank,
    "ageRating": ageRating == null ? null : ageRating,
    "ageRatingGuide": ageRatingGuide == null ? null : ageRatingGuide,
    "subtype": subtype == null ? null : subtype,
    "status": status == null ? null : status,
    "tba": tba == null ? null : tba,
    "posterImage": posterImage == null ? null : posterImage.toJson(),
    "coverImage": coverImage == null ? null : coverImage.toJson(),
    "episodeCount": episodeCount == null ? null : episodeCount,
    "episodeLength": episodeLength == null ? null : episodeLength,
    "totalLength": totalLength == null ? null : totalLength,
    "youtubeVideoId": youtubeVideoId == null ? null : youtubeVideoId,
    "showType": showType == null ? null : showType,
    "nsfw": nsfw == null ? null : nsfw,
  };
}

class CoverImage {
  String tiny;
  String small;
  String large;
  String original;
  CoverImageMeta meta;

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
    meta: json["meta"] == null ? null : CoverImageMeta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "tiny": tiny == null ? null : tiny,
    "small": small == null ? null : small,
    "large": large == null ? null : large,
    "original": original == null ? null : original,
    "meta": meta == null ? null : meta.toJson(),
  };
}

class CoverImageMeta {
  PurpleDimensions dimensions;

  CoverImageMeta({
    this.dimensions,
  });

  factory CoverImageMeta.fromJson(Map<String, dynamic> json) => new CoverImageMeta(
    dimensions: json["dimensions"] == null ? null : PurpleDimensions.fromJson(json["dimensions"]),
  );

  Map<String, dynamic> toJson() => {
    "dimensions": dimensions == null ? null : dimensions.toJson(),
  };
}

class PurpleDimensions {
  Large tiny;
  Large small;
  Large large;

  PurpleDimensions({
    this.tiny,
    this.small,
    this.large,
  });

  factory PurpleDimensions.fromJson(Map<String, dynamic> json) => new PurpleDimensions(
    tiny: json["tiny"] == null ? null : Large.fromJson(json["tiny"]),
    small: json["small"] == null ? null : Large.fromJson(json["small"]),
    large: json["large"] == null ? null : Large.fromJson(json["large"]),
  );

  Map<String, dynamic> toJson() => {
    "tiny": tiny == null ? null : tiny.toJson(),
    "small": small == null ? null : small.toJson(),
    "large": large == null ? null : large.toJson(),
  };
}

class Large {
  int width;
  int height;

  Large({
    this.width,
    this.height,
  });

  factory Large.fromJson(Map<String, dynamic> json) => new Large(
    width: json["width"] == null ? null : json["width"],
    height: json["height"] == null ? null : json["height"],
  );

  Map<String, dynamic> toJson() => {
    "width": width == null ? null : width,
    "height": height == null ? null : height,
  };
}

class PosterImage {
  String tiny;
  String small;
  String medium;
  String large;
  String original;
  PosterImageMeta meta;

  PosterImage({
    this.tiny,
    this.small,
    this.medium,
    this.large,
    this.original,
    this.meta,
  });

  factory PosterImage.fromJson(Map<String, dynamic> json) => new PosterImage(
    tiny: json["tiny"] == null ? null : json["tiny"],
    small: json["small"] == null ? null : json["small"],
    medium: json["medium"] == null ? null : json["medium"],
    large: json["large"] == null ? null : json["large"],
    original: json["original"] == null ? null : json["original"],
    meta: json["meta"] == null ? null : PosterImageMeta.fromJson(json["meta"]),
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

class PosterImageMeta {
  FluffyDimensions dimensions;

  PosterImageMeta({
    this.dimensions,
  });

  factory PosterImageMeta.fromJson(Map<String, dynamic> json) => new PosterImageMeta(
    dimensions: json["dimensions"] == null ? null : FluffyDimensions.fromJson(json["dimensions"]),
  );

  Map<String, dynamic> toJson() => {
    "dimensions": dimensions == null ? null : dimensions.toJson(),
  };
}

class FluffyDimensions {
  Large tiny;
  Large small;
  Large medium;
  Large large;

  FluffyDimensions({
    this.tiny,
    this.small,
    this.medium,
    this.large,
  });

  factory FluffyDimensions.fromJson(Map<String, dynamic> json) => new FluffyDimensions(
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

class Titles {
  String en;
  String enJp;
  String jaJp;

  Titles({
    this.en,
    this.enJp,
    this.jaJp,
  });

  factory Titles.fromJson(Map<String, dynamic> json) => new Titles(
    en: json["en"] == null ? "" : json["en"],
    enJp: json["en_jp"] == null ? "" : json["en_jp"],
    jaJp: json["ja_jp"] == null ? "" : json["ja_jp"],
  );

  Map<String, dynamic> toJson() => {
    "en": en == null ? null : en,
    "en_jp": enJp == null ? null : enJp,
    "ja_jp": jaJp == null ? null : jaJp,
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

class DataContext extends InheritedWidget {
  List<AnimeData> _datas;

  List<AnimeData> get datas => _datas;

  set datas(List<AnimeData> datas) {
    _datas = datas;
  }

  Future<List<AnimeData>> getAllRecords() async {
    return DBProvider.db.getAllRecords();
  }

  DataContext._({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  static Widget around(Widget child, {Key key}) {
    return _DataContextWrapper(
      child: child,
      key: key,
    );
  }

  static DataContext of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(DataContext);
  }

  @override
  bool updateShouldNotify(DataContext oldWidget) {
    return true;
  }
}

class _DataContextWrapper extends StatefulWidget {
  final Widget child;

  _DataContextWrapper({Key key, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DataContextWrapperState();
}

class _DataContextWrapperState extends State<_DataContextWrapper> {
  List<AnimeData> datas = new List<AnimeData>();
  //String _error;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DataContext._(
      child: widget.child,
    );
  }
}


