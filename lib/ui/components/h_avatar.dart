import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:homies/data/models/avatar.dart';

class HAvatar extends StatelessWidget {
  final Avatar avatar;
  final double width;
  final double height;

  const HAvatar({
    super.key,
    required this.avatar,
    this.width = 100,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    final String svgData =
        '''
<svg width="80" height="80" xmlns="http://www.w3.org/2000/svg">
    <circle r="40" cx="40" cy="40" fill="#${avatar.bgColor}"/>
    <g transform="translate(${avatar.faceX}, ${avatar.faceY}) scale(2)">
        <path d="M4 10c${avatar.bezier}" stroke="#${avatar.faceColor}" stroke-width="1.5" fill="none" stroke-linecap="round"></path>
        <rect x="${avatar.leX}" y="${avatar.leY}" width="2" height="2" rx="1" stroke="none" fill="#${avatar.faceColor}"></rect>
        <rect x="${avatar.reX}" y="${avatar.reY}" width="2" height="2" rx="1" stroke="none" fill="#${avatar.faceColor}"></rect>
    </g>
</svg>
''';

    return SvgPicture.string(svgData, width: width, height: height);
  }
}
