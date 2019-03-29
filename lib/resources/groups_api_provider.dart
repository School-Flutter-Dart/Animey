import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:animey/models/group.dart';
import 'package:animey/models/group_member.dart';
import 'package:animey/utils/http_utils.dart';

class GroupsApiProvider {
  Client client = Client();

  Stream<GroupMember> fetchGroupMembers(String userId,{int offset = 0})async*{
    var response = await client.get('https://kitsu.io/api/edge/group-members?fields%5BgroupMembers%5D=unreadCount%2Cgroup&fields%5Bgroups%5D=name%2Cslug%2Cavatar&filter%5Buser%5D=$userId&include=group&page%5Blimit%5D=8&sort=-group.last_activity_at');
    var json = convertToUtf8Json(response.bodyBytes);
    var groupMemberJsonList = json['data'] as List;
    var groupJsonList = json['included'] as List;
    //int total = json['meta']['count'] as int;
    for(int i = 0;i<groupMemberJsonList.length;i++){
      var groupMember = GroupMember.fromJson(groupMemberJsonList[i]);
      groupMember.group = Group.fromJson(groupJsonList[i]);
      yield groupMember;
    }
  }
}
