import 'package:flutter/material.dart';
import '../../domain/order_model.dart';

class OrderInfoSection extends StatelessWidget {
  final Order order;

  const OrderInfoSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题与价格
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                order.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '¥${order.price}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.red),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          order.description,
          style: TextStyle(color: Colors.grey[700], height: 1.5),
        ),
        const SizedBox(height: 24),
        
        // 地址信息
        _buildAddressItem(Icons.circle, Colors.green, order.startLocation, '距离当前位置 0.5km'),
        Padding(
          padding: const EdgeInsets.only(left: 11),
          child: Container(height: 20, width: 1, color: Colors.grey[300]),
        ),
        _buildAddressItem(Icons.circle, Colors.orange, order.endLocation, '距离起点 3.2km'),
        
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        
        // 雇主信息
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026024d'),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('张先生', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('信用分 780 | 已发 12 单', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            IconButton.filled(
              onPressed: () {},
              icon: const Icon(Icons.message),
              style: IconButton.styleFrom(backgroundColor: Colors.blue.shade50, foregroundColor: Colors.blue),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: () {},
              icon: const Icon(Icons.phone),
              style: IconButton.styleFrom(backgroundColor: Colors.green.shade50, foregroundColor: Colors.green),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddressItem(IconData icon, Color color, String address, String sub) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(address, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(sub, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.navigation_rounded, color: Colors.blue),
          iconSize: 20,
        )
      ],
    );
  }
}
