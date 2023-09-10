import 'dart:typed_data';
class ItemModel {
  final int deviceId;
  final String itemType;
  final String company;
  final String deviceDetail;
  final String cost;
  final String storage;
  final String remark;

  ItemModel({
    required this.deviceId,
    required this.itemType,
    required this.company,
    required this.deviceDetail,
    required this.cost,
    required this.storage,
    required this.remark,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      deviceId :json['deviceid'],
      itemType: json['itemtype'],
      company: json['company'],
      deviceDetail: json['devicedetail'],
      cost: json['cost'],
      storage: json['storage'],
      remark: json['remark'],
    );
  }
}