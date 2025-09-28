import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

part 'medical_document.g.dart';

@JsonSerializable()
class MedicalDocument extends BaseModel {
  final String patientId;
  final String fileName;
  final String originalFileName;
  final String documentType;
  final String filePath;
  final String fileUrl;
  final int fileSize;
  final String mimeType;
  final String uploadedBy;
  final DateTime uploadDate;
  final String? description;
  final Map<String, dynamic>? metadata;
  final bool isVerified;
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final List<String>? tags;

  const MedicalDocument({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    super.createdBy,
    super.updatedBy,
    required this.patientId,
    required this.fileName,
    required this.originalFileName,
    required this.documentType,
    required this.filePath,
    required this.fileUrl,
    required this.fileSize,
    required this.mimeType,
    required this.uploadedBy,
    required this.uploadDate,
    this.description,
    this.metadata,
    this.isVerified = false,
    this.verifiedBy,
    this.verifiedAt,
    this.tags,
  });

  String get fileExtension {
    return originalFileName.split('.').last.toLowerCase();
  }

  String get formattedFileSize {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  bool get isPdf => fileExtension == 'pdf';
  bool get isImage => ['jpg', 'jpeg', 'png', 'gif'].contains(fileExtension);
  bool get isDocument => ['doc', 'docx', 'txt'].contains(fileExtension);

  factory MedicalDocument.fromJson(Map<String, dynamic> json) =>
      _$MedicalDocumentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MedicalDocumentToJson(this);

  MedicalDocument copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    String? patientId,
    String? fileName,
    String? originalFileName,
    String? documentType,
    String? filePath,
    String? fileUrl,
    int? fileSize,
    String? mimeType,
    String? uploadedBy,
    DateTime? uploadDate,
    String? description,
    Map<String, dynamic>? metadata,
    bool? isVerified,
    String? verifiedBy,
    DateTime? verifiedAt,
    List<String>? tags,
  }) {
    return MedicalDocument(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      patientId: patientId ?? this.patientId,
      fileName: fileName ?? this.fileName,
      originalFileName: originalFileName ?? this.originalFileName,
      documentType: documentType ?? this.documentType,
      filePath: filePath ?? this.filePath,
      fileUrl: fileUrl ?? this.fileUrl,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      uploadDate: uploadDate ?? this.uploadDate,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
      isVerified: isVerified ?? this.isVerified,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      tags: tags ?? this.tags,
    );
  }
}
