import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/player_controller.dart';
import '../models/mission_model.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Escutando o Controller para reagir a mudanças de XP ou novas missões
    final controller = context.watch<PlayerController>();
    final player = controller.player;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Fundo Dark Moderno
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

      // BOTÃO PARA ADICIONAR MISSÕES
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent[400],
        onPressed: () => _abrirFormularioMissao(context, controller),
        child: const Icon(Icons.add, color: Colors.black, size: 30),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- CABEÇALHO DO JOGADOR ---
            _buildPlayerHeader(player),
            
            const SizedBox(height: 30),
            
            // --- SEÇÃO DE ATRIBUTOS ---
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
            
            // ListView que cresce conforme você adiciona missões
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

  // FUNÇÃO: Abre o painel inferior para cadastrar a missão
  void _abrirFormularioMissao(BuildContext context, PlayerController controller) {
    final TextEditingController tituloController = TextEditingController();
    double xpSelecionado = 15.0;
    String tipoSelecionado = 'fisico';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que o teclado não cubra o formulário
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 20, right: 20, top: 20
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "NOVA MISSÃO",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  
                  // Nome da Missão
                  TextField(
                    controller: tituloController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Ex: Correr 5km",
                      hintStyle: const TextStyle(color: Colors.white24),
                      labelText: "O que você vai realizar?",
                      labelStyle: const TextStyle(color: Colors.greenAccent),
                      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white10)),
                      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.greenAccent)),
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // Seleção de Tipo
                  const Text("Foco da Missão:", style: TextStyle(color: Colors.white70, fontSize: 13)),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'fisico',
                        groupValue: tipoSelecionado,
                        activeColor: Colors.orangeAccent,
                        onChanged: (val) => setModalState(() => tipoSelecionado = val!),
                      ),
                      const Text("Físico", style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 20),
                      Radio<String>(
                        value: 'mental',
                        groupValue: tipoSelecionado,
                        activeColor: Colors.lightBlueAccent,
                        onChanged: (val) => setModalState(() => tipoSelecionado = val!),
                      ),
                      const Text("Mental", style: TextStyle(color: Colors.white)),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Controle de Recompensa (XP)
                  Text(
                    "Recompensa: ${xpSelecionado.toInt()} XP",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: xpSelecionado,
                    min: 5, max: 50, divisions: 9,
                    activeColor: Colors.greenAccent,
                    onChanged: (val) => setModalState(() => xpSelecionado = val),
                  ),

                  const SizedBox(height: 30),

                  // Botão para salvar
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent[700],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (tituloController.text.isNotEmpty) {
                          // O Controller gera o ID automaticamente lá dentro
                          controller.adicionarMissao(
                            titulo: tituloController.text,
                            xp: xpSelecionado,
                            tipo: tipoSelecionado,
                          );
                          Navigator.pop(context); // Fecha o formulário
                        }
                      },
                      child: const Text(
                        "CADASTRAR MISSÃO",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- WIDGETS AUXILIARES (COMPONENTIZAÇÃO) ---

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
                      fontWeight: FontWeight.w900, // Uso de w900 para evitar erro de getter
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
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMissionTile(BuildContext context, PlayerController controller, MissionModel mission) {
    final bool concluida = mission.foiConcluidaHoje;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: concluida ? Colors.white.withOpacity(0.05) : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: concluida ? Colors.transparent : Colors.white10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: mission.tipo == 'fisico' ? Colors.orange.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
            child: Icon(
              mission.tipo == 'fisico' ? Icons.bolt : Icons.auto_stories,
              color: mission.tipo == 'fisico' ? Colors.orange : Colors.blue,
              size: 18,
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
                    color: concluida ? Colors.white38 : Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: concluida ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  "+${mission.recompensaXP.toInt()} XP",
                  style: TextStyle(color: Colors.greenAccent.withOpacity(0.7), fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: concluida ? null : () => controller.concluirMissao(mission),
            style: ElevatedButton.styleFrom(
              backgroundColor: concluida ? Colors.grey[800] : Colors.greenAccent[700],
              disabledBackgroundColor: Colors.grey[800],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              concluida ? "FEITO" : "CONCLUIR",
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}