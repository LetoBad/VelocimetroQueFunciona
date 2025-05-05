import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Widget principal do velocímetro
class VelocimetroWidget extends StatelessWidget {
  final double velocidade;
  final double velocidadeMax;

  const VelocimetroWidget({
    super.key,
    required this.velocidade,
    this.velocidadeMax = 180.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 220,
            width: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3A5A99),
                  Color(0xFF6B7B94),
                ],
              ),
            ),
          ),
          CustomPaint(
            size: const Size(240, 240),
            painter: PintorVelocimetro(velocidadeMax: velocidadeMax),
          ),
          Transform.rotate(
            angle: _obterAnguloDaVelocidade(velocidade, velocidadeMax),
            child: Container(
              height: 160,
              width: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.green.shade300, Colors.green.shade700],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF2E3B3C),
            ),
          ),
          Positioned(
            bottom: 30,
            child: Column(
              children: [
                Text(
                  velocidade.toStringAsFixed(1),
                  style: GoogleFonts.orbitron(
                    fontSize: 46,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'km/h',
                  style: GoogleFonts.orbitron(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _obterAnguloDaVelocidade(double velocidade, double velocidadeMax) {
    double velocidadeLimitada = velocidade.clamp(0, velocidadeMax);

    double anguloInicial = -3 * pi / 4; // -135 graus
    double anguloFinal = 3 * pi / 4; // 135 graus
    double intervaloTotal = anguloFinal - anguloInicial;

    double proporcao = velocidadeLimitada / velocidadeMax;
    return anguloInicial + (proporcao * intervaloTotal);
  }
}

class PintorVelocimetro extends CustomPainter {
  final double velocidadeMax;

  PintorVelocimetro({required this.velocidadeMax});

  @override
  void paint(Canvas canvas, Size tamanho) {
    final centro = Offset(tamanho.width / 2, tamanho.height / 2);
    final raio = tamanho.width / 2;

    final pincel = Paint()
      ..color = Colors.white.withOpacity(
        0.6,
      )
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const anguloInicial = -3 * pi / 4;
    const anguloFinal = 3 * pi / 4;
    canvas.drawArc(
      Rect.fromCircle(center: centro, radius: raio - 20),
      anguloInicial,
      anguloFinal - anguloInicial,
      false,
      pincel,
    );

    const quantidadeMarcasGrandes = 10;
    const passoAngulo = (anguloFinal - anguloInicial) / quantidadeMarcasGrandes;
    final passoVelocidade = velocidadeMax / quantidadeMarcasGrandes;

    final desenhadorTexto = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i <= quantidadeMarcasGrandes; i++) {
      final angulo = anguloInicial + (i * passoAngulo);
      final x1 = centro.dx + (raio - 20) * cos(angulo);
      final y1 = centro.dy + (raio - 20) * sin(angulo);
      final x2 = centro.dx + (raio - 35) * cos(angulo);
      final y2 = centro.dy + (raio - 35) * sin(angulo);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), pincel);

      final velocidade = (i * passoVelocidade).toStringAsFixed(0);
      desenhadorTexto.text = TextSpan(
        text: velocidade,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      );

      desenhadorTexto.layout();

      final textoX =
          centro.dx + (raio - 50) * cos(angulo) - desenhadorTexto.width / 2;
      final textoY =
          centro.dy + (raio - 50) * sin(angulo) - desenhadorTexto.height / 2;
      desenhadorTexto.paint(canvas, Offset(textoX, textoY));
    }

    const quantidadeMarcasPequenas = quantidadeMarcasGrandes * 5;
    final passoAnguloMenor =
        (anguloFinal - anguloInicial) / quantidadeMarcasPequenas;

    for (int i = 0; i <= quantidadeMarcasPequenas; i++) {
      if (i % 5 != 0) {
        final angulo = anguloInicial + (i * passoAnguloMenor);
        final x1 = centro.dx + (raio - 20) * cos(angulo);
        final y1 = centro.dy + (raio - 20) * sin(angulo);
        final x2 = centro.dx + (raio - 28) * cos(angulo);
        final y2 = centro.dy + (raio - 28) * sin(angulo);

        canvas.drawLine(
          Offset(x1, y1),
          Offset(x2, y2),
          Paint()
            ..color = Colors.white.withOpacity(0.3)
            ..strokeWidth = 1,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter antigo) {
    return true;
  }
}
