import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_ui/util/smart_fan_box.dart';
import 'package:simple_ui/util/smart_device_box.dart';
import 'package:simple_ui/util/smart_light_box.dart';
import 'package:simple_ui/util/environment_components.dart';
import 'package:simple_ui/components/app_drawer.dart'; // New drawer component
import 'package:simple_ui/pages/login_page.dart'; // For logout functionality

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // padding constants
  final double horizontalPadding = 30;
  final double verticalPadding = 25;

  // list of smart devices
  List mySmartDevices = [
    ["Smart Light", "lib/icons/light-bulb.png", true],
    ["Smart Window", "lib/icons/windows.png", false],
    ["Smart Door", "lib/icons/house-door.png", false],
    ["Smart Fan", "lib/icons/fan.png", false],
  ];

  // Global key for scaffold to open drawer programmatically
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // power button switched
  void powerSwitchChanged(bool value, int index) {
    setState(() {
      mySmartDevices[index][2] = value;
    });
  }

  // Toggle all devices
  void toggleAllDevices(bool value) {
    setState(() {
      for (var device in mySmartDevices) {
        device[2] = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[300],
      drawer: AppDrawer(
        onLogout: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // app bar with menu button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu button to open drawer
                  IconButton(
                    icon: Image.asset(
                      'lib/icons/menu.png',
                      height: 30,
                      color: Colors.grey[800],
                    ),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  // User profile with quick actions menu
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.grey[800],
                    ),
                    onSelected: (value) {
                      if (value == 'logout') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem(
                          value: 'profile',
                          child: Text('Edit Profile'),
                        ),
                        const PopupMenuItem(
                          value: 'settings',
                          child: Text('Settings'),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem(
                          value: 'logout',
                          child: Text('Log Out'),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // welcome home section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome Home,",
                    style: TextStyle(fontSize: 20, color: Colors.grey.shade800),
                  ),
                  Text(
                    'Mohamed Ragb',
                    style: GoogleFonts.bebasNeue(fontSize: 62),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Environment Status Bar
            StreamBuilder<EnvironmentData>(
              stream: EnvironmentService().stream,
              builder: (context, snapshot) {
                final data = snapshot.data ?? EnvironmentData.empty();
                if (data.gasLeak) {
                  return const GasAlertBanner();
                }
                return SensorStatusBar(
                  temperature: data.temperature,
                  humidity: data.humidity,
                );
              },
            ),

            const SizedBox(height: 15),

            // Quick actions row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.power_settings_new, size: 18),
                    label: const Text('All On'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => toggleAllDevices(true),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.power_off, size: 18),
                    label: const Text('All Off'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => toggleAllDevices(false),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Divider(
                thickness: 1,
                color: Color.fromARGB(255, 204, 204, 204),
              ),
            ),

            const SizedBox(height: 15),

            // smart devices grid header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  Text(
                    "Smart Devices",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      // Refresh device states
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // devices grid
            Expanded(
              child: GridView.builder(
                itemCount: mySmartDevices.length,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.25,
                ),
                itemBuilder: (context, index) {
                  if (mySmartDevices[index][0] == "Smart Light") {
                    return SmartLightBox(
                      smartDeviceName: mySmartDevices[index][0],
                      iconPath: mySmartDevices[index][1],
                      powerOn: mySmartDevices[index][2],
                      onChanged: (value) => powerSwitchChanged(value, index),
                    );
                  } else if (mySmartDevices[index][0] == "Smart Fan") {
                    return SmartFanBox(
                      smartDeviceName: mySmartDevices[index][0],
                      iconPath: mySmartDevices[index][1],
                      powerOn: mySmartDevices[index][2],
                      onChanged: (value) => powerSwitchChanged(value, index),
                    );
                  }
                  return SmartDeviceBox(
                    smartDeviceName: mySmartDevices[index][0],
                    iconPath: mySmartDevices[index][1],
                    powerOn: mySmartDevices[index][2],
                    onChanged: (value) => powerSwitchChanged(value, index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Floating action button for quick actions
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show quick actions menu
          showModalBottomSheet(
            context: context,
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Add New Device'),
                  onTap: () {
                    Navigator.pop(context);
                    // Add device logic
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Quick Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    // Settings logic
                  },
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.menu),
      ),
    );
  }
}
