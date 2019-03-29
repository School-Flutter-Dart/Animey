class Links {
  String self;
  String related;

  Links({
    this.self,
    this.related,
  });

  factory Links.fromJson(Map<String, dynamic> json) => new Links(
        self: json["self"] == null ? null : json['self'],
        related: json["related"] == null ? null : json['related'],
      );

  Map<String, dynamic> toJson() => {
        "self": self == null ? null : self,
        "related": related == null ? null : related,
      };
}
