class GetTodoListDTO {
  ///status 状态， 1-完成；0未完成; 默认全部展示；
  //	type 创建时传入的类型, 默认全部展示
  //	priority 创建时传入的优先级；默认全部展示
  //	orderby 1:完成日期顺序；2.完成日期逆序；3.创建日期顺序；4.创建日期逆序(默认)；
  int status;
  int type;
  int priority;
  int orderby = 1;

  GetTodoListDTO({this.status, this.type, this.priority, this.orderby});

  GetTodoListDTO.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    type = json['type'];
    priority = json['priority'];
    orderby = json['orderby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) data['status'] = this.status;
    if (this.type != null) data['type'] = this.type;
    if (this.priority != null) data['priority'] = this.priority;
    if (this.orderby != null) data['orderby'] = this.orderby;
    return data;
  }
}
