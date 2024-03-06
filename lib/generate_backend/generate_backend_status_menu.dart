import 'package:bladecreate/generate_backend/generate_backend_provider.dart';
import 'package:bladecreate/store/generate_remote_store.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:flutter/material.dart';
import 'package:animated_icon/animated_icon.dart';
import 'package:provider/provider.dart';

class ClusterStatusMenu extends StatefulWidget {
  const ClusterStatusMenu({super.key});

  @override
  State<ClusterStatusMenu> createState() => _ClusterStatusMenuState();
}

class _ClusterStatusMenuState extends State<ClusterStatusMenu> {
  Widget _buildStatusIcon(GenerateBackendStatus status, Function onTap) {
    // TODO: fix continueAnimation does not work
    if (status == GenerateBackendStatus.busy) {
      return AnimateIcon(
        height: 30,
        width: 30,
        onTap: onTap,
        iconType: IconType.continueAnimation,
        color: Colors.yellow,
        animateIcon: AnimateIcons.walk,
      );
    } else if (status == GenerateBackendStatus.idle) {
      return AnimateIcon(
        height: 30,
        width: 30,
        onTap: onTap,
        iconType: IconType.animatedOnHover,
        color: Colors.green,
        animateIcon: AnimateIcons.walk,
      );
    }
    return AnimateIcon(
      height: 30,
      width: 30,
      onTap: onTap,
      iconType: IconType.animatedOnHover,
      color: Colors.red,
      animateIcon: AnimateIcons.confused,
    );
  }

  Widget _buildConnectionStatus(WSStatus wsStatus) {
    if (wsStatus == WSStatus.connected) {
      return const Text("Connection Status: Connected");
    }
    return const Text("Connection Status: Disconnected");
  }

  Widget _buildWorkerItem(Worker w) {
    if (w.currentJob == null) {
      return Text("- ${w.uuid}: ${w.status} - Idle");
    }
    return Text("- ${w.uuid}: ${w.status} - Job ${w.currentJob}");
  }

  Widget _buildTaskItem(Generation t) {
    return Text("- ${t.uuid}: ${t.status}");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GenerateBackendProvider>(builder: (context, cr, child) {
      return MenuAnchor(
        builder:
            (BuildContext context, MenuController controller, Widget? child) {
          return _buildStatusIcon(cr.status, () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          });
        },
        menuChildren: [
          _buildConnectionStatus(cr.wsStatus),
          Text("Workers: ${cr.activeWorkers.length}"),
          ...cr.workers.map((w) => _buildWorkerItem(w)),
          Text("Active Tasks: ${cr.activeTasks.length}"),
          ...cr.activeTasks.map((t) => _buildTaskItem(t)),
        ],
      );
    });
  }
}
