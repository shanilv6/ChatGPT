class ModelsModel {
  final String id;
  final String root;
  final int created;

  ModelsModel({required this.id, required this.created, required this.root});

  factory ModelsModel.fromJson(Map<String, dynamic> json) =>
      ModelsModel(id: json['id'], root: json['root'], created: json['created']);
  static List<ModelsModel> modelsFromSnapshot(List modelSnapshot) {
    return modelSnapshot.map((data) => ModelsModel.fromJson(data)).toList();
  }
}
