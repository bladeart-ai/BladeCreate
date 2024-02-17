import 'package:bladecreate/project/project_provider.dart';
import 'package:bladecreate/cluster/cluster_status_dropdown.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LayerToolbar extends StatelessWidget {
  const LayerToolbar({super.key});

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
                p.addLayer(Layer(
                    uuid: uuid.v4(),
                    name: "name",
                    width: 100.0,
                    height: 100.0));
              },
              icon: const Icon(Icons.border_color),
            ),
            IconButton(
              onPressed: () {
                p.addLayer(Layer(
                    uuid: uuid.v4(),
                    name: "name",
                    x: 300.0,
                    y: 300.0,
                    width: 100.0,
                    height: 100.0));
              },
              icon: const Icon(Icons.border_color),
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
