import 'package:intl/intl.dart';

class AppFormatters {
  static String currency(double amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)} L';
    } else if (amount >= 1000) {
      return '₹${_formatIndian(amount.toInt())}';
    }
    return '₹${amount.toStringAsFixed(0)}';
  }

  static String currencyFull(double amount) {
    return '₹${_formatIndian(amount.toInt())}';
  }

  static String weight(double kg) {
    if (kg >= 1000) {
      return '${(kg / 1000).toStringAsFixed(1)} T';
    }
    return '${kg.toStringAsFixed(0)} kg';
  }

  static String weightFull(double kg) {
    return '${_formatIndian(kg.toInt())} kg';
  }

  static String percentage(double value) {
    return '${value >= 0 ? '+' : ''}${value.toStringAsFixed(1)}%';
  }

  static String timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('dd MMM').format(dateTime);
  }

  static String dateShort(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }

  static String dateFull(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  static String _formatIndian(int n) {
    final str = n.toString();
    if (str.length <= 3) return str;
    final lastThree = str.substring(str.length - 3);
    final remaining = str.substring(0, str.length - 3);
    final formatted = remaining.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{2})+$)'),
      (m) => '${m[1]},',
    );
    return '$formatted,$lastThree';
  }
}
