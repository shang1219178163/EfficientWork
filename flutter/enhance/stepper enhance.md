## stepper enhance


    Step add 'bool isStepperTypeHorizontalBottom'；
    if(type == StepperType.horizontal && isStepperTypeHorizontalBottom == true) {
        //title , subtitle below the Icon；
    }
    
#### screen shot：

    Step(
        //...
        isStepperTypeHorizontalBottom: true,
        //...
      )
      
![stepper enhance](https://github.com/shang1219178163/EfficientWork/blob/master/flutter/enhance/stepper.jpeg?raw=true)

    Step(
        //...
        isStepperTypeHorizontalBottom: true,
        isStepperTypeHorizontalBottomLineFollowIconMidY: true,
        //...
      )

![stepper enhance](https://github.com/shang1219178163/EfficientWork/blob/master/flutter/enhance/stepper1.jpeg?raw=true)

### use:
    replace file:
    /Users/*/flutter/packages/flutter/lib/src/material/stepper.dart

#### code：
    //
    //	StepperDemoPage.dart
    //	MacTemplet
    //
    //	Created by Bin Shang on 2021/06/11 17:15
    //	Copyright © 2021 Bin Shang. All rights reserved.
    //
    
    import 'package:flutter/material.dart';
    import 'package:fluttertemplet/dartExpand/DDLog.dart';
    
    
    class StepperDemoPage extends StatefulWidget {
      StepperDemoPage({Key? key}) : super(key: key);
    
      @override
      _StepperDemoPageState createState() => _StepperDemoPageState();
    }
    
    /// This is the private State class that goes with StepperDemoPage.
    class _StepperDemoPageState extends State<StepperDemoPage> {
      StepperType _type = StepperType.vertical;
    
      List titles = List.generate(3, (index) => "Step $index");
    
      int _index = 0;
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
              title: Text("$widget"),
              actions: [
                TextButton(onPressed: (){
                  DDLog("change");
                  setState(() {
                    if (_type == StepperType.vertical) {
                      _type = StepperType.horizontal;
                    } else {
                      _type = StepperType.vertical;
                    }
                  });
                }, child: Icon(Icons.change_circle_outlined, color: Colors.white,)),
              ],
            ),
            body: buildStepper(context),
        );
      }
    
      void go(int index) {
        if (index == -1 && _index <= 0 ) {
          DDLog("first step");
          return;
        }
    
        if (index == 1 && _index >= titles.length - 1) {
          DDLog("last step");
          return;
        }
    
        setState(() {
          _index += index;
        });
      }
    
      Widget buildStepper(BuildContext context) {
        return Stepper(
          type: _type,
          currentStep: _index,
          physics: ClampingScrollPhysics(),
          onStepCancel: () {
            go(-1);
          },
          onStepContinue: () {
            go(1);
          },
          onStepTapped: (index) {
            DDLog(index);
            setState(() {
              _index = index;
            });
          },
          steps: titles.map((e) => Step(
            isActive: _index == titles.indexOf(e),
            isStepperTypeHorizontalBottom: true,
            isStepperTypeHorizontalBottomLineFollowIconMidY: true,
            title: Text(e,),
            subtitle: Text("subtitle${titles.indexOf(e)}",),
            content: Container(
              // alignment: Alignment.centerLeft,
                child: Text("Content for Step ${titles.indexOf(e)}")
            ),
          )).toList(),
        );
      }

    }

#### DDLog
    // ignore: non_constant_identifier_names
    void DDLog(dynamic obj){
      DDTraceModel model = DDTraceModel(StackTrace.current);
      print("${DateTime.now()}  ${model.fileName}, ${model.className} [line ${model.lineNumber}]: $obj");
    }
    
    class DDTraceModel {
      final StackTrace _trace;
    
      String fileName = "";
      String className = "";
      int lineNumber = 0;
      int columnNumber = 0;
    
      DDTraceModel(this._trace) {
        _parseTrace();
      }
    
      void _parseTrace() {
        var traceString = this._trace.toString().split("\n")[1];
        this.className = traceString.split(".")[0].replaceAll("#1", "").trim();
        // print('___${this.className}_$traceString');
        // print('___${this.className}_\n${this._trace.toString()}');
    
        var indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z_]+.dart'));
        var fileInfo = traceString.substring(indexOfFileName);
        var listOfInfos = fileInfo.split(":");
        this.fileName = listOfInfos[0];
        this.lineNumber = int.parse(listOfInfos[1]);
    
        var columnStr = listOfInfos[2];
        columnStr = columnStr.replaceFirst(")", "");
        this.columnNumber = int.parse(columnStr);
      }
    }
