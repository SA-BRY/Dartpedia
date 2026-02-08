import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:command_runner/command_runner.dart' as command_runner;

void main(List<String> arguments) async {
  const version = '3.0.0';

  var commandRunner = command_runner.CommandRunner();
  commandRunner.addCommand(command_runner.HelpCommand());
  commandRunner.run(arguments);
}
