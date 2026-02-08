import 'dart:async';
import '../command_runner.dart';
import 'dart:collection';

enum OptionType { flag, option }

abstract class Arguments {
  String get name;
  String? get help;
  Object? get defaultValue;
  String? get valueHelp;
  String? get usage;
}

class Option extends Arguments {
  Option(
    this.name, {
    required this.type,
    this.help,
    this.abbr,
    this.defaultValue,
    this.valueHelp,
  });

  @override
  final String name;
  final OptionType type;

  @override
  final String? help;
  final String? abbr;

  @override
  final Object? defaultValue;

  @override
  final String? valueHelp;

  @override
  String? get usage {
    if (abbr != null) {
      return '-$abbr,--$name: $help';
    }
    return '--$name: $help';
  }
}

abstract class Command extends Arguments {
  @override
  String get name;
  String get description;
  bool get requireArgument => false;

  late CommandRunner runner;

  @override
  String get help;
  @override
  Object get defaultValue;
  @override
  String get valueHelp;

  final List<Option> _options = [];

  UnmodifiableListView<Option> get options =>
      UnmodifiableListView(_options.toSet());
  void addFlag(String name, {String? help, String? abbr, String? valueHelp}) {
    _options.add(
      Option(
        name,
        help: help,
        abbr: abbr,
        defaultValue: false,
        valueHelp: valueHelp,
        type: OptionType.flag,
      ),
    );
  }

  void addOption(
    String name, {
    String? help,
    String? abbr,
    String? defaultValue,
    String? valueHelp,
  }) {
    _options.add(
      Option(
        name,
        help: help,
        abbr: abbr,
        defaultValue: defaultValue,
        valueHelp: valueHelp,
        type: OptionType.option,
      ),
    );
  }

  FutureOr<Object?> run(ArgResults args);

  @override
  String get usage {
    return '$name:  $description';
  }
}

class ArgResults {
  Command? command;
  String? commandArg;
  Map<Option, Object?> options = {};

  bool flag(String name) {
    for (var option in options.keys.where(
      (option) => option.type == OptionType.flag,
    )) {
      if (option.name == name) {
        return options[option] as bool;
      }
    }

    return false;
  }

  bool hasOption(String name) {
    return options.keys.any((option) => option.name == name);
  }

  ({Option option, Object? input}) getOption(String name) {
    var mapEntry = options.entries.firstWhere(
      (option) => option.key.name == name || option.key.abbr == name,
    );
    return (option: mapEntry.key, input: mapEntry.value);
  }
}
