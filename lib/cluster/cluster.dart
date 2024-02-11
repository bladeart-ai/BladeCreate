import 'package:bladecreate/cluster/cluster_repo.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:flutter/material.dart';
import 'package:animated_icon/animated_icon.dart';
import 'package:provider/provider.dart';

class ClusterStatusDropdown extends StatelessWidget {
  const ClusterStatusDropdown({super.key});

  Widget _buildStatusIcon(ClusterStatus status, Function onTap) {
    if (status == ClusterStatus.busy) {
      return AnimateIcon(
        onTap: onTap,
        iconType: IconType.continueAnimation,
        color: Colors.green,
        animateIcon: AnimateIcons.walk,
      );
    } else if (status == ClusterStatus.idle) {
      return AnimateIcon(
        onTap: onTap,
        iconType: IconType.animatedOnHover,
        color: Colors.green,
        animateIcon: AnimateIcons.walk,
      );
    }
    return AnimateIcon(
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
    return ChangeNotifierProvider(create: (context) {
      final cr = ClusterRepo();
      cr.connect();
      return cr;
    }, child: Consumer<ClusterRepo>(builder: (_, cr, child) {
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
          ...cr.tasks.map((t) => _buildTaskItem(t)),
        ],
      );
    }));
  }
}
