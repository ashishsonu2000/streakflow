import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'settings_tile.dart';

class VersionTile extends StatelessWidget {
  const VersionTile({super.key});

  Future<String> _version() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _version(),
      builder: (context, snapshot) {
        return SettingsTile(
          leading: const Icon(Icons.info_outline),
          title: 'Version',
          subtitle: snapshot.data ?? '--',
          trailing: const SizedBox.shrink(),
        );
      },
    );
  }
}
