import 'package:flutter/material.dart';

import '../../core/session/session_controller.dart';
import '../../domain/repositories/product_repository.dart';
import '../viewmodels/product_viewmodel.dart';
import '../viewmodels/product state.dart';
import 'login_page.dart';
import 'product_detail_page.dart';
import 'product_form_page.dart';
import 'profile_page.dart';

class ProductPage extends StatefulWidget {
  final ProductViewModel viewModel;
  final ProductRepository repository;

  const ProductPage({
    super.key,
    required this.viewModel,
    required this.repository,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadProducts();
  }

  void _logout() {
    SessionController.instance.logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = SessionController.instance.user;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            if (user?.image.isNotEmpty == true)
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white24,
                backgroundImage: NetworkImage(user!.image),
                onBackgroundImageError: (_, _) {},
              )
            else
              const CircleAvatar(
                radius: 16,
                child: Icon(Icons.person, size: 18),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                user != null
                    ? 'Olá, ${user.firstName}'
                    : 'Products',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Novo produto',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductFormPage(viewModel: widget.viewModel),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Perfil',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: _logout,
          ),
        ],
      ),
      body: ValueListenableBuilder<ProductState>(
        valueListenable: widget.viewModel.state,
        builder: (context, state, _) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text(state.error!));
          }
          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return ListTile(
                leading: SizedBox(
                  width: 48,
                  height: 48,
                  child: Image.network(
                    product.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
                title: Text(product.title),
                subtitle: Text(
                  'R\$ ${product.price.toStringAsFixed(2)} | '
                  'Estoque: ${product.stock}',
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailPage(
                      productId: product.id,
                      repository: widget.repository,
                    ),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductFormPage(
                            viewModel: widget.viewModel,
                            product: product,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: const Text('Confirmar exclusão'),
                              content: const Text(
                                'Deseja excluir este produto?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(dialogContext, false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(dialogContext, true),
                                  child: const Text('Excluir'),
                                ),
                              ],
                            );
                          },
                        );

                        if (shouldDelete == true) {
                          await widget.viewModel.deleteProduct(product.id);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.viewModel.loadProducts,
        child: const Icon(Icons.download),
      ),
    );
  }
}
