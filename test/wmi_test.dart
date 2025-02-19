import 'package:flutter_test/flutter_test.dart';
import 'package:wmi/wmi.dart';
import 'package:wmi/wmi_platform_interface.dart';
import 'package:wmi/wmi_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWmiPlatform with MockPlatformInterfaceMixin implements WmiPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool?> wmicPreInstalled() => Future.value(false);

  @override
  Future<bool?> wmiInit({String servename = 'ROOT\\CIMV2'}) =>
      Future.value(false);

  @override
  Future<void> wmiRelease() => Future.value();

  @override
  Future<String?> wmiValue({
    required String fieldname,
    required String tablename,
    String condition = '',
    String delimiter = ';',
  }) =>
      Future.value('Microsoft Windows 10 Home');

  @override
  Future<String?> wmiValues({
    required String fieldname,
    required String tablename,
    String condition = '',
    String delimiter = ';',
  }) =>
      Future.value('Microsoft Windows 10 Home');
}

void main() {
  final WmiPlatform initialPlatform = WmiPlatform.instance;

  test('$MethodChannelWmi is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWmi>());
  });

  test('getPlatformVersion', () async {
    Wmi wmiPlugin = Wmi();
    MockWmiPlatform fakePlatform = MockWmiPlatform();
    WmiPlatform.instance = fakePlatform;

    expect(await wmiPlugin.getPlatformVersion(), '42');
  });

  test('wmiValue', () async {
    Wmi wmiPlugin = Wmi();
    MockWmiPlatform fakePlatform = MockWmiPlatform();
    WmiPlatform.instance = fakePlatform;

    String wmiinfo = '';
    try {
      wmiinfo = await wmiPlugin.wmiValue(
              fieldname: 'Name', tablename: 'Win32_OperatingSystem') ??
          '';
    } catch (e) {
      // ignore: avoid_print
      print('test wmiValue, Win32_OperatingSystem.Name, error: $e');
      wmiinfo = '';
    }

    // ignore: avoid_print
    print('test wmiValue, Win32_OperatingSystem.Name, $wmiinfo');
    expect(wmiinfo.contains('Windows'), isTrue);
  });
}
