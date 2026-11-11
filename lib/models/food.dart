/// Model data untuk satu menu makanan.
class Food {
  final String id;
  final String name; // nama makanan
  final String imageUrl; // gambar makanan (link internet atau path assets)
  final int price; // harga dalam Rupiah
  final String description; // deskripsi makanan

  // Data tambahan supaya tampilan lebih menarik
  final String category;
  final String emoji; // dipakai kalau gambar gagal dimuat
  final double rating;
  final int sold;
  final int prepMinutes; // lama penyajian (menit)
  final bool isSpicy;

  const Food({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.category,
    required this.emoji,
    required this.rating,
    required this.sold,
    required this.prepMinutes,
    this.isSpicy = false,
  });
}