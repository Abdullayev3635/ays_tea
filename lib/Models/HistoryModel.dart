class HistoryModel {
  String? id;
  String? mijozId;
  String? mijozName;
  String? document;
  String? totalSumm;
  String? holati;
  String? timeCreate;

  HistoryModel(
      {this.id,
        this.mijozId,
        this.mijozName,
        this.document,
        this.totalSumm,
        this.holati,
        this.timeCreate});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    mijozId = json['mijoz_id'];
    mijozName = json['mijoz_name'];
    document = json['document'];
    totalSumm = json['total_summ'];
    holati = json['holati'];
    timeCreate = json['time_create'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['mijoz_id'] = this.mijozId;
    data['mijoz_name'] = this.mijozName;
    data['document'] = this.document;
    data['total_summ'] = this.totalSumm;
    data['holati'] = this.holati;
    data['time_create'] = this.timeCreate;
    return data;
  }
}