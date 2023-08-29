import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Tutorial',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  Widget welcome = Container(margin: EdgeInsets.only(left: 14, top:20, bottom: 10), child: Text('Welcome to Flutter learning App!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.brown),));
  Widget text1 = Container(margin: EdgeInsets.only(left: 14, top:10, bottom: 10), child: Text('　このアプリはFlutterを勉強している初心者向けの学習支援アプリです。'
      '\n　ご覧の通り、ナビゲーターには「Tutorial」と「Notes」二つのボタンがあり、クリックすると本アプリの主要な二つの機能を使うことができます。'
      '「Tutorial」では、Flutterを勉強するための教材が章分けで用意されています。まだ一部のコンテンツを準備しているところですが、すでにアップロードした部分は制限なく読むことができます。'
      '「Notes」では、右下の「＋」ボタン右上のゴミ箱ボタンを利用することでノートを追加・削除することができます。Flutterを勉強する時は、学習ノートとしてお使いください。'
      '\n　なお、各ページの左上にホームマークがあり、クリックするとホーム画面に戻ることができます。'
      'それでは、アプリを楽しんでください！', style: TextStyle(fontSize: 16),));

  void tutorPage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new TutorPage()),
      (route) => route == null,
    );
  }

  void notePage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new NotePage()),
      (route) => route == null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Tutorial',
          style: TextStyle(
              color: Colors.brown.shade700, fontWeight: FontWeight.bold, fontSize: 26,),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        elevation: 5,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    width: width * 0.5,
                    child: TextButton(
                      onPressed: tutorPage,
                      child: Text('Tutorial'),
                    )),
                SizedBox(
                    width: width * 0.5,
                    child: TextButton(
                      onPressed: notePage,
                      child: Text('Notes'),
                    )),
              ]),
        ),
      ),
      drawer: null,
      body: Column(textDirection: TextDirection.ltr, crossAxisAlignment: CrossAxisAlignment.start, children: [welcome, text1],),
    );
  }
}

class NotePage extends StatefulWidget {
  NotePage({Key? key}) : super(key: key);
  List<Widget> cards = [];

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // ③ SharedPreferencesのインスタンスを取得し、
    // SharedPreferencesに保存されているリストを取得
    SharedPreferences.getInstance().then((prefs) {
      var todo = prefs.getStringList("todo") ?? [];
      for (var v in todo) {
        setState(() {
          // ④ 保存されている場合は、widgetのリストに追加
          widget.cards.add(TodoCardWidget(label: v));
        });
      }
    });
  }

  Future<String?> _showTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Note'),
            content: TextField(
              controller: _textFieldController,
              decoration:
                  const InputDecoration(hintText: "Type your note here"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                  _textFieldController.clear();
                },
              ),
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context, _textFieldController.text);
                  _textFieldController.clear();
                },
              ),
            ],
          );
        });
  }

  void homePage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new MyHomePage()),
      (route) => route == null,
    );
  }

  void tutorPage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new TutorPage()),
      (route) => route == null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Tutorial',
          style: TextStyle(
              color: Colors.brown.shade700, fontWeight: FontWeight.bold, fontSize: 26,),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        elevation: 5,
        actions: <Widget>[
          IconButton(
            onPressed: homePage,
            icon: Icon(Icons.home),
          ),
          IconButton(
              onPressed: () {
                SharedPreferences.getInstance().then((prefs) async {
                  await prefs.setStringList("todo", []);
                  setState(() {
                    widget.cards = [];
                  });
                });
              },
              icon: Icon(Icons.delete))
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    width: width * 0.5,
                    child: TextButton(
                      onPressed: tutorPage,
                      child: Text('Tutorial'),
                    )),
                SizedBox(
                    width: width * 0.5,
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.orange.shade400),
                      ),
                      child:
                          Text('Notes', style: TextStyle(color: Colors.white)),
                    )),
              ]),
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: widget.cards.length,
          itemBuilder: (BuildContext context, int index) {
            return widget.cards[index];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // ⑤ TextInputDialogを用いて、任意の文字列を取得する。
          var label = await _showTextInputDialog(context);

          if (label != null) {
            setState(() {
              widget.cards.add(TodoCardWidget(label: label));
            });

            // ⑥ SharedPreferencesのインスタンスを取得し、追加する。
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var todo = prefs.getStringList("todo") ?? [];
            todo.add(label);
            await prefs.setStringList("todo", todo);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TutorPage extends StatefulWidget {
  TutorPage({Key? key}) : super(key: key);

  @override
  _TutorPageState createState() => _TutorPageState();
}

class _TutorPageState extends State<TutorPage> {
  void homePage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new MyHomePage()),
      (route) => route == null,
    );
  }

  void notePage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new NotePage()),
      (route) => route == null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Flutter Tutorial',
            style: TextStyle(
                color: Colors.brown.shade700, fontWeight: FontWeight.bold, fontSize: 26,),
          ),
          backgroundColor: Colors.orange,
          centerTitle: true,
          elevation: 5,
          actions: <Widget>[
            IconButton(
              onPressed: homePage,
              icon: Icon(Icons.home),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(5),
            child: Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      width: width * 0.5,
                      child: TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.orange.shade400),
                        ),
                        child: Text('Tutorial',
                            style: TextStyle(color: Colors.white)),
                      )),
                  SizedBox(
                      width: width * 0.5,
                      child: TextButton(
                        onPressed: notePage,
                        child: Text('Notes'),
                      )),
                ]),
          ),
        ),
        drawer: null,
        body: Column(
            textDirection: TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TutorialRow(
                  name1: 'Chapter1',
                  name2: 'Chapter2',
                  name3: 'Chapter3',
                  detail1: 'Introduction',
                  detail2: 'Flow',
                  detail3: 'MaterialApp',
                  link1: IntroPage(),
                  link2: WidgetPage(),
                  link3: MaterialPage(),
                  width: width),
              TutorialRow(
                  name1: 'Chapter4',
                  name2: 'Chapter5',
                  name3: 'Chapter6',
                  detail1: 'Scaffold Widget',
                  detail2: 'Stateless Widget',
                  detail3: 'Stateful Widget',
                  width: width,
                  link1: ScaffoldPage(),
                  link2: StatelessPage(),
                  link3: StatefulPage()),
            ]));
  }
}

