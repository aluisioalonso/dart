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
    print("\nEmpréstimos de $nome:");

    for (var emprestimo in emprestimos) {
      if (emprestimo.usuario.id == id) {
        print("- ${emprestimo.livro.titulo}");
      }
    }
  }
}


// ===============================
// CLASSE BIBLIOTECARIO
// Herda de Pessoa
// ===============================

class Bibliotecario extends Pessoa {
  String email;
  String senha;

  Bibliotecario(
    int id,
    String nome,
    this.email,
    this.senha,
  ) : super(id, nome);

  void cadastrarLivro(
    List<Livro> livros,
    Livro livro,
  ) {
    livros.add(livro);

    print(
      "Livro '${livro.titulo}' cadastrado com sucesso."
    );
  }

  void listarLivrosDisponiveis(List<Livro> livros) {
    print("\n===== LIVROS DISPONÍVEIS =====");

    for (var livro in livros) {
      if (livro.consultarDisponibilidade()) {
        print(
          "${livro.id} - ${livro.titulo} - "
          "${livro.autor} - ${livro.anoPublicacao}"
        );
      }
    }
  }

  void listarLivrosAlugados(List<Livro> livros) {
    print("\n===== LIVROS EMPRESTADOS =====");

    for (var livro in livros) {
      if (livro.status == StatusLivro.emprestado ||
          livro.status == StatusLivro.atrasado) {
        print(
          "${livro.id} - ${livro.titulo}"
        );
      }
    }
  }

  void listarPendencias(List<Emprestimo> emprestimos) {
    print("\n===== PENDÊNCIAS =====");

    for (var emprestimo in emprestimos) {
      if (emprestimo.verificarAtraso() &&
          emprestimo.dataDevolucaoReal == null) {

        print(
          "Usuário: ${emprestimo.usuario.nome}"
        );

        print(
          "Livro: ${emprestimo.livro.titulo}"
        );

        print(
          "Dias de atraso: "
          "${emprestimo.calcularDiasAtraso()}"
        );

        print("--------------------");
      }
    }
  }

  void aplicarPenalidade(Emprestimo emprestimo) {
    int diasAtraso = emprestimo.calcularDiasAtraso();

    if (diasAtraso > 0) {

      // Regra numérica definida para o protótipo:
      // 2 pontos de penalidade por dia de atraso.
      int penalidade = diasAtraso * 2;

      emprestimo.usuario.carteira.removerPontos(penalidade);

      print(
        "Penalidade aplicada: "
        "$penalidade pontos."
      );
    }
  }
}


// ===============================
// CLASSE LIVRO
// ===============================

class Livro {
  int id;
  String titulo;
  String autor;
  String categoria;
  int anoPublicacao;
  StatusLivro status;

  Livro(
    this.id,
    this.titulo,
    this.autor,
    this.categoria,
    this.anoPublicacao, {
    this.status = StatusLivro.disponivel,
  });

  bool consultarDisponibilidade() {
    return status == StatusLivro.disponivel;
  }
}


// ===============================
// CLASSE CARTEIRA DE FIDELIDADE
// ===============================

class CarteiraFidelidade {
  int id;
  int pontos;
  DateTime dataCriacao;

  CarteiraFidelidade(
    this.id,
    this.pontos,
    this.dataCriacao,
  );

  void adicionarPontos(int quantidade) {
    pontos += quantidade;
  }

  void removerPontos(int quantidade) {
    pontos -= quantidade;

    if (pontos < 0) {
      pontos = 0;
    }
  }

  int consultarPontos() {
    return pontos;
  }
}


