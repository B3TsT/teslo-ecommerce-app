import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/shared/shared.dart';

import '../../../shared/infrastructure/services/camara_gallery_service_impl.dart';
import '../../domain/domain.dart';
import '../providers/providers.dart';

class ProductScreen extends ConsumerWidget {
  const ProductScreen({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productProvider(productId));

    void showSnackBar(BuildContext context, {String? message}) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? 'Producto actualizado')),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: (productState.id == 'new')
              ? const Text('Crear producto')
              : const Text('Editar producto'),
          actions: [
            IconButton(
              onPressed: () async {
                final photoPath =
                    await CamaraGalleryServiceImpl().selectPhoto();
                if (photoPath == null) return;
                photoPath;
              },
              icon: const Icon(Icons.photo_library_outlined),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt_outlined),
            ),
          ],
        ),
        body: productState.isLoading
            ? const FullScreenLoader()
            : _ProductView(product: productState.product!),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (productState.product == null) return;

            ref
                .read(productFormProvider(productState.product!).notifier)
                .onFormSubmit()
                .then((value) {
              if (!value) return;
              (productState.id == 'new')
                  ? showSnackBar(context, message: 'Producto creado')
                  : showSnackBar(context);
            });
          },
          child: const Icon(Icons.save_outlined),
        ),
      ),
    );
  }
}

class _ProductView extends ConsumerWidget {
  const _ProductView({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context).textTheme;
    final productForm = ref.watch(productFormProvider(product));
    return ListView(
      children: [
        SizedBox(
          height: 250,
          width: 600,
          child: _ImageGallery(images: productForm.images),
        ),
        const SizedBox(height: 10),
        Text(
          productForm.title.value,
          style: textStyle.titleSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        _ProductInformation(product: product),
      ],
    );
  }
}

class _ProductInformation extends ConsumerWidget {
  const _ProductInformation({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productForm = ref.watch(productFormProvider(product));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generales'),
          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Nombre',
            initialValue: productForm.title.value,
            onChanged:
                ref.read(productFormProvider(product).notifier).onTitleChanged,
            errorMessage: productForm.title.errorMessage,
          ),
          CustomProductField(
            label: 'Slug',
            initialValue: productForm.slug.value,
            onChanged:
                ref.read(productFormProvider(product).notifier).onSlugChanged,
            errorMessage: productForm.slug.errorMessage,
          ),
          CustomProductField(
            isBottomField: true,
            label: 'Precio',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productForm.price.value.toString(),
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onPriceChanged(double.tryParse(value) ?? -1),
            errorMessage: productForm.price.errorMessage,
          ),
          const SizedBox(height: 15),
          const Text('Extras'),
          _SizeSelector(
            selectedSizes: productForm.sizes,
            onSizeChanged:
                ref.read(productFormProvider(product).notifier).onSizeChanged,
          ),
          const SizedBox(height: 5),
          _GenderSelector(
            selectedGender: productForm.gender,
            onGenderChanged:
                ref.read(productFormProvider(product).notifier).onGenderChanged,
          ),
          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Existencias',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productForm.inStock.value.toString(),
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onStockChanged(int.tryParse(value) ?? -1),
            errorMessage: productForm.inStock.errorMessage,
          ),
          CustomProductField(
            maxLines: 6,
            label: 'Descripción',
            keyboardType: TextInputType.multiline,
            initialValue: product.description,
            onChanged: ref
                .read(productFormProvider(product).notifier)
                .onDescriptionChanged,
          ),
          CustomProductField(
              isBottomField: true,
              maxLines: 2,
              label: 'Tags (separados por coma)',
              keyboardType: TextInputType.multiline,
              initialValue: product.tags.join(', '),
              onChanged: ref
                  .read(productFormProvider(product).notifier)
                  .onTagsChanged),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _GenderSelector extends StatelessWidget {
  const _GenderSelector(
      {required this.selectedGender, required this.onGenderChanged});
  final String selectedGender;
  final void Function(String selectedGender) onGenderChanged;
  final List<String> genders = const ['men', 'women', 'kid'];
  final List<IconData> genderIcons = const [
    Icons.man,
    Icons.woman,
    Icons.boy,
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
          multiSelectionEnabled: false,
          showSelectedIcon: false,
          style: const ButtonStyle(visualDensity: VisualDensity.compact),
          segments: genders
              .map(
                (gender) => ButtonSegment(
                    icon: Icon(genderIcons[genders.indexOf(gender)]),
                    value: gender,
                    label: Text(
                      gender,
                      style: const TextStyle(fontSize: 12),
                    )),
              )
              .toList(),
          selected: {selectedGender},
          onSelectionChanged: (newSelection) {
            FocusScope.of(context).unfocus();
            onGenderChanged(newSelection.first);
          }),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  const _SizeSelector(
      {required this.selectedSizes, required this.onSizeChanged});
  final List<String> selectedSizes;
  final List<String> sizes = const ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final void Function(List<String> selectedSized) onSizeChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      showSelectedIcon: false,
      emptySelectionAllowed: true,
      segments: sizes
          .map((size) => ButtonSegment(
                value: size,
                label: Text(size, style: const TextStyle(fontSize: 10)),
              ))
          .toList(),
      selected: Set.from(selectedSizes),
      onSelectionChanged: (newSelection) {
        FocusScope.of(context).unfocus();
        onSizeChanged(List.from(newSelection));
      },
      multiSelectionEnabled: true,
    );
  }
}

class _ImageGallery extends StatelessWidget {
  const _ImageGallery({required this.images});

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(viewportFraction: 0.7),
      children: images.isEmpty
          ? [
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/no-image.jpg',
                    fit: BoxFit.cover,
                  )),
            ]
          : images
              .map(
                (e) => ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    e,
                    fit: BoxFit.cover,
                  ),
                ),
              )
              .toList(),
    );
  }
}
