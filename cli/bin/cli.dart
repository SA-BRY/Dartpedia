import 'dart:io';
import 'package:http/http.dart' as http;

void printUsage() {
  print(
    "the following commands are available : 'help' ,'version' ,'search <ARTICLE-TITLE>'",
  );
}

void searchWikipedia(List<String>? topics) async {
  late String? articleTitle;

  if (topics == null || topics.isEmpty) {
    print('plz enter a title or some stuff U wanna search about');

    articleTitle = stdin.readLineSync() ?? '';
  } else {
    articleTitle = topics.join(' ');
  }

  print('allright iam doin a real work now just give us sometime');
  print("stop yelling i'm doing my best");
  var articleContent = await getWikipediaArticle(articleTitle);
  print(articleContent);
}

Future<String> getWikipediaArticle(String articleTitle) async {
  final client = http.Client();
  final url = Uri.http(
    'en.wikipedia.org',
    '/api/rest_v1/page/summary/$articleTitle',
  );
  final response = await client.get(url);
  if (response.statusCode == 200) {
    return response.body;
  }

  return 'Error: Failed to fetch article "$articleTitle". Status code: ${response.statusCode}';
}

void main(List<String> arguments) {
  const version = '1.1.0';
  if (arguments.isEmpty || arguments.first == 'help') {
    printUsage();
  } else if (arguments.first == 'version') {
    print('Dartpedia CLI version :$version');
  } else if (arguments.first == 'search') {
    final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
    searchWikipedia(inputArgs);
  } else {
    printUsage();
  }
}
