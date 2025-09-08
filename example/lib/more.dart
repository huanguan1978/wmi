import 'package:flutter/material.dart';
import 'package:wmi/wmi.dart';

class MoreTypes extends StatefulWidget {
  const MoreTypes({super.key, required this.wmiPlugin});

  final Wmi wmiPlugin;

  @override
  State<MoreTypes> createState() => _MoreTypesState();
}

class _MoreTypesState extends State<MoreTypes> {
  late final Wmi _wmiPlugin; //  = Wmi();
  bool _wmiInitialized = false;

  String _fieldName = '';
  String _tableName = '';
  String _value = '';

  @override
  void initState() {
    super.initState();

    _wmiPlugin = widget.wmiPlugin;
    _wmiInitialized = true;
    // initWmi();
  }

  /*
  Future<void> initWmi() async {
    try {
      _wmiInitialized = await _wmiPlugin.wmiInit() ?? false;
    } catch (e) {
      debugPrint('Failed wmiInit(), error: $e');
    }
  }
  */

  @override
  void dispose() {
    // if (_wmiInitialized) _wmiPlugin.wmiRelease();
    super.dispose();
  }

  Future<void> _getValue(String fieldName, String tableName) async {
    if (!_wmiInitialized) return;

    _fieldName = fieldName;
    _tableName = tableName;

    try {
      _value =
          await _wmiPlugin.wmiValue(
            fieldname: _fieldName,
            tablename: _tableName,
          ) ??
          'Unknown';
    } catch (e) {
      _value = 'Failed to get $_fieldName from $_tableName, error: $e';
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('wmi demo2')),
      body: Column(
        children: [
          Text('Field: $_fieldName'),
          Text('Table: $_tableName'),
          Text('Value: $_value'),
          Text('!! means crash'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton(
                onPressed: () => _getValue('DaylightName', 'Win32_TimeZone'),
                child: const Text('Daylight Name (string)'),
              ),
              ElevatedButton(
                onPressed: () =>
                    _getValue('StandardDayOfWeek', 'Win32_TimeZone'),
                child: const Text('Day of Week (uint8) !!'),
              ),
              ElevatedButton(
                onPressed: () => _getValue('OSType', 'Win32_OperatingSystem'),
                child: const Text('OS Type (uint16) !!'),
              ),
              ElevatedButton(
                onPressed: () =>
                    _getValue('OSLanguage', 'Win32_OperatingSystem'),
                child: const Text('OS Language (uint32) !!'),
              ),
              ElevatedButton(
                onPressed: () => _getValue(
                  'TotalVisibleMemorySize',
                  'Win32_OperatingSystem',
                ),
                child: const Text('Memory Size (uint64)'),
              ),
              ElevatedButton(
                onPressed: () => _getValue(
                  'VirtualizationFirmwareEnabled',
                  'Win32_Processor',
                ),
                child: const Text('Virtualization (bool) !!'),
              ),
              ElevatedButton(
                onPressed: () =>
                    _getValue('LastBootUpTime', 'Win32_OperatingSystem'),
                child: const Text('Last boot (datetime)'),
              ),
              ElevatedButton(
                onPressed: () =>
                    _getValue('CurrentTimeZone', 'Win32_OperatingSystem'),
                child: const Text('Current Time Zone (sint16) !!'),
              ),
              ElevatedButton(
                onPressed: () => _getValue('Bias', 'Win32_TimeZone'),
                child: const Text('Bias (sint32) !!'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
