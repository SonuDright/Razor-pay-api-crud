// class QrCodeModel {
//   String? id;
//   String? entity;
//   String? status;
//   int? createdAt;
//   // Add more fields as per the API response
//
//   QrCodeModel({
//     this.id,
//     this.entity,
//     this.status,
//     this.createdAt,
//     // Add more fields as needed
//   });
//
//   factory QrCodeModel.fromJson(Map<String, dynamic> json) {
//     return QrCodeModel(
//       id: json['id'],
//       entity: json['entity'],
//       status: json['status'],
//       createdAt: json['created_at'],
//       // Map more fields as needed
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'entity': entity,
//       'status': status,
//       'created_at': createdAt,
//       // Add more fields as needed
//     };
//   }
// }