class TutorialRow extends StatefulWidget {
  TutorialRow({
    Key? key,
    required this.name1,
    required this.name2,
    required this.name3,
    required this.detail1,
    required this.detail2,
    required this.detail3,
    required this.link1,
    required this.link2,
    required this.link3,
    required this.width,
  }) : super(key: key);

  final String name1;
  final String name2;
  final String name3;
  final String detail1;
  final String detail2;
  final String detail3;
  final double width;
  final link1;
  final link2;
  final link3;

  @override
  _TutorialRowState createState() => _TutorialRowState();
}

class _TutorialRowState extends State<TutorialRow> {
  void jump1() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return widget.link1;
    }));
  }

  void jump2() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return widget.link2;
    }));
  }

  void jump3() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return widget.link3;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: widget.width * 0.05, top: 20),
            height: 150,
            width: widget.width * 0.28,
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            alignment: Alignment.center,
            child: Column(
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    height: 50,
                    padding: EdgeInsets.only(top: 20),
                    child: Text(widget.name1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ))),
                Container(
                    height: 30,
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      widget.detail1,
                      style: TextStyle(color: Colors.grey),
                    )),
                Container(
                    height: 40,
                    margin: EdgeInsets.only(top: 10),
                    child: TextButton(
                      child: Text(
                        'Learn it',
                        style: TextStyle(
                          color: Colors.brown.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.orange.shade300),
                      ),
                      onPressed: jump1,
                    )),
              ],
            )),
        Container(
          margin: EdgeInsets.only(left: widget.width * 0.03, top: 20),
          height: 150,
          width: widget.width * 0.28,
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          alignment: Alignment.center,
          child: Column(
            textDirection: TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: 50,
                  padding: EdgeInsets.only(top: 20),
                  child: Text(widget.name2,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ))),
              Container(
                  height: 30,
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    widget.detail2,
                    style: TextStyle(color: Colors.grey),
                  )),
              Container(
                  height: 40,
                  margin: EdgeInsets.only(top: 10),
                  child: TextButton(
                    child: Text(
                      'Learn it',
                      style: TextStyle(
                        color: Colors.brown.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.orange.shade300),
                    ),
                    onPressed: jump2,
                  )),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: widget.width * 0.03, top: 20),
          height: 150,
          width: widget.width * 0.28,
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          alignment: Alignment.center,
          child: Column(
            textDirection: TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: 50,
                  padding: EdgeInsets.only(top: 20),
                  child: Text(widget.name3,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ))),
              Container(
                  height: 30,
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    widget.detail3,
                    style: TextStyle(color: Colors.grey),
                  )),
              Container(
                  height: 40,
                  margin: EdgeInsets.only(top: 10),
                  child: TextButton(
                    child: Text(
                      'Learn it',
                      style: TextStyle(
                        color: Colors.brown.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.orange.shade300),
                    ),
                    onPressed: jump3,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class IntroPage extends StatefulWidget {
  IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  Widget title1 = Container(margin: EdgeInsets.only(left: 14, top:20, bottom: 10), child: Text('Flutterとは何か', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),));
  Widget text1 = Container(margin: EdgeInsets.only(left: 14), child: Text("Flutterは、Googleによって開発されたフリーかつオープンソースのUIのSDKである。"
      "単一のコードベースから、Android、iOS、Linux、macOS、Windows、Google Fuchsia向けのクロスプラットフォームアプリケーションを開発するために利用される。"
      "2018年12月4日、ロンドンで開催されたFlutter Live 18にて、初の正式版となるFlutter 1.0のリリースが発表された。"
      "2021年3月3日、Googleはオンライン開催されたFlutter Engageイベント中にFlutter 2をリリースした。"
      "このメジャーアップデートでは、新しいCanvasKitレンダラーとウェブ向けのウィジェットを使用したウェブベースのアプリケーションの公式サポート、Windows、macOS、Linux向けのアーリーアクセスのデスクトップアプリケーションのサポート、Add-to-App APIの改善などが行われた。"));
  Widget title2 = Container(margin: EdgeInsets.only(left: 14, top:20, bottom: 10), child: Text('Flutterのアーキテクチャ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),));
  Widget text2 = Text("    Flutterの主なコンポーネントは以下の通りである。\n    ・Dartプラットフォーム\n    ・Flutterエンジン\n    ・基本ライブラリ\n    ・特定のデザイン体系向けのWidget\n    ・Flutter Development Tools（DevTools）");

  void homePage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new MyHomePage()),
          (route) => route == null,
    );
  }

  void tutorPage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new TutorPage()),
      (route) => route == null,
    );
  }

  void notePage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new NotePage()),
      (route) => route == null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Tutorial',
          style: TextStyle(
              color: Colors.brown.shade700, fontWeight: FontWeight.bold, fontSize: 26,),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        elevation: 5,
        actions: [IconButton(
          onPressed: homePage,
          icon: Icon(Icons.home),
        ),],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    width: width * 0.5,
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.orange.shade400),
                      ),
                      child: Text('Tutorial',
                          style: TextStyle(color: Colors.white)),
                    )),
                SizedBox(
                    width: width * 0.5,
                    child: TextButton(
                      onPressed: notePage,
                      child: Text('Notes'),
                    )),
              ]),
        ),
      ),
      drawer: null,
      body: Column(textDirection: TextDirection.ltr, crossAxisAlignment: CrossAxisAlignment.start, children: [title1, text1, title2, text2],),
    );
  }
}

