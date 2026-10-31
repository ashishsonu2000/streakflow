import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screen_time_providers.dart';

/// Hidden diagnostics for "Digital detox" habits (tap "Screen time
/// today" 5 times): permissions, limits, what iOS/Android is monitoring
/// and the native side's recent events, with Copy to send them on.
class ScreenTimeDiagnosticsSheet extends ConsumerStatefulWidget {
  const ScreenTimeDiagnosticsSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => const ScreenTimeDiagnosticsSheet(),
      );

  @override
  ConsumerState<ScreenTimeDiagnosticsSheet> createState() =>
      _ScreenTimeDiagnosticsSheetState();
}

class _ScreenTimeDiagnosticsSheetState
    extends ConsumerState<ScreenTimeDiagnosticsSheet> {
  Map<String, Object?>? _data;
  String? _testMessage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ref.read(screenTimeServiceProvider).diagnostics();
    if (mounted) setState(() => _data = data);
  }

  String _asText() {
    final buffer = StringBuffer('StreakFlow screen-time diagnostics\n');
    for (final entry in (_data ?? const {}).entries) {
      final value = entry.value;
      if (value is List) {
        buffer.writeln('${entry.key}:');
        if (value.isEmpty) buffer.writeln('  (none)');
        for (final line in value) {
          buffer.writeln('  $line');
        }
      } else {
        buffer.writeln('${entry.key}: $value');
      }
    }
    if (_testMessage != null) buffer.writeln('Test: $_testMessage');
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final service = ref.watch(screenTimeServiceProvider);
    final data = _data;

    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Screen-time diagnostics',
                style: theme.textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: data == null
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SelectableText(
                        _asText(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Refresh'),
                    onPressed: () {
                      setState(() => _data = null);
                      _load();
                    },
                  ),
                  if (service.isIOS)
                    OutlinedButton.icon(
                      icon: const Icon(Icons.timer_outlined),
                      label: const Text('1-minute test alert'),
                      onPressed: () async {
                        final message = await service.startTestAlert();
                        if (!mounted) return;
                        setState(() => _testMessage = message);
                        _load();
                      },
                    ),
                  FilledButton.icon(
                    icon: const Icon(Icons.copy_rounded),
                    label: const Text('Copy'),
                    onPressed: data == null
                        ? null
                        : () async {
                            await Clipboard.setData(
                              ClipboardData(text: _asText()),
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Diagnostics copied'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
