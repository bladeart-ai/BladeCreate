import 'package:bladecreate/project/project_provider.dart';
import 'package:bladecreate/project/layer/adaptive_text.dart';
import 'package:bladecreate/project/layer/layer.dart';
import 'package:bladecreate/cluster/cluster_status_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectToolbar extends StatelessWidget {
  const ProjectToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, p, child) => Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
              Text(p.project.name),
            ]),
          ),
          Expanded(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.layers),
            ),
            IconButton(
              onPressed: () {
                p.addLayer(const AdaptiveText(
                  'Flutter Candies',
                  tapToEdit: true,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ));
              },
              icon: const Icon(Icons.border_color),
            ),
            IconButton(
              onPressed: () {
                p.addLayer(LayerModel(
                  child: Image.network(
                      'https://avatars.githubusercontent.com/u/47586449?s=200&v=4'),
                ));
              },
              icon: const Icon(Icons.image),
            ),
          ])),
          Expanded(
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            const ClusterStatusDropdown(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.manage_accounts),
            )
          ]))
        ],
      ),
    );
  }
}
