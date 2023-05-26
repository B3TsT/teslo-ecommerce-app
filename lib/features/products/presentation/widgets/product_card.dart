import 'package:flutter/material.dart';

import '../../domain/domain.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ImageViewer(images: product.images),
        Text(
          product.title,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _ImageViewer extends StatelessWidget {
  const _ImageViewer({required this.images});
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/no-image.jpg',
          fit: BoxFit.cover,
          height: 250,
          // width: double.infinity,
        ),
      );
    }
    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FadeInImage(
          height: 250,
          fit: BoxFit.cover,
          fadeOutDuration: const Duration(milliseconds: 100),
          image: NetworkImage(images.first),
          placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
          // width: double.infinity,
        ));
  }
}
