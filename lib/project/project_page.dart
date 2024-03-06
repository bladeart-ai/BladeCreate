import 'package:bladecreate/canvas/canvas_stack_provider.dart';
import 'package:bladecreate/canvas/mask_layer_provider.dart';
import 'package:bladecreate/generate_backend/generate_backend_provider.dart';
import 'package:bladecreate/canvas/canvas_stack.dart';
import 'package:bladecreate/project/layer_history_card_list.dart';
import 'package:bladecreate/canvas/transform_box_provider.dart';
import 'package:bladecreate/project/project_provider.dart';
import 'package:bladecreate/project/generate_toolbar.dart';
import 'package:bladecreate/project/top_toolbar.dart';
import 'package:bladecreate/widgets/error_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectPageArguments {
  final String projectUUID;

  ProjectPageArguments(this.projectUUID);
}

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ProjectPageArguments;

    return Scaffold(
        body: PopScope(
            canPop: false,
            child: SafeArea(child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                      create: (_) => GenerateBackendProvider()),
                  ChangeNotifierProvider(
                      create: (_) =>
                          ProjectProvider(projectUUID: args.projectUUID)),
                  ChangeNotifierProvider(
                    create: (_) => TransformBoxProvider(),
                  ),
                  ChangeNotifierProvider(create: (_) => MaskLayerProvider()),
                  ChangeNotifierProvider(
                    create: (context) {
                      final cp = CanvasStackProvider(
                          Provider.of<ProjectProvider>(context, listen: false),
                          Provider.of<GenerateBackendProvider>(context,
                              listen: false),
                          Provider.of<TransformBoxProvider>(context,
                              listen: false),
                          Provider.of<MaskLayerProvider>(context,
                              listen: false));
                      cp.load();
                      return cp;
                    },
                  )
                ],
                builder: (context, child) {
                  final loadFuture = context
                      .select<CanvasStackProvider, Future>((p) => p.loadFuture);
                  final load =
                      context.select<CanvasStackProvider, Future Function()>(
                          (p) => p.load);
                  return FutureBuilder(
                    future: loadFuture,
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return FutureErrorDialog(
                          f: load,
                          error: snapshot.error!,
                          stackTrace: snapshot.stackTrace!,
                          returnable: true,
                        );
                      }
                      return Stack(
                        children: [
                          Positioned(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            child: const CanvasStack(),
                          ),
                          Positioned(
                            height: constraints.maxHeight,
                            right: 0,
                            child: const LayerHistoryCardList(),
                          ),
                          Positioned(
                            width: constraints.maxWidth,
                            top: 0,
                            child: const TopToolbar(),
                          ),
                          Positioned(
                            width: constraints.maxWidth,
                            bottom: 0,
                            child: const GenerateToolbar(),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            }))));
  }
}
