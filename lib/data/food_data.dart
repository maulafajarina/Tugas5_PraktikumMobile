import '../models/food.dart';

/// Daftar kategori untuk filter di halaman utama: (nama, emoji).
const List<(String, String)> categories = [
  ('Semua', '🍽️'),
  ('Makanan Berat', '🍛'),
  ('Berkuah', '🍜'),
  ('Jajanan', '🥞'),
  ('Minuman', '🧋'),
];

/// Data dummy menu makanan.
/// Gambar diambil dari Wikimedia Commons (lisensi bebas / Creative Commons).
/// Mau ganti gambar? Cukup paste link foto lain ke imageUrl.
const List<Food> foodList = [
  Food(
    id: 'f01',
    name: 'Nasi Goreng Spesial',
    imageUrl:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Nasi_goreng_indonesia.jpg?width=600',
    price: 25000,
    description:
        'Nasi goreng bumbu rumahan yang dimasak di atas wajan panas sampai '
        'harum, lengkap dengan telur mata sapi, suwiran ayam, kerupuk udang, '
        'dan acar timun. Rasa gurih manisnya pas, cocok untuk makan siang '
        'maupun makan malam.',
    category: 'Makanan Berat',
    emoji: '🍳',
    rating: 4.8,
    sold: 1520,
    prepMinutes: 15,
  ),
  Food(
    id: 'f02',
    name: 'Rendang Daging',
    imageUrl:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Rendang_daging_sapi_asli_Padang.JPG?width=600',
    price: 38000,
    description:
        'Daging sapi pilihan yang dimasak perlahan berjam-jam dalam santan dan '
        'rempah khas Minang hingga bumbunya meresap sampai ke serat daging. '
        'Disajikan dengan nasi putih hangat, daun singkong, dan sambal hijau.',
    category: 'Makanan Berat',
    emoji: '🍛',
    rating: 4.9,
    sold: 980,
    prepMinutes: 10,
    isSpicy: true,
  ),
  Food(
    id: 'f03',
    name: 'Sate Ayam Madura',
    imageUrl:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Sate_ayam_madura.jpg?width=600',
    price: 28000,
    description:
        'Sepuluh tusuk sate ayam yang dibakar di atas arang sampai sedikit '
        'gosong di pinggirnya, lalu disiram bumbu kacang kental dan kecap '
        'manis. Ditemani lontong, irisan bawang merah, dan cabai rawit.',
    category: 'Makanan Berat',
    emoji: '🍢',
    rating: 4.8,
    sold: 1340,
    prepMinutes: 20,
  ),
  Food(
    id: 'f04',
    name: 'Gado-Gado Betawi',
    imageUrl:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Gado-gado_in_Jakarta.JPG?width=600',
    price: 18000,
    description:
        'Sayuran rebus segar seperti kangkung, tauge, kol, dan kacang panjang, '
        'ditambah tahu, tempe, telur rebus, dan lontong. Semuanya disiram '
        'saus kacang yang diulek langsung, level pedasnya bisa diatur.',
    category: 'Makanan Berat',
    emoji: '🥗',
    rating: 4.5,
    sold: 640,
    prepMinutes: 10,
  ),
  Food(
    id: 'f05',
    name: 'Bakso Urat Komplit',
    imageUrl:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Bakso_mi_bihun.jpg?width=600',
    price: 22000,
    description:
        'Semangkuk bakso urat kenyal dengan kuah kaldu sapi bening yang '
        'gurih. Isinya lengkap: mi kuning, bihun, sawi, tahu, dan pangsit '
        'goreng, ditaburi bawang goreng serta seledri.',
    category: 'Berkuah',
    emoji: '🍲',
    rating: 4.7,
    sold: 2100,
    prepMinutes: 10,
  ),
  Food(
    id: 'f06',
    name: 'Mie Ayam Pangsit',
    imageUrl:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Jakarta_Ayam_Kampung-style_Mie_Ayam.jpg?width=600',
    price: 20000,
    description:
        'Mi kuning buatan sendiri yang lembut, diberi topping ayam kecap '
        'berbumbu, jamur, dan sawi hijau. Disajikan bersama kuah kaldu ayam '
        'terpisah dan pangsit rebus yang lembut.',
    category: 'Berkuah',
    emoji: '🍜',
    rating: 4.6,
    sold: 1870,
    prepMinutes: 12,
  ),
  Food(
    id: 'f07',
    name: 'Soto Ayam Kuning',
    imageUrl:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Soto_Ayam_home-made.JPG?width=600',
    price: 21000,
    description:
        'Soto ayam berkuah kuning dari kunyit dan rempah, berisi suwiran ayam, '
        'bihun, tauge, telur rebus, dan perkedel kentang. Hangat dan '
        'menyegarkan, paling nikmat ditambah perasan jeruk nipis dan sambal.',
    category: 'Berkuah',
    emoji: '🥣',
    rating: 4.7,
    sold: 760,
    prepMinutes: 12,
  ),
  Food(
    id: 'f08',
    name: 'Martabak Manis Cokelat Keju',
    imageUrl:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Martabak_manis_Indonesia.jpg?width=600',
    price: 45000,
    description:
        'Martabak manis tebal dengan pinggiran renyah dan bagian dalam yang '
        'berserat lembut. Diolesi mentega lalu diberi topping meses cokelat, '
        'parutan keju, dan susu kental manis yang melimpah.',
    category: 'Jajanan',
    emoji: '🥞',
    rating: 4.9,
    sold: 1150,
    prepMinutes: 20,
  ),
  Food(
    id: 'f09',
    name: 'Pisang Goreng Crispy',
    imageUrl:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Pisang_goreng_fried_banana.JPG?width=600',
    price: 12000,
    description:
        'Lima potong pisang kepok matang yang dibalut adonan tepung renyah '
        'lalu digoreng sampai keemasan. Manis di dalam, kriuk di luar, pas '
        'banget jadi teman minum teh atau kopi sore hari.',
    category: 'Jajanan',
    emoji: '🍌',
    rating: 4.5,
    sold: 2300,
    prepMinutes: 8,
  ),
  Food(
    id: 'f10',
    name: 'Es Cendol Gula Aren',
    imageUrl:
        'https://commons.wikimedia.org/wiki/Special:FilePath/Cendol_in_a_Glass.JPG?width=600',
    price: 10000,
    description:
        'Cendol hijau dari tepung beras dan daun pandan, disajikan dengan '
        'santan gurih, sirup gula aren asli, dan es serut. Segar, manis, '
        'dan wangi pandan, cocok menemani cuaca yang panas.',
    category: 'Minuman',
    emoji: '🍧',
    rating: 4.8,
    sold: 3050,
    prepMinutes: 5,
  ),
];