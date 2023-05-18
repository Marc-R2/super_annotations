@CodeGen(runAfter: [CodeGen.addPartOfDirective])
library main;

import 'package:super_annotations/super_annotations.dart';

import 'data_class.dart';

part 'main.g.dart';

@DataClass()
class Person with _$Person {
  Person(this.name, [this.age = 0]);
  @override
  final String name;
  @override
  final int age;
}

@DataClass()
class Animal with _$Animal {
  Animal(this.name, this.height, {this.isMammal = true});
  @override
  final String name;
  @override
  final int height;
  @override
  final bool isMammal;
}

void main() {
  final p1 = Person('Tom', 32);
  print(p1); // prints: Person{name: Tom, age: 32}

  final p2 = p1.copyWith(name: 'Alice');
  print(p2); // prints: Person{name: Alice, age: 32}
}
