import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../services/player_service.dart';

/// O Controller atua como a ponte entre a View e o Service.
/// Ele gerencia o estado da UI e reage às interações do usuário.
/// 
class PlayerController extends ChangeNotifier {
  // Instâncias do Model e do Service
  final PlayerModel _player = PlayerModel();
  final PlayerService _service = PlayerService();

  // Getters para que a View acesse os dados sem modificá-los diretamente
  PlayerModel get player => _player;

  /// Método chamado pela View quando uma missão é concluída.
  void concluirMissao(double xpGanho, {String? tipo}) {
    // 1. Delega a lógica de negócio para o Service
    _service.processarGanhoXP(_player, xpGanho);

    // 2. Atualiza atributos específicos se necessário
    if (tipo == 'fisico') _player.fisico++;
    if (tipo == 'mental') _player.mental++;

    // 3. O PASSO MAIS IMPORTANTE: Notifica a interface para redesenhar
    notifyListeners();
  }

  // Futuramente, o Controller chamaria o Service para persistir dados:
  // void salvarProgresso() => _service.salvarNoBanco(_player);
}