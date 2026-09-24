import 'pessoa.dart';
import 'carteira_fidelidade.dart';
import 'livro.dart';
import 'emprestimo.dart';
import 'enums.dart';

class Usuario extends Pessoa {
  int matricula;
  CarteiraFidelidade carteira;

  Usuario(int id, String nome, this.matricula, this.carteira) : super(id, nome);

  void alugarLivro(Livro livro, DateTime dataAluguel, DateTime dataDevolucaoPrevista) {
    if (!livro.consultarDisponibilidade()) {
      print("O livro '${livro.titulo}' não está disponível.");
      return;
    }

    livro.status = StatusLivro.emprestado;

    print("Empréstimo realizado: ${livro.titulo}");
    print(
      "Devolução prevista para: "
      "${dataDevolucaoPrevista.day}/${dataDevolucaoPrevista.month}/${dataDevolucaoPrevista.year}",
    );
  }

  void devolverLivro(Emprestimo emprestimo) {
    emprestimo.registrarDevolucao();
  }

  void consultarPontos() {
    print("$nome possui ${carteira.consultarPontos()} pontos.");
  }

  void consultarPendencias(List<Emprestimo> emprestimos) {
    print("\nPendências de $nome:");

    var temPendencia = false;

    for (var emprestimo in emprestimos) {
      if (emprestimo.usuario.id == id &&
          emprestimo.verificarAtraso() &&
          emprestimo.dataDevolucaoReal == null) {
        print("- ${emprestimo.livro.titulo} (${emprestimo.calcularDiasAtraso()} dias de atraso)");
        temPendencia = true;
      }
    }

    if (!temPendencia) print("Nenhuma pendência.");
  }

  void consultarAlugueis(List<Emprestimo> emprestimos) {
    print("\nEmpréstimos de $nome:");

    for (var emprestimo in emprestimos) {
      if (emprestimo.usuario.id == id) print("- ${emprestimo.livro.titulo}");
    }
  }
}
