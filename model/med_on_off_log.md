# Med On-Off log

## onOffDurations

Scans through the events in chronological order and produces [EventDuration](./event_duration.dart) objects. 

The first period is of the type given as lastEventBeforeMed, otherwise "Ta medisin"(uptake) event type.

This code skips multiple occurences of the same type of event.

The end of the last period ends when the earliest of the following occurs: 
* the next dose is taken
* 8 hours after the med
* midnight
* now()

## Duration
Total duration between doses

## Time until On
Time between tmed and first On-log after tmed 

## Time until Off
Time between tmed and first Off log after the Time until On