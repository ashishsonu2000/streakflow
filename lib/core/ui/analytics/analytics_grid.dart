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
      viewportFraction: 0.88,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (widget.analytics.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        // ===========================================================
        // ANALYTICS HEADER
        // ===========================================================

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 2,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Analytics',
                  style: theme
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    color:
                    colors.onSurface,
                    fontWeight:
                    FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
              ),

              Text(
                '${_currentPage + 1}/${widget.analytics.length}',
                style: theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  color:
                  colors.onSurfaceVariant,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // ===========================================================
        // CAROUSEL
        // ===========================================================

        SizedBox(
          height: 128,

          child: PageView.builder(
            controller: _pageController,

            itemCount:
            widget.analytics.length,

            physics:
            const BouncingScrollPhysics(),

            onPageChanged: (index) {
              if (!mounted) {
                return;
              }

              setState(() {
                _currentPage = index;
              });
            },

            itemBuilder:
                (context, index) {
              return Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 4,
                ),

                child: AnalyticsCard(
                  metric:
                  widget.analytics[index],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 7),

        // ===========================================================
        // PAGE INDICATORS
        // ===========================================================

        Center(
          child: Row(
            mainAxisSize:
            MainAxisSize.min,
            children: List.generate(
              widget.analytics.length,
                  (index) {
                final isActive =
                    index == _currentPage;

                return GestureDetector(
                  behavior:
                  HitTestBehavior.opaque,

                  onTap: () {
                    _pageController
                        .animateToPage(
                      index,
                      duration:
                      const Duration(
                        milliseconds: 280,
                      ),
                      curve:
                      Curves.easeOutCubic,
                    );
                  },

                  child:
                  AnimatedContainer(
                    duration:
                    const Duration(
                      milliseconds: 220,
                    ),
                    curve:
                    Curves.easeOut,

                    margin:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 3,
                    ),

                    width:
                    isActive ? 18 : 6,

                    height: 6,

                    decoration:
                    BoxDecoration(
                      color: isActive
                          ? colors.primary
                          : colors
                          .outlineVariant,
                      borderRadius:
                      BorderRadius
                          .circular(
                        999,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}