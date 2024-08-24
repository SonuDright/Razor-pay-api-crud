

import 'dart:convert';

ItemGetMode itemGetModeFromJson(String str) => ItemGetMode.fromJson(json.decode(str));

String itemGetModeToJson(ItemGetMode data) => json.encode(data.toJson());

class ItemGetMode {
  String? id;
  bool? active;
  String? name;
  String? description;
  int? amount;
  int? unitAmount;
  String? currency;
  String? type;
  dynamic unit;
  bool? taxInclusive;
  dynamic hsnCode;
  dynamic sacCode;
  dynamic taxRate;
  dynamic taxId;
  dynamic taxGroupId;
  int? createdAt;

  ItemGetMode({
    this.id,
    this.active,
    this.name,
    this.description,
    this.amount,
    this.unitAmount,
    this.currency,
    this.type,
    this.unit,
    this.taxInclusive,
    this.hsnCode,
    this.sacCode,
    this.taxRate,
    this.taxId,
    this.taxGroupId,
    this.createdAt,
  });

  factory ItemGetMode.fromJson(Map<String, dynamic> json) => ItemGetMode(
    id: json["id"],
    active: json["active"],
    name: json["name"],
    description: json["description"],
    amount: json["amount"],
    unitAmount: json["unit_amount"],
    currency: json["currency"],
    type: json["type"],
    unit: json["unit"],
    taxInclusive: json["tax_inclusive"],
    hsnCode: json["hsn_code"],
    sacCode: json["sac_code"],
    taxRate: json["tax_rate"],
    taxId: json["tax_id"],
    taxGroupId: json["tax_group_id"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "active": active,
    "name": name,
    "description": description,
    "amount": amount,
    "unit_amount": unitAmount,
    "currency": currency,
    "type": type,
    "unit": unit,
    "tax_inclusive": taxInclusive,
    "hsn_code": hsnCode,
    "sac_code": sacCode,
    "tax_rate": taxRate,
    "tax_id": taxId,
    "tax_group_id": taxGroupId,
    "created_at": createdAt,
  };
}
