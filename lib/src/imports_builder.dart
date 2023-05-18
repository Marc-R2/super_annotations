import 'package:build/build.dart';
import 'package:path/path.dart' as path;

class ImportsBuilder {
  ImportsBuilder(this._input);
  final Set<Uri> _imports = {};
  final AssetId _input;

  void add(Uri import) => _imports.add(import);

  String write() {
    List<String> sdk = [], package = [], relative = [];

    for (final import in _imports) {
      if (import.isScheme('asset')) {
        final relativePath =
            path.relative(import.path, from: path.dirname(_input.uri.path));

        relative.add(relativePath);
      } else if (import.isScheme('package') &&
          import.pathSegments.first == _input.package) {
        final libPath =
            import.replace(pathSegments: import.pathSegments.skip(1)).path;

        final inputPath = _input.uri
            .replace(pathSegments: _input.uri.pathSegments.skip(1))
            .path;
        final relativePath =
            path.relative(libPath, from: path.dirname(inputPath));

        relative.add(relativePath);
      } else if (import.scheme == 'dart') {
        sdk.add(import.toString());
      } else if (import.scheme == 'package') {
        package.add(import.toString());
      } else {
        relative.add(import.toString()); // TODO: is this correct?
      }
    }

    sdk.sort();
    package.sort();
    relative.sort();

    String joined(List<String> s) =>
        s.isNotEmpty ? '${s.map((s) => "import '$s';").join('\n')}\n\n' : '';
    return joined(sdk) + joined(package) + joined(relative);
  }
}
