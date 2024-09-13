import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/emoticon_provider.dart';

class EmoticonItem extends StatelessWidget {
  const EmoticonItem({
    super.key,
    required this.emoticon,
    required this.index,
  });

  final String emoticon;
  final int index;

  @override
  Widget build(BuildContext context) {
    final emoticonProvider = context.read<EmoticonProvider>();
    final isHovered =
        context.select((EmoticonProvider p) => p.isHovering(index));

    return GestureDetector(
      onTap: () => emoticonProvider.copyEmoticon(emoticon),
      behavior: HitTestBehavior.translucent,
      child: MouseRegion(
        onEnter: (_) => emoticonProvider.updateHoverState(true, index),
        onExit: (_) => emoticonProvider.updateHoverState(false, index),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isHovered)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                ),
              ),
            Text(
              emoticon,
              style: TextStyle(
                fontSize: isHovered ? 24.0 : 20.0,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}