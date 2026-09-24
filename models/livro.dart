import 'enums.dart';

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

  bool consultarDisponibilidade() => status == StatusLivro.disponivel;
}
