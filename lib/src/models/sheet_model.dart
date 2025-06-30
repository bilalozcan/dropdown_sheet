class SheetModel {
  SheetModel({
    required this.id,
    required this.name,
    this.val,
  });

  final String id;
  final String name;
  final dynamic val;
  
  @override
  String toString() {
    return 'SheetModel(id: $id, name: $name, val: $val)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SheetModel && other.id == id && other.name == name;
  }
  
  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
