class TodoUpdateDTO {
  ///{
  //                "completeDate": null,
  //                "completeDateStr": "",
  //                "content": "想说的撒地",
  //                "date": 1546444800000,
  //                "dateStr": "2019-01-03",
  //                "id": 6106,
  //                "priority": 0,
  //                "status": 0,
  //                "title": "新的todo",
  //                "type": 0,
  //                "userId": 15345
  //            }
  String content;
  String date;
  int id;
  int priority;
  int status;
  String title;
  int type;

  TodoUpdateDTO({
    this.content,
    this.date,
    this.id,
    this.priority,
    this.status,
    this.title,
    this.type,
  });

  TodoUpdateDTO.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    date = json['date'];
    id = json['id'];
    priority = json['priority'];
    status = json['status'];
    title = json['title'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['date'] = this.date;
    data['id'] = this.id;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['title'] = this.title;
    data['type'] = this.type;
    return data;
  }
}
