class EventItem {
  final DateTime dateTime;
  final String title;
  final String venue;
  final String? imageUrl;
  final bool hasTicketQr;

  EventItem({
    required this.dateTime,
    required this.title,
    required this.venue,
    this.imageUrl,
    this.hasTicketQr = false,
  });
}
