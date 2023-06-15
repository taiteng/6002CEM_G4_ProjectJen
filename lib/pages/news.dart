import 'package:flutter/material.dart';
import 'package:projectjen/service/news_api_service.dart';
import '../model/article_model.dart';
import '../widgets/news_widget.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    NewsApiService client = NewsApiService();


    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: client.getArticle(),
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          if (snapshot.hasData) {
            List<Article>? articles = snapshot.data;
            return ListView.builder(
              itemCount: articles?.length,
              itemBuilder: (context, index) =>
                  ListTile(
                    title: Text(articles![index].title ?? 'No Title'),
                  ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}