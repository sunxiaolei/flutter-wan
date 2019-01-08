class AddTodoDTO {
  ///title: 新增标题（必须）
  //  content: 新增详情（必须）
  //  date: 2018-08-01 预定完成时间（不传默认当天，建议传）
  //  type: 大于0的整数（可选）；
  //  priority 大于0的整数（可选） 主要用于定义优先级，在app 中预定义几个优先级：重要（1），一般（2）等，查询的时候，传入priority 进行筛选；

  String title;
  String content;
  String date;
  int type;
  int priority;

  AddTodoDTO(this.title, this.date, this.type, {this.content, this.priority});

  AddTodoDTO.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    date = json['date'];
    priority = json['priority'];
    title = json['title'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['date'] = this.date;
    data['priority'] = this.priority;
    data['title'] = this.title;
    data['type'] = this.type;
    return data;
  }
}
