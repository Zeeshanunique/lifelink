import 'dart:typed_data';
import '../models/medical_document.dart';
import '../utils/result.dart';
import '../errors/failures.dart';

class MedicalDocumentService {
  final List<MedicalDocument> _documents = [];

  Future<Result<MedicalDocument>> uploadDocument({
    required String patientId,
    required String fileName,
    required String documentType,
    required Uint8List fileBytes,
    required int fileSize,
    required String mimeType,
    required String uploadedBy,
    String? description,
  }) async {
    try {
      // Generate unique file name
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileExtension = fileName.split('.').last;
      final uniqueFileName = '${timestamp}_$fileName';

      // Simulate file storage (in real app, you'd upload to cloud storage)
      final filePath = '/documents/$patientId/$uniqueFileName';
      final fileUrl = 'https://storage.example.com$filePath';

      final document = MedicalDocument(
        id: timestamp.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        patientId: patientId,
        fileName: uniqueFileName,
        originalFileName: fileName,
        documentType: documentType,
        filePath: filePath,
        fileUrl: fileUrl,
        fileSize: fileSize,
        mimeType: mimeType,
        uploadedBy: uploadedBy,
        uploadDate: DateTime.now(),
        description: description,
        metadata: {
          'original_name': fileName,
          'upload_timestamp': timestamp,
          'file_extension': fileExtension,
        },
      );

      _documents.add(document);

      return Result.success(document);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to upload document: ${e.toString()}'),
      );
    }
  }

  Future<Result<List<MedicalDocument>>> getDocumentsByPatient(
    String patientId,
  ) async {
    try {
      final patientDocuments = _documents
          .where((doc) => doc.patientId == patientId)
          .toList();

      // Sort by upload date (newest first)
      patientDocuments.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));

      return Result.success(patientDocuments);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch documents: ${e.toString()}'),
      );
    }
  }

  Future<Result<List<MedicalDocument>>> getDocumentsByType(
    String patientId,
    String documentType,
  ) async {
    try {
      final filteredDocuments = _documents
          .where(
            (doc) =>
                doc.patientId == patientId && doc.documentType == documentType,
          )
          .toList();

      filteredDocuments.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));

      return Result.success(filteredDocuments);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to fetch documents by type: ${e.toString()}'),
      );
    }
  }

  Future<Result<void>> deleteDocument(String documentId) async {
    try {
      _documents.removeWhere((doc) => doc.id == documentId);
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to delete document: ${e.toString()}'),
      );
    }
  }

  Future<Result<MedicalDocument>> verifyDocument(
    String documentId,
    String verifiedBy,
  ) async {
    try {
      final docIndex = _documents.indexWhere((doc) => doc.id == documentId);
      if (docIndex == -1) {
        return Result.failure(NotFoundFailure('Document not found'));
      }

      final updatedDoc = _documents[docIndex].copyWith(
        isVerified: true,
        verifiedBy: verifiedBy,
        verifiedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _documents[docIndex] = updatedDoc;

      return Result.success(updatedDoc);
    } catch (e) {
      return Result.failure(
        ServerFailure('Failed to verify document: ${e.toString()}'),
      );
    }
  }

  // Add some mock documents for demonstration
  void addMockDocuments() {
    final mockDocs = [
      MedicalDocument(
        id: 'doc1',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        patientId: '1', // John Doe from mock patients
        fileName: 'blood_test_results.pdf',
        originalFileName: 'Blood Test Results - Complete Panel.pdf',
        documentType: 'Lab Results',
        filePath: '/documents/1/blood_test_results.pdf',
        fileUrl:
            'https://storage.example.com/documents/1/blood_test_results.pdf',
        fileSize: 2400000, // 2.4 MB
        mimeType: 'application/pdf',
        uploadedBy: 'john.doe@email.com',
        uploadDate: DateTime.now().subtract(const Duration(days: 5)),
        description: 'Complete blood panel results',
        isVerified: true,
        verifiedBy: 'Dr. Smith',
        verifiedAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      MedicalDocument(
        id: 'doc2',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 10)),
        patientId: '1',
        fileName: 'chest_xray.jpg',
        originalFileName: 'Chest X-Ray Report.jpg',
        documentType: 'X-Ray Reports',
        filePath: '/documents/1/chest_xray.jpg',
        fileUrl: 'https://storage.example.com/documents/1/chest_xray.jpg',
        fileSize: 1800000, // 1.8 MB
        mimeType: 'image/jpeg',
        uploadedBy: 'john.doe@email.com',
        uploadDate: DateTime.now().subtract(const Duration(days: 10)),
        description: 'Routine chest X-ray',
        isVerified: true,
        verifiedBy: 'Dr. Johnson',
        verifiedAt: DateTime.now().subtract(const Duration(days: 9)),
      ),
      MedicalDocument(
        id: 'doc3',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        updatedAt: DateTime.now().subtract(const Duration(days: 8)),
        patientId: '1',
        fileName: 'prescription_list.pdf',
        originalFileName: 'Prescription - Medication List.pdf',
        documentType: 'Prescription',
        filePath: '/documents/1/prescription_list.pdf',
        fileUrl:
            'https://storage.example.com/documents/1/prescription_list.pdf',
        fileSize: 500000, // 0.5 MB
        mimeType: 'application/pdf',
        uploadedBy: 'john.doe@email.com',
        uploadDate: DateTime.now().subtract(const Duration(days: 8)),
        description: 'Current medication list',
        isVerified: false,
      ),
    ];

    _documents.addAll(mockDocs);
  }
}
