import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:on_app/db/database_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/logg.dart';

class SupabaseHelper implements DatabaseHelper {
  static const _tableName = 'events';
  SupabaseHelper._privateConstructor();
  static final SupabaseHelper instance = SupabaseHelper._privateConstructor();

  static SupabaseClient? _db;

  Future<SupabaseClient> get db async {
    if (_db == null) {
      _db = Supabase.instance.client;
      await nativeGoogleSignIn();
    }

    return _db!;
  }

  Future<GoTrueClient> get auth async {
    return await db.then((it) => it.auth);
  }

  @override
  Future<void> insert(String event) async {
    var database = await db;
    await database.from(_tableName).insert({'event': event});
  }

  @override
  Future<List<Logg>> readAllLogs() async {
    var data = await db.then((database) => database.from(_tableName).select());
    return data.isNotEmpty
        ? data
            .map((entry) => Logg(
                event: entry['event'] as String,
                timestamp: entry['timestamp'] as String))
            .toList()
        : [];
  }

  @override
  void clearAll() async {
    await db
        .then((database) => database.from(_tableName).delete().neq('event', 0));
  }

  Future<DateTime?> lastMedicineTaken() async {
    var database = await db;
    PostgrestList foo = await database
        .from(_tableName)
        .select('timestamp')
        .eq('event', 'Ta medisin')
        .order('timestamp', ascending: false)
        .limit(1);

    var bar = DateTime.tryParse(foo.firstOrNull?['timestamp']);

    return bar;
  }

  Future<bool> lastStatus() async {
    var database = await db;
    PostgrestList sisteStatus = await database
        .from(_tableName)
        .select('event')
        .or('event.eq.On,event.eq.Off')
        .order('timestamp', ascending: false)
        .limit(1);
    var siste = sisteStatus.firstOrNull?['event'];
    if (siste == 'On') {
      return true;
    } else {
      return false;
    }
  }

  static Future<AuthResponse> nativeGoogleSignIn() async {
    var webClientId = dotenv.env['WEB_CLIENT_ID'];
    var iosClientId = dotenv.env['IOS_CLIENT_ID'];

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return _db!.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }
}
