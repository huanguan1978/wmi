import 'wmi_platform_interface.dart';

class Wmi {
  Future<String?> getPlatformVersion() {
    return WmiPlatform.instance.getPlatformVersion();
  }

  /// wmicPreInstalled? (version < Windows 11 version 24H2) ? true : false
  Future<bool?> wmicPreInstalled() => WmiPlatform.instance.wmicPreInstalled();

  /// initialize WMI resources
  Future<bool?> wmiInit({String servename = 'ROOT\\CIMV2'}) =>
      WmiPlatform.instance.wmiInit(servename: servename);

  /// release WMI resources
  Future<void> wmiRelease() => WmiPlatform.instance.wmiRelease();

  /// Get-WmiObject single property
  Future<String?> wmiValue({
    required String fieldname,
    required String tablename,
    String condition = '',
    String delimiter = ';',
  }) =>
      WmiPlatform.instance.wmiValue(
        fieldname: fieldname,
        tablename: tablename,
        condition: condition,
        delimiter: delimiter,
      );

  /// Get-WmiObject multiple properties
  Future<String?> wmiValues({
    required String fieldname,
    required String tablename,
    String condition = '',
    String delimiter = ';',
  }) =>
      WmiPlatform.instance.wmiValues(
        fieldname: fieldname,
        tablename: tablename,
        condition: condition,
        delimiter: delimiter,
      );

  /// Get-WmiObject -Class Win32_ComputerSystemProduct | Select-Object -Property UUID
  Future<String?> uuid() => WmiPlatform.instance.wmiValue(
        fieldname: 'UUID',
        tablename: 'Win32_ComputerSystemProduct',
      );

  /// Get-WmiObject -Class Win32_OperatingSystem | Select-Object -Property SerialNumber
  Future<String?> osSerialNumber() => WmiPlatform.instance.wmiValue(
        fieldname: 'SerialNumber',
        tablename: 'Win32_OperatingSystem',
      );

  /// Get-WmiObject -Class Win32_OperatingSystem | Select-Object -Property RegisteredUser,SerialNumber,Name
  Future<String?> osInfo() => WmiPlatform.instance.wmiValues(
        fieldname: 'RegisteredUser,SerialNumber,Name',
        tablename: 'Win32_OperatingSystem',
      );

  /// Get-WmiObject -Class Win32_NetworkAdapter | Select-Object -Property MacAddress
  /// SELECT MacAddress FROM Win32_NetworkAdapterConfiguration WHERE DHCPEnabled=TRUE
  Future<String?> macAddress() => WmiPlatform.instance.wmiValue(
        fieldname: 'MacAddress',
        tablename: 'Win32_NetworkAdapter',
        condition:
            "WHERE (MACAddress IS NOT NULL) AND (NOT (PNPDeviceID LIKE 'ROOT%'))",
      );

  /// Get-WmiObject -Class Win32_BIOS | Select-Object -Property SerialNumber
  Future<String?> biosSerialNumber() => WmiPlatform.instance.wmiValue(
        fieldname: 'SerialNumber',
        tablename: 'Win32_BIOS',
      );

  /// Get-WmiObject -Class Win32_DiskDrive | Select-Object SerialNumber
  Future<String?> diskDriveSerialNumber() => WmiPlatform.instance.wmiValue(
        fieldname: 'SerialNumber',
        tablename: 'Win32_DiskDrive',
      );

  /// Get-WmiObject -Class Win32_Processor | Select-Object ProcessorId
  Future<String?> processorId() => WmiPlatform.instance.wmiValue(
        fieldname: 'ProcessorId',
        tablename: 'Win32_Processor',
      );

  // end_cls
}
