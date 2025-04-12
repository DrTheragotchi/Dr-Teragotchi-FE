import 'package:emogotchi/const/theme/theme.dart';
import 'package:emogotchi/pages/initpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Ensure 'provider' is added in pubspec.yaml

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) => CoursesProvider()),

        // ChangeNotifierProvider(create: (context) => ClassGrouping()),

        // // ChangeNotifierProvider(
        // //   create: (context) => SemestersProvider(preloadedSemesters),
        // // ),
        // // ChangeNotifierProvider(
        // //   create: (context) => SavedSemesterProvider(semester),
        // // ),

        // /* --- 아래는 정상 ---- */
        // ChangeNotifierProvider(create: (_) => CurrentIndexProvider()),
        // ChangeNotifierProvider(create: (_) => FriendsProvider()),
        // /* --- course & personasl info provider ====  */
        // ChangeNotifierProvider(create: (_) => SemesterProvider()),
        // ChangeNotifierProvider(create: (context) => CourseColorProvider()),

        // ChangeNotifierProvider(create: (context) => DepartmentProvider()),
        // ChangeNotifierProvider(create: (context) => InstitutionProvider()),
        // ChangeNotifierProvider(create: (context) => UserInfoProvider()),
        // ChangeNotifierProvider(create: (context) => AdminProvider()),
        // ChangeNotifierProvider(create: (context) => ShowAdProvider()),
        // ChangeNotifierProvider(create: (context) => AppIconProvider()),
        // ChangeNotifierProvider(create: (context) => MyCodeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: InitPage(),
      ),
    );
  }
}
