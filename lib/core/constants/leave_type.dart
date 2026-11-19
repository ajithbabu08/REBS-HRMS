/// Leave type constants.
abstract final class LeaveType {
  static const String casual = 'CASUAL';
  static const String sick = 'SICK';

  static const List<String> all = [casual, sick];

  static String displayName(String type) {
    switch (type) {
      case casual:
        return 'Casual Leave';
      case sick:
        return 'Sick Leave';
      default:
        return type;
    }
  }
}