class WidgetPage extends StatefulWidget {
  WidgetPage({Key? key}) : super(key: key);

  @override
  _WidgetPageState createState() => _WidgetPageState();
}

class _WidgetPageState extends State<WidgetPage> {
  void homePage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new MyHomePage()),
          (route) => route == null,
    );
  }

  void tutorPage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new TutorPage()),
      (route) => route == null,
    );
  }

  void notePage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new NotePage()),
      (route) => route == null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Tutorial',
          style: TextStyle(
              color: Colors.brown.shade700, fontWeight: FontWeight.bold, fontSize: 26,),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        elevation: 5,
        actions: [IconButton(
          onPressed: homePage,
          icon: Icon(Icons.home),
        ),],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    width: width * 0.5,
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.orange.shade400),
                      ),
                      child: Text('Tutorial',
                          style: TextStyle(color: Colors.white)),
                    )),
                SizedBox(
                    width: width * 0.5,
                    child: TextButton(
                      onPressed: notePage,
                      child: Text('Notes'),
                    )),
              ]),
        ),
      ),
      drawer: null,
      body: Center(child: Text('Flutterプログラミングのフローについて紹介するページです。内容は準備中。')),
    );
  }
}

class MaterialPage extends StatefulWidget {
  MaterialPage({Key? key}) : super(key: key);

  @override
  _MaterialPageState createState() => _MaterialPageState();
}

class _MaterialPageState extends State<MaterialPage> {
  void homePage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new MyHomePage()),
          (route) => route == null,
    );
  }

  void tutorPage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new TutorPage()),
      (route) => route == null,
    );
  }

  void notePage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new NotePage()),
      (route) => route == null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Tutorial',
          style: TextStyle(
              color: Colors.brown.shade700, fontWeight: FontWeight.bold, fontSize: 26,),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        elevation: 5,
        actions: [IconButton(
          onPressed: homePage,
          icon: Icon(Icons.home),
        ),],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    width: width * 0.5,
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.orange.shade400),
                      ),
                      child: Text('Tutorial',
                          style: TextStyle(color: Colors.white)),
                    )),
                SizedBox(
                    width: width * 0.5,
                    child: TextButton(
                      onPressed: notePage,
                      child: Text('Notes'),
                    )),
              ]),
        ),
      ),
      drawer: null,
      body: Center(child: Text('MaterialAppについて紹介するページです。内容は準備中。')),
    );
  }
}

