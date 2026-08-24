import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({
    super.key,
  });

  @override
  State<AboutPage> createState() {
    return _AboutPageState();
  }
}

class _AboutPageState extends State<AboutPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();

    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info =
    await PackageInfo.fromPlatform();

    if (!mounted) {
      return;
    }

    setState(() {
      _version =
      '${info.version}+${info.buildNumber}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About',
        ),
      ),
      body: Padding(
        padding:
        const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),

            const Icon(
              Icons.local_fire_department,
              size: 72,
            ),

            const SizedBox(
              height: 24,
            ),

            Text(
              'Streak Calculator',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall,
            ),

            const SizedBox(
              height: 8,
            ),

            const Text(
              'Build better habits every day.',
            ),

            const SizedBox(
              height: 32,
            ),

            ListTile(
              leading: const Icon(
                Icons.info_outline,
              ),
              title: const Text(
                'Version',
              ),
              subtitle: Text(
                _version,
              ),
            ),

            const Divider(),

            const ListTile(
              leading: Icon(
                Icons.storage_outlined,
              ),
              title: Text(
                'Storage',
              ),
              subtitle: Text(
                'All data is stored locally.',
              ),
            ),

            const Divider(),

            const ListTile(
              leading: Icon(
                Icons.flutter_dash,
              ),
              title: Text(
                'Built With',
              ),
              subtitle: Text(
                'Flutter + Riverpod',
              ),
            ),

            const Spacer(),

            const Text(
              '© 2026',
            ),

            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}