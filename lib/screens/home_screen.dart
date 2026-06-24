import 'package:flutter/material.dart';
import 'simulado_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade600,
              Colors.blue.shade800,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'PMP Simulado',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Escolha qual simulado deseja fazer',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: 40),
                  _buildModuloCard(
                    context,
                    title: 'Módulo 1B',
                    description: 'Gerenciamento de Projetos - Conceitos',
                    questoes: 15,
                    tempo: '30 min',
                    color: Colors.blue.shade100,
                    textColor: Colors.blue.shade900,
                    onTap: () => _navigateToSimulado(context, 'modulo_1b'),
                  ),
                  const SizedBox(height: 16),
                  _buildModuloCard(
                    context,
                    title: 'Módulo 2B',
                    description: 'Domínio de Desempenho do Escopo',
                    questoes: 15,
                    tempo: '30 min',
                    color: Colors.green.shade100,
                    textColor: Colors.green.shade900,
                    onTap: () => _navigateToSimulado(context, 'modulo_2b'),
                  ),
                  const SizedBox(height: 16),
                  _buildModuloCard(
                    context,
                    title: 'Todos',
                    description: 'Simulado Completo (Módulos 1B + 2B)',
                    questoes: 30,
                    tempo: '60 min',
                    color: Colors.orange.shade100,
                    textColor: Colors.orange.shade900,
                    onTap: () => _navigateToSimulado(context, 'todos'),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '💡 Dica:',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Comece com os módulos individuais para focar em cada tópico. Depois faça o simulado completo para praticar a mistura de conteúdos.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModuloCard(
    BuildContext context, {
    required String title,
    required String description,
    required int questoes,
    required String tempo,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor.withOpacity(0.8),
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$questoes questões',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  tempo,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textColor.withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSimulado(BuildContext context, String modulo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SimuladoScreen(modulo: modulo),
      ),
    );
  }
}
