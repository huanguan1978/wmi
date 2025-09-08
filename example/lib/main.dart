import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:wmi/wmi.dart';
import 'more.dart';

void main() {
  runApp(MaterialApp(title: 'wmi demo', home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _wmiPlugin = Wmi();
  bool _wmiInitialized = false;
  bool _wmicPreInstalled = false;
  String _platformVersion = 'Unknown';
  String _wmiinfo = 'Unknown';
  String _wminame = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    if (_wmiInitialized) _wmiPlugin.wmiRelease();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _wmiPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    bool wmicPreInstalled = false;
    try {
      wmicPreInstalled = await _wmiPlugin.wmicPreInstalled() ?? false;
    } on PlatformException catch (e) {
      debugPrint('Failed wmicPreInstalled(), error: $e');
    }

    bool wmiInitialized = false;
    try {
      wmiInitialized = await _wmiPlugin.wmiInit() ?? false;
    } on PlatformException catch (e) {
      debugPrint('Failed wmiInit(), error: $e');
    }

    String wmiinfo = "", wminame = 'UUID';
    if (wmiInitialized) {
      try {
        wmiinfo =
            await _wmiPlugin.wmiValue(
              fieldname: 'UUID',
              tablename: 'Win32_ComputerSystemProduct',
            ) ??
            'Unknown';
      } on PlatformException catch (e) {
        wmiinfo = 'Failed to get $wminame, error: $e';
      }
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _wmiInitialized = wmiInitialized;
      _wmicPreInstalled = wmicPreInstalled;
      _wmiinfo = wmiinfo;
      _wminame = wminame;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('wmi demo1'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MoreTypes(wmiPlugin: _wmiPlugin),
                ),
              );
            },
            icon: const Icon(Icons.more),
            tooltip: 'test more types',
          ),
        ],
      ),
      body: Center(
        // Text('Running on: $_platformVersion\n $_wmiinfo\n'),
        child: Column(
          children: <Widget>[
            Text('wmicPreInstalled: $_wmicPreInstalled'),
            Text('Running on: $_platformVersion'),
            Text('WMI Info, $_wminame: $_wmiinfo'),
            SizedBox(height: 20),
            TextButton(
              child: const Text('UUID'),
              onPressed: () async {
                String wmiinfo, wminame = 'UUID';
                try {
                  wmiinfo = await _wmiPlugin.uuid() ?? 'Unknown';
                } on PlatformException catch (e) {
                  wmiinfo = 'Failed get $wminame, \n error: $e';
                }
                setState(() {
                  _wmiinfo = wmiinfo;
                  _wminame = wminame;
                });
              },
            ),
            SizedBox(height: 10),
            TextButton(
              child: const Text('osSerialNumber'),
              onPressed: () async {
                String wmiinfo, wminame = 'osSerialNumber';
                try {
                  wmiinfo = await _wmiPlugin.osSerialNumber() ?? 'Unknown';
                } on PlatformException catch (e) {
                  wmiinfo = 'Failed get $wminame, error: $e';
                }
                setState(() {
                  _wmiinfo = wmiinfo;
                  _wminame = wminame;
                });
              },
            ),
            SizedBox(height: 10),
            TextButton(
              child: const Text('osInformation'),
              onPressed: () async {
                String wmiinfo, wminame = 'osInfo';
                try {
                  wmiinfo = await _wmiPlugin.osInfo() ?? 'Unknown';
                } on PlatformException catch (e) {
                  wmiinfo = 'Failed get $wminame, error: $e';
                }
                setState(() {
                  _wmiinfo = wmiinfo;
                  _wminame = wminame;
                });
              },
            ),
            SizedBox(height: 10),
            TextButton(
              child: const Text('macAddress'),
              onPressed: () async {
                String wmiinfo, wminame = 'macAddress';
                try {
                  wmiinfo = await _wmiPlugin.macAddress() ?? 'Unknown';
                } on PlatformException catch (e) {
                  wmiinfo = 'Failed get $wminame, error: $e';
                }
                setState(() {
                  _wmiinfo = wmiinfo;
                  _wminame = wminame;
                });
              },
            ),
            SizedBox(height: 10),
            TextButton(
              child: const Text('biosSerialNumber'),
              onPressed: () async {
                String wmiinfo, wminame = 'biosSerialNumber';
                try {
                  wmiinfo = await _wmiPlugin.biosSerialNumber() ?? 'Unknown';
                } on PlatformException catch (e) {
                  wmiinfo = 'Failed get $wminame, error: $e';
                }
                setState(() {
                  _wmiinfo = wmiinfo;
                  _wminame = wminame;
                });
              },
            ),
            SizedBox(height: 10),
            TextButton(
              child: const Text('diskDriveSerialNumber'),
              onPressed: () async {
                String wmiinfo, wminame = 'diskDriveSerialNumber';
                try {
                  wmiinfo =
                      await _wmiPlugin.diskDriveSerialNumber() ?? 'Unknown';
                } on PlatformException catch (e) {
                  wmiinfo = 'Failed get $wminame, error: $e';
                }
                setState(() {
                  _wmiinfo = wmiinfo;
                  _wminame = wminame;
                });
              },
            ),
            SizedBox(height: 10),
            TextButton(
              child: const Text('ProcessorId'),
              onPressed: () async {
                String wmiinfo, wminame = 'ProcessorId';
                try {
                  wmiinfo = await _wmiPlugin.processorId() ?? 'Unknown';
                } on PlatformException catch (e) {
                  wmiinfo = 'Failed get $wminame, error: $e';
                }
                setState(() {
                  _wmiinfo = wmiinfo;
                  _wminame = wminame;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
