# Loggeknapp

The Log button is used in the [On Screen](../screens/on_screen.md)

## Tap
When a Loggeknapp is tapped, inserts a row into the SQLite database using the [LocalDBHelper](../db/sqflite_helper.dart). As a callback when the insert operation is finished, updates the last log and medicine taken in [Statistics](../notifiers/statistics.md)

## Long Click
A long click will show the amazing time picker that comes with Flutter. 
The chosen time of day will always be in local time, so this is converted to the local datetime of the local current date, then converted to UTC before it is sent to the database. 

As a callback to the database operation, the [Statistics](../notifiers/statistics.md) are updated, so that the screen gets rebuilt and texts updated.

## Subcomponents
Inkwell is used as a button because it has onlongclick and ontap as well as a splash effect animation in a hope that the user gets some visual feedback. It may not be as visible as I would have wanted. At least it is not too disturbing.