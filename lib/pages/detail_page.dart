import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/food.dart';
import '../utils/app_style.dart';
import '../utils/formatter.dart';
import '../widgets/food_image.dart';

class DetailPage extends StatefulWidget {
  final Food food;
  final void Function(CartItem item) onAddToCart;

  const DetailPage({super.key, required this.food, required this.onAddToCart});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _quantity = 1;
  bool _isFavorite = false;
  final _noteController = TextEditingController();

  Food get food => widget.food;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _changeQty(int delta) {
    final newQty = _quantity + delta;
    if (newQty < 1 || newQty > 99) return;
    setState(() => _quantity = newQty);
  }

  void _addToCart() {
    widget.onAddToCart(
      CartItem(
        food: food,
        quantity: _quantity,
        note: _noteController.text.trim(),
      ),
    );
    // Kembali ke halaman utama lalu tampilkan notifikasi di sana
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    showAppSnackBar(messenger, '$_quantity x ${food.name} masuk keranjang');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTags(),
                  const SizedBox(height: 12),
                  Text(
                    food.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatRupiah(food.price),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildStats(),
                  const SizedBox(height: 26),
                  _sectionTitle('Deskripsi'),
                  Text(
                    food.description,
                    style: const TextStyle(
                      fontSize: 14.5,
                      height: 1.65,
                      color: Color(0xFF5E5853),
                    ),
                  ),
                  const SizedBox(height: 26),
                  _sectionTitle('Catatan untuk Penjual'),
                  _buildNoteField(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ================= GAMBAR BESAR DI ATAS =================
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 340,
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      leading: _circleButton(
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: () => Navigator.pop(context),
      ),
      actions: [
        _circleButton(
          icon: _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: _isFavorite ? Colors.redAccent : AppColors.text,
          onTap: () => setState(() => _isFavorite = !_isFavorite),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'food-${food.id}',
              child: FoodImage(food: food, emojiSize: 96),
            ),
            // Bayangan tipis di atas supaya tombol tetap terlihat jelas
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x66000000), Colors.transparent],
                  stops: [0, 0.4],
                ),
              ),
            ),
          ],
        ),
      ),
      // Lengkungan putih di bawah gambar
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(28),
        child: Container(
          height: 28,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = AppColors.text,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, size: 20, color: color),
          ),
        ),
      ),
    );
  }

  // ================= LABEL KATEGORI =================
  Widget _buildTags() {
    return Wrap(
      spacing: 8,
      children: [
        _tag(food.category, AppColors.soft, AppColors.primary),
        if (food.isSpicy)
          _tag('🌶️ Pedas', const Color(0xFFFFE5E5), Colors.redAccent),
      ],
    );
  }

  Widget _tag(String text, Color background, Color foreground) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: foreground,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  // ================= RATING, WAKTU, TERJUAL =================
  Widget _buildStats() {
    return Row(
      children: [
        _statTile('⭐', '${food.rating}', 'Rating'),
        const SizedBox(width: 10),
        _statTile('⏱️', '${food.prepMinutes} mnt', 'Waktu saji'),
        const SizedBox(width: 10),
        _statTile('🛍️', formatSold(food.sold), 'Terjual'),
      ],
    );
  }

  Widget _statTile(String emoji, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 11.5, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CATATAN =================
  Widget _buildNoteField() {
    return TextField(
      controller: _noteController,
      maxLines: 2,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: 'Contoh: sambal dipisah, tanpa bawang goreng',
        hintStyle: const TextStyle(color: AppColors.muted, fontSize: 13.5),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: AppColors.text,
        ),
      ),
    );
  }

  // ================= BAR BAWAH (jumlah + tombol) =================
  Widget _buildBottomBar() {
    final total = food.price * _quantity;

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
        child: Row(
          children: [
            // Pengatur jumlah
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: _quantity > 1 ? () => _changeQty(-1) : null,
                    icon: const Icon(Icons.remove_rounded),
                    color: AppColors.primary,
                  ),
                  SizedBox(
                    width: 26,
                    child: Text(
                      '$_quantity',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _quantity < 99 ? () => _changeQty(1) : null,
                    icon: const Icon(Icons.add_rounded),
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            // Tombol tambah ke keranjang
            Expanded(
              child: SizedBox(
                height: 56,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: _addToCart,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.shopping_bag_rounded, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Tambah  •  ${formatRupiah(total)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}