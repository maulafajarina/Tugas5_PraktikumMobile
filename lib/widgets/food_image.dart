import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../models/food.dart';
import '../utils/app_style.dart';

/// Menampilkan gambar makanan (dari link internet atau dari folder assets).
/// Selama loading tampil indikator, dan kalau gagal tampil emoji makanannya.
class FoodImage extends StatelessWidget {
  final Food food;
  final BoxFit fit;
  final double emojiSize;

  const FoodImage({
    super.key,
    required this.food,
    this.fit = BoxFit.cover,
    this.emojiSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    final url = food.imageUrl;

    // Gambar dari internet
    if (url.startsWith('http')) {
      return Image.network(
        url,
        key: ValueKey(url),
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        // Wikimedia meminta User-Agent yang jelas (tidak berlaku di web)
        headers: kIsWeb
            ? null
            : const {'User-Agent': 'Tugas5FoodApp/1.0 (Flutter; tugas kuliah)'},
        // Supaya gambar dari situs lain tetap tampil di Flutter Web (Chrome/Edge)
        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _placeholder(loading: true);
        },
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    // Gambar dari folder assets
    return Image.asset(
      url,
      key: ValueKey(url),
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => _placeholder(),
    );
  }

  Widget _placeholder({bool loading = false}) {
    return Container(
      color: AppColors.soft,
      alignment: Alignment.center,
      child: loading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            )
          : Text(food.emoji, style: TextStyle(fontSize: emojiSize)),
    );
  }
}