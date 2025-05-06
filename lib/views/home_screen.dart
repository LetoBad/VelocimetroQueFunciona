import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocimetro/viewmodels/viagem_viewmodel.dart';
import 'package:velocimetro/widgets/velocimetro_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<ViagemViewModel>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text(
          'Speidometer',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.blue.shade50,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<ViagemViewModel>(
        builder: (context, viagemViewModel, child) {
          if (!viagemViewModel.permissaoLocalizacao) {
            return _buildPermissaoSolicitacao(viagemViewModel);
          }
          return _buildInformacoesViagem(viagemViewModel);
        },
      ),
    );
  }

  Widget _buildPermissaoSolicitacao(ViagemViewModel viagemViewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_disabled, size: 60, color: Colors.white70),
          const SizedBox(height: 20),
          const Text(
            'Permissão de localização necessária',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => viagemViewModel.solicitarPermissaoLocalizacao(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('Solicitar Permissão'),
          ),
        ],
      ),
    );
  }

  Widget _buildInformacoesViagem(ViagemViewModel viagemViewModel) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                VelocimetroWidget(
                  velocidade: viagemViewModel.velocidade,
                  velocidadeMax: 180,
                ),
                const SizedBox(height: 30),
                _buildCartoesInformacoes(viagemViewModel),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        _buildControleBotoes(viagemViewModel),
      ],
    );
  }

  Widget _buildCartoesInformacoes(ViagemViewModel viagemViewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          // Cartão de Distância
          _buildCard(
            Icons.straighten,
            'Distância',
            '${viagemViewModel.distancia.toStringAsFixed(2)} km',
            Colors.green.shade400,
            context,
          ),
          const SizedBox(height: 20),
          // Cartão de Velocidade Média
          _buildCard(
            Icons.speed,
            'Vel. Média',
            '${viagemViewModel.velocidade.toStringAsFixed(1)} km/h',
            Colors.orange.shade400,
            context,
          ),
          const SizedBox(height: 20),
          // Cartão de Tempo
          _buildCard(
            Icons.timer,
            'Tempo',
            _formatarDuracao(viagemViewModel.duracaoViagem),
            Colors.blue.shade400,
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildControleBotoes(ViagemViewModel viagemViewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _actionButton(
            viagemViewModel.rastreamentoAtivo ? Icons.pause : Icons.play_arrow,
            viagemViewModel.rastreamentoAtivo ? Colors.orange : Colors.black,
            () {
              if (viagemViewModel.rastreamentoAtivo) {
                viagemViewModel.pausarRastreamento();
              } else {
                viagemViewModel.iniciarViagem();
              }
            },
          ),
          _actionButton(
            Icons.refresh,
            Colors.black,
            () => viagemViewModel.retomarRastreamento(),
          ),
        ],
      ),
    );
  }

  // Novo método para criar o card estilizado
  Widget _buildCard(IconData icon, String title, String value, Color color,
      BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Ícone
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),
            // Texto de Título e Valor
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: GoogleFonts.orbitron(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: color, size: 30),
    );
  }

  String _formatarDuracao(Duration duration) {
    String doisDigitos(int n) => n.toString().padLeft(2, '0');
    return '${doisDigitos(duration.inHours)}:${doisDigitos(duration.inMinutes.remainder(60))}:${doisDigitos(duration.inSeconds.remainder(60))}';
  }
}
