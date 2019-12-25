import 'dart:async';
import 'package:args/args.dart';
import 'package:grpc/grpc.dart';

import 'package:piano_server/src/pb/piano.pbgrpc.dart';

class PianoService extends PianoServiceBase {
  final _controllers = <StreamController<Note>, void>{};

  @override
  Stream<Note> connect(ServiceCall call, Stream<Note> request) async* {
    print('Connected: #${request.hashCode}');

    final clientController = StreamController<Note>();
    _controllers[clientController] = null;

    request.listen((req) {
      print('Request from #${request.hashCode}: ${req.pitch}');

      if (req.pitch > 127) {
        print('Pitch out of range');
        return;
      }

      _controllers.forEach((controller, _) {
        if (controller != clientController) {
          controller.sink.add(req);
        }
      });
    }).onError((dynamic e) {
      print(e);

      _controllers.remove(clientController);
      clientController.close();
      print('Disconnected: #${request.hashCode}');
    });

    await for (final req in clientController.stream) {
      yield Note()..pitch = req.pitch;
    }
  }
}

Future<void> main(List<String> args) async {
  final results = parseArgs(args);
  if (results == null) {
    return;
  }

  final port = toInt(results['port']?.toString()) ?? 50051;

  final server = Server([PianoService()]);
  await server.serve(port: port);
  print('Server listening on port ${server.port}...');
}

ArgResults parseArgs(List<String> args) {
  final parser = ArgParser();
  parser.addFlag('help', abbr: 'h');
  parser.addOption('port', abbr: 'p', help: 'Port number to listen on');
  final results = parser.parse(args);

  if (results['help'] == true) {
    print(parser.usage);
    return null;
  }

  return results;
}

int toInt(String text) {
  return text == null ? null : int.parse(text);
}
