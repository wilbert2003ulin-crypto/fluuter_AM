import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

class SignaturePadCard extends StatefulWidget {
  const SignaturePadCard({super.key});

  @override
  State<SignaturePadCard> createState() => _SignaturePadCardState();
}

class _SignaturePadCardState extends State<SignaturePadCard> {
  final List<Offset?> _points = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F4EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.primaryGreen,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PASO 3',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primaryGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    'Firma del cliente',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textDark,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'El cliente recibe el producto y acepta el monto y esquema de pagos establecido.',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD1D5DB), width: 1.2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        _points.add(details.localPosition);
                      });
                    },
                    onPanEnd: (_) {
                      _points.add(null);
                    },
                    child: CustomPaint(
                      painter: _SignaturePainter(_points),
                      size: Size.infinite,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _points.clear();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Text(
                          'Limpiar',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.primaryGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_points.isEmpty)
                    Positioned(
                      bottom: 12,
                      left: 14,
                      child: IgnorePointer(
                        child: Text(
                          'Firme dentro de este recuadro',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textMuted.withValues(alpha: 0.6),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset?> points;
  _SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textDark
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.6;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter oldDelegate) => true;
}
