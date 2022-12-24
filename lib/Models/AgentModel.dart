class AgentModel {
  String? id;
  String? agentId;
  String? fio;
  String? boshagan;
  String? canZakaz;
  String? canHisobot;
  String? canTolov;
  String? telefon;
  String? parol;
  bool? success;
  String? message;

  AgentModel(
      {this.id,
      this.agentId,
      this.fio,
      this.boshagan,
      this.canZakaz,
      this.canHisobot,
      this.canTolov,
      this.telefon,
      this.parol,
      this.success,
      this.message});

  AgentModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    agentId = json['agent_id'];
    fio = json['fio'];
    boshagan = json['boshagan'];
    canZakaz = json['can_zakaz'];
    canHisobot = json['can_hisobot'];
    canTolov = json['can_tolov'];
    telefon = json['telefon'];
    parol = json['parol'];
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['agent_id'] = this.agentId;
    data['fio'] = this.fio;
    data['boshagan'] = this.boshagan;
    data['can_zakaz'] = this.canZakaz;
    data['can_hisobot'] = this.canHisobot;
    data['can_tolov'] = this.canTolov;
    data['telefon'] = this.telefon;
    data['parol'] = this.parol;
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}
