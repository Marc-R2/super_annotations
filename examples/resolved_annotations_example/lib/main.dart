@CodeGen(runAfter: [CodeGen.addPartOfDirective])
library main;

import 'package:super_annotations/super_annotations.dart';

import 'annotations.dart';
import 'annotations2.dart';

part 'main.g.dart';

@MyAnnotation()
class MyClass {
  MyClass(this._internal);
  @WrapGetter('data')
  final String _internal;
}

void main() {
  final v = MyClass('hallo');
  print(v.data); // prints: hallo
}
