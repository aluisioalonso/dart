// ===============================
// ENUMS
// ===============================

enum StatusLivro {
  disponivel,
  emprestado,
  atrasado,
  devolvido,
}

enum TipoNotificacao {
  devolucaoConcluida,
  avisoDeAtraso,
  lembreteDePrazo,
}


// ===============================
// CLASSE PESSOA
// ===============================

class Pessoa {
  int id;
  String nome;

  Pessoa(this.id, this.nome);
}


// ===============================
// CLASSE USUARIO
// Herda de Pessoa
// ===============================

class Usuario extends Pessoa {
  int matricula;
  CarteiraFidelidade carteira;

  Usuario(
    int id,
    String nome,
    this.matricula,
    this.carteira,
  ) : super(id, nome);

  void alugarLivro(
    Livro livro,
    DateTime dataAluguel,
    DateTime dataDevolucaoPrevista,
  ) {
    if (!livro.consultarDisponibilidade()) {
      print("O livro '${livro.titulo}' não está disponível.");
      return;
    }

    Emprestimo emprestimo = Emprestimo(
      id: DateTime.now().millisecondsSinceEpoch,
      usuario: this,
      livro: livro,
      dataAluguel: dataAluguel,
      dataDevolucaoPrevista: dataDevolucaoPrevista,
    );

    livro.status = StatusLivro.emprestado;

    print(
      "Empréstimo realizado: ${livro.titulo}"
    );

    print(
      "Devolução prevista para: "
      "${dataDevolucaoPrevista.day}/"
      "${dataDevolucaoPrevista.month}/"
      "${dataDevolucaoPrevista.year}"
    );
  }

  void devolverLivro(Emprestimo emprestimo) {
    emprestimo.registrarDevolucao();
  }

  void consultarPontos() {
    print(
      "$nome possui ${carteira.consultarPontos()} pontos."
    );
  }

  void consultarPendencias(List<Emprestimo> emprestimos) {
    print("\nPendências de $nome:");

    bool possuiPendencia = false;

    for (var emprestimo in emprestimos) {
      if (emprestimo.usuario.id == id &&
          emprestimo.verificarAtraso() &&
          emprestimo.dataDevolucaoReal == null) {
        print(
          "- ${emprestimo.livro.titulo} "
          "(${emprestimo.calcularDiasAtraso()} dias de atraso)"
        );

        possuiPendencia = true;
      }
    }

    if (!possuiPendencia) {
      print("Nenhuma pendência.");
    }
  }

  void consultarAlugueis(List<Emprestimo> emprestimos) {
    print("\nEm