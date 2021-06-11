## stepper enhance


    Step 新增 isStepperTypeHorizontalBottom 属性；
    当 type 为 StepperType.horizontal 且 isStepperTypeHorizontalBottom 为 true，title 和 subtitle 布局在底部；



    //
    //	StepperDemoPage.dart
    //	MacTemplet
    //
    //	Created by Bin Shang on 2021/06/11 17:15
    //	Copyright © 2021 Bin Shang. All rights reserved.
    //
    
    import 'package:flutter/material.dart';
    import 'package:fluttertemplet/dartExpand/DDLog.dart';
    
    
    /// This is the stateful widget that the main application instantiates.
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
          DDLog("已经是第一个 Step了,无法再后退了");
          return;
        }
    
        if (index == 1 && _index >= titles.length - 1) {
          DDLog("已经是最后一个 Step了,无法再前进了");
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
