import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:homies/data/models/avatar.dart';

// TODO: chiedere a MR codice l'avatar
const Avatar sadGrayAvatar = Avatar(
  bgColor: 'D5D5D5',
  faceColor: '424242',
  faceX: 33.399338,
  faceY: 15.339521,
  leX: 0.50351334,
  leY: 4.794397,
  reX: 11.496487,
  reY: 3.4529395,
  bezier: '1 2 3 0 6 1', // downward curve (sad)
);

class HAvatar extends StatelessWidget {
  final Avatar? avatar;
  final double size;

  const HAvatar({super.key, this.avatar, this.size = 100});

  @override
  Widget build(BuildContext context) {
    final avatarNullSafe = avatar ?? sadGrayAvatar;

    final String svgData =
        '''
<svg width="80" height="80" xmlns="http://www.w3.org/2000/svg">
    <circle r="40" cx="40" cy="40" fill="#${avatarNullSafe.bgColor}"/>
    <g transform="translate(${avatarNullSafe.faceX}, ${avatarNullSafe.faceY}) scale(2)">
        <path d="M4 10c${avatarNullSafe.bezier}" stroke="#${avatarNullSafe.faceColor}" stroke-width="1.5" fill="none" stroke-linecap="round"></path>
        <rect x="${avatarNullSafe.leX}" y="${avatarNullSafe.leY}" width="2" height="2" rx="1" stroke="none" fill="#${avatarNullSafe.faceColor}"></rect>
        <rect x="${avatarNullSafe.reX}" y="${avatarNullSafe.reY}" width="2" height="2" rx="1" stroke="none" fill="#${avatarNullSafe.faceColor}"></rect>
    </g>
</svg>
''';

    return SvgPicture.string(svgData, width: size, height: size);
  }
}
