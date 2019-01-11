///收藏文章列表
class FavoriteDatasDTO {
  int curPage;
  List<Datas> datas;
  int offset;
  bool over;
  int pageCount;
  int size;
  int total;

  FavoriteDatasDTO(
      {this.curPage,
      this.datas,
      this.offset,
      this.over,
      this.pageCount,
      this.size,
      this.total});

  FavoriteDatasDTO.fromJson(Map<String, dynamic> json) {
    curPage = json['curPage'];
    if (json['datas'] != null) {
      datas = new List<Datas>();
      json['datas'].forEach((v) {
        datas.add(new Datas.fromJson(v));
      });
    }
    offset = json['offset'];
    over = json['over'];
    pageCount = json['pageCount'];
    size = json['size'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['curPage'] = this.curPage;
    if (this.datas != null) {
      data['datas'] = this.datas.map((v) => v.toJson()).toList();
    }
    data['offset'] = this.offset;
    data['over'] = this.over;
    data['pageCount'] = this.pageCount;
    data['size'] = this.size;
    data['total'] = this.total;
    return data;
  }
}

///{author: 鸿洋, chapterId: 408, chapterName: 鸿洋, courseId: 13, desc: , envelopePic:
///, id: 42694, link: https://mp.weixin.qq.com/s/H5bHzTUTDVAfl37yyX43IA, niceDate: 刚刚,
/// origin: , originId: 7743, publishTime: 1547194817000, title: PopWindow 制作常见的6种花哨效果,
/// userId: 15923, visible: 0, zan: 0}
class Datas {
  String author;
  String chapterName;
  int chapterId;
  String desc;
  String envelopePic;
  int id;
  String link;
  String niceDate;
  String origin;
  int originId;
  int publishTime;
  String title;
  int userId;
  int visible;
  int zan;

  Datas(
      {this.author,
      this.chapterId,
      this.chapterName,
      this.desc,
      this.envelopePic,
      this.id,
      this.link,
      this.niceDate,
      this.origin,
      this.originId,
      this.publishTime,
      this.title,
      this.userId,
      this.visible,
      this.zan});

  Datas.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    chapterId = json['chapterId'];
    chapterName = json['chapterName'];
    desc = json['desc'];
    envelopePic = json['envelopePic'];
    id = json['id'];
    link = json['link'];
    niceDate = json['niceDate'];
    origin = json['origin'];
    originId = json['originId'];
    publishTime = json['publishTime'];
    title = json['title'];
    userId = json['userId'];
    visible = json['visible'];
    zan = json['zan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['chapterId'] = this.chapterId;
    data['chapterName'] = this.chapterName;
    data['desc'] = this.desc;
    data['envelopePic'] = this.envelopePic;
    data['id'] = this.id;
    data['link'] = this.link;
    data['niceDate'] = this.niceDate;
    data['origin'] = this.origin;
    data['originId'] = this.originId;
    data['publishTime'] = this.publishTime;
    data['title'] = this.title;
    data['userId'] = this.userId;
    data['visible'] = this.visible;
    data['zan'] = this.zan;
    return data;
  }
}
