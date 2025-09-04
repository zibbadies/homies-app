class Avatar {
  final String bgColor;
  final String faceColor;
  final double faceX;
  final double faceY;
  final double leX;
  final double leY;
  final double reX;
  final double reY;
  final String bezier;

  Avatar({
    required this.bgColor,
    required this.faceColor,
    required this.faceX,
    required this.faceY,
    required this.leX,
    required this.leY,
    required this.reX,
    required this.reY,
    required this.bezier,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      bgColor: json['bg_color'],
      faceColor: json['face_color'],
      faceX: json['face_x'],
      faceY: json['face_y'],
      leX: json['le_x'],
      leY: json['le_y'],
      reX: json['re_x'],
      reY: json['re_y'],
      bezier: json['bezier'],
    );
  }
}