class ScaffoldPage extends StatefulWidget {
  ScaffoldPage({Key? key}) : super(key: key);

  @override
  _ScaffoldPageState createState() => _ScaffoldPageState();
}

class _ScaffoldPageState extends State<ScaffoldPage> {
  void homePage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new MyHomePage()),
          (route) => route == null,
    );
  }

  void tutorPage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new TutorPage()),
      (route) => route == null,
    );
  }

  void notePage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new NotePage()),
      (route) => route == null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Tutorial',
          style: TextStyle(
              color: Colors.brown.shade700, fontWeight: FontWeight.bold, fontSize: 26,),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        elevation: 5,
        actions: [IconButton(
          onPressed: homePage,
          icon: Icon(Icons.home),
        ),],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    width: width * 0.5,
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.orange.shade400),
                      ),
                      child: Text('Tutorial',
                          style: TextStyle(color: Colors.white)),
                    )),
                SizedBox(
                    width: width * 0.5,
                    child: TextButton(
                      onPressed: notePage,
                      child: Text('Notes'),
                    )),
              ]),
        ),
      ),
      drawer: null,
      body: Center(child: Text('Scaffold Widgetについて紹介するページです。内容は準備中。')),
    );
  }
}

class StatelessPage extends StatefulWidget {
  StatelessPage({Key? key}) : super(key: key);

  @override
  _StatelessPageState createState() => _StatelessPageState();
}

class _StatelessPageState extends State<StatelessPage> {
  void homePage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new MyHomePage()),
          (route) => route == null,
    );
  }

  void tutorPage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new TutorPage()),
      (route) => route == null,
    );
  }

  void notePage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new NotePage()),
      (route) => route == null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Tutorial',
          style: TextStyle(
              color: Colors.brown.shade700, fontWeight: FontWeight.bold, fontSize: 26,),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        elevation: 5,
        actions: [IconButton(
          onPressed: homePage,
          icon: Icon(Icons.home),
        ),],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    width: width * 0.5,
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.orange.shade400),
                      ),
                      child: Text('Tutorial',
                          style: TextStyle(color: Colors.white)),
                    )),
                SizedBox(
                    width: width * 0.5,
                    child: TextButton(
                      onPressed: notePage,
                      child: Text('Notes'),
                    )),
              ]),
        ),
      ),
      drawer: null,
      body: Center(child: Text('Stateless Widgetについて紹介するページです。内容は準備中。')),
    );
  }
}

class StatefulPage extends StatefulWidget {
  StatefulPage({Key? key}) : super(key: key);

  @override
  _StatefulPageState createState() => _StatefulPageState();
}

class _StatefulPageState extends State<StatefulPage> {
  void homePage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new MyHomePage()),
          (route) => route == null,
    );
  }

  void tutorPage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new TutorPage()),
      (route) => route == null,
    );
  }

  void notePage() {
    Navigator.pushAndRemoveUntil(
      context,
      new MaterialPageRoute(builder: (context) => new NotePage()),
      (route) => route == null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Tutorial',
          style: TextStyle(
              color: Colors.brown.shade700, fontWeight: FontWeight.bold, fontSize: 26,),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        elevation: 5,
        actions: [IconButton(
          onPressed: homePage,
          icon: Icon(Icons.home),
        ),],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    width: width * 0.5,
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.orange.shade400),
                      ),
                      child: Text('Tutorial',
                          style: TextStyle(color: Colors.white)),
                    )),
                SizedBox(
                    width: width * 0.5,
                    child: TextButton(
                      onPressed: notePage,
                      child: Text('Notes'),
                    )),
              ]),
        ),
      ),
      drawer: null,
      body: Center(child: Text('Stateful Widgetについて紹介するページです。内容は準備中。')),
    );
  }
}

class TodoCardWidget extends StatefulWidget {
  final String label;
  var state = false;

  TodoCardWidget({Key? key, required this.label}) : super(key: key);

  @override
  _TodoCardWidgetState createState() => _TodoCardWidgetState();
}

class _TodoCardWidgetState extends State<TodoCardWidget> {
  void _changeState(value) {
    setState(() {
      widget.state = value ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Checkbox(onChanged: _changeState, value: widget.state),
            Text(widget.label),
          ],
        ),
      ),
    );
  }
}
