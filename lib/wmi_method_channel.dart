import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'wmi_platform_interface.dart';

/// An implementation of [WmiPlatform] that uses method channels.
class MethodChannelWmi extends WmiPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('wmi');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> wmicPreInstalled() async {
    final wmicPreInstalled =
        await methodChannel.invokeMethod<bool>('wmicPreInstalled');
    return wmicPreInstalled;
  }

  @override
  Future<bool?> wmiInit({String servename = 'ROOT\\CIMV2'}) async {
    final args = <String, dynamic>{'servename': servename};
    final initialized = await methodChannel.invokeMethod<bool>('wmiInit', args);
    return initialized;
  }

  @override
  Future<void> wmiRelease() => methodChannel.invokeMethod<void>('wmiRelease');

  @override
  Future<String?> wmiValue({
    required String fieldname,
    required String tablename,
    String condition = '',
    String delimiter = ';',
  }) async {
    final args = <String, dynamic>{
      'fieldname': fieldname,
      'tablename': tablename,
      'condition': condition,
      'delimiter': delimiter,
    };
    final message = await methodChannel.invokeMethod<String>('wmiValue', args);
    return message;
  }

  @override
  Future<String?> wmiValues({
    required String fieldname,
    required String tablename,
    String condition = '',
    String delimiter = ';',
  }) async {
    final args = <String, dynamic>{
      'fieldname': fieldname,
      'tablename': tablename,
      'condition': condition,
      'delimiter': delimiter,
    };
    final message = await methodChannel.invokeMethod<String>('wmiValues', args);
    return message;
  }
}
