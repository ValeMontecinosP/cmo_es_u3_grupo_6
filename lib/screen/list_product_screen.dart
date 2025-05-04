import 'package:flutter/material.dart';
import 'package:flutter_application_3/providers/cart_provider.dart';
import 'package:flutter_application_3/screen/cart_screen.dart';
import 'package:flutter_application_3/screen/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_3/models/productos.dart';
import 'package:flutter_application_3/widgets/product_card.dart';
import 'package:flutter_application_3/services/product_service.dart';

class ListProductScreen extends StatefulWidget {
  const ListProductScreen({super.key});

  @override
  State<ListProductScreen> createState() => _ListProductScreenState();
}

class _ListProductScreenState extends State<ListProductScreen> {
  List<Listado> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final productService = Provider.of<ProductService>(context, listen: false);
    _filteredProducts = productService.products;
  }

  void _filterProducts(String query, List<Listado> allProducts) {
    final filtered = allProducts.where((product) {
      final nameLower = product.productName.toLowerCase();
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    setState(() {
      _filteredProducts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    if (productService.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de productos'),
        actions: [
          Consumer<CartProvider>(
            builder: (_, cart, __) => Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                     Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const CartScreen()),
                     );
                  },
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                _filterProducts(value, productService.products);
              },
            ),
          ),
          Expanded(
            child: _filteredProducts.isNotEmpty
                ? ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (BuildContext context, index) {
                      final product = _filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          productService.SelectProduct = product.copy();
                          Navigator.pushNamed(context, 'edit');
                        },
                        child: ProductCard(
                          product: product,
                          trailing: IconButton(
                            icon: const Icon(Icons.add_shopping_cart),
                            onPressed: () {
                              Provider.of<CartProvider>(context, listen: false)
                                  .addItem();
                            },
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text('No se encontraron productos'),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          productService.SelectProduct = Listado(
            productId: 0,
            productName: '',
            productPrice: 0,
            productImage:
                'https://abravidro.org.br/wp-content/uploads/2015/04/sem-imagem4.jpg',
            productState: '',
          );
          Navigator.pushNamed(context, 'edit');
        },
      ),
    );
  }
}
