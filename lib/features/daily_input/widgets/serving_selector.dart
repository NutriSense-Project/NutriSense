import 'package:flutter/material.dart';
import '../../../data/models/food_groups.dart';

class ServingSelectorBottomSheet extends StatefulWidget {
  final FoodGroup group;
  final int currentServings;
  final ValueChanged<int> onChanged;

  const ServingSelectorBottomSheet({
    super.key,
    required this.group,
    required this.currentServings,
    required this.onChanged,
  });

  @override
  State<ServingSelectorBottomSheet> createState() => _ServingSelectorBottomSheetState();
}

class _ServingSelectorBottomSheetState extends State<ServingSelectorBottomSheet> {
  late int _selectedServings;

  @override
  void initState() {
    super.initState();
    _selectedServings = widget.currentServings;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.group.emoji, style: const TextStyle(fontSize: 64)),
          Text(
            widget.group.name,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          Text(
            widget.group.servingHint,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [0, 1, 2, 3, 4].map((count) {
              final isSelected = _selectedServings == count;
              return ChoiceChip(
                label: Text(count == 4 ? '4+' : count.toString()),
                selected: isSelected,
                selectedColor: Theme.of(context).colorScheme.primaryContainer,
                labelStyle: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : null,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (_) {
                  setState(() {
                    _selectedServings = count;
                  });
                  widget.onChanged(count);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          if (_selectedServings > 0)
            TextButton.icon(
              onPressed: () {
                setState(() => _selectedServings = 0);
                widget.onChanged(0);
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text("Remove"),
            ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}