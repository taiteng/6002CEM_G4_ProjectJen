import 'package:flutter/material.dart';
import 'package:projectjen/model/news_model.dart';
import 'package:projectjen/service/news_api_service.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff2b2b2c),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: NewsApiService().getNews(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("${snapshot.hasError}");
                  } else if (snapshot.hasData) {
                    NewsModal? l1 = snapshot.data;
                    return ListView.builder(
                      // scrollDirection: Axis.horizontal,
                      itemCount: l1!.articles!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 150,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 50,
                                        width: 200,
                                        child: Text(
                                          "${l1.articles![index].title}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 50,
                                        width: 200,
                                        child: Text(
                                          "${l1.articles![index].description}",
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Image.network(
                                  "${l1.articles![index].urlToImage}",height: double.infinity,width: 170,),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  else{
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}