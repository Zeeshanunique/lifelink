// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalDocument _$MedicalDocumentFromJson(Map<String, dynamic> json) =>
    MedicalDocument(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      patientId: json['patientId'] as String,
      fileName: json['fileName'] as String,
      originalFileName: json['originalFileName'] as String,
      documentType: json['documentType'] as String,
      filePath: json['filePath'] as String,
      fileUrl: json['fileUrl'] as String,
      fileSize: (json['fileSize'] as num).toInt(),
      mimeType: json['mimeType'] as String,
      uploadedBy: json['uploadedBy'] as String,
      uploadDate: DateTime.parse(json['uploadDate'] as String),
      description: json['description'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isVerified: json['isVerified'] as bool? ?? false,
      verifiedBy: json['verifiedBy'] as String?,
      verifiedAt: json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$MedicalDocumentToJson(MedicalDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'patientId': instance.patientId,
      'fileName': instance.fileName,
      'originalFileName': instance.originalFileName,
      'documentType': instance.documentType,
      'filePath': instance.filePath,
      'fileUrl': instance.fileUrl,
      'fileSize': instance.fileSize,
      'mimeType': instance.mimeType,
      'uploadedBy': instance.uploadedBy,
      'uploadDate': instance.uploadDate.toIso8601String(),
      'description': instance.description,
      'metadata': instance.metadata,
      'isVerified': instance.isVerified,
      'verifiedBy': instance.verifiedBy,
      'verifiedAt': instance.verifiedAt?.toIso8601String(),
      'tags': instance.tags,
    };
