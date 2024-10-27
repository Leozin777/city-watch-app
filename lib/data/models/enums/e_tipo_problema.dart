enum ETipoProblema {
  FaltaDeEnergia(1),
  SaneamentoBasico(2),
  Infraestrutura(3),
  AreaDeRisco(4),
  Outros(5);

  final int value;

  const ETipoProblema(this.value);
}
