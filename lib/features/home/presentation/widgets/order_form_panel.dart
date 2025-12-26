import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'service_tab.dart';

/// 订单表单面板：包含服务选择、描述输入、AI估价和发布按钮
class OrderFormPanel extends StatelessWidget {
  final int selectedServiceIndex;
  final TextEditingController descController;
  final double price;
  final bool isAnalyzing;
  final bool hasPhoto;
  
  final Function(int) onServiceSelected;
  final VoidCallback onAnalyze;
  final Function(double) onPriceChanged;
  final VoidCallback onPhotoToggle;
  final VoidCallback onSubmit;

  const OrderFormPanel({
    super.key,
    required this.selectedServiceIndex,
    required this.descController,
    required this.price,
    required this.isAnalyzing,
    required this.hasPhoto,
    required this.onServiceSelected,
    required this.onAnalyze,
    required this.onPriceChanged,
    required this.onPhotoToggle,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 服务类型选择
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ServiceTab(
                icon: Icons.inventory_2_rounded,
                label: '帮我搬',
                isSelected: selectedServiceIndex == 0,
                onTap: () => onServiceSelected(0),
              ),
              const SizedBox(width: 12),
              ServiceTab(
                icon: Icons.shopping_cart_rounded,
                label: '帮我买',
                isSelected: selectedServiceIndex == 1,
                onTap: () => onServiceSelected(1),
              ),
              const SizedBox(width: 12),
              ServiceTab(
                icon: Icons.cleaning_services_rounded,
                label: '临时工',
                isSelected: selectedServiceIndex == 2,
                onTap: () => onServiceSelected(2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 描述输入框 + 拍照按钮
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: descController,
                      maxLines: 3,
                      minLines: 2,
                      decoration: const InputDecoration.collapsed(
                        hintText: '描述您的需求，例如：搬运两个大箱子到5楼...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  // 拍照按钮
                  InkWell(
                    onTap: onPhotoToggle,
                    child: Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        image: hasPhoto 
                          ? const DecorationImage(image: NetworkImage('https://via.placeholder.com/150'), fit: BoxFit.cover)
                          : null,
                      ),
                      child: hasPhoto 
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt, color: Colors.grey, size: 24),
                                Text('拍照', style: TextStyle(fontSize: 10, color: Colors.grey)),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),

        // AI 估价区域
        Row(
          children: [
            // AI 按钮
            InkWell(
              onTap: isAnalyzing ? null : onAnalyze,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.purple.shade100, Colors.blue.shade100]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: Row(
                  children: [
                    if (isAnalyzing)
                       const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2))
                    else
                       const Icon(Icons.auto_awesome, size: 16, color: Colors.purple),
                    const SizedBox(width: 4),
                    Text(isAnalyzing ? '分析中...' : 'AI 估价', style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // 价格显示与调节
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => onPriceChanged(math.max(10, price - 5)),
            ),
            Text(
              '¥${price.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => onPriceChanged(price + 5),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // 发布按钮
        ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('发布需求', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ],
    );
  }
}
