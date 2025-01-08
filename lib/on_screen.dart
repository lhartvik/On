import 'package:flutter/material.dart';
import 'package:on_app/components/loggeknapp.dart';
import 'package:on_app/db/supabase_helper.dart';

class OnScreen extends StatefulWidget {
  const OnScreen({super.key});

  @override
  State<OnScreen> createState() => _OnScreenState();
}

class _OnScreenState extends State<OnScreen> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    SupabaseHelper.instance.auth
        .then((auth) => auth.onAuthStateChange.listen((data) {
              setState(() {
                _userId = data.session?.user.id;
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SafeArea(
        child: Column(
          spacing: 50,
          children: [
            Text(_userId != null ? 'Innlogget' : 'Ikke innlogget'),
            for (var title in ['Ta medisin', 'On', 'Off'])
              Loggeknapp(tittel: title, theme: theme),
            ElevatedButton(
                onPressed: () {
                  SupabaseHelper.instance.clearAll();
                },
                child: Text('Clear all'))
          ],
        ),
      ),
    );
  }
}
