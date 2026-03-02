import 'dart:io';

Future<void> main() async {
  //print('Starting flutter build web to check errors...');
  final process = await Process.start(
    'flutter.bat', 
    ['build', 'web', '--verbose'], 
    runInShell: true,
  );

  final logFile = File('flutter_diagnostic.log');
  final sink = logFile.openWrite();

  process.stdout.listen((data) {
    sink.add(data);
    stdout.add(data);
  });

  process.stderr.listen((data) {
    sink.add(data);
    stderr.add(data);
  });

 // final exitCode = await process.exitCode;
  await sink.close();
 // print('Done. Exit code: $exitCode');
}
