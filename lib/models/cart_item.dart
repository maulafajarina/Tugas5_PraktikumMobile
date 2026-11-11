import 'food.dart';

/// Satu pesanan di dalam keranjang.
class CartItem {
  final Food food;
  int quantity;
  final String note; // catatan untuk penjual, boleh kosong

  CartItem({
    required this.food,
    required this.quantity,
    this.note = '',
  });

  /// Total harga pesanan ini (harga x jumlah).
  int get subtotal => food.price * quantity;

  /// Pesanan dianggap sama kalau makanannya dan catatannya sama.
  bool isSameAs(CartItem other) =>
      food.id == other.food.id && note.trim() == other.note.trim();
}