enum Genre { action, comedy, drama, horror, scifi, other }

enum WatchStatus { wantToWatch, watching, completed }

class WatchlistItem {
  const WatchlistItem({
    required this.id,
    required this.title,
    required this.genre,
    required this.status,
    required this.rating,
  });

  final String id;
  final String title;
  final Genre genre;
  final WatchStatus status;
  final int rating;
}
