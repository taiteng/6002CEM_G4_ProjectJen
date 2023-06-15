import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/news_model.dart';

class NewsApiService {
  String apilink2 =
      "https://newsapi.org/v2/top-headlines?country=us&category=realestate&apiKey=d387b58ae8254db685545577fb74d7fe";

  Future<NewsModal?> getNews() async {
    String apilink =
        "https://newsapi.org/v2/everything?q=realestate&sortBy=popularity&apiKey=d387b58ae8254db685545577fb74d7fe";
    var response = await http.get(Uri.parse(apilink));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return NewsModal.fromJson(json);
    }
    return null;
  }
}