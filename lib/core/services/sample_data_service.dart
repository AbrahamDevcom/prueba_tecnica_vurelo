import 'package:cinepulse/core/models/movie.dart';
import 'package:cinepulse/core/models/movie_detail.dart';

class SampleDataService {
  static List<Movie> getUpcomingMovies() {
    return [
      Movie(
        id: 1,
        title: 'Dune: Part Two',
        originalTitle: 'Dune: Part Two',
        overview: 'Sigue el viaje mítico de Paul Atreides mientras se une con Chani y los Fremen en una guerra de venganza contra los conspiradores que destruyeron a su familia.',
        posterPath: '/czembW0Rk1Ke7lCJGahbOhdCuhV.jpg',
        backdropPath: '/xOMo8BRK7PfcJv9JCnx7s5hj0PX.jpg',
        releaseDate: '2024-02-28',
        voteAverage: 8.2,
        voteCount: 4521,
        genreIds: [12, 18, 878],
        originalLanguage: 'en',
        popularity: 987.5,
        adult: false,
        video: false,
      ),
      Movie(
        id: 2,
        title: 'Godzilla x Kong: The New Empire',
        originalTitle: 'Godzilla x Kong: The New Empire',
        overview: 'Después de su última batalla, Kong y Godzilla deben volver a unirse para enfrentar una amenaza colosal oculta en nuestro mundo.',
        posterPath: '/gmGK5Gw8SSJgKm7pAfMTjkQwM5g.jpg',
        backdropPath: '/7O4iVfOMQmdCSxhOg1WnzG1AgYT.jpg',
        releaseDate: '2024-03-27',
        voteAverage: 7.1,
        voteCount: 2157,
        genreIds: [28, 12, 878],
        originalLanguage: 'en',
        popularity: 756.3,
        adult: false,
        video: false,
      ),
      Movie(
        id: 3,
        title: 'Furiosa: A Mad Max Saga',
        originalTitle: 'Furiosa: A Mad Max Saga',
        overview: 'La historia de origen de la guerrera Furiosa antes de conocer a Max Rockatansky en Mad Max: Fury Road.',
        posterPath: '/wNUFzjTRnhOqq6WKsL9rwHajKUa.jpg',
        backdropPath: '/bi7dVJu7fXI0bFBKbxlOWHhMOcO.jpg',
        releaseDate: '2024-05-22',
        voteAverage: 7.8,
        voteCount: 1834,
        genreIds: [28, 12, 878],
        originalLanguage: 'en',
        popularity: 432.1,
        adult: false,
        video: false,
      ),
      Movie(
        id: 4,
        title: 'Wicked',
        originalTitle: 'Wicked',
        overview: 'La historia no contada de las brujas de Oz, explorando la amistad entre Elphaba y Glinda antes de convertirse en la Bruja Malvada del Oeste y Glinda la Buena.',
        posterPath: '/uAyqNlCr5LXKfY8jZCLLGIeR9Fs.jpg',
        backdropPath: '/kJ0oqGHDfQ4vRbEaMGFzjwIcgMN.jpg',
        releaseDate: '2024-11-21',
        voteAverage: 8.7,
        voteCount: 892,
        genreIds: [14, 10402, 10749],
        originalLanguage: 'en',
        popularity: 1287.4,
        adult: false,
        video: false,
      ),
      Movie(
        id: 5,
        title: 'Gladiator II',
        originalTitle: 'Gladiator II',
        overview: 'Lucius, el sobrino de Cómodo, debe luchar por Roma después de que su hogar sea conquistado por los tiranos emperadores que ahora dirigen el imperio.',
        posterPath: '/bKk2JMI6WCNcF91Iv8iF7djNLdX.jpg',
        backdropPath: '/aJSrkzwKr3AQhGMCpRsRZq0fOhP.jpg',
        releaseDate: '2024-11-13',
        voteAverage: 7.9,
        voteCount: 1567,
        genreIds: [28, 12, 18],
        originalLanguage: 'en',
        popularity: 678.9,
        adult: false,
        video: false,
      ),
    ];
  }

