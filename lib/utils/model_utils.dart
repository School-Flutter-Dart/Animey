import 'package:animey/models/library_entries.dart';
import 'package:animey/resources/string_values.dart';

String statusToRequesetStringConverter(Status status){
  switch(status){
    case Status.COMPLETED: return "completed";
    case Status.CURRENT: return "current";
    case Status.DROPPED: return "dropped";
    case Status.ONHOLD: return "on_hold";
    case Status.PLANNED: return "planned";
    default: throw Exception();
  }
}

String statusToStringConverter(Status status){
  switch(status){
    case Status.COMPLETED: return "Completed";
    case Status.CURRENT: return "Current";
    case Status.DROPPED: return "Dropped";
    case Status.ONHOLD: return "On Hold";
    case Status.PLANNED: return "Planned";
    default: throw Exception();
  }
}

String statusToAllCapitalizedStringConverter(Status status){
  switch(status){
    case Status.COMPLETED: return "COMPLETED";
    case Status.CURRENT: return "CURRENT";
    case Status.DROPPED: return "DROPPED";
    case Status.ONHOLD: return "ON HOLD";
    case Status.PLANNED: return "PLANNED";
    default: throw Exception();
  }
}

String streamerNameToStreamerIdConverter(String streamerName){
  switch(streamerName){
    case Amazon: return '9';
    case CrunchyRoll: return '3';
    case Funimation: return '2';
    case HIDIVE: return '7';
    case Hulu: return '1';
    case Netflix: return '6';
    case TubiTV: return '8';
    case Viewster: return '4';
    case YouTube: return '10';
    default: throw Exception('Failed to covert streamer to streamer Id');
  }
}