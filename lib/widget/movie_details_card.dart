import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whatif/Screens/movie_details.dart';

class MovieCardDetails extends StatelessWidget {
  const MovieCardDetails({super.key, required this.imagePath, required this.movieTitle, this.movieData});

  final String imagePath, movieTitle;
  final dynamic movieData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children:[
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              reverseTransitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) {
                return MovieDetails(
                   moviedata: movieData,
                );
              },
            ),
          ),
          child:ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imagePath,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child:Container(
              height: 60,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: Colors.black26,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(movieTitle),
              ),
            )
          ),
        ),
        
      ],
    );
  }
}