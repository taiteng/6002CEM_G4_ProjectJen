import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/article_model.dart';

class NewsApiService{
  final endPointUrl = Uri.parse(
      "https://newsapi.org/v2/top-headlines?country=us&apiKey=4919fdfcc35846aea1ff72f6d3063c53"
  );

  Future<List<Article>> getArticle() async{
    final res = await http.get(endPointUrl);

    if(res.statusCode == 200){

      Map<String, dynamic> json = jsonDecode(res.body);
      print(json);
      List<dynamic> body = json['articles'];
      print(body[0]['title']);

      List<Article> articles =
      body.map((dynamic item) => Article.fromJson(item)).toList();

      return articles;
    }else{
      throw("Cannot get the Articles");
    }
  }
}