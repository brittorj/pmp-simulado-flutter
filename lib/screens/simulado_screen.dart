import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/questao.dart';

class SimuladoScreen extends StatefulWidget {
  final String modulo;

  const SimuladoScreen({Key? key, required this.modulo}) : super(key: key);

  @override
  State<SimuladoScreen> createState() => _SimuladoScreenState();
}

class _SimuladoScreenState extends State<SimuladoScreen> {
  late List<Questao> questoes = [];
  int currentIndex = 0;
  Map<int, String> respostas = {};
  bool isLoading = true;
  bool showResultado = false;

  @override
  void initState() {
    super.initState();
    _loadQuestoes();
  }

  Future<void> _loadQuestoes() async {
    try {
      final String response = await rootBundle.loadString('assets/questoes_mobile.json');
      final data = json.decode(response);
      
      List<dynamic> questoesData = [];
      if (widget.modulo == 'modulo_1b') {
        questoesData = data['modulo_1b'] ?? [];
      } else if (widget.modulo == 'modulo_2b') {
        questoesData = data['modulo_2b'] ?? [];
      } else if (widget.modulo == 'todos') {
        questoesData = [...(data['modulo_1b'] ?? []), ...(data['modulo_2b'] ?? [])];
      }

      setState(() {
        questoes = questoesData.map((q) => Questao.fromJson(q)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar questões: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Carregando...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (questoes.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: const Center(child: Text('Nenhuma questão encontrada')),
      );
    }

    if (showResultado) {
      return _buildResultadoScreen();
    }

    final questao = questoes[currentIndex];
    final respostaSelecionada = respostas[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Questão ${currentIndex + 1}/${questoes.length}'),
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.exit_to_app),
            label: const Text('Sair'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: (currentIndex + 1) / questoes.length,
              ),
              const SizedBox(height: 20),
              Text(
                questao.pergunta,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              ..._buildOpcoes(questao, respostaSelecionada),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentIndex > 0)
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() => currentIndex--);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Anterior'),
                    )
                  else
                    const SizedBox.shrink(),
                  if (currentIndex < questoes.length - 1)
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() => currentIndex++);
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Próxima'),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() => showResultado = true);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Finalizar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOpcoes(Questao questao, String? respostaSelecionada) {
    return questao.opcoes.entries.map((entry) {
      final opcao = entry.key;
      final texto = entry.value;
      final isSelected = respostaSelecionada == opcao;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              respostas[currentIndex] = opcao;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isSelected ? Colors.blue.shade50 : Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.shade400,
                      width: 2,
                    ),
                    color: isSelected ? Colors.blue : Colors.white,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opcao.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.blue : Colors.black,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        texto,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade700,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildResultadoScreen() {
    int acertos = 0;
    for (int i = 0; i < questoes.length; i++) {
      if (respostas[i] == questoes[i].respostaCorreta) {
        acertos++;
      }
    }

    final percentual = ((acertos / questoes.length) * 100).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                '$percentual%',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: double.parse(percentual) >= 70
                          ? Colors.green
                          : Colors.red,
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                '$acertos acertos de ${questoes.length} questões',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.home),
                label: const Text('Voltar ao Início'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
