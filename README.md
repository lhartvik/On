# on_app

On er laget for å tracke On og Off-perioder når man er nybegynner på å ha Parkinson og vil få kontroll på når man kan ta medisin for å unngå symptomer.

## Getting Started

1. Generere prosjekt
```
flutter create onlight
````

2. Sjekke ut koden i lib-folderen

3. Gå gjennom alle dart-filer, markere import-linjene som feiler, og få VSCode til å legge til riktig avhengighet(Command .)

I skrivende tid er det disse: 

````
  collection: ^1.19.1
  intl: ^0.20.2
  path: ^1.9.1
  provider: ^6.1.2
  sqflite: ^2.4.2
  uuid: ^4.5.1
````
Men versjonene vil endre seg etter at jeg har skrevet dette og jeg legger helt sikkert til flere uten å oppdatere README

# Ny versjon IPhone

For å slippe å huke av hver gang for at det ikke brukes noen proprietære krypteringsalgoritmer: 
````
  <key>ITSAppUsesNonExemptEncryption</key>
  <false/>
````
inn i ios/Runner/Info.plist

1. Oppdatere versjonsnummer i pubspec.yaml.
2. gå til flutter-bygg-mappen, ett nivå over lib og kjør flutter build ios
3. Åpne ios-folderen i xcode
4. Test at XCode også kan kjøre appen i simulator
5. Product - Archive
6. Hvis det lykkes skal det dukke opp et vindu med Archives og versjoner. Velg ønsker versjon og klikk Distribute
7. https://appstoreconnect.apple.com/login

# Ny versjon Android

1. Oppdatere versjonsnummer i pubspec.yaml.
2. flutter build android
3. https://play.google.com/console

# Test
(evt). Sjekke ut testprosjektet (https://github.com/lhartvik/ontests) i test-folderen