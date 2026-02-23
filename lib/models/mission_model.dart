import 'package:flutter/material.dart';


class MissionModel{
  final String id;
  final String titulo;
  final double recompensaXP;
  final String tipo;
  DateTime? ultimaConclusao;

  MissionModel({
    required this.id,
    required this.titulo,
    required this.recompensaXP,
    required this.tipo,
    this.ultimaConclusao,
  })


}