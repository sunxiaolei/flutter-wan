import 'package:wan/model/dto/tags_dto.dart';

  ///{
  //    "data":[
  //        {
  //            "articles":[
  //                {
  //                    "apkLink":"",
  //                    "author":"小编",
  //                    "chapterId":366,
  //                    "chapterName":"在线文档",
  //                    "collect":false,
  //                    "courseId":13,
  //                    "desc":"",
  //                    "envelopePic":"",
  //                    "fresh":false,
  //                    "id":2977,
  //                    "link":"https://docs.qq.com",
  //                    "niceDate":"2018-06-03",
  //                    "origin":"",
  //                    "projectLink":"",
  //                    "publishTime":1527991506000,
  //                    "superChapterId":0,
  //                    "superChapterName":"",
  //                    "tags":[
  //
  //                    ],
  //                    "title":"腾讯文档",
  //                    "type":0,
  //                    "userId":-1,
  //                    "visible":0,
  //                    "zan":0
  //                },
  //                {
  //                    "apkLink":"",
  //                    "author":"小编",
  //                    "chapterId":366,
  //                    "chapterName":"在线文档",
  //                    "collect":false,
  //                    "courseId":13,
  //                    "desc":"",
  //                    "envelopePic":"",
  //                    "fresh":false,
  //                    "id":2978,
  //                    "link":"https://yuque.com",
  //                    "niceDate":"2018-06-03",
  //                    "origin":"",
  //                    "projectLink":"",
  //                    "publishTime":1527991521000,
  //                    "superChapterId":0,
  //                    "superChapterName":"",
  //                    "tags":[
  //
  //                    ],
  //                    "title":"阿里文档语雀",
  //                    "type":0,
  //                    "userId":-1,
  //                    "visible":0,
  //                    "zan":0
  //                }
  //            ],
  //            "cid":366,
  //            "name":"在线文档"
  //        },
  //        {
  //            "articles":[
  //                {
  //                    "apkLink":"",
  //                    "author":"小编",
  //                    "chapterId":369,
  //                    "chapterName":"短视频SDK",
  //                    "collect":false,
  //                    "courseId":13,
  //                    "desc":"",
  //                    "envelopePic":"",
  //                    "fresh":false,
  //                    "id":3012,
  //                    "link":"https://www.upyun.com/products/short-video",
  //                    "niceDate":"2018-06-15",
  //                    "origin":"",
  //                    "projectLink":"",
  //                    "publishTime":1529043871000,
  //                    "superChapterId":0,
  //                    "superChapterName":"",
  //                    "tags":[
  //
  //                    ],
  //                    "title":"又拍云短视频",
  //                    "type":0,
  //                    "userId":-1,
  //                    "visible":0,
  //                    "zan":0
  //                }
  //            ],
  //            "cid":369,
  //            "name":"短视频SDK"
  //        }
  //    ],
  //    "errorCode":0,
  //    "errorMsg":""
  //}

class NaviDTO {
  List<Articles> articles;
  int cid;
  String name;

  NaviDTO({this.articles, this.cid, this.name});

  NaviDTO.fromJson(Map<String, dynamic> json) {
    if (json['articles'] != null) {
      articles = new List<Articles>();
      json['articles'].forEach((v) {
        articles.add(new Articles.fromJson(v));
      });
    }
    cid = json['cid'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.articles != null) {
      data['articles'] = this.articles.map((v) => v.toJson()).toList();
    }
    data['cid'] = this.cid;
    data['name'] = this.name;
    return data;
  }
}

class Articles {
  String apkLink;
  String author;
  int chapterId;
  String chapterName;
  bool collect;
  int courseId;
  String desc;
  String envelopePic;
  bool fresh;
  int id;
  String link;
  String niceDate;
  String origin;
  String projectLink;
  int publishTime;
  int superChapterId;
  String superChapterName;
  List<Tags> tags;
  String title;
  int type;
  int userId;
  int visible;
  int zan;

  Articles(
      {this.apkLink,
      this.author,
      this.chapterId,
      this.chapterName,
      this.collect,
      this.courseId,
      this.desc,
      this.envelopePic,
      this.fresh,
      this.id,
      this.link,
      this.niceDate,
      this.origin,
      this.projectLink,
      this.publishTime,
      this.superChapterId,
      this.superChapterName,
      this.tags,
      this.title,
      this.type,
      this.userId,
      this.visible,
      this.zan});

  Articles.fromJson(Map<String, dynamic> json) {
    apkLink = json['apkLink'];
    author = json['author'];
    chapterId = json['chapterId'];
    chapterName = json['chapterName'];
    collect = json['collect'];
    courseId = json['courseId'];
    desc = json['desc'];
    envelopePic = json['envelopePic'];
    fresh = json['fresh'];
    id = json['id'];
    link = json['link'];
    niceDate = json['niceDate'];
    origin = json['origin'];
    projectLink = json['projectLink'];
    publishTime = json['publishTime'];
    superChapterId = json['superChapterId'];
    superChapterName = json['superChapterName'];
    if (json['tags'] != null) {
      tags = new List<Tags>();
      json['tags'].forEach((v) {
        tags.add(new Tags.fromJson(v));
      });
    }
    title = json['title'];
    type = json['type'];
    userId = json['userId'];
    visible = json['visible'];
    zan = json['zan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['apkLink'] = this.apkLink;
    data['author'] = this.author;
    data['chapterId'] = this.chapterId;
    data['chapterName'] = this.chapterName;
    data['collect'] = this.collect;
    data['courseId'] = this.courseId;
    data['desc'] = this.desc;
    data['envelopePic'] = this.envelopePic;
    data['fresh'] = this.fresh;
    data['id'] = this.id;
    data['link'] = this.link;
    data['niceDate'] = this.niceDate;
    data['origin'] = this.origin;
    data['projectLink'] = this.projectLink;
    data['publishTime'] = this.publishTime;
    data['superChapterId'] = this.superChapterId;
    data['superChapterName'] = this.superChapterName;
    if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    data['type'] = this.type;
    data['userId'] = this.userId;
    data['visible'] = this.visible;
    data['zan'] = this.zan;
    return data;
  }
}
