# on_app

On er laget for å tracke On og Off-perioder når man er nybegynner på å ha Parkinson og vil få kontroll på når man kan ta medisin for å unngå symptomer.

## Getting Started

1. Generere prosjekt
```
flutter create on_app
````

Jeg har sjekket inn "lib"-folderen på github. Man må softlinke eller sjekke ut koden så den erstatter lib-folderen som ble generert av flutter create.

Kopier secrets-filen inn i mappen on_app, rotmappen til flutterapplikasjonen. Denne fila inneholder SUPABASE_URL, SUPABASE_KEY, GOOGLE_CLIENT_ID, WEB_CLIENT_ID og IOS_CLIENT_ID.
Hvis du ikke vil få fila fra meg kan du opprette et supabaseprosjekt og koble dette til Google-auth selv, for å styre dataene selv.

Man må legge til følgende i pubspec.yaml, som betyr at filen med filnavn "secrets" tas med i bygget:
```
flutter:
    assets:
        - secrets
````

For å kjøre appen på ios må GOOGLE_CLIENT_ID inn i ios-konfigen.

I ios/Info.plist kan man klistre inn dette:

```
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>GOOGLE_CLIENT_ID_PLACEHOLDER</string>
			</array>
		</dict>
	</array>
```

Man kan så kjøre:

```sh
GOOGLE_CLIENT_ID=$(grep GOOGLE_CLIENT_ID secrets | cut -d '=' -f2)
/usr/libexec/PlistBuddy -c "Set CFBundleURLTypes:0:CFBundleURLSchemes:0 $GOOGLE_CLIENT_ID" ios/Runner/Info.plist
```

Jeg er usikker på hva CFBundleTypeRole er for noe og om den er nødvendig.
Man kan også bare lime inn GOOGLE_CLIENT_ID istedenfor GOOGLE_CLIENT_ID_PLACEHOLDER, grunnen til at jeg gjorde det på denne måten var å kunne sjekke inn hele prosjektet, men det er mye enklere å lage nytt prosjekt enn å være nødt til å finne feil i alt det som genereres.
