import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product_model.dart';

class CartPage extends StatelessWidget {
  final List<ProductModel> items;
  final ValueChanged<int> onRemoveItem;

  const CartPage({super.key, required this.items, required this.onRemoveItem});

  double _parsePrice(String value) {
    final raw = value.replaceAll(RegExp(r'[^0-9,\.]'), '');
    if (raw.isEmpty) return 0;

    final normalized = raw.replaceAll(',', '.');
    final parts = normalized.split('.');

    if (parts.length <= 2) {
      return double.tryParse(normalized) ?? 0;
    }

    final decimalPart = parts.removeLast();
    final integerPart = parts.join();
    return double.tryParse('$integerPart.$decimalPart') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final total = items.fold<double>(
      0,
      (sum, item) => sum + _parsePrice(item.price),
    );

    final currency = items.isNotEmpty ? items.first.currency : 'TL';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sepetim',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: items.isEmpty
                  ? const Center(child: Text('Sepetiniz boş'))
                  : ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 56,
                                height: 56,
                                color: Colors.grey.shade100,
                                child: Image.network(
                                  item.image,
                                  fit: BoxFit.contain,
                                  webHtmlElementStrategy:
                                      WebHtmlElementStrategy.prefer,
                                    errorBuilder: (_, _, _) =>
                                      const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                            title: Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text('${item.price} ${item.currency}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => onRemoveItem(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Toplam',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${total.toStringAsFixed(2)} $currency',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
}
