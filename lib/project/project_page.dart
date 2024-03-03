import 'package:bladecreate/cluster/cluster_provider.dart';
import 'package:bladecreate/project/board.dart';
import 'package:bladecreate/project/layer_history_card_list.dart';
import 'package:bladecreate/project/layer/transform_box_provider.dart';
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
                    ChangeNotifierProvider(create: (context) {
                      final cp = ClusterProvider();
                      cp.connect();
                      return cp;
                    }),
                    ChangeNotifierProvider(create: (context) {
                      final cp =
                          Provider.of<ClusterProvider>(context, listen: false);
                      final p = ProjectProvider(projectUUID: args.projectUUID);
                      p.load();
                      p.watchGenerationStream(cp.generationStreamCtr);
                      return p;
                    }),
                    ChangeNotifierProvider(
                      create: (_) => TransformBoxProvider(),
                    ),
                  ],
                  child: Consumer<ProjectProvider>(builder: (_, pp, child) {
                    return FutureBuilder(
                        future: pp.loadFuture,
                        builder: (BuildContext context,
                            AsyncSnapshot<void> snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return FutureErrorDialog(
                              f: pp.load,
                              error: snapshot.error!,
                              stackTrace: snapshot.stackTrace!,
                              returnable: true,
                            );
                          }

                          return Stack(children: [
                            Positioned(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              child: const Board(),
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
                          ]);
                        });
                  }));
            }))));
  }
}
