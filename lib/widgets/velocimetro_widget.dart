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
          CustomPaint(
            size: const Size(240, 240),
            painter: PintorVelocimetro(velocidadeMax: velocidadeMax),
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
                    color: Colors.blue.shade600, // Alterado para azul
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

    double anguloInicial = -3 * pi / 4;
    double anguloFinal = 3 * pi / 4;
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
      ..color = Colors.blue.shade300 // Alterado para um azul mais suave
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
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i <= quantidadeMarcasGrandes; i++) {
      final angulo = anguloInicial + (passoAngulo * i);
      final x = centro.dx + cos(angulo) * (raio - 20);
      final y = centro.dy + sin(angulo) * (raio - 20);

      desenhadorTexto.text = TextSpan(
        text: (passoVelocidade * i).toStringAsFixed(0),
        style: const TextStyle(color: Colors.black, fontSize: 14),
      );

      desenhadorTexto.layout();
      desenhadorTexto.paint(
        canvas,
        Offset(x - desenhadorTexto.width / 2, y - desenhadorTexto.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
