import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/product_controller.dart';
import '../../core/theme.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../widgets/custom_textfield.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.accentColor,
          tabs: const [
            Tab(text: 'Products'),
            Tab(text: 'Categories'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthController>().logout(),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _ProductsTab(),
          _CategoriesTab(),
        ],
      ),
    );
  }
}

// ── Products tab ──────────────────────────────────────────────────────────────

class _ProductsTab extends StatefulWidget {
  const _ProductsTab();

  @override
  State<_ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<_ProductsTab> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  String? _category;
  bool _seeding = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _seedProducts() async {
    setState(() => _seeding = true);
    final ok = await context.read<ProductController>().seedSampleProducts();
    if (!mounted) return;
    setState(() => _seeding = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? '5 sample products loaded!' : 'Seed failed. Check Firestore.',
        ),
      ),
    );
  }

  Future<bool> _saveProduct({ProductModel? existing}) async {
    if (!_formKey.currentState!.validate()) return false;
    if (_category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a category first')),
      );
      return false;
    }

    final controller = context.read<ProductController>();
    final product = ProductModel(
      id: existing?.id ?? '',
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      category: _category!,
      imageUrl: _imageController.text.trim(),
    );

    final ok = existing == null
        ? await controller.addProduct(product)
        : await controller.updateProduct(product);

    if (!mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? (existing == null ? 'Product added!' : 'Product updated!')
            : 'Operation failed'),
      ),
    );
    if (ok && existing == null) {
      _nameController.clear();
      _descController.clear();
      _priceController.clear();
      _imageController.clear();
    }
    return ok;
  }

  void _clearForm() {
    _nameController.clear();
    _descController.clear();
    _priceController.clear();
    _imageController.clear();
    setState(() => _category = null);
  }

  Future<void> _showProductDialog({ProductModel? product}) async {
    if (product != null) {
      _nameController.text = product.name;
      _descController.text = product.description;
      _priceController.text = product.price.toString();
      _imageController.text = product.imageUrl;
      _category = product.category;
    } else {
      _clearForm();
    }

    final names = context.read<ProductController>().shopCategoryNames;
    if (names.isNotEmpty && (_category == null || !names.contains(_category))) {
      _category = names.first;
    }

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(product == null ? 'Add Product' : 'Edit Product'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    label: 'Name',
                    hint: 'Product name',
                    controller: _nameController,
                    validator: (v) =>
                        v != null && v.isNotEmpty ? null : 'Required',
                  ),
                  CustomTextField(
                    label: 'Description',
                    hint: 'Description',
                    controller: _descController,
                    validator: (v) =>
                        v != null && v.isNotEmpty ? null : 'Required',
                  ),
                  CustomTextField(
                    label: 'Price',
                    hint: '99.99',
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (double.tryParse(v) == null) return 'Invalid number';
                      return null;
                    },
                  ),
                  CustomTextField(
                    label: 'Image URL',
                    hint: 'https://...',
                    controller: _imageController,
                    validator: (v) =>
                        v != null && v.isNotEmpty ? null : 'Required',
                  ),
                  if (names.isEmpty)
                    const Text('Add a category first')
                  else
                    DropdownButtonFormField<String>(
                      initialValue: _category,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: names
                          .map((c) =>
                              DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setDialogState(() => _category = v),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clearForm();
                Navigator.pop(ctx);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final ok = await _saveProduct(existing: product);
                if (ok && ctx.mounted) {
                  _clearForm();
                  Navigator.pop(ctx);
                }
              },
              child: Text(product == null ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );
    _clearForm();
  }

  Future<void> _confirmDeleteProduct(ProductModel product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete product?'),
        content: Text('Remove "${product.name}" from the store?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    final ok =
        await context.read<ProductController>().deleteProduct(product.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'Product deleted' : 'Delete failed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProductController>();
    final products = controller.products;
    final categoryNames = controller.shopCategoryNames;

    if (_category == null && categoryNames.isNotEmpty) {
      _category = categoryNames.first;
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: categoryNames.isEmpty
                    ? null
                    : () => _showProductDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add Product'),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: _seeding ? null : _seedProducts,
              child: _seeding
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Seed 5'),
            ),
          ],
        ),
        if (categoryNames.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'Add categories in the Categories tab first.',
              style: TextStyle(color: Colors.orange.shade800),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          'Products (${products.length})',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (products.isEmpty)
          const Text('No products yet.')
        else
          ...products.map(
            (p) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(p.name),
                subtitle: Text('${p.category} • \$${p.price.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _showProductDialog(product: p),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: AppTheme.errorColor),
                      onPressed: () => _confirmDeleteProduct(p),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Categories tab ──────────────────────────────────────────────────────────

class _CategoriesTab extends StatefulWidget {
  const _CategoriesTab();

  @override
  State<_CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<_CategoriesTab> {
  final _nameController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _addCategory() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _saving = true);
    final ok = await context.read<ProductController>().addCategory(name);
    if (!mounted) return;
    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'Category added' : 'Failed to add')),
    );
    if (ok) _nameController.clear();
  }

  Future<void> _showEditCategoryDialog(CategoryModel category) async {
    final editController = TextEditingController(text: category.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Category'),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(labelText: 'Category name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(ctx, editController.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    editController.dispose();

    if (newName == null || newName.isEmpty || newName == category.name) return;
    if (!mounted) return;

    setState(() => _saving = true);
    final ok = await context
        .read<ProductController>()
        .updateCategory(category, newName);
    if (!mounted) return;
    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Category updated (products updated too)' : 'Update failed',
        ),
      ),
    );
  }

  Future<void> _confirmDeleteCategory(CategoryModel category) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete category?'),
        content: Text('Remove "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    setState(() => _saving = true);
    final error =
        await context.read<ProductController>().deleteCategory(category);
    if (!mounted) return;
    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'Category deleted'),
        backgroundColor: error != null ? AppTheme.errorColor : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<ProductController>().categories;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Manage Categories',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Shop filters use these categories. Rename updates all products in that category.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'New category name',
                  hintText: 'e.g. Kids',
                ),
              ),
            ),
            const SizedBox(width: 8),
            _saving
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton.filled(
                    onPressed: _addCategory,
                    icon: const Icon(Icons.add),
                  ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Categories (${categories.length})',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (categories.isEmpty)
          const Text('No categories yet.')
        else
          ...categories.map(
            (c) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.accentColor.withValues(alpha: 0.3),
                  child: Text(
                    c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(c.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: _saving
                          ? null
                          : () => _showEditCategoryDialog(c),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: AppTheme.errorColor),
                      onPressed:
                          _saving ? null : () => _confirmDeleteCategory(c),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
