class AppConstants {
  // App Information
  static const String appName = 'LifeLink';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'https://api.lifelink.com';
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Database Configuration
  static const String databaseName = 'lifelink.db';
  static const int databaseVersion = 1;

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String hospitalIdKey = 'hospital_id';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;

  // Organ Donor Specific
  static const List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];
  static const List<String> organTypes = [
    'Heart',
    'Lung',
    'Liver',
    'Kidney',
    'Pancreas',
    'Intestine',
    'Cornea',
    'Skin',
    'Bone',
    'Tissue',
  ];

  // Hospital Types
  static const List<String> hospitalTypes = [
    'General Hospital',
    'Specialty Hospital',
    'Teaching Hospital',
    'Research Hospital',
    'Emergency Hospital',
    'Rehabilitation Center',
  ];

  // User Roles
  static const List<String> userRoles = [
    'Admin',
    'Doctor',
    'Nurse',
    'Receptionist',
    'Lab Technician',
    'Pharmacist',
    'Radiologist',
    'Surgeon',
    'Anesthesiologist',
  ];

  // Appointment Status
  static const List<String> appointmentStatuses = [
    'Scheduled',
    'Confirmed',
    'In Progress',
    'Completed',
    'Cancelled',
    'No Show',
  ];

  // Patient Status
  static const List<String> patientStatuses = [
    'Active',
    'Discharged',
    'Transferred',
    'Deceased',
    'Emergency',
  ];

  // Donor Status
  static const List<String> donorStatuses = [
    'Registered',
    'Active',
    'Inactive',
    'Deceased',
    'Transplanted',
  ];
}
