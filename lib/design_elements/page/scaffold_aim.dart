import 'package:flutter/material.dart';

/// {@template scaffold_aim}
/// ScaffoldAim widget
/// {@endtemplate}
class ScaffoldAim extends StatefulWidget {
  /// {@macro scaffold_aim}
  const ScaffoldAim({
    required this.body,
    required this.metaName,
    this.appBarWidget,
    super.key,
  });

  final Widget body;
  final String metaName;
  final Widget? appBarWidget;

  @override
  State<ScaffoldAim> createState() => _ScaffoldAimState();
}

class _ScaffoldAimState extends State<ScaffoldAim> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: widget.appBarWidget == null
          ? null
          : AppBar(
              backgroundColor: theme.colorScheme.inversePrimary,
              title: widget.appBarWidget,
            ),
      body: widget.body,
    );
  }
}
