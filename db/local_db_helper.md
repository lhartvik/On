# LocalDBHelper
This is the class that talks to the phone's SQLite database which is needed to keep a state when the app is closed and started up again. 

Table name: pmed
```
TABLE PMED (
    id TEXT PRIMARY KEY,
    event TEXT NOT NULL,
    timestamp TEXT
    )
```

A log consists of a timestamp and a event. Any log that is inserted without an id also gets a new Uuid generated.

All timestamps are receied as DateTime objects and converted to UTC time if they happen to be in any other timezone(if it is already in UTC then nothing happens, better to do it twice than never) then stored as a ISO standard timestamp string.

There is a superclass to LocalDBHelper. This is a remnant of the cloud DB I used to be able to upload data to. This needed authentication, cloud db account, users needed a Google account etc and was a lot of work so was discontinued. I am working on a different backup solution, but this is no longer a priority for me. There should be a way to delete old data and a way to import data for testing on new emulators would also be handy.