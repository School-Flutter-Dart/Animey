String getTimeDifference(String dateStr){
  var date = DateTime.parse(dateStr);
  var duration = DateTime.now().difference(date);
  if(duration.inMinutes<60){
    return '${duration.inMinutes} minutes ago';
  }else if(duration.inHours<24){
    return '${duration.inHours} hours ago';
  }else if(duration.inDays<31){
    return '${duration.inDays} days ago';
  }else if(duration.inDays<356){
    return 'about ${duration.inDays~/30} months ago';
  }else{
    return 'about ${duration.inDays~/356} years ago';
  }
}