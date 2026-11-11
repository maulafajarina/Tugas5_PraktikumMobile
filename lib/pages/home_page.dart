import 'package:flutter/material.dart';
import '../data/food_data.dart';
import '../models/cart_item.dart';
import '../models/food.dart';
import '../utils/app_style.dart';
import '../utils/formatter.dart';
import '../widgets/food_card.dart';
import '../widgets/food_image.dart';
import 'cart_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'Semua';
  String _keyword = '';
  final List<CartItem> _cart = [];

  int get _cartCount => _cart.fold(0, (sum, item) => sum + item.quantity);
  int get _cartTotal => _cart.fold(0, (sum, item) => sum + item.subtotal);

  /// Menu yang sesuai kategori & kata kunci pencarian.
  List<Food> get _filteredFoods {
    final keyword = _keyword.trim().toLowerCase();
    return foodList.where((food) {
      final matchCategory =
          _selectedCategory == 'Semua' || food.category == _selectedCategory;
      final matchKeyword = keyword.isEmpty ||
          food.name.toLowerCase().contains(keyword) ||
          food.category.toLowerCase().contains(keyword);
      return matchCategory && matchKeyword;
    }).toList();
  }

  /// 4 menu dengan penjualan terbanyak.
  List<Food> get _bestSellers {
    final sorted = [...foodList]..sort((a, b) => b.sold.compareTo(a.sold));
    return sorted.take(4).toList();
  }

  /// Tambah ke keranjang. Kalau menu & catatannya sama, jumlahnya digabung.
  void _addToCart(CartItem newItem) {
    setState(() {
      final index = _cart.indexWhere((item) => item.isSameAs(newItem));
      if (index >= 0) {
        final item = _cart[index];
        item.quantity = (item.quantity + newItem.quantity).clamp(1, 99).toInt();
      } else {
        _cart.add(newItem);
      }
    });
  }

  /// Tombol "+" di kartu: langsung tambah 1 porsi.
  void _quickAdd(Food food) {
    _addToCart(CartItem(food: food, quantity: 1));
    showAppSnackBar(
      ScaffoldMessenger.of(context),
      '1x ${food.name} masuk keranjang',
    );
  }

  void _openDetail(Food food) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPage(food: food, onAddToCart: _addToCart),
      ),
    );
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CartPage(
          cart: _cart,
          onChanged: () => setState(() {}),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foods = _filteredFoods;
    final isBrowsing = _keyword.trim().isEmpty && _selectedCategory == 'Semua';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildSearch()),
            if (isBrowsing) SliverToBoxAdapter(child: _buildPromoBanner()),
            SliverToBoxAdapter(child: _buildCategories()),
            if (isBrowsing) ...[
              SliverToBoxAdapter(
                child: _sectionTitle('🔥 Paling Laris', subtitle: 'Minggu ini'),
              ),
              SliverToBoxAdapter(child: _buildBestSellers()),
            ],
            SliverToBoxAdapter(
              child: _sectionTitle(
                isBrowsing ? 'Semua Menu' : 'Hasil Pencarian',
                subtitle: '${foods.length} menu',
              ),
            ),
            if (foods.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmpty(),
              )
            else
              SliverPadding(
                // Bawah dibuat lega supaya tidak tertutup tombol keranjang
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final food = foods[index];
                      return FoodCard(
                        key: ValueKey(food.id),
                        food: food,
                        onTap: () => _openDetail(food),
                        onAdd: () => _quickAdd(food),
                      );
                    },
                    childCount: foods.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    mainAxisExtent: 252,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _cartCount == 0
          ? null
          : FloatingActionButton.extended(
              onPressed: _openCart,
              backgroundColor: AppColors.text,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.shopping_bag_rounded),
              label: Text(
                '$_cartCount item  •  ${formatRupiah(_cartTotal)}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, mau makan apa hari ini? 👋',
                  style: TextStyle(color: AppColors.muted, fontSize: 13.5),
                ),
                SizedBox(height: 4),
                Text(
                  'Warung Nusantara',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          Badge(
            isLabelVisible: _cartCount > 0,
            backgroundColor: AppColors.primary,
            label: Text('$_cartCount'),
            offset: const Offset(-4, 4),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: AppStyle.softShadow,
              ),
              child: IconButton(
                onPressed: _openCart,
                icon: const Icon(Icons.shopping_bag_outlined),
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= PENCARIAN =================
  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppStyle.softShadow,
        ),
        child: TextField(
          onChanged: (value) => setState(() => _keyword = value),
          decoration: const InputDecoration(
            hintText: 'Cari nasi goreng, bakso, es cendol...',
            hintStyle: TextStyle(color: AppColors.muted, fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  // ================= BANNER PROMO =================
  Widget _buildPromoBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        height: 150,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF8A4C), Color(0xFFFF5722)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(right: -30, top: -40, child: _bubble(150, 0.12)),
            Positioned(right: 60, bottom: -60, child: _bubble(120, 0.10)),
            const Positioned(
              right: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text('🍜', style: TextStyle(fontSize: 70)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'PROMO HARI INI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Gratis Ongkir!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Min. belanja ${formatRupiah(minGratisOngkir)}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bubble(double size, double alpha) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: alpha),
      ),
    );
  }

  // ================= KATEGORI =================
  Widget _buildCategories() {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final (name, emoji) = categories[index];
          final selected = name == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = name),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppColors.text,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= PALING LARIS =================
  Widget _buildBestSellers() {
    final foods = _bestSellers;
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: foods.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final food = foods[index];
          return GestureDetector(
            onTap: () => _openDetail(food),
            child: Container(
              width: 250,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppStyle.softShadow,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  FoodImage(food: food, emojiSize: 56),
                  // Gradasi gelap supaya tulisan putih terbaca
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xD9000000)],
                        stops: [0.35, 1],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '#${index + 1} Terlaris',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          food.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              formatRupiah(food.price),
                              style: const TextStyle(
                                color: Color(0xFFFFC9A8),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.star_rounded,
                                size: 16, color: Colors.amber),
                            Text(
                              ' ${food.rating}  •  ${formatSold(food.sold)} terjual',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= LAIN-LAIN =================
  Widget _sectionTitle(String title, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
              ),
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12.5, color: AppColors.muted),
            ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🥺', style: TextStyle(fontSize: 56)),
            SizedBox(height: 12),
            Text(
              'Menu tidak ditemukan',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Coba kata kunci atau kategori lain ya.',
              style: TextStyle(color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}