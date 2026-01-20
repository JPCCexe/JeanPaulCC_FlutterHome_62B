import 'package:watchlist_manager_movies_series/model/watchlist_item.dart';

const dummyWatchlist = [
  WatchlistItem(
    id: 'w1',
    title: 'The Dark Knight',
    genre: Genre.action,
    status: WatchStatus.completed,
    rating: 5,
  ),
  WatchlistItem(
    id: 'w2',
    title: 'The Office',
    genre: Genre.comedy,
    status: WatchStatus.watching,
    rating: 5,
  ),
  WatchlistItem(
    id: 'w3',
    title: 'Inception',
    genre: Genre.scifi,
    status: WatchStatus.completed,
    rating: 5,
  ),
  WatchlistItem(
    id: 'w4',
    title: 'Breaking Bad',
    genre: Genre.drama,
    status: WatchStatus.completed,
    rating: 4,
  ),
  WatchlistItem(
    id: 'w5',
    title: 'The Conjuring',
    genre: Genre.horror,
    status: WatchStatus.wantToWatch,
    rating: 0,
  ),
];
