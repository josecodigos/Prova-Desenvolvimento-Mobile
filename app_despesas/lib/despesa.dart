class Despesa {
  final int? id;
  final String titulo;
  final String descricao;
  final DateTime data;
  final double valor;

  Despesa({
    this.id,
    required this.titulo, 
    required this.descricao, 
    required this.data, 
    required this.valor
  });

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'data': data.toIso8601String(),
      'valor': valor
  };
  }

  factory Despesa.fromMap(Map<String, dynamic> map) {
    return Despesa(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      data: DateTime.parse(map['data']),
      valor: map['valor']
    );
  }
}