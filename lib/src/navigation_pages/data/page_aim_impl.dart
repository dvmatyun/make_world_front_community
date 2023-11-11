import 'package:flutter/material.dart';
import 'package:make_world_front_community/src/navigation_pages/domain/page_aim.dart';

class PageAim implements IPageAim {
  PageAim({
    required String name,
    required this.child,
  })  : key = name,
        nameUi = name;

  @override
  final String key;
  @override
  final String nameUi;
  @override
  final Widget child;
}
