import 'package:onlight/util/util.dart';

class MedOnOffLog {
  DateTime tmed;
  DateTime? tplus;
  DateTime? tminus;
  DateTime? tprevmed;
  DateTime? tnextmed;

  MedOnOffLog(this.tmed, this.tplus, this.tminus, {this.tprevmed, this.tnextmed});

  Duration get timeUntilOn {
    return tplus?.difference(tmed) ?? Duration.zero;
  }

  Duration get timeUntilOff {
    return tminus?.difference(tmed) ?? Duration.zero;
  }

  Duration? get timeBetweenOnAndNow {
    var t = tplus == null ? Duration.zero : DateTime.now().difference(tplus!);

    if (t.isNegative) {
      return Duration.zero;
    }
    if (t.inHours > 8) {
      return null;
    }
    return t;
  }

  Duration get timeOn {
    return (tplus == null)
        ? Duration.zero
        : tminus?.difference(tplus!) ?? tnextmed?.difference(tplus!) ?? timeBetweenOnAndNow ?? Duration(hours: 8);
  }

  Duration get timeUntilNextMed {
    return tnextmed?.difference(tmed) ?? Duration.zero;
  }

  @override
  String toString() {
    String tmedString = ((tprevmed != null) ? "prev: ${Util.onlyTime(tprevmed!)}" : "( no prev )");
    tmedString = "$tmedString|med: ${Util.onlyTime(tmed)}";
    tmedString = "$tmedString|${(tplus != null) ? "on: ${Util.onlyTime(tplus!)}" : "(no tplus)"}";
    tmedString = "$tmedString|${(tminus != null) ? "off: ${Util.onlyTime(tminus!)}" : "(no tminus)"}";
    tmedString = "$tmedString|${(tnextmed != null) ? "next: ${Util.onlyTime(tnextmed!)}" : "(no nextmed)"}";
    return tmedString;
  }

  @override
  operator ==(Object other) {
    return other is MedOnOffLog &&
        other.tmed == tmed &&
        other.tplus == tplus &&
        other.tminus == tminus &&
        other.tprevmed == tprevmed &&
        other.tnextmed == tnextmed;
  }

  @override
  int get hashCode {
    return tmed.hashCode ^ tplus.hashCode ^ tminus.hashCode ^ tprevmed.hashCode ^ tnextmed.hashCode;
  }
}
