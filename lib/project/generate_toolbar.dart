import 'package:bladecreate/project/project_provider.dart';
import 'package:bladecreate/style.dart';
import 'package:bladecreate/swagger_generated_code/openapi.swagger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GenerateToolbar extends StatefulWidget {
  const GenerateToolbar({super.key});

  @override
  State<GenerateToolbar> createState() => _GenerateToolbarState();
}

class _GenerateToolbarState extends State<GenerateToolbar> {
  final promptCtr = TextEditingController();
  final negativePromptCtr = TextEditingController();
  int outputNum = 1;
  int inferenceSteps = 10;

  @override
  void dispose() {
    promptCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, p, child) => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTextFields(),
          Container(
            decoration: BoxDecoration(
              color: AppStyle.backgroundWithOpacity,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildMenu(),
                IconButton(
                  onPressed: () {
                    p.generate(GenerationParams(
                      prompt: promptCtr.text,
                      negativePrompt: negativePromptCtr.text,
                      width: 400,
                      height: 400,
                      outputNumber: outputNum,
                      inferenceSteps: inferenceSteps,
                    ));
                  },
                  icon: const Icon(Icons.auto_fix_high),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextFields() {
    final unfocusedborder = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppStyle.borderColor,
        width: 0,
      ),
    );
    final focusedborder = OutlineInputBorder(
      borderSide: BorderSide(
        color: AppStyle.borderColor,
        width: AppStyle.borderWidth,
      ),
    );
    const negativeUnfocusedborder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black38,
        width: 0,
      ),
    );
    const negativeFocusedborder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black38,
        width: AppStyle.borderWidth,
      ),
    );
    return Row(children: [
      SizedBox(
        height: 80,
        width: 400,
        child: TextField(
          controller: promptCtr,
          expands: true,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: unfocusedborder,
            enabledBorder: unfocusedborder,
            focusedBorder: focusedborder,
            errorBorder: unfocusedborder,
            focusedErrorBorder: focusedborder,
            disabledBorder: unfocusedborder,
            fillColor: AppStyle.backgroundWithOpacity,
            contentPadding: const EdgeInsets.all(4),
            hintText: 'Enter a prompt',
            filled: true,
          ),
          style: AppStyle.smallText,
        ),
      ),
      SizedBox(
        height: 80,
        width: 200,
        child: TextField(
          controller: negativePromptCtr,
          expands: true,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: negativeUnfocusedborder,
            enabledBorder: negativeUnfocusedborder,
            focusedBorder: negativeFocusedborder,
            errorBorder: negativeUnfocusedborder,
            focusedErrorBorder: negativeFocusedborder,
            disabledBorder: negativeUnfocusedborder,
            fillColor: AppStyle.backgroundWithOpacity,
            contentPadding: const EdgeInsets.all(4),
            hintText: 'Enter a negative prompt',
            filled: true,
          ),
          style: AppStyle.smallText,
        ),
      )
    ]);
  }

  Widget buildMenu() {
    return MenuAnchor(
      builder: (context, controller, child) {
        return IconButton(
          onPressed: () => setState(() {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          }),
          icon: controller.isOpen
              ? const Icon(Icons.menu_open_rounded)
              : const Icon(Icons.menu_rounded),
        );
      },
      menuChildren: [
        Text("Output Number: $outputNum", style: AppStyle.smallText),
        Slider(
          value: outputNum.toDouble(),
          max: 4,
          min: 1,
          divisions: 3,
          label: outputNum.toString(),
          onChanged: (value) => setState(() {
            outputNum = value.toInt();
          }),
        ),
        Text("Inference Steps: $inferenceSteps", style: AppStyle.smallText),
        Slider(
          value: inferenceSteps.toDouble(),
          max: 100,
          min: 1,
          divisions: 99,
          label: inferenceSteps.toString(),
          onChanged: (value) => setState(() {
            inferenceSteps = value.toInt();
          }),
        ),
      ],
    );
  }
}
