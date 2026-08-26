import 'package:flutter/material.dart';

import 'analytics_card.dart';
import 'analytics_card_model.dart';

class AnalyticsGrid extends StatefulWidget {
  const AnalyticsGrid({
    super.key,
    required this.analytics,
  });

  final List<AnalyticsCardModel> analytics;

  @override
  State<AnalyticsGrid> createState() =>
      _AnalyticsGridState();
}

class _AnalyticsGridState
    extends State<AnalyticsGrid> {
  late final PageController _pageController;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      viewportFraction: 0.90,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ===============================================================
  // GO TO PAGE
  // ===============================================================

  Future<void> _goToPage(int index) async {
    if (!_pageController.hasClients) {
      return;
    }

    if (index < 0 ||
        index >= widget.analytics.length) {
      return;
    }

    await _pageController.animateToPage(
      index,
      duration: const Duration(
        milliseconds: 280,
      ),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.analytics.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        // =========================================================
        // HEADER
        // =========================================================

        Row(
          children: [
            Expanded(
              child: Text(
                'Analytics',
                style: theme
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(
                    0xFF0F172A,
                  ),
                ),
              ),
            ),

            if (widget.analytics.length > 1)
              Text(
                '${_currentPage + 1}/${widget.analytics.length}',
                style: theme
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                  color: const Color(
                    0xFF64748B,
                  ),
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
          ],
        ),

        const SizedBox(height: 10),

        // =========================================================
        // CAROUSEL
        // =========================================================

        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.analytics.length,
            clipBehavior: Clip.none,

            onPageChanged: (index) {
              if (!mounted) {
                return;
              }

              setState(() {
                _currentPage = index;
              });
            },

            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index ==
                      widget.analytics.length - 1
                      ? 0
                      : 10,
                ),
                child: AnalyticsCard(
                  metric:
                  widget.analytics[index],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 6),

        // =========================================================
        // PAGE INDICATORS
        // =========================================================

        if (widget.analytics.length > 1)
          Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: List.generate(
              widget.analytics.length,
                  (index) {
                final selected =
                    index == _currentPage;

                return Semantics(
                  button: true,
                  label:
                  'Show analytics ${index + 1}',
                  child: GestureDetector(
                    behavior:
                    HitTestBehavior.opaque,
                    onTap: () {
                      _goToPage(index);
                    },
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 5,
                      ),
                      child: AnimatedContainer(
                        duration:
                        const Duration(
                          milliseconds: 180,
                        ),
                        curve:
                        Curves.easeOutCubic,
                        width:
                        selected ? 18 : 6,
                        height: 5,
                        decoration:
                        BoxDecoration(
                          color: selected
                              ? const Color(
                            0xFF4F46E5,
                          )
                              : const Color(
                            0xFFC7CED9,
                          ),
                          borderRadius:
                          BorderRadius.circular(
                            999,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}