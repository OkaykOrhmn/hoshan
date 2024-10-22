import 'package:hoshan/core/gen/assets.gen.dart';

class HomeNavbar {
  final String title;
  final String icon;
  bool enabled;
  final String outlineAsset = 'assets/icon/outline/';
  final String bulkAsset = 'assets/icon/bulk/';
  HomeNavbar({required this.title, required this.icon, required this.enabled});

  SvgGenImage getIcon() {
    return SvgGenImage('${enabled ? bulkAsset : outlineAsset}$icon.svg');
  }

  void setEnabled(bool enable) {
    enabled = enable;
  }
}
