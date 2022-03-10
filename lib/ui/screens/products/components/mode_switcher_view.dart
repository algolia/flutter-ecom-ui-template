import 'package:flutter/material.dart';

class ModeSwitcherView extends StatelessWidget {
  const ModeSwitcherView(
      {Key? key, required this.currentDisplay, this.onPressed})
      : super(key: key);

  final HitsDisplay currentDisplay;
  final Function(HitsDisplay)? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Display'),
        const SizedBox(width: 10),
        SizedBox(
          height: 20,
          width: 20,
          child: IconButton(
            splashRadius: 10,
            padding: const EdgeInsets.all(0.0),
            onPressed: () => onPressed?.call(HitsDisplay.grid),
            icon: Icon(Icons.grid_view,
                size: 20,
                color: HitsDisplay.grid == currentDisplay ? Colors.blue : null),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 20,
          width: 20,
          child: IconButton(
            splashRadius: 10,
            padding: const EdgeInsets.all(0.0),
            onPressed: () => onPressed?.call(HitsDisplay.list),
            icon: Icon(Icons.view_list,
                size: 20,
                color: HitsDisplay.list == currentDisplay ? Colors.blue : null),
          ),
        ),
      ],
    );
  }
}

enum HitsDisplay { list, grid }
