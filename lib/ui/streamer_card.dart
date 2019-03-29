import 'package:flutter/material.dart';
import 'package:animey/resources/string_values.dart';

class StreamerCard extends StatelessWidget{
  final String siteName;
  final VoidCallback onTap;

  StreamerCard({@required this.siteName, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: InkWell(
      onTap: onTap,
        child: Card(
          elevation: 4,
          color: Colors.transparent,
          child: Container(
            height: 50,
            child: Image.asset(streamerToStreamerLogoConverter(siteName),fit: BoxFit.fill,),
          ),
        )
      )
    );
  }

  String streamerToStreamerLogoConverter(String siteNmae){
    switch(siteNmae){
      case Amazon: return 'assets/streamer_logo/amazon.png';
      case CrunchyRoll: return 'assets/streamer_logo/crunchyroll.png';
      case Funimation: return 'assets/streamer_logo/funimation.png';
      case HIDIVE: return 'assets/streamer_logo/hidive.png';
      case Hulu: return 'assets/streamer_logo/hulu.png';
      case Netflix: return 'assets/streamer_logo/netflix.png';
      case TubiTV: return 'assets/streamer_logo/tubitv.png';
      case Viewster: return 'assets/streamer_logo/viewster.png';
      case YouTube: return 'assets/streamer_logo/youtube.png';
      default: throw Exception('Failed to covert streamer to streamer logo');
    }
  }
}