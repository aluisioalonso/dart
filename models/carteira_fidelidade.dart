class CarteiraFidelidade {
  int id;
  int pontos;
  DateTime dataCriacao;

  CarteiraFidelidade(this.id, this.pontos, this.dataCriacao);

  void adicionarPontos(int quantidade) {
    pontos += quantidade;
  }

  void removerPontos(int quantidade) {
    pontos -= quantidade;
    if (pontos < 0) pontos = 0;
  }

  int consultarPontos() => pontos;
}
