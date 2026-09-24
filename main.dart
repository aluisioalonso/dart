import 'models/usuario.dart';
import 'models/bibliotecario.dart';
import 'models/livro.dart';
import 'models/carteira_fidelidade.dart';
import 'models/emprestimo.dart';

void main() {
  List<Livro> livros = [];
  List<Emprestimo> emprestimos = [];

  Usuario usuario = Usuario(1, "Ceci", 12345, CarteiraFidelidade(1, 0, DateTime.now()));
  Bibliotecario bibliotecario = Bibliotecario(2, "Maria", "maria@email.com", "1234");

  Livro livro1 = Livro(1, "Dom Casmurro", "Machado de Assis", "Romance", 1899);
  Livro livro2 = Livro(2, "A Hora da Estrela", "Clarice Lispector", "Romance", 1977);
  Livro livro3 = Livro(3, "O Cortiço", "Aluísio Azevedo", "Naturalismo", 1890);

  bibliotecario.cadastrarLivro(livros, livro1);
  bibliotecario.cadastrarLivro(livros, livro2);
  bibliotecario.cadastrarLivro(livros, livro3);

  bibliotecario.listarLivrosDisponiveis(livros);

  DateTime hoje = DateTime.now();
  DateTime devolucaoPrevista = hoje.add(const Duration(days: 7));

  Emprestimo emprestimo = Emprestimo(
    id: 1,
    usuario: usuario,
    livro: livro1,
    dataAluguel: hoje,
    dataDevolucaoPrevista: devolucaoPrevista,
  );

  emprestimos.add(emprestimo);
  emprestimo.realizarEmprestimo();

  usuario.alugarLivro(livro1, hoje, devolucaoPrevista);

  bibliotecario.listarLivrosAlugados(livros);
  usuario.consultarAlugueis(emprestimos);
  usuario.consultarPendencias(emprestimos);

  usuario.devolverLivro(emprestimo);
  usuario.consultarPontos();

  bibliotecario.listarLivrosDisponiveis(livros);
}
