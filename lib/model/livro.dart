class Livro {
  final int id;
  final String titulo;
  final String autor;
  final String editora;
  final int anoLancamento;

  Livro(this.id, this.titulo, this.autor, this.editora, this.anoLancamento);

  @override
  String toString() {
    return 'LIVROS(id: $id, titulo: $titulo, autor: $autor, editora: $editora anoLancamento: $anoLancamento)';
  }
}