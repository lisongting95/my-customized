import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Random expressions'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  var screenWidth = MediaQueryData.fromWindow(ui.window).size.width;//屏幕宽度
  var screenHeight = MediaQueryData.fromWindow(ui.window).size.height;//屏幕高度
  var scale = MediaQueryData.fromWindow(ui.window).devicePixelRatio;//每一个逻辑像素包含多少个原始像素
  var statusBar = MediaQueryData.fromWindow(ui.window).padding.top;//状态栏高度



  var data = {
    ['等价无穷小','sin x','x'],
    ['等价无穷小','cos x','x'],
    ['等价无穷小','tan x','x'],
    ['等价无穷小','ln(1+x)','x'],
    ['等价无穷小','arctan x','x'],
    ['等价无穷小','e^x -1','x'],
    ['等价无穷小','1- cos x','1/2 * x^2'],
    ['等价无穷小','(1-x)^a -1','ax'],
    ['泰勒公式','sin x','x - 1/6*x^3'],
    ['泰勒公式','cos x','1 - 1/2*x^2 + 1/24*x^4'],
    ['泰勒公式','arcsin x','x + 1/6*x^3'],
    ['泰勒公式','tan x','x + 1/3*x^3'],
    ['泰勒公式','arctan x','x - 1/3*x^3'],
    ['泰勒公式','ln(1+x)','x - 1/2*x^2 + 1/3*x^3 - 1/4*x^4'],
    ['泰勒公式','e^x','1 + x + 1/2*x^2 + 1/6*x^3 + 1/24*x^4'],
    ['泰勒公式','1/(1-x)','x + x^2 + x^3 + x^4 (|x|<1)'],
  };

  TextEditingController _unameController=new TextEditingController();

  void _toTestPage() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Test Page'),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Form(
                // key: _formKey, //设置globalKey，用于后面获取FormState
                autovalidate: true, //开启自动校验
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        autofocus: false,
                        controller: _unameController,
                        decoration: InputDecoration(
                            labelText: "用户名",
                            hintText: "用户名或邮箱",
                            icon: Icon(Icons.person)
                        ),
                        // 校验用户名
                        validator: (v) {
                          return v
                              .trim()
                              .length > 0 ? null : "用户名不能为空";
                        }

                    ),
                    TextFormField(
                        // controller: _pwdController,
                        decoration: InputDecoration(
                            labelText: "密码",
                            hintText: "您的登录密码",
                            icon: Icon(Icons.lock)
                        ),
                        obscureText: true,
                        //校验密码
                        validator: (v) {
                          return v
                              .trim()
                              .length > 5 ? null : "密码不能少于6位";
                        }
                    ),
                    // 登录按钮
                    Padding(
                      padding: const EdgeInsets.only(top: 28.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              padding: EdgeInsets.all(15.0),
                              child: Text("登录"),
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                              textColor: Colors.white,
                              onPressed: () {
                                //在这里不能通过此方式获取FormState，context不对
                                //print(Form.of(context));

                                // 通过_formKey.currentState 获取FormState后，
                                // 调用validate()方法校验用户名密码是否合法，校验
                                // 通过后再提交数据。 
                                // if((_formKey.currentState as FormState).validate()){
                                //   //验证通过提交数据
                                // }
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Expressions exp = new Expressions('泰勒公式', '1/(1-x)', 'x + x^2 + x^3 + x^4 (|x|<1)');
  bool isShowAnswer = false;

  @override
  void initState(){
    super.initState();
    _unameController.addListener((){
      print(_unameController.text);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _toTestPage),
        ],
      ),
      body: Container(
        height: screenHeight-statusBar-56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top:30.0),
              child: Container(
                color: Colors.blue[50],
                margin: EdgeInsets.only(
                  left: 30.0,
                  right: 30.0,
                ),
                padding: EdgeInsets.only(
                  left:30.0,
                  right:30.0,
                  top:20.0,
                  bottom:20.0,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: isShowAnswer? 0:40,
                      child: Text(
                        exp.type,
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    Container(
                      height: isShowAnswer? 0:40,
                      child: Text(
                        exp.origin,
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    Container(
                      height: isShowAnswer? null:0,
                      width: isShowAnswer? null:0,
                      child: Text(
                        exp.vary,
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 150.0,
              child: Align(
                alignment: Alignment.bottomRight,
                child: ButtonBar(children: <Widget>[
                  MaterialButton(
                    child: Icon(
                      Icons.check,
                    ),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    color: Colors.blueGrey[100],
                    onPressed: (){
                      isShowAnswer = false;
                      List dataList = new List<Expressions>();
                      data.forEach((d){
                        Expressions temp = new Expressions(d[0], d[1], d[2]);
                        dataList.add(temp);
                      });
                      int index =  Random().nextInt(dataList.length-1);
                      exp = dataList[index];
                      setState(() {});
                    },
                  ),
                  MaterialButton(
                    child: Icon(
                      Icons.add,
                    ),
                    padding: EdgeInsets.all(20),
                    shape: CircleBorder(),
                    color: Colors.blueGrey[100],
                    onPressed: (){
                      isShowAnswer = true;
                      setState(() {});
                    },
                  ),
                ],),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Expressions {
  String type;
  String origin;
  String vary;

  Expressions(t, o, v){
    this.type =  t;
    this.origin = o;
    this.vary = v;
  }
}