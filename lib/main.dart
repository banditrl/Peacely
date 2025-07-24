import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:peacely/ui/resident/edit/resident_edit_page.dart';
import 'package:peacely/ui/resident/view/resident_view_page.dart';
import 'firebase_options.dart';
import 'ui/control-panel/control_panel_page.dart';
import 'ui/login/login_page.dart';
import 'ui/resident/register/resident_register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PeacelyApp());
}

class PeacelyApp extends StatelessWidget {
  const PeacelyApp({super.key});

@override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peacely',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/control-panel': (context) => const ControlPanelPage(),
        '/resident-register': (context) => const ResidentRegisterPage(),
        '/resident-view': (context) => const ResidentViewPage(),
        '/resident-edit': (context) => const ResidentEditPage(),
      },
    );
  }
}
