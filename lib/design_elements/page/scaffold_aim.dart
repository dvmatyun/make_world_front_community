import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      //final theme = Theme.of(context);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
          label: widget.metaName,
          primaryColor: 0,
        ),
      );
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', widget.metaName, defaultValue: ''));
    //properties.add(ColorProperty('color', color, defaultValue: null));
  }

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
