

import 'export.dart';

class ScreenPath{
  static const String home = '/';
  static const String episodeList = '/episodeList';
  static const String movieDetail = '/movieDetails';
}


final GoRouter router = GoRouter(
  routes:[
    GoRoute(
      path: ScreenPath.home,
      builder: (context, state) {
        return const BackgroundCover(child: Home());
      },
      routes: <RouteBase>[
        GoRoute(
          path: ScreenPath.episodeList, 
          builder: (context, state)  {
            final extra = state.extra as Map<String, Object>;
            final index = extra['index'] as int;
            final magazines = extra['magazines'] as List<Magazine>;
            return DetailScreen(
              index: index,
              magazines: magazines,
            );
          },
        
        ),
        GoRoute(
              path: ScreenPath.movieDetail, 
              builder: (context, state)  {
                final extra = state.extra as Map<String, dynamic>;
                final data = extra['data'] as dynamic;
                return MovieDetails(
                  moviedata: data,
                );
              }
            )
      ]
    ),
  ]
);