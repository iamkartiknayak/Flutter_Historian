import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_theme.dart';
import '../../../common/accent_svg_icon.dart';
import '../../../common/custom_button.dart';
import '../../clipboard/providers/clipboard_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/accent_color_pallete.dart';
import '../widgets/app_version_card.dart';
import '../widgets/border_radius_config_item.dart';
import '../widgets/custom_switch.dart';
import '../widgets/fitz_patrick_scale.dart';
import '../widgets/keyboard_shortcuts_bottomsheet.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final borderRadius = Theme.of(context).extension<BorderRadiusTheme>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: -12,
                  child: CustomButton(
                    onTap: Navigator.of(context).pop,
                    svgPath: 'assets/svgs/chevron_left.svg',
                    svgHeight: 24.0,
                    noAccent: true,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            borderRadius!.categoryTwoRadius,
                          ),
                        ),
                        context: context,
                        builder: (context) =>
                            const KeyboardShortcutsBottomsheet(),
                      );
                    },
                    child: const AccentSvgIcon(
                      iconPath: 'assets/svgs/keyboard.svg',
                      svgHeight: 24.0,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Settings',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Clipboard',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                CustomSwitch(
                  onTap:
                      context.read<SettingsProvider>().toggleClipboardListener,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Clipboard size'),
                const Spacer(),
                const _BuildClipboardSizeManipButton(
                  isIncremented: false,
                  svgPath: 'assets/svgs/chevron_down.svg',
                ),
                Selector<ClipboardProvider, int>(
                  builder: (context, clipboardSize, _) => SizedBox(
                    width: 32.0,
                    child: Text(
                      '$clipboardSize',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  selector: (_, p1) => p1.clipboardSize,
                ),
                const _BuildClipboardSizeManipButton(
                  isIncremented: true,
                  svgPath: 'assets/svgs/chevron_up.svg',
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            Text(
              'Emojis & Emoticons',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Clear recents',
                ),
                CustomButton(
                  onTap: context.read<SettingsProvider>().clearRecents,
                  label: 'Clear',
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            const Text('Emoji Skin Tone'),
            const SizedBox(height: 8.0),
            const FitzPatrickScale(),
            const SizedBox(height: 32.0),
            Text(
              'Personalization',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 8.0),
            const Text('Accent colors'),
            const SizedBox(height: 8.0),
            const AccentColorPallete(),
            const SizedBox(height: 20.0),
            const Text('Border Radius'),
            const SizedBox(height: 12.0),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BorderRadiusConfigItem(
                  label: 'Rounded',
                  borderRadius: 10,
                  position: 0,
                ),
                BorderRadiusConfigItem(
                  label: 'Curved',
                  borderRadius: 6,
                  position: 1,
                ),
                BorderRadiusConfigItem(
                  label: 'Square',
                  borderRadius: 0,
                  position: 2,
                ),
              ],
            ),
            const Spacer(),
            const AppVersionCard(),
          ],
        ),
      ),
    );
  }
}

class _BuildClipboardSizeManipButton extends StatelessWidget {
  const _BuildClipboardSizeManipButton({
    required this.isIncremented,
    required this.svgPath,
  });

  final bool isIncremented;
  final String svgPath;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ClipboardProvider>();
    return CustomButton(
      onTap: () => provider.updateClipboardSize(isIncremented),
      onLongPressStart: (p0) =>
          provider.startModifyingClipboardSize(isIncremented),
      onLongPressEnd: (p0) => provider.stopModifyingClipboardSize(),
      svgPath: svgPath,
    );
  }
}
