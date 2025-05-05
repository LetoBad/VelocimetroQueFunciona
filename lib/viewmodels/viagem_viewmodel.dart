import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:velocimetro/models/viagem_model.dart';

/// ViewModel para gerenciar a lógica de rastreamento de viagens
class ViagemViewModel with ChangeNotifier {
  ViagemModel _dadosViagem = ViagemModel();
  StreamSubscription<Position>? _assinaturaStreamPosicao;
  Position? _ultimaPosicao;
  DateTime? _tempoInicial;
  DateTime? _ultimoTempoAtualizado;

  bool _rastreamentoAtivo = false;
  bool get rastreamentoAtivo => _rastreamentoAtivo;

  bool _permissaoLocalizacao = false;
  bool get permissaoLocalizacao => _permissaoLocalizacao;

  // Getters públicos para os dados da viagem
  double get velocidade => _dadosViagem.velocidade;
  double get distancia => _dadosViagem.distancia;
  double get velocidadeMedia => _dadosViagem.velocidadeMedia;
  Duration get duracaoViagem => _dadosViagem.duracaoViagem;

  /// Inicializa o ViewModel verificando a permissão de localização
  Future<void> init() async {
    await _verificarPermissaoLocalizacao();
  }

  /// Verifica e solicita permissões de localização
  Future<void> _verificarPermissaoLocalizacao() async {
    final servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) {
      _alterarPermissaoLocalizacao(false);
      return;
    }

    var statusPermissao = await Geolocator.checkPermission();
    if (statusPermissao == LocationPermission.denied) {
      statusPermissao = await Geolocator.requestPermission();
      if (statusPermissao == LocationPermission.denied) {
        _alterarPermissaoLocalizacao(false);
        return;
      }
    }

    if (statusPermissao == LocationPermission.deniedForever) {
      _alterarPermissaoLocalizacao(false);
      return;
    }

    _alterarPermissaoLocalizacao(true);
  }

  /// Atualiza o status da permissão de localização e notifica
  void _alterarPermissaoLocalizacao(bool status) {
    _permissaoLocalizacao = status;
    notifyListeners();
  }

  /// Solicita manualmente a permissão de localização
  Future<void> solicitarPermissaoLocalizacao() async {
    await _verificarPermissaoLocalizacao();
  }

  /// Inicia o rastreamento da viagem
  void iniciarViagem() {
    if (!_permissaoLocalizacao || _rastreamentoAtivo) return;

    _rastreamentoAtivo = true;
    _tempoInicial = DateTime.now();
    _ultimoTempoAtualizado = _tempoInicial;

    const configuracoesLocalizacao = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    _assinaturaStreamPosicao = Geolocator.getPositionStream(
      locationSettings: configuracoesLocalizacao,
    ).listen(_atualizarDadosViagem);

    notifyListeners();
  }

  /// Pausa o rastreamento da viagem
  void pausarRastreamento() {
    if (!_rastreamentoAtivo) return;

    _assinaturaStreamPosicao?.pause();
    _rastreamentoAtivo = false;
    notifyListeners();
  }

  /// Retoma o rastreamento da viagem
  void retomarRastreamento() {
    if (_rastreamentoAtivo) return;

    _assinaturaStreamPosicao?.resume();
    _ultimoTempoAtualizado = DateTime.now();
    _rastreamentoAtivo = true;
    notifyListeners();
  }

  /// Reseta todos os dados da viagem
  void resetarViagem() {
    _dadosViagem = ViagemModel();
    _ultimaPosicao = null;
    _tempoInicial = _rastreamentoAtivo ? DateTime.now() : null;
    _ultimoTempoAtualizado = _tempoInicial;
    notifyListeners();
  }

  /// Atualiza os dados da viagem com base na nova posição
  void _atualizarDadosViagem(Position posicaoAtual) {
    final agora = DateTime.now();
    final velocidadeKmh = posicaoAtual.speed * 3.6;

    _calcularDistancia(posicaoAtual);
    _calcularDuracaoViagem(agora);
    _calcularVelocidadeMedia();

    _dadosViagem = _dadosViagem.copiarCom(velocidade: velocidadeKmh);

    _ultimaPosicao = posicaoAtual;
    _ultimoTempoAtualizado = agora;

    notifyListeners();
  }

  /// Calcula a distância percorrida
  void _calcularDistancia(Position posicaoAtual) {
    if (_ultimaPosicao != null) {
      final distanciaMetros = Geolocator.distanceBetween(
        _ultimaPosicao!.latitude,
        _ultimaPosicao!.longitude,
        posicaoAtual.latitude,
        posicaoAtual.longitude,
      );

      _dadosViagem = _dadosViagem.copiarCom(
        distancia: _dadosViagem.distancia + (distanciaMetros / 1000),
      );
    }
  }

  /// Calcula a duração da viagem
  void _calcularDuracaoViagem(DateTime agora) {
    if (_tempoInicial != null) {
      final duracao = agora.difference(_tempoInicial!);
      _dadosViagem = _dadosViagem.copiarCom(duracaoViagem: duracao);
    }
  }

  /// Calcula a velocidade média da viagem
  void _calcularVelocidadeMedia() {
    if (_dadosViagem.duracaoViagem.inSeconds > 0) {
      final velocidadeMediaCalculada =
          (_dadosViagem.distancia / _dadosViagem.duracaoViagem.inSeconds) *
              3600;
      _dadosViagem = _dadosViagem.copiarCom(
        velocidadeMedia: velocidadeMediaCalculada,
      );
    }
  }

  /// Cancela a assinatura ao descartar o ViewModel
  @override
  void dispose() {
    _assinaturaStreamPosicao?.cancel();
    super.dispose();
  }
}
