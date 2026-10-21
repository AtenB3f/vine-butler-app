  String formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  String formatMoveInDate(DateTime? date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (date == null || !date.isAfter(today)) { return '즉시 입주'; }

    return '${formatDate(date)} 이후';
  }
