/// Result of a sync cycle.
class SyncResult {
  final int synced;
  final int rejected;
  final int failed;
  final int total;

  const SyncResult({
    this.synced = 0,
    this.rejected = 0,
    this.failed = 0,
    this.total = 0,
  });

  bool get hasErrors => rejected > 0 || failed > 0;
  bool get allSucceeded => synced == total && total > 0;

  @override
  String toString() =>
      'SyncResult(total: $total, synced: $synced, rejected: $rejected, failed: $failed)';
}