  static List<Movie> getTrendingMovies() {
    return [
      Movie(
        id: 6,
        title: 'Avatar: The Way of Water',
        originalTitle: 'Avatar: The Way of Water',
        overview: 'Ambientada más de una década después de los acontecimientos de la primera película, Avatar: The Way of Water cuenta la historia de la familia Sully.',
        posterPath: '/rEMy3bZgJTZA49mZVlYGJF8HhRo.jpg',
        backdropPath: '/198vrF8k7mfQ4FjDJsBmdQcaiyq.jpg',
        releaseDate: '2022-12-14',
        voteAverage: 7.6,
        voteCount: 8954,
        genreIds: [12, 14, 878],
        originalLanguage: 'en',
        popularity: 2154.7,
        adult: false,
        video: false,
      ),
      Movie(
        id: 7,
        title: 'Top Gun: Maverick',
        originalTitle: 'Top Gun: Maverick',
        overview: 'Después de más de 30 años de servicio como uno de los mejores aviadores de la Marina, Pete "Maverick" Mitchell está donde pertenece.',
        posterPath: '/bOMGJYhbDXlpOUJ0xYZjvZV0qx8.jpg',
        backdropPath: '/VlHt27nCqOuTnuX6bku8QZapzO.jpg',
        releaseDate: '2022-05-24',
        voteAverage: 8.3,
        voteCount: 7432,
        genreIds: [28, 18],
        originalLanguage: 'en',
        popularity: 1897.3,
        adult: false,
        video: false,
      ),
      Movie(
        id: 8,
        title: 'Spider-Man: No Way Home',
        originalTitle: 'Spider-Man: No Way Home',
        overview: 'Por primera vez en la historia cinematográfica de Spider-Man, nuestro vecino y amigo héroe es desenmascarado y ya no puede separar su vida normal de los enormes riesgos de ser un superhéroe.',
        posterPath: '/osYbtvqjMUhEXgWqJOiRqTg0TyH.jpg',
        backdropPath: '/14QbnygCuTO0vl7CAFmPf1fgZfV.jpg',
        releaseDate: '2021-12-15',
        voteAverage: 8.0,
        voteCount: 18567,
        genreIds: [28, 12, 878],
        originalLanguage: 'en',
        popularity: 1675.9,
        adult: false,
        video: false,
      ),
      Movie(
        id: 9,
        title: 'The Batman',
        originalTitle: 'The Batman',
        overview: 'Cuando un asesino se dirige a la élite de Gotham con una serie de maquinaciones sádicas, un rastro de pistas crípticas envía al Detective del Mundo en una investigación al inframundo.',
        posterPath: '/aQvJ5WPzZgYVDrxLX4R6cLJCEaQ.jpg',
        backdropPath: '/b0PlSFdDwbyK0cf5RxwDpaOJQvQ.jpg',
        releaseDate: '2022-03-01',
        voteAverage: 7.7,
        voteCount: 9876,
        genreIds: [28, 80, 18],
        originalLanguage: 'en',
        popularity: 1423.6,
        adult: false,
        video: false,
      ),
      Movie(
        id: 10,
        title: 'Oppenheimer',
        originalTitle: 'Oppenheimer',
        overview: 'La historia del físico estadounidense J. Robert Oppenheimer y su papel en el desarrollo de la bomba atómica.',
        posterPath: '/dcWyJwLauVfY8lHQVOLB2qkwpEw.jpg',
        backdropPath: '/7I6VUdPj6tQECNHdviJkUHD2u89.jpg',
        releaseDate: '2023-07-19',
        voteAverage: 8.1,
        voteCount: 6789,
        genreIds: [18, 36, 53],
        originalLanguage: 'en',
        popularity: 1287.4,
        adult: false,
        video: false,
      ),
      Movie(
        id: 11,
        title: 'Barbie',
        originalTitle: 'Barbie',
        overview: 'Barbie y Ken están teniendo el tiempo de sus vidas en el colorido y aparentemente perfecto mundo de Barbie Land. Sin embargo, cuando tienen la oportunidad de ir al mundo real, pronto descubren las alegrías y peligros de vivir entre los humanos.',
        posterPath: '/plCpKP71q8R2phGfNc3JqY0dJP3.jpg',
        backdropPath: '/nHf61UzkfFno5X1ofIhugCPus2R.jpg',
        releaseDate: '2023-07-19',
        voteAverage: 7.2,
        voteCount: 8934,
        genreIds: [35, 12, 14],
        originalLanguage: 'en',
        popularity: 2156.8,
        adult: false,
        video: false,
      ),
    ];
  }

  static MovieDetail getMovieDetail(int movieId) {
    // Return a sample movie detail based on the ID
    final movies = [...getUpcomingMovies(), ...getTrendingMovies()];
    final movie = movies.firstWhere((m) => m.id == movieId, orElse: () => movies.first);
    
    return MovieDetail(
      id: movie.id,
      title: movie.title,
      originalTitle: movie.originalTitle,
      overview: movie.overview,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      releaseDate: movie.releaseDate,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount,
      genres: _getGenresFromIds(movie.genreIds),
      originalLanguage: movie.originalLanguage,
      popularity: movie.popularity,
      adult: movie.adult,
      runtime: 148, // Sample runtime
      status: 'Released',
      tagline: 'Una experiencia cinematográfica épica',
      budget: 165000000,
      revenue: 694700000,
    );
  }

  static List<Genre> _getGenresFromIds(List<int> genreIds) {
    final genreMap = {
      12: 'Aventura',
      14: 'Fantasía',
      16: 'Animación',
      18: 'Drama',
      27: 'Terror',
      28: 'Acción',
      35: 'Comedia',
      36: 'Historia',
      53: 'Suspense',
      80: 'Crimen',
      99: 'Documental',
      878: 'Ciencia ficción',
      9648: 'Misterio',
      10402: 'Música',
      10749: 'Romance',
      10751: 'Familiar',
      10752: 'Guerra',
      10770: 'Película de TV',
    };

    return genreIds
        .map((id) => Genre(id: id, name: genreMap[id] ?? 'Desconocido'))
        .toList();
  }

  static List<MovieVideo> getMovieVideos(int movieId) {
    // Return sample trailer data
    return [
      MovieVideo(
        id: 'sample_trailer_1',
        key: 'dQw4w9WgXcQ', // Sample YouTube key
        name: 'Tráiler Oficial',
        site: 'YouTube',
        type: 'Trailer',
        official: true,
      ),
    ];
  }
}