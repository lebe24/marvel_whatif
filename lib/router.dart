
import 'package:marvel_what_if/Screens/Home.dart';
import 'package:marvel_what_if/Screens/details_screen.dart';
import 'package:marvel_what_if/Screens/movie_details.dart';
import 'package:marvel_what_if/model/magazine.dart';
import 'package:marvel_what_if/widget/background_cover.dart';

import 'export.dart';

class ScreenPath{
  static const String home = '/';
  static const String episodeList = '/episodeList';
  static const String movieDetail = '/movieDetails';
  static const String player = '/player';
}


final GoRouter router = GoRouter(
  routes:[
    GoRoute(
      path: ScreenPath.home,
      builder: (context, state) {
        return const BackgroundCover(
          child: Home()
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: ScreenPath.episodeList, 
          builder: (context, state)  {
            final extra = state.extra as Map<String, Object>;
            final index = extra['index'] as int;
            final magazines = extra['magazines'] as List<Magazine>;
            final tag = extra['tag'] as String;
            return DetailScreen(
              index: index,
              magazines: magazines,
              tag:tag
            );
          },
        ),
        GoRoute(
              path: ScreenPath.movieDetail, 
              builder: (context, state)  {
                final extra = state.extra as Map<String, dynamic>;
                final data = extra['data'] as dynamic;
                return MovieDetails(
                  moviedata: data, tag: '',
                );
              }
            )
      ]
    ),
  ]
);