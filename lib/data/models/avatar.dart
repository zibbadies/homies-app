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

  const Avatar({
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
    // Go's encoding/json emits whole numbers as ints (4, not 4.0),
    // so every numeric field goes through num.toDouble().
    return Avatar(
      bgColor: json['bg_color'],
      faceColor: json['face_color'],
      faceX: (json['face_x'] as num).toDouble(),
      faceY: (json['face_y'] as num).toDouble(),
      leX: (json['le_x'] as num).toDouble(),
      leY: (json['le_y'] as num).toDouble(),
      reX: (json['re_x'] as num).toDouble(),
      reY: (json['re_y'] as num).toDouble(),
      bezier: json['bezier'],
    );
  }
}
