import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';
import '../viewmodels/product_viewmodel.dart';

class ProductFormPage extends StatefulWidget {
  final ProductViewModel viewModel;
  final Product? product;

  const ProductFormPage({super.key, required this.viewModel, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _thumbnailController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    if (product != null) {
      _titleController.text = product.title;
      _priceController.text = product.price.toString();
      _stockController.text = product.stock.toString();
      _thumbnailController.text = product.thumbnail;
      _descriptionController.text = product.description;
      _categoryController.text = product.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _thumbnailController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final priceText = _priceController.text.trim();

    if (title.isEmpty || priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Título e preço são obrigatórios')),
      );
      return;
    }

    final parsedPrice = double.tryParse(priceText);
    if (parsedPrice == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preço inválido')));
      return;
    }

    final parsedStock = int.tryParse(_stockController.text.trim()) ?? 0;

    setState(() => _isSaving = true);

    final editedProduct = Product(
      id: widget.product?.id ?? 0,
      title: title,
      description: _descriptionController.text.trim(),
      category: _categoryController.text.trim(),
      price: parsedPrice,
      rating: widget.product?.rating ?? 0.0,
      stock: parsedStock,
      thumbnail: _thumbnailController.text.trim(),
    );

    try {
      if (widget.product == null) {
        await widget.viewModel.addProduct(editedProduct);
      } else {
        await widget.viewModel.updateProduct(editedProduct);
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Produto' : 'Novo Produto'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Salvar'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Preço'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Estoque'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _thumbnailController,
              decoration: const InputDecoration(
                labelText: 'URL da imagem (thumbnail)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Categoria'),
            ),
            if (isEditing) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Rating: ${widget.product!.rating.toStringAsFixed(2)} '
                  '(somente leitura)',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
