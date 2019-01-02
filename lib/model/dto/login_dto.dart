class LoginDTO {
  List<String> chapterTops;
  List<int> collectIds;
  String email;
  String icon;
  int id;
  String password;
  String token;
  int type;
  String username;

  LoginDTO(
      {this.chapterTops,
        this.collectIds,
        this.email,
        this.icon,
        this.id,
        this.password,
        this.token,
        this.type,
        this.username});

  LoginDTO.fromJson(Map<String, dynamic> json) {
    chapterTops = json['chapterTops'].cast<String>();
    collectIds = json['collectIds'].cast<int>();
    email = json['email'];
    icon = json['icon'];
    id = json['id'];
    password = json['password'];
    token = json['token'];
    type = json['type'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chapterTops'] = this.chapterTops;
    data['collectIds'] = this.collectIds;
    data['email'] = this.email;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['password'] = this.password;
    data['token'] = this.token;
    data['type'] = this.type;
    data['username'] = this.username;
    return data;
  }
}

