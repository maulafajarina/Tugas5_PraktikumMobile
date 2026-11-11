import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../utils/app_style.dart';
import '../utils/formatter.dart';
import '../widgets/food_image.dart';

class CartPage extends StatefulWidget {
  final List<CartItem> cart;
  final VoidCallback onChanged; // memberi tahu HomePage kalau isi keranjang berubah

  const CartPage({super.key, required this.cart, required this.onChanged});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> get cart => widget.cart;

  int get _subtotal => cart.fold(0, (sum, item) => sum + item.subtotal);
  int get _totalItems => cart.fold(0, (sum, item) => sum + item.quantity);
  int get _ongkir => _subtotal >= minGratisOngkir ? 0 : ongkosKirim;
  int get _total => _subtotal + _ongkir;

  void _update(VoidCallback action) {
    setState(action);
    widget.onChanged();
  }

  void _changeQty(CartItem item, int delta) {
    final newQty = item.quantity + delta;
    if (newQty < 1) {
      _remove(item);
      return;
    }
    if (newQty > 99) return;
    _update(() => item.quantity = newQty);
  }

  /// Hapus pesanan, dengan tombol BATAL untuk mengembalikannya.
  void _remove(CartItem item) {
    final index = cart.indexOf(item);
    if (index < 0) return;
    _update(() => cart.removeAt(index));

    showAppSnackBar(
      ScaffoldMessenger.of(context),
      '${item.food.name} dihapus dari keranjang',
      icon: Icons.delete_outline_rounded,
      action: SnackBarAction(
        label: 'BATAL',
        textColor: AppColors.primary,
        onPressed: () {
          cart.insert(math.min(index, cart.length), item);
          widget.onChanged();
          if (mounted) setState(() {});
        },
      ),
    );
  }

  void _checkout() {
    final totalItems = _totalItems;
    final total = _total;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        icon: Container(
          width: 76,
          height: 76,
          decoration: const BoxDecoration(
            color: Color(0xFFE6F7EC),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded,
              color: AppColors.success, size: 46),
        ),
        title: const Text(
          'Pesanan Diterima!',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Text(
          'Terima kasih! $totalItems porsi senilai ${formatRupiah(total)} '
          'sedang disiapkan oleh dapur kami. 🍳',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted, height: 1.5),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogContext); // tutup dialog
              _update(() => cart.clear());
              Navigator.pop(context); // kembali ke halaman utama
            },
            child: const Text('Kembali ke Menu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Keranjang Saya',
          style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.text),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
      ),
      body: cart.isEmpty
          ? _buildEmpty()
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Geser ke kiri untuk menghapus pesanan',
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                ),
                ...cart.map(_buildItem),
                _buildOngkirInfo(),
                _buildSummary(),
              ],
            ),
      bottomNavigationBar: cart.isEmpty ? null : _buildBottomBar(),
    );
  }

  // ================= KERANJANG KOSONG =================
  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.soft,
                shape: BoxShape.circle,
              ),
              child: const Text('🛒', style: TextStyle(fontSize: 56)),
            ),
            const SizedBox(height: 20),
            const Text(
              'Keranjang masih kosong',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Yuk, pilih makanan favoritmu dulu!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.restaurant_menu_rounded),
              label: const Text('Lihat Menu'),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SATU PESANAN =================
  Widget _buildItem(CartItem item) {
    final food = item.food;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Dismissible(
        key: ObjectKey(item),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => _remove(item),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFFF5A5F),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Icon(Icons.delete_rounded, color: Colors.white),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: AppStyle.softShadow,
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 82,
                  height: 82,
                  child: FoodImage(food: food, emojiSize: 34),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.note.isEmpty ? food.category : '📝 ${item.note}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            formatRupiah(item.subtotal),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        _buildStepper(item),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepper(CartItem item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _miniButton(
            item.quantity == 1
                ? Icons.delete_outline_rounded
                : Icons.remove_rounded,
            () => _changeQty(item, -1),
          ),
          SizedBox(
            width: 24,
            child: Text(
              '${item.quantity}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.text,
              ),
            ),
          ),
          _miniButton(Icons.add_rounded, () => _changeQty(item, 1)),
        ],
      ),
    );
  }

  Widget _miniButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Icon(icon, size: 17, color: AppColors.primary),
      ),
    );
  }

  // ================= INFO GRATIS ONGKIR =================
  Widget _buildOngkirInfo() {
    final reached = _subtotal >= minGratisOngkir;
    final progress = (_subtotal / minGratisOngkir).clamp(0.0, 1.0).toDouble();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.soft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🚚', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  reached
                      ? 'Yeay, kamu dapat gratis ongkir!'
                      : 'Tambah ${formatRupiah(minGratisOngkir - _subtotal)} '
                          'lagi untuk gratis ongkir',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              color: reached ? AppColors.success : AppColors.primary,
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ================= RINGKASAN HARGA =================
  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppStyle.softShadow,
      ),
      child: Column(
        children: [
          _summaryRow('Subtotal ($_totalItems porsi)', formatRupiah(_subtotal)),
          const SizedBox(height: 10),
          _summaryRow(
            'Ongkos kirim',
            _ongkir == 0 ? 'Gratis' : formatRupiah(_ongkir),
            valueColor: _ongkir == 0 ? AppColors.success : null,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: AppColors.border),
          ),
          _summaryRow('Total pembayaran', formatRupiah(_total), bold: true),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool bold = false,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: bold ? AppColors.text : AppColors.muted,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
              fontSize: bold ? 15 : 13.5,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
            fontSize: bold ? 17 : 14,
            color: valueColor ?? (bold ? AppColors.primary : AppColors.text),
          ),
        ),
      ],
    );
  }

  // ================= BAR BAWAH =================
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: _checkout,
            child: Row(
              children: [
                const Icon(Icons.receipt_long_rounded, size: 20),
                const SizedBox(width: 10),
                const Text(
                  'Pesan Sekarang',
                  style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text(
                  formatRupiah(_total),
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}