import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:on_app/db/database_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../model/logg.dart';

class SupabaseHelper implements DatabaseHelper {
  static const _tableName = 'events';
  SupabaseHelper._privateConstructor();
  static final SupabaseHelper instance = SupabaseHelper._privateConstructor();

  static SupabaseClient? _db;

  Future<SupabaseClient> get db async {
    if (_db == null) {
      _db = Supabase.instance.client;
      if (Supabase.instance.client.auth.currentUser == null) {
        await nativeGoogleSignIn();
      }
    }

    return _db!;
  }

  Future<GoTrueClient> get auth async {
    return await db.then((it) => it.auth);
  }

  void insertAllLogs(List<Logg> value) async {
    var database = await db;
    List<Map<String, dynamic>> data =
        value.map((logg) {
          return {
            'id': logg.id,
            'event': logg.event,
            'timestamp': logg.timestamp,
          };
        }).toList();
    await database.from(_tableName).upsert(data, ignoreDuplicates: true);
  }

  @override
  Future<void> insert(String event, {DateTime? tidspunkt}) async {
    var database = await db;
    await database.from(_tableName).insert({
      'id': Uuid().v4(),
      'event': event,
      'timestamp': tidspunkt,
    });
  }

  @override
  Future<List<Logg>> readAllLogs() async {
    var data = await db.then((database) => database.from(_tableName).select());
    return data.isNotEmpty
        ? data
            .map(
              (entry) => Logg(
                id: entry['id'] as String,
                event: entry['event'] as String,
                timestamp: entry['timestamp'] as String,
              ),
            )
            .toList()
        : [];
  }

  @override
  void clearAll() async {
    await db.then(
      (database) => database.from(_tableName).delete().neq('event', 0),
    );
  }

  @override
  Future<DateTime?> lastMedicineTaken() async {
    var database = await db;
    PostgrestList list = await database
        .from(_tableName)
        .select('timestamp')
        .eq('event', 'Ta medisin')
        .order('timestamp', ascending: false)
        .limit(1);

    return DateTime.tryParse(list.firstOrNull?['timestamp'])?.toUtc();
  }

  @override
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

  subscription(void Function(PostgresChangePayload payload) callback) {
    return Supabase.instance.client
        .channel('events')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'events',
          callback: callback,
        )
        .subscribe();
  }
}
