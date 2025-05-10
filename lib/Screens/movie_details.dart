import 'package:flutter/material.dart';
import 'package:whatif/widget/background_cover.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({super.key,required this.moviedata});

  final dynamic moviedata;

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  @override
  Widget build(BuildContext context) {
    return  BackgroundCover(
      child:CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            expandedHeight: MediaQuery.of(context).size.height / 2.1,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                "https://media.themoviedb.org/t/p/w454_and_h254_bestv2/${widget.moviedata["still_path"]}",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((ctx, _) {
              
            }
          ))
        ],
      )
    );
  }
}