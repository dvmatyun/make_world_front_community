import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// {@template page_wrapper_aim}
/// PageWrapperAim widget
/// {@endtemplate}
class PageWrapperAim extends StatefulWidget {
  /// {@macro page_wrapper_aim}
  const PageWrapperAim({required this.metaName, required this.child, super.key});

  final String metaName;
  final Widget child;

  @override
  State<PageWrapperAim> createState() => _PageWrapperAimState();
}

/// State for widget PageWrapperAim
class _PageWrapperAimState extends State<PageWrapperAim> {
  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _setAttrs();
    });
  }

  Future<void> _setAttrs() async {
    //final theme = Theme.of(context);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (!mounted) {
      return;
    }
    await SystemChrome.setApplicationSwitcherDescription(
      ApplicationSwitcherDescription(
        label: widget.metaName,
        primaryColor: 0,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', widget.metaName, defaultValue: ''));
    //properties.add(ColorProperty('color', color, defaultValue: null));
  }

  @override
  void didUpdateWidget(PageWrapperAim oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setAttrs();
  }

  /* #endregion */

  @override
  Widget build(BuildContext context) => widget.child;
}
