import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/models/patient.dart';
import '../../../core/models/medical_document.dart';
import '../../../core/services/medical_document_service.dart';
import '../../../core/widgets/rbac_widget.dart';
import '../../../core/utils/rbac_utils.dart';
import '../../../core/providers/auth_providers.dart';

class MedicalRecordsPage extends ConsumerStatefulWidget {
  final Patient? patient;

  const MedicalRecordsPage({super.key, this.patient});

  @override
  ConsumerState<MedicalRecordsPage> createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends ConsumerState<MedicalRecordsPage> {
  String? _selectedDocumentType;
  bool _isUploading = false;

  // File selection variables
  PlatformFile? _selectedFile;
  String? _selectedFileName;
  String? _selectedFileSize;
  bool _isFileSelected = false;

  // Document service
  final MedicalDocumentService _documentService = MedicalDocumentService();
  List<MedicalDocument> _documents = [];

  final List<String> _documentTypes = [
    'Lab Results',
    'X-Ray Reports',
    'MRI Scans',
    'CT Scans',
    'Blood Test Results',
    'Prescription',
    'Vaccination Records',
    'Surgery Reports',
    'Discharge Summary',
    'Medical History',
    'Insurance Documents',
    'Other Medical Documents',
  ];

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    // Add mock documents for demonstration
    _documentService.addMockDocuments();

    // Load documents for current patient (using mock patient ID)
    final patientId = widget.patient?.id ?? '1';
    final result = await _documentService.getDocumentsByPatient(patientId);

    if (result.isSuccess && mounted) {
      setState(() {
        _documents = result.data!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Medical Records'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload Section Header
            const Text(
              'Upload Medical Documents',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Upload and manage your medical documents securely',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // Document Type Selection
            const Text(
              'Document Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedDocumentType,
                  hint: const Text(
                    'Select document type',
                    style: TextStyle(color: Color(0xFF6B7280), fontSize: 16),
                  ),
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF6B7280),
                  ),
                  items: _documentTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(
                        type,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDocumentType = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Upload File Section
            const Text(
              'Upload File',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),

            // Upload Area
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Cloud Upload Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9CA3AF).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cloud_upload_outlined,
                      size: 40,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Choose File Button
                  _isFileSelected
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: _chooseFile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF374151),
                                side: const BorderSide(
                                  color: Color(0xFFE5E7EB),
                                ),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Change File',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: _clearFile,
                              icon: const Icon(
                                Icons.close,
                                color: Color(0xFFEF4444),
                                size: 20,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFFEF4444,
                                ).withOpacity(0.1),
                                padding: const EdgeInsets.all(8),
                              ),
                            ),
                          ],
                        )
                      : ElevatedButton(
                          onPressed: _chooseFile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF374151),
                            side: const BorderSide(color: Color(0xFFE5E7EB)),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Choose File',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                  const SizedBox(height: 8),
                  _isFileSelected
                      ? Column(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedFileName ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1F2937),
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _selectedFileSize ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        )
                      : const Text(
                          'No file chosen',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                  const SizedBox(height: 8),
                  Text(
                    'Supported formats: PDF, JPG, PNG, DOCX (Max 10MB)',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Upload Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed:
                    _selectedDocumentType != null &&
                        _isFileSelected &&
                        !_isUploading
                    ? _uploadDocument
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F80ED),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFE5E7EB),
                  disabledForegroundColor: const Color(0xFF9CA3AF),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isUploading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Upload Document',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 32),

            // Recent Documents Section
            const Text(
              'Recent Documents',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 16),

            // Documents List
            _buildRecentDocuments(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentDocuments() {
    if (_documents.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          children: [
            Icon(Icons.description_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'No documents uploaded yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Upload your first medical document to get started',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: _documents
          .map((doc) => _buildDocumentCardFromModel(doc))
          .toList(),
    );
  }

  Widget _buildDocumentCardFromModel(MedicalDocument document) {
    return Consumer(
      builder: (context, ref, child) {
        final currentUser = ref.watch(currentUserProvider);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Document Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF2F80ED).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getDocumentTypeIcon(document.documentType),
                  color: const Color(0xFF2F80ED),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Document Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            document.originalFileName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (document.isVerified)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.verified,
                              color: Color(0xFF10B981),
                              size: 12,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      document.documentType,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          _formatUploadDate(document.uploadDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        Text(
                          ' • ${document.formattedFileSize}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                onSelected: (action) =>
                    _handleDocumentActionFromModel(action, document),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility, size: 20),
                        SizedBox(width: 8),
                        Text('View'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'download',
                    child: Row(
                      children: [
                        Icon(Icons.download, size: 20),
                        SizedBox(width: 8),
                        Text('Download'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share, size: 20),
                        SizedBox(width: 8),
                        Text('Share'),
                      ],
                    ),
                  ),
                  // Only show verify option for hospital/admin users
                  if (!document.isVerified &&
                      RBACUtils.hasPermission(
                        currentUser,
                        Permission.verifyDocuments,
                      ))
                    const PopupMenuItem(
                      value: 'verify',
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 20,
                            color: Color(0xFF10B981),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Verify',
                            style: TextStyle(color: Color(0xFF10B981)),
                          ),
                        ],
                      ),
                    ),
                  // Show delete only for hospital/admin users
                  if (RBACUtils.hasPermission(
                    currentUser,
                    Permission.managePatients,
                  ))
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatUploadDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  void _handleDocumentActionFromModel(String action, MedicalDocument document) {
    switch (action) {
      case 'view':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Viewing ${document.originalFileName}')),
        );
        break;
      case 'download':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloading ${document.originalFileName}')),
        );
        break;
      case 'share':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sharing ${document.originalFileName}')),
        );
        break;
      case 'verify':
        _verifyDocument(document);
        break;
      case 'delete':
        _showDeleteConfirmationFromModel(document);
        break;
    }
  }

  Future<void> _verifyDocument(MedicalDocument document) async {
    final result = await _documentService.verifyDocument(
      document.id,
      'Dr. Current User', // TODO: Get from current user
    );

    if (result.isSuccess && mounted) {
      await _loadDocuments();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${document.originalFileName} verified successfully'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    }
  }

  void _showDeleteConfirmationFromModel(MedicalDocument document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text(
          'Are you sure you want to delete "${document.originalFileName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final result = await _documentService.deleteDocument(document.id);
              if (result.isSuccess && mounted) {
                await _loadDocuments();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${document.originalFileName} deleted'),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  IconData _getDocumentTypeIcon(String type) {
    switch (type) {
      case 'Lab Results':
      case 'Blood Test Results':
        return Icons.science;
      case 'X-Ray Reports':
      case 'MRI Scans':
      case 'CT Scans':
        return Icons.image;
      case 'Prescription':
        return Icons.receipt;
      case 'Vaccination Records':
        return Icons.vaccines;
      case 'Surgery Reports':
        return Icons.medical_services;
      case 'Insurance Documents':
        return Icons.shield;
      default:
        return Icons.description;
    }
  }

  Future<void> _chooseFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'docx', 'doc'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        // Validate file size (10MB limit)
        if (file.size > 10 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('File size must be less than 10MB'),
                backgroundColor: Color(0xFFEF4444),
              ),
            );
          }
          return;
        }

        setState(() {
          _selectedFile = file;
          _selectedFileName = file.name;
          _selectedFileSize = _formatFileSize(file.size);
          _isFileSelected = true;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File "${file.name}" selected successfully'),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick file: ${e.toString()}'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  void _clearFile() {
    setState(() {
      _selectedFile = null;
      _selectedFileName = null;
      _selectedFileSize = null;
      _isFileSelected = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File cleared'),
        backgroundColor: Color(0xFF6B7280),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _uploadDocument() async {
    if (_selectedDocumentType == null || _selectedFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // Get file information
      final fileName = _selectedFile!.name;
      final fileSize = _selectedFile!.size;

      // Try to get file bytes, with fallback for demonstration
      Uint8List? fileBytes = _selectedFile!.bytes;

      // If bytes are null (which can happen on some platforms),
      // create mock bytes for demonstration purposes
      if (fileBytes == null) {
        // In a real production app, you would need to implement
        // platform-specific file reading logic here
        fileBytes = Uint8List.fromList(
          List.generate(
            math.min(fileSize, 1024), // Limit to 1KB for demo
            (index) => index % 256,
          ),
        );

        if (kDebugMode) {
          print('Info: Using simulated file data for demonstration purposes');
          print('File: $fileName, Size: ${_formatFileSize(fileSize)}');
        }

        // Show user feedback that this is a simulation
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Note: File upload simulated for demonstration. In production, actual file data would be uploaded.',
              ),
              backgroundColor: Color(0xFF2563EB),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }

      // Get MIME type
      String mimeType = 'application/octet-stream';
      final extension = fileName.split('.').last.toLowerCase();
      switch (extension) {
        case 'pdf':
          mimeType = 'application/pdf';
          break;
        case 'jpg':
        case 'jpeg':
          mimeType = 'image/jpeg';
          break;
        case 'png':
          mimeType = 'image/png';
          break;
        case 'doc':
          mimeType = 'application/msword';
          break;
        case 'docx':
          mimeType =
              'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
          break;
      }

      // Simulate upload progress
      await Future.delayed(const Duration(seconds: 1));

      // Upload document using the service
      final patientId = widget.patient?.id ?? '1';
      final result = await _documentService.uploadDocument(
        patientId: patientId,
        fileName: fileName,
        documentType: _selectedDocumentType!,
        fileBytes: fileBytes,
        fileSize: fileSize,
        mimeType: mimeType,
        uploadedBy: 'current-user@email.com', // TODO: Get from current user
        description: 'Uploaded via mobile app',
      );

      if (result.isSuccess && mounted) {
        // Refresh documents list
        await _loadDocuments();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'File "$fileName" ($_selectedFileSize) uploaded successfully!',
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

        // Reset form
        setState(() {
          _selectedDocumentType = null;
          _selectedFile = null;
          _selectedFileName = null;
          _selectedFileSize = null;
          _isFileSelected = false;
        });
      } else {
        throw Exception(result.failure?.message ?? 'Upload failed');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: ${e.toString()}'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }
}
