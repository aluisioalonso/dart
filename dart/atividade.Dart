import 'dart:io';
void main() {
  String nomeFilme = "Artu Do Val";
  int classificacaoIndicativa = 14; 
  int idadeCliente = 16;
  bool isEstudante = true;
  double precoPadrao = 30.00;

  if (idadeCliente < classificacaoIndicativa) {
    print("Entrada negada: O filme $nomeFilme é para maiores de $classificacaoIndicativa anos.");
  } else {
    double precoFinal;
    
    if (isEstudante) {
      precoFinal = precoPadrao / 2;
    } else {
      precoFinal = precoPadrao;
    }

    print("BILHETE CINE");
    print("Filme: $nomeFilme");
    print("Ingresso Liberado! Valor a pagar: R\$ ${precoFinal.toStringAsFixed(2)}");
  }
}