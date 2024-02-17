import 'package:bladecreate/project/board.dart';
import 'package:bladecreate/project/layer/transform_box_provider.dart';
import 'package:bladecreate/project/project_provider.dart';
import 'package:bladecreate/project/generate_toolbar.dart';
import 'package:bladecreate/project/layer_toolbar.dart';
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
                    ChangeNotifierProvider(create: (context) {
                      final p = ProjectProvider(projectUUID: args.projectUUID);
                      p.fetchProject();
                      return p;
                    }),
                    ChangeNotifierProvider(
                        create: (_) => TransformBoxProvider()),
                  ],
                  child: Consumer<ProjectProvider>(builder: (_, p, child) {
                    return FutureBuilder(
                        future: p.fetchProjectFuture,
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return FutureErrorDialog(
                              f: p.fetchProject,
                              error: snapshot.error!,
                              returnable: true,
                            );
                          }
                          return Stack(children: [
                            Positioned(
                                width: constraints.maxWidth,
                                height: constraints.maxHeight,
                                child: const Board()),
                            Positioned(
                                width: constraints.maxWidth,
                                top: 0,
                                child: const LayerToolbar()),
                            Positioned(
                                width: constraints.maxWidth,
                                bottom: 0,
                                child: const GenerateToolbar()),
                          ]);
                        });
                  }));
            }))));
  }
}
