import 'package:flutter/material.dart';
import 'package:marvel_what_if/widget/background_cover.dart';
import 'package:marvel_what_if/widget/cast.dart';
import 'package:marvel_what_if/widget/player.dart';



class MovieDetails extends StatefulWidget {
  const MovieDetails({super.key,required this.moviedata, required this.tag});
  
  final dynamic moviedata;
  final String tag;

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  
  @override
  Widget build(BuildContext context) {
    debugPrint("MovieDetails: ${widget.tag}");
    return Scaffold(
      body: BackgroundCover(
          child: CustomScrollView(
        // sliver app bar
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            expandedHeight: MediaQuery.of(context).size.height / 2.1,
            
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                "https://media.themoviedb.org/t/p/w454_and_h254_bestv2/${widget.moviedata["still_path"]}",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    child: const Center(child: Text('No Image')),
                  );
                },
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((ctx, _) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    widget.moviedata["name"],
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.date_range),
                        Text(widget.moviedata["air_date"].toString().substring(0, 4)),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(Icons.star),
                        Text(widget.moviedata['vote_average'].toString()),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            icon: const Icon(Icons.play_circle),
                            onPressed: () { 
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Player(
                                    videoUrl:widget.tag
                                  ),
                                ),
                              );
                             },
                        ),
                        // const Icon(Icons.play_circle),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Text(
                    'Story Line',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.moviedata["overview"],
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  // CastWidget(
                  //   cast: widget.moviedata,
                  
                  // ),
                ],
              ),
            );
          }, childCount: 1))
        ],
      )),
    );
  }
}
