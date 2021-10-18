Future<T> futureAppDuration<T>(Future<T> future) {
  return future.timeout(
    const Duration(
      minutes: 7,
    ),
  );
}
