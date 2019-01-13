import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<Null> getPermission(FlutterPermissionGroup permissionGroup,
      PermissionCallBack callback) async {
    PermissionGroup pg = _transform(permissionGroup);
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(pg);
    if (permission == PermissionStatus.granted) {
      callback(true);
    } else {
      PermissionHandler().requestPermissions([pg]).then((permissions) {
        permissions.forEach((group, status) {
          if (group == pg) {
            callback(status == PermissionStatus.granted);
          }
        });
      });
    }
  }

  static void startAppSettins() {
    PermissionHandler().openAppSettings();
  }
}

PermissionGroup _transform(FlutterPermissionGroup group) {
  switch (group) {
    case FlutterPermissionGroup.calendar:
      return PermissionGroup.calendar;
      break;
    case FlutterPermissionGroup.camera:
      return PermissionGroup.camera;
      break;
    case FlutterPermissionGroup.contacts:
      return PermissionGroup.contacts;
      break;
    case FlutterPermissionGroup.microphone:
      return PermissionGroup.microphone;
      break;
    case FlutterPermissionGroup.location:
      return PermissionGroup.location;
      break;
    case FlutterPermissionGroup.reminders:
      return PermissionGroup.reminders;
      break;
    case FlutterPermissionGroup.photos:
      return PermissionGroup.photos;
      break;
    case FlutterPermissionGroup.sensors:
      return PermissionGroup.sensors;
      break;
    case FlutterPermissionGroup.sms:
      return PermissionGroup.sms;
      break;
    case FlutterPermissionGroup.storage:
      return PermissionGroup.storage;
      break;
    case FlutterPermissionGroup.speech:
      return PermissionGroup.speech;
      break;
    case FlutterPermissionGroup.locationAlways:
      return PermissionGroup.locationAlways;
      break;
    case FlutterPermissionGroup.mediaLibrary:
      return PermissionGroup.mediaLibrary;
      break;
    case FlutterPermissionGroup.locationWhenInUse:
      return PermissionGroup.locationWhenInUse;
      break;
    default:
      return PermissionGroup.unknown;
      break;
  }
}

typedef PermissionCallBack = void Function(bool granted);

enum FlutterPermissionGroup {
  /// The unknown permission only used for return type, never requested
  unknown,

  /// Android: Calendar
  /// iOS: Calendar (Events)
  calendar,

  /// Android: Camera
  /// iOS: Photos (Camera Roll and Camera)
  camera,

  /// Android: Contacts
  /// iOS: AddressBook
  contacts,

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation (Always and WhenInUse)
  location,

  /// Android: Microphone
  /// iOS: Microphone
  microphone,

  /// Android: Phone
  /// iOS: Nothing
  phone,

  /// Android: Nothing
  /// iOS: Photos
  photos,

  /// Android: Nothing
  /// iOS: Reminders
  reminders,

  /// Android: Body Sensors
  /// iOS: CoreMotion
  sensors,

  /// Android: Sms
  /// iOS: Nothing
  sms,

  /// Android: External Storage
  /// iOS: Nothing
  storage,

  /// Android: Microphone
  /// iOS: Speech
  speech,

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation - Always
  locationAlways,

  /// Android: Fine and Coarse Location
  /// iOS: CoreLocation - WhenInUse
  locationWhenInUse,

  /// Android: None
  /// iOS: MPMediaLibrary
  mediaLibrary
}
