import 'package:flutter/material.dart';

import '../../app_theme.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({Key? key}) : super(key: key);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Filter & Sort",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
            Row(
              children: [
                const Text(
                  "Sort",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.add))
              ],
            ),
            Row(
              children: [
                const Text(
                  "Category",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.add))
              ],
            ),
            Row(
              children: [
                const Text(
                  "Brand",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.add))
              ],
            ),
            Row(
              children: [
                const Text(
                  "Colours",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.add))
              ],
            ),
            Row(
              children: [
                const Text(
                  "Size",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.add))
              ],
            ),
            Row(
              children: [
                const Text(
                  "Materials",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.add))
              ],
            ),
            Row(
              children: [
                const Text(
                  "Price",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.add))
              ],
            ),
            Row(
              children: [
                const Spacer(),
                OutlinedButton(
                    onPressed: () => {},
                    style: OutlinedButton.styleFrom(
                      primary: AppTheme.darkBlue,
                      side: const BorderSide(
                          width: 1.0,
                          color: AppTheme.darkBlue,
                          style: BorderStyle.solid),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Clear Filters"),
                        ])),
                const Spacer(),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: AppTheme.darkBlue),
                    onPressed: () => {},
                    child: const Text("See 37 Products")),
                const Spacer(),
              ],
            )
          ],
        ));
  }
}
