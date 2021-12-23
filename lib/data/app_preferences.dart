import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class AppPreferences{

  //------------------------------------------------------------- Preference Constants ------------------------------------------------------------

  // Constants for Preference-Value's data-type
  static const String PREF_TYPE_BOOL = "BOOL";
  static const String PREF_TYPE_INTEGER = "INTEGER";
  static const String PREF_TYPE_DOUBLE = "DOUBLE";
  static const String PREF_TYPE_STRING = "STRING";

  // Constants for Preference-Name
  static const String PREF_IS_LOGGED_IN = "IS_LOGGED_IN";

  static SharedPreferences? _preferences;
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setLoggedIn( bool isLoggedIn) async =>
      await _preferences?.setBool(PREF_IS_LOGGED_IN, isLoggedIn);

  static bool getLoggedIn() => _preferences?.getBool(PREF_IS_LOGGED_IN)??false; // Check value for NULL. If NULL provide default value as FALSE.

  //--------------------------------------------------- Private Preference Methods ----------------------------------------------------
  /// Set Preference Method -> void
  /// @param -> @required prefName -> String
  ///        -> @required prefValue -> dynamic
  ///        -> @required prefType -> String
  /// @usage -> This is a generalized method to set preferences with required Preference-Name(Key) with Preference-Value(Value) and Preference-Value's data-type.
  static Future<void> setPreference ({required String prefName,required dynamic prefValue,required String prefType})async {
    // Make switch for Preference Type i.e. Preference-Value's data-type
    switch(prefType){
    // prefType is bool
      case PREF_TYPE_BOOL:{
        _preferences?.setBool(prefName, prefValue);
        break;
      }
    // prefType is int
      case PREF_TYPE_INTEGER:{
        _preferences?.setInt(prefName, prefValue);
        break;
      }
    // prefType is double
      case PREF_TYPE_DOUBLE:{
        _preferences?.setDouble(prefName, prefValue);
        break;
      }
    // prefType is String
      case PREF_TYPE_STRING:{
        _preferences?.setString(prefName, prefValue);
        break;
      }
    }

  }

  /// Get Preference Method -> Future<dynamic>
  /// @param -> @required prefName -> String
  /// @usage -> Returns Preference-Value for given Preference-Name
  Future<dynamic> _getPreference({required prefName}) async => _preferences?.get(prefName);

}
