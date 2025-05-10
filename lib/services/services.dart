

import 'package:http/http.dart' as http;
import 'dart:convert'; 


class WhatIfServices {

  late String id;
  static const String apikey = "2b22ab5e2d69c8926e451e306dcf9225";
  static const String baseUrl = 'https://api.themoviedb.org/3';
  String getEndPoint(String id) => '/tv/91363/season/$id?language=en-GB&api_key=$apikey';

  Future<dynamic> fetchWhatIfTvShow(String season) async {
    final url = Uri.parse('$baseUrl${getEndPoint(season.toString())}');
    
    try{
      final response = await http.get(url);
      if(response.statusCode == 200){
        // Parse the JSON response
        final data = jsonDecode(response.body);
        // Do something with the data
        return data;
        // print(data);
      }else{
        throw Exception('Failed to load What If TV show');
      }
    }catch(e){
      throw Exception('Failed to load What If TV show');
    }
  }
}

