import 'package:bladecreate/project/project_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GenerateToolbar extends StatelessWidget {
  const GenerateToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, model, child) => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.auto_fix_high),
          ),
        ],
      ),
    );
  }
}
