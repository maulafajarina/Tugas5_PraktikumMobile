/// Mengubah angka menjadi format Rupiah, contoh: 18999000 -> "Rp 18.999.000"
String formatRupiah(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    final posFromEnd = digits.length - i;
    buffer.write(digits[i]);
    if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write('.');
  }
  return 'Rp ${buffer.toString()}';
}

/// Format angka terjual, contoh: 2100 -> "2,1rb"
String formatSold(int value) {
  if (value >= 1000) {
    final k = value / 1000;
    final text = k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1);
    return '${text.replaceAll('.', ',')}rb';
  }
  return value.toString();
}