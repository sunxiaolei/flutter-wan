class UpdateDTO {
  int version;
  String versionName;
  String downloadUrl;

  UpdateDTO({this.version, this.versionName, this.downloadUrl});

  UpdateDTO.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    versionName = json['versionName'];
    downloadUrl = json['downloadUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['versionName'] = this.versionName;
    data['downloadUrl'] = this.downloadUrl;
    return data;
  }
}
