/// A utility to extract clean error messages from verbose exceptions.
String extractErrorMessage(Object error) {
  final messagePattern = RegExp(r'message: (.*?),\s*statusCode');
  final match = messagePattern.firstMatch(error.toString());

  if (match != null && match.groupCount >= 1) {
    return match.group(1)!;
  }

  return 'An unexpected error occurred';
}
