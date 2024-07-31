class Tarefa {
  final int id;
  final String descricao;
  final String obs;
  final int livro;
  final String? livro_titulo;

  Tarefa(this.id, this.descricao, this.obs, this.livro, this.livro_titulo);

  @override
  String toString() {
    return 'Tarefa{descricao: $descricao, obs: $obs, livro: $livro $livro_titulo}';
  }
}