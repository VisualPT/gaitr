class Ticker {
  const Ticker();
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(
        const Duration(milliseconds: 10), (x) => (ticks + x + 1) * 10);
  }
}
