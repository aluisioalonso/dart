import 'usuario.dart';
import 'livro.dart';
import 'notificacao.dart';
import 'enums.dart';

class Emprestimo {
  int id;
  Usuario usuario;
  Livro livro;
  DateTime dataAluguel;
  DateTime dataDevolucaoPrevista;
  DateTime? dataDevolucaoReal;

  Emprestimo({
    required this.id,
    required this.usuario,
    required this.livro,
    required this.dataAluguel,
    required this.dataDevolucaoPrevista,
  });

  void realizarEmprestimo() {
    if (!livro.consultarDisponibilidade()) {
      print("Não é possível realizar o empréstimo.");
      return;
    }

    livro.status = StatusLivro.emprestado;
    print("Empréstimo realizado com sucesso.");
  }

  void registrarDevolucao() {
    dataDevolucaoReal = DateTime.now();
    livro.status = StatusLivro.devolvido;
    print("Livro '${livro.titulo}' devolvido.");

    usuario.carteira.adicionarPontos(10);
    print("10 pontos adicionados à carteira de fidelidade.");

    if (verificarAtraso()) {
      final dias = calcularDiasAtraso();
      print("Devolução realizada com atraso de $dias dias.");

      Notificacao(
        id: 1,
        mensagem: "O livro ${livro.titulo} foi devolvido com atraso.",
        dataNotificacao: DateTime.now(),
        tipo: TipoNotificacao.avisoDeAtraso,
      ).enviar();
    } else {
      Notificacao(
        id: 2,
        mensagem: "Devolução do livro ${livro.titulo} concluída.",
        dataNotificacao: DateTime.now(),
        tipo: TipoNotificacao.devolucaoConcluida,
      ).enviar();
    }
  }

  bool verificarAtraso() {
    final dataComparacao = dataDevolucaoReal ?? DateTime.now();
    return dataComparacao.isAfter(dataDevolucaoPrevista);
  }

  int calcularDiasAtraso() {
    if (!verificarAtraso()) return 0;
    final dataComparacao = dataDevolucaoReal ?? DateTime.now();
    return dataComparacao.difference(dataDevolucaoPrevista).inDays;
  }
}
