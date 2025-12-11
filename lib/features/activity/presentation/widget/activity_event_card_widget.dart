import 'package:flutter/material.dart';
import 'package:kasm_poc_workspace/features/activity/data/model/event_item_model.dart';

class ActivityEventCardWidget extends StatelessWidget {
  const ActivityEventCardWidget({super.key, required this.item, this.onTap});

  final EventItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = _formatMonthDay(item.dateTime);
    final timeStr = _formatTime(item.dateTime);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withOpacity(0.6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: date + time + QR
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // "Nov 15"
                        Text(
                          dateStr,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        // "7:00pm"
                        Text(
                          timeStr,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (item.hasTicketQr)
                    Icon(
                      Icons.qr_code_2,
                      size: 22,
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.85),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Title
              Text(
                item.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),

              const SizedBox(height: 8),

              // Venue row
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.75),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.venue,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.85),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Image area (fixed aspect)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _EventImage(imageUrl: item.imageUrl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatMonthDay(DateTime dt) {
    // e.g., "Nov 15"
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}';
    // If you need localization, use intl package's DateFormat.
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'pm' : 'am';
    return '$hour:$minute$ampm';
  }
}

class _EventImage extends StatelessWidget {
  const _EventImage({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final bg = Colors.grey.shade800;

    // Keep a **wide** aspect like screenshot
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: DecoratedBox(
        decoration: BoxDecoration(color: bg),
        child: imageUrl == null || imageUrl!.isEmpty
            ? Center(
                child: Icon(Icons.image_outlined, color: Colors.white.withOpacity(0.85), size: 40),
              )
            : Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Center(child: Icon(Icons.broken_image, color: Colors.white70, size: 40)),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
