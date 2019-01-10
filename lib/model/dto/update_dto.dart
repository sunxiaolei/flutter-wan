class UpdateDTO {
  int version;
  String versionName;
  String downloadUrl;
  String apkUrl;

  UpdateDTO({this.version, this.versionName, this.downloadUrl, this.apkUrl});

  UpdateDTO.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    versionName = json['versionName'];
    downloadUrl = json['downloadUrl'];
    apkUrl = json['apkUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['versionName'] = this.versionName;
    data['downloadUrl'] = this.downloadUrl;
    data['apkUrl'] = this.apkUrl;
    return data;
  }
}
