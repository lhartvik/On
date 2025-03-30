# Med Dilution Graph
The med dilution graph is displayed behind the [med on-off bars](./med_on_off_log_widget.md) in the [Stats screen](../screens/stats_screen.md) inside the [Day stats](./day_stats_widget.md).

According to [science](https://levodopalevel.com/) the half life of Levodopa is 90 minutes, starting from a point where the medicine approximately instantly takes effect.

This graph was plotted in a spreadsheet and recorded in this [table](../util/dilution_table.dart). The longest duration between meds is divided into 25 segments and a colored bar the height of dilution level is drawn for each segment.

```rb
# med_dilution_widget.dart
```
