@CodeGen(runAfter: [CodeGen.addPartOfDirective])
library main;

import 'package:super_annotations/super_annotations.dart';

import 'json_serializable.dart';

part 'main.g.dart';

@JsonSerializable()
class Person {
  Person(this.name, {this.age});

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  final String name;
  final int? age;
  Map<String, dynamic> toJson() => _$PersonToJson(this);
}

void main() {
  final p = Person('Steffen', age: 23);
  final map = p.toJson();
  print(map);

  final p2 = Person.fromJson(map);
  print(p2.name);
}
