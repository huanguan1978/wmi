import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'wmi_method_channel.dart';

abstract class WmiPlatform extends PlatformInterface {
  /// Constructs a WmiPlatform.
  WmiPlatform() : super(token: _token);

  static final Object _token = Object();

  static WmiPlatform _instance = MethodChannelWmi();

  /// The default instance of [WmiPlatform] to use.
  ///
  /// Defaults to [MethodChannelWmi].
  static WmiPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WmiPlatform] when
  /// they register themselves.
  static set instance(WmiPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> wmiInit({String servename = 'ROOT\\CIMV2'}) {
    throw UnimplementedError('wmiInit(servename) has not been implemented.');
  }

  Future<void> wmiRelease() {
    throw UnimplementedError('wmiRelease() has not been implemented.');
  }

  Future<String?> wmiValue({
    required String fieldname,
    required String tablename,
    String condition = '',
    String delimiter = ';',
  }) {
    throw UnimplementedError(
        'wmiValue(fieldname, tablename) has not been implemented.');
  }

  Future<String?> wmiValues({
    required String fieldname,
    required String tablename,
    String condition = '',
    String delimiter = ';',
  }) {
    throw UnimplementedError(
        'wmiValues(fieldname, tablename) has not been implemented.');
  }
}
