
import 'dart:convert';

PostGetyMode postGetyModeFromJson(String str) => PostGetyMode.fromJson(json.decode(str));

String postGetyModeToJson(PostGetyMode data) => json.encode(data.toJson());

class PostGetyMode {
  String? entity;
  int? count;
  List<Item>? items;

  PostGetyMode({
    this.entity,
    this.count,
    this.items,
  });

  factory PostGetyMode.fromJson(Map<String, dynamic> json) => PostGetyMode(
    entity: json["entity"],
    count: json["count"],
    items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "entity": entity,
    "count": count,
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class Item {
  String? id;
  bool? active;
  String? name;
  String? description;
  int? amount;
  int? unitAmount;
  Currency? currency;
  Type? type;
  dynamic unit;
  bool? taxInclusive;
  dynamic hsnCode;
  dynamic sacCode;
  dynamic taxRate;
  dynamic taxId;
  dynamic taxGroupId;
  int? createdAt;

  Item({
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

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    active: json["active"],
    name: json["name"],
    description: json["description"],
    amount: json["amount"],
    unitAmount: json["unit_amount"],
    currency: currencyValues.map[json["currency"]]!,
    type: typeValues.map[json["type"]]!,
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
    "currency": currencyValues.reverse[currency],
    "type": typeValues.reverse[type],
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

enum Currency {
  INR
}

final currencyValues = EnumValues({
  "INR": Currency.INR
});

enum Type {
  INVOICE
}

final typeValues = EnumValues({
  "invoice": Type.INVOICE
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
