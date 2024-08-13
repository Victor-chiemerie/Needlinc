


String calculateTimeDifference(int postTimeInMilliSeconds) {
  final now = DateTime.now();
  final postTime = DateTime.fromMillisecondsSinceEpoch(postTimeInMilliSeconds);
  final difference = now.difference(postTime);

  if (difference.inDays > 0) {
    return '${difference.inDays}d ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m ago';
  } else {
    return 'just now';
  }
}