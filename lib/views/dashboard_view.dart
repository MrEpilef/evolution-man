import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/player_controller.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Aqui a View "assina" o Controller. Sempre que houver um notifyListeners(),
    // este widget build será executado novamente.
    final controller = context.watch<PlayerController>();
    final player = controller.player;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // --- HEADER (Usando dados do Controller) ---
            _buildHeader(player.level, player.xp, player.fisico, player.mental),
            
            const SizedBox(height: 30),

            Row(
              children: [
                // --- MISSÕES (Chamando métodos do Controller) ---
                Expanded(
                  child: _buildMissionCard(
                    'Missões Diárias', 
                    [
                      _missionItem('Treino Intenso', '+20 XP', Colors.redAccent, 
                        () => controller.concluirMissao(20, tipo: 'fisico')),
                      _missionItem('Leitura', '+15 XP', Colors.blueAccent, 
                        () => controller.concluirMissao(15, tipo: 'mental')),
                    ]
                  ),
                ),
                // ... (O resto da interface seguiria o mesmo padrão)
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Métodos auxiliares de UI (Widgets privados)

  Widget _missionItem(String task, String reward, Color color, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.check_circle_outline, color: color),
      title: Text(task, style: const TextStyle(fontSize: 14)),
      trailing: Text(reward, style: const TextStyle(color: Colors.orangeAccent, fontSize: 12)),
      onTap: onTap,
    );
  }
  Widget _buildHeader(int nivel, double xp, int fisico, int mental) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blueAccent,
            child: Text('$nivel', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('STATUS DO EVOLUTION MAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: xp,
                    minHeight: 10,
                    backgroundColor: Colors.white10,
                    color: Colors.greenAccent,
                  ),
                ),
                const SizedBox(height: 5),
                Text('${(xp * 100).toInt()}% PARA O PRÓXIMO NÍVEL', style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          _buildStatBadge(Icons.fitness_center, fisico, Colors.redAccent),
          const SizedBox(width: 10),
          _buildStatBadge(Icons.psychology, mental, Colors.blueAccent),
        ],
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, int valor, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        Text('$valor', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildMissionCard(String titulo, List<Widget> missoes) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
          const SizedBox(height: 15),
          ...missoes,
        ],
      ),
    );
  }

}