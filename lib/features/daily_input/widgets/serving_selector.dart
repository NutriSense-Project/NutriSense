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
  int _selectedServings = 1;

  @override
  void initState() {
    super.initState();
    _selectedServings = widget.currentServings > 0 ? widget.currentServings : 1;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.group.emoji, style: const TextStyle(fontSize: 64)),
          Text(
            widget.group.name,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          Text(widget.group.servingHint),
          const SizedBox(height: 32),

          Text(
            "$_selectedServings serving${_selectedServings > 1 ? 's' : ''}",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          Slider(
            value: _selectedServings.toDouble(),
            min: 0,
            max: 10,
            divisions: 10,
            label: _selectedServings.toString(),
            onChanged: (value) {
              setState(() => _selectedServings = value.round());
            },
          ),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("0"),
              Text("10"),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              FilledButton(
                onPressed: () {
                  widget.onChanged(_selectedServings);
                  Navigator.pop(context);
                },
                child: const Text("Confirm"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}