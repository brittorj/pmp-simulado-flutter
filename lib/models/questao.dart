class Questao {
  final String numero;
  final String pergunta;
  final Map<String, String> opcoes;
  final String respostaCorreta;
  final String justificativa;
  final String dificuldade;
  final List<String> topicosRelacionados;
  final String dominio;

  Questao({
    required this.numero,
    required this.pergunta,
    required this.opcoes,
    required this.respostaCorreta,
    required this.justificativa,
    required this.dificuldade,
    required this.topicosRelacionados,
    required this.dominio,
  });

  factory Questao.fromJson(Map<String, dynamic> json) {
    return Questao(
      numero: json['numero'] ?? '',
      pergunta: json['pergunta'] ?? '',
      opcoes: Map<String, String>.from(json['opcoes'] ?? {}),
      respostaCorreta: json['resposta_correta'] ?? '',
      justificativa: json['justificativa'] ?? '',
      dificuldade: json['dificuldade'] ?? 'Médio',
      topicosRelacionados: List<String>.from(json['topicos_relacionados'] ?? []),
      dominio: json['dominio'] ?? '',
    );
  }
}
