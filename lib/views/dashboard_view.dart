import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/player_controller.dart';
import '../models/mission_model.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuta as alterações no Controller (Padrão Observer)
    final controller = context.watch<PlayerController>();
    final player = controller.player;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Fundo Escuro Moderno
      appBar: AppBar(
        title: const Text(
          'EVOLUTION MAN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- CARTÃO DE ESTADO DO JOGADOR ---
            _buildPlayerHeader(player),
            
            const SizedBox(height: 30),
            
            // --- SECÇÃO DE ATRIBUTOS ---
            const Text(
              "ATRIBUTOS",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildStatCard("FÍSICO", player.fisico, Colors.orangeAccent, Icons.fitness_center),
                const SizedBox(width: 15),
                _buildStatCard("MENTAL", player.mental, Colors.lightBlueAccent, Icons.psychology),
              ],
            ),

            const SizedBox(height: 40),

            // --- LISTA DINÂMICA DE MISSÕES ---
            const Text(
              "MISSÕES DIÁRIAS",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            
            // Renderização dinâmica da lista de missões vindas do JSON
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: player.missoes.length,
              itemBuilder: (context, index) {
                final mission = player.missoes[index];
                return _buildMissionTile(context, controller, mission);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget: Cabeçalho com Nível e Barra de XP
  Widget _buildPlayerHeader(player) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("NÍVEL", style: TextStyle(color: Colors.white54, fontSize: 12)),
                  Text(
                    "${player.level}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w900, // Corrigido de .black para .w900
                    ),
                  ),
                ],
              ),
              const Icon(Icons.shield, color: Colors.amber, size: 50),
            ],
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: player.xp,
              backgroundColor: Colors.white10,
              color: Colors.greenAccent,
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${(player.xp * 100).toInt()}% para o próximo nível",
              style: const TextStyle(color: Colors.greenAccent, fontSize: 10),
            ),
          )
        ],
      ),
    );
  }

  // Widget: Cartão de Atributo Individual
  Widget _buildStatCard(String label, int value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
                Text(
                  "$value",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Widget: Elemento de Missão Dinâmico
  Widget _buildMissionTile(BuildContext context, PlayerController controller, MissionModel mission) {
    final bool concluidaHoje = mission.foiConcluidaHoje;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: concluidaHoje ? Colors.white.withOpacity(0.05) : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: concluidaHoje ? Colors.transparent : Colors.white10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: mission.tipo == 'fisico' 
                ? Colors.orange.withOpacity(0.2) 
                : Colors.blue.withOpacity(0.2),
            child: Icon(
              mission.tipo == 'fisico' ? Icons.bolt : Icons.auto_stories,
              color: mission.tipo == 'fisico' ? Colors.orange : Colors.blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission.titulo,
                  style: TextStyle(
                    color: concluidaHoje ? Colors.white38 : Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: concluidaHoje ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  "+${mission.recompensaXP.toInt()} XP",
                  style: TextStyle(
                    color: Colors.greenAccent.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: concluidaHoje ? null : () => controller.concluirMissao(mission),
            style: ElevatedButton.styleFrom(
              backgroundColor: concluidaHoje ? Colors.grey[800] : Colors.greenAccent[700],
              disabledBackgroundColor: Colors.grey[800],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: Text(
              concluidaHoje ? "FEITO" : "CONCLUIR",
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}