import 'pessoa.dart';
import 'livro.dart';
import 'emprestimo.dart';
import 'enums.dart';

class Bibliotecario extends Pessoa {
  String email;
  String senha;

  Bibliotecario(int id, String nome, this.email, this.senha) : super(id, nome);

  void cadastrarLivro(List<Livro> livros, Livro livro) {
    livros.add(livro);
    print("Livro '${livro.titulo}' cadastrado com sucesso.");
  }

  void listarLivrosDisponiveis(List<Livro> livros) {
    print("\n===== LIVROS DISPONÍVEIS =====");

    for (var livro in livros) {
      if (livro.consultarDisponibilidade()) {
        print("${livro.id} - ${livro.titulo} - ${livro.autor} - ${livro.anoPublicacao}");
      }
    }
  }

  void listarLivrosAlugados(List<Livro> livros) {
    print("\n===== LIVROS EMPRESTADOS =====");

    for (var livro in livros) {
      if (livro.status == StatusLivro.emprestado || livro.status == StatusLivro.atrasado) {
        print("${livro.id} - ${livro.titulo}");
      }
    }
  }

  void listarPendencias(List<Emprestimo> emprestimos) {
    print("\n===== PENDÊNCIAS =====");

    for (var emprestimo in emprestimos) {
      if (emprestimo.verificarAtraso() && emprestimo.dataDevolucaoReal == null) {
        print("Usuário: ${emprestimo.usuario.nome}");
        print("Livro: ${emprestimo.livro.titulo}");
        print("Dias de atraso: ${emprestimo.calcularDiasAtraso()}");
        print("--------------------");
      }
    }
  }

  void aplicarPenalidade(Emprestimo emprestimo) {
    final diasAtraso = emprestimo.calcularDiasAtraso();
    if (diasAtraso == 0) return;

    final penalidade = diasAtraso * 2;
    emprestimo.usuario.carteira.removerPontos(penalidade);

    print("Penalidade aplicada: $penalidade pontos.");
  }
}
