import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/player_model.dart';

class PlayerService {
  // Nome do arquivo onde os dados serão salvos no Windows
  final String _fileName = 'player_data.json';

  // Método privado para localizar o caminho correto no disco
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  // SALVAR: Transforma o objeto em texto JSON e grava no arquivo
  Future<void> savePlayer(PlayerModel player) async {
    try {
      final file = await _getFile();
      // jsonEncode transforma o mapa do toJson() em uma String
      String jsonString = jsonEncode(player.toJson());
      await file.writeAsString(jsonString);
    } catch (e) {
      print("Erro ao salvar dados: $e");
    }
  }

  // CARREGAR: Lê o arquivo e reconstrói o objeto PlayerModel
  Future<PlayerModel> loadPlayer() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        String content = await file.readAsString();
        // jsonDecode transforma o texto de volta em um Mapa
        Map<String, dynamic> jsonMap = jsonDecode(content);
        return PlayerModel.fromJson(jsonMap);
      }
    } catch (e) {
      print("Erro ao carregar dados: $e");
    }
    
    // Retorna um jogador inicial se o arquivo não existir (Primeira vez rodando o app)
    return PlayerModel(level: 1, xp: 0.0, fisico: 0, mental: 0);
  }
}