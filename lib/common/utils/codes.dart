class StatusCodes {
  // API Status Codes
  static const int RESPONSE_SUCCESS = 200;
  static const int RESPONSE_FAILURE = 400;
  static const int USER_NOT_REGISTERED = 601;

  static const int API_SUCCESS = 0x10001;
  static const int API_FAILURE = 0x10002;

  // Other Status Codes
  static const int VERIFIED = 0x00101;
  static const int VERIFICATION_FAILED = 0x00102;

  // Refresh Codes
  static const int KEY_TRIGGER_API = 100;
  static const int KEY_TRIGGER_LOCAL_DB = 101;
  static const int KEY_SESSION_NOT_FOUND = 102;

  static const int KEY_REFRESH_UPCOMING_APPOINTMENTS = 111;
  static const int KEY_REFRESH_CLINICS = 112;
  static const int KEY_PENDING_CHAT_ACTIVE = 113;
  static const int KEY_USER_DATA_UPDATED = 114;

  // Tabs
  static const int KEY_HOME_TAB = 451;

  // Firebase Session Codes
  static const int FIREBASE_INTERNAL_ERROR = 2001;
  static const int FIREBASE_TOKEN_REFRESHED = 2002;
  static const int FIREBASE_TOKEN_NOT_EXPIRED = 2003;
}
