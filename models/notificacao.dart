import 'enums.dart';

class Notificacao {
  int id;
  String mensagem;
  DateTime dataNotificacao;
  TipoNotificacao tipo;

  Notificacao({
    required this.id,
    required this.mensagem,
    required this.dataNotificacao,
    required this.tipo,
  });

  void enviar() {
    print("\n===== NOTIFICAÇÃO =====");
    print(mensagem);
    print("Tipo: $tipo");
    print("=======================\n");
  }
}
