import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/constant/value.dart';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';

import 'package:super_annotations/src/runner_builder.dart';

class SuperAnnotationsBuilder extends Builder {
  SuperAnnotationsBuilder(this.options);
  final BuilderOptions options;

  List<String> get targetOptions {
    final targets = options.config['targets'];
    if (targets is List) {
      return targets.cast<String>();
    } else {
      return [];
    }
  }

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final codeGenAnnotation =
        await getCodeGenAnnotation(buildStep).catchError((_) => null);

    if (codeGenAnnotation == null) {
      return;
    }

    var targets = codeGenAnnotation
        .getField('targets')
        ?.toListValue()
        ?.map((o) => o.toStringValue())
        .whereType<String>();

    if (targets == null || targets.isEmpty) {
      if (targetOptions.isNotEmpty) {
        targets = [targetOptions.first];
      } else {
        targets = ['g'];
      }
    }

    for (final target in targets) {
      final outputId = buildStep.inputId.changeExtension('.$target.dart');
      final output = await RunnerBuilder(
        buildStep,
        target,
        codeGenAnnotation,
        options.config,
      ).run();

      final newOutput = AssetId(outputId.package, 'test/gen/${outputId.path}');

      final formatted = DartFormatter().format(output);

      // Allow file to be created anywhere
      final file = File(newOutput.path);

      if (formatted.length <= 3) {
        if (file.existsSync()) file.deleteSync();
        return;
      }

      file.createSync(recursive: true);
      await file.writeAsString(formatted);
      // await buildStep.writeAsString(newOutput, DartFormatter().format(output));
    }
  }

  Future<DartObject?> getCodeGenAnnotation(BuildStep buildStep) async {
    final library = await buildStep.inputLibrary;
    return codeGenChecker.firstAnnotationOf(library);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': [
          if (targetOptions.isNotEmpty)
            ...targetOptions.map((t) => '.$t.dart')
          else ...[
            '.g.dart',
            '.super.dart',
            '.client.dart',
            '.server.dart',
            '.freezed.dart',
            '.json.dart',
            '.data.dart',
            '.mapper.dart',
            '.gen.dart',
            '.def.dart',
            '.types.dart',
            '.api.dart',
            '.schema.dart',
            '.db.dart',
            '.query.dart',
            '.part.dart',
            '.meta.dart',
          ]
        ]
      };
}
