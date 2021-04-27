import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/src/models/category_model.dart';

import 'package:newsapp/src/models/news_models.dart';

final _URL_NEWS = 'http://newsapi.org/v2';
final _APIKEY = '3a8551675dea4c6ca9e8871d0bd4acbf';

class NewsService with ChangeNotifier {
  List<Article> headlines = [];

  String _selectedCategory = 'business';
  
  List<Category> categorias = [
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.volleyballBall, 'sports'),
    Category(FontAwesomeIcons.memory, 'technology')
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsService(){
    this.getTopHeadlines();

    categorias.forEach((item) {
      this.categoryArticles[item.name] = new List();
    });
  }

  get selectedCategory => this._selectedCategory;
  
  set selectedCategory (String valor){
    this._selectedCategory = valor;

    this.getArticlesByCategory(valor);
    notifyListeners();
  }

  List<Article> get getArticulosSelecionados => this.categoryArticles[this.selectedCategory];

  getTopHeadlines() async {
    final url = '$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=ca';
    final resp = await http.get(url);

    final newsResponse = newsResponseFromJson(resp.body);

    this.headlines.addAll(newsResponse.articles);
    notifyListeners();
  }

  getArticlesByCategory(String category) async{

    if(this.categoryArticles[category].length > 0){
      return this.categoryArticles[category];
    }
    final url = '$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=ca&category=$category';
    final resp = await http.get(url);

    final newsResponse = newsResponseFromJson(resp.body);

    this.categoryArticles[category].addAll(newsResponse.articles);
    notifyListeners();
  }
}