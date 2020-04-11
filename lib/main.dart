import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_final/scoped_model/MainSModel.dart';
import 'package:scoped_model/scoped_model.dart';

import 'AppWithDrawer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  MainSModel _model = MainSModel();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainSModel>(
      model: _model,
      child: DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
          primarySwatch: Colors.red,
          primaryColor: Colors.red,
          brightness: Brightness.light,
          //brightness: 0.0,
        ),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            title: 'Ứng Dụng Chat Flutter',
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: AppWithDrawer()
            ),
          );
        },
      ),
    );
  }

}