// ===============================
// CLASSE EMPRESTIMO
// ===============================

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
      print(
        "Não é possível realizar o empréstimo."
      );
      return;
    }

    livro.status = StatusLivro.emprestado;

    print(
      "Empréstimo realizado com sucesso."
    );
  }

  void registrarDevolucao() {

    dataDevolucaoReal = DateTime.now();

    livro.status = StatusLivro.devolvido;

    print(
      "Livro '${livro.titulo}' devolvido."
    );

    // Adiciona pontos após a devolução
    usuario.carteira.adicionarPontos(10);

    print(
      "10 pontos adicionados à carteira de fidelidade."
    );

    // Verifica se houve atraso
    if (verificarAtraso()) {

      int dias = calcularDiasAtraso();

      print(
        "Devolução realizada com atraso de "
        "$dias dias."
      );

      Notificacao notificacao = Notificacao(
        id: 1,
        mensagem:
            "O livro ${livro.titulo} foi devolvido com atraso.",
        dataNotificacao: DateTime.now(),
        tipo: TipoNotificacao.avisoDeAtraso,
      );

      notificacao.enviar();

    } else {

      Notificacao notificacao = Notificacao(
        id: 2,
        mensagem:
            "Devolução do livro ${livro.titulo} concluída.",
        dataNotificacao: DateTime.now(),
        tipo: TipoNotificacao.devolucaoConcluida,
      );

      notificacao.enviar();
    }
  }

  bool verificarAtraso() {

    DateTime dataComparacao =
        dataDevolucaoReal ?? DateTime.now();

    return dataComparacao.isAfter(
      dataDevolucaoPrevista,
    );
  }

  int calcularDiasAtraso() {

    if (!verificarAtraso()) {
      return 0;
    }

    DateTime dataComparacao =
        dataDevolucaoReal ?? DateTime.now();

    return dataComparacao
        .difference(dataDevolucaoPrevista)
        .inDays;
  }
}


// ===============================
// CLASSE NOTIFICACAO
// ===============================

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


// ===============================
// MAIN
// Demonstração do sistema
// ===============================

void main() {

  // Lista de livros
  List<Livro> livros = [];

  // Lista de empréstimos
  List<Emprestimo> emprestimos = [];


  // ===============================
  // CRIANDO USUÁRIO
  // ===============================

  Usuario usuario = Usuario(
    1,
    "Ceci",
    12345,
    CarteiraFidelidade(
      1,
      0,
      DateTime.now(),
    ),
  );


  // ===============================
  // CRIANDO BIBLIOTECÁRIO
  // ===============================

  Bibliotecario bibliotecario = Bibliotecario(
    2,
    "Maria",
    "maria@email.com",
    "1234",
  );


  // ===============================
  // CADASTRANDO LIVROS
  // ===============================

  Livro livro1 = Livro(
    1,
    "Dom Casmurro",
    "Machado de Assis",
    "Romance",
    1899,
  );

  Livro livro2 = Livro(
    2,
    "A Hora da Estrela",
    "Clarice Lispector",
    "Romance",
    1977,
  );

  Livro livro3 = Livro(
    3,
    "O Cortiço",
    "Aluísio Azevedo",
    "Naturalismo",
    1890,
  );


  bibliotecario.cadastrarLivro(
    livros,
    livro1,
  );

  bibliotecario.cadastrarLivro(
    livros,
    livro2,
  );

  bibliotecario.cadastrarLivro(
    livros,
    livro3,
  );


  // ===============================
  // LISTAR LIVROS DISPONÍVEIS
  // ===============================

  bibliotecario.listarLivrosDisponiveis(livros);


  // ===============================
  // REALIZAR EMPRÉSTIMO
  // ===============================

  DateTime hoje = DateTime.now();

  DateTime devolucaoPrevista =
      hoje.add(const Duration(days: 7));

  Emprestimo emprestimo = Emprestimo(
    id: 1,
    usuario: usuario,
    livro: livro1,
    dataAluguel: hoje,
    dataDevolucaoPrevista: devolucaoPrevista,
  );


  // Adiciona o empréstimo à lista
  emprestimos.add(emprestimo);

  emprestimo.realizarEmprestimo();


  // ===============================
  // TENTAR EMPRESTAR LIVRO
  // INDISPONÍVEL
  // ===============================

  usuario.alugarLivro(
    livro1,
    hoje,
    devolucaoPrevista,
  );


  // ===============================
  // LISTAR LIVROS EMPRESTADOS
  // ===============================

  bibliotecario.listarLivrosAlugados(livros);


  // ===============================
  // CONSULTAR ALUGUÉIS DO USUÁRIO
  // ===============================

  usuario.consultarAlugueis(emprestimos);


  // ===============================
  // VERIFICAR PENDÊNCIAS
  // ===============================

  usuario.consultarPendencias(emprestimos);


  // ===============================
  // DEVOLVER LIVRO
  // ===============================

  usuario.devolverLivro(emprestimo);


  // ===============================
  // CONSULTAR PONTOS
  // ===============================

  usuario.consultarPontos();


  // ===============================
  // LIVROS DISPONÍVEIS NOVAMENTE
  // ===============================

  bibliotecario.listarLivrosDisponiveis(livros);
}