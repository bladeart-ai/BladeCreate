import 'dart:ui';

import 'package:bladecreate/canvas/canvas_stack_provider.dart';
import 'package:bladecreate/project/project_provider.dart';
import 'package:bladecreate/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LayerListMenu extends StatefulWidget {
  const LayerListMenu({super.key});

  @override
  State<LayerListMenu> createState() => _GenerateToolbarState();
}

class _GenerateToolbarState extends State<LayerListMenu> {
  @override
  Widget build(BuildContext context) {
    Widget proxyDecorator(
        Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double elevation = lerpDouble(0, 6, animValue)!;

          return Material(
            elevation: elevation,
            color: AppStyle.primaryLighter,
            shadowColor: AppStyle.shadow,
            child: child,
          );
        },
        child: child,
      );
    }

    return Consumer2<CanvasStackProvider, ProjectProvider>(
      builder: (context, p, pp, child) => MenuAnchor(
        builder: (context, controller, child) {
          return IconButton(
            onPressed: () => setState(() {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            }),
            style: controller.isOpen
                ? const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        AppStyle.primaryLightest))
                : null,
            icon: const Icon(Icons.layers_outlined),
          );
        },
        menuChildren: [
          SizedBox(
            width: 300,
            height: 300,
            child: ReorderableListView(
              buildDefaultDragHandles: false,
              shrinkWrap: true,
              proxyDecorator: proxyDecorator,
              children: pp.orderedLayers.toList().indexed.map<Widget>((e) {
                final ix = e.$1;
                final l = e.$2;
                return ReorderableDragStartListener(
                    key: Key(l.uuid),
                    index: ix,
                    child: ListTile(
                      dense: true,
                      title: Text(
                        l.name,
                        softWrap: true,
                        style: AppStyle.smallText,
                      ),
                      tileColor: p.selectedLayerUUID == l.uuid
                          ? AppStyle.primaryLighter
                          : AppStyle.backgroundWithOpacity,
                      onTap: () => p.select(l),
                    ));
              }).toList(),
              onReorder: (int oldIndex, int newIndex) =>
                  pp.reorderLayer(oldIndex, newIndex),
            ),
          ),
        ],
      ),
    );
  }
}
