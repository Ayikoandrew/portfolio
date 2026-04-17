import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sectionKeysProvider = Provider<Map<String, GlobalKey>>((ref) {
  return {
    'Home': GlobalKey(),
    'About': GlobalKey(),
    'Research': GlobalKey(),
    'Projects': GlobalKey(),
    'Skills': GlobalKey(),
    'Contact': GlobalKey(),
  };
});

void scrollToSection(GlobalKey key) {
  final context = key.currentContext;
  if (context != null) {
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }
}
