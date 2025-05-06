// Modelo de dados
class ViagemModel {
  double velocidade;
  double distancia;
  double velocidadeMedia;
  Duration duracaoViagem;

  // Construtor com valores padrão
  ViagemModel({
    this.velocidade = 0.0,
    this.distancia = 0.0,
    this.velocidadeMedia = 0.0,
    this.duracaoViagem = const Duration(),
  });

  // Método para copiar o modelo e atualizar apenas os campos desejados
  ViagemModel copiarCom({
    double? velocidade,
    double? distancia,
    double? velocidadeMedia,
    Duration? duracaoViagem,
  }) {
    // Retorna uma nova instância de ModeloViagem
    return ViagemModel(
      velocidade: velocidade ?? this.velocidade,
      distancia: distancia ?? this.distancia,
      velocidadeMedia: velocidadeMedia ?? this.velocidadeMedia,
      duracaoViagem: duracaoViagem ?? this.duracaoViagem,
    );
  }
}
