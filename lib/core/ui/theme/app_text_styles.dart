import 'package:flutter/material.dart';

class AppTextStyles {
  const AppTextStyles._();

  //------------------------------------------------------
  // Screen Titles
  //------------------------------------------------------

  static TextStyle screenTitle(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontWeight: FontWeight.bold,
        );
  }

  static TextStyle pageTitle(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.bold,
        );
  }

  //------------------------------------------------------
  // Section Titles
  //------------------------------------------------------

  static TextStyle sectionTitle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.w700,
        );
  }

  static TextStyle cardTitle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w700,
        );
  }

  //------------------------------------------------------
  // Body
  //------------------------------------------------------

  static TextStyle body(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!;
  }

  static TextStyle bodySecondary(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
  }

  static TextStyle caption(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
  }

  //------------------------------------------------------
  // Labels
  //------------------------------------------------------

  static TextStyle label(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
          fontWeight: FontWeight.w600,
        );
  }

  static TextStyle chip(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
          fontWeight: FontWeight.w600,
        );
  }

  //------------------------------------------------------
  // Metrics
  //------------------------------------------------------

  static TextStyle metric(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.bold,
        );
  }

  static TextStyle hero(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge!.copyWith(
          fontWeight: FontWeight.bold,
        );
  }
}
