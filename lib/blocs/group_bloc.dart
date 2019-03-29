import 'package:animey/resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:animey/models/group_member.dart';

class GroupBloc{
  final _repository = Repository();
  final _groupMemberesFetcher = BehaviorSubject<List<GroupMember>>();
  final _groupMembers =List<GroupMember>();

  Observable<List<GroupMember>> get groupMembers => _groupMemberesFetcher.stream;

  void fetchGroupMemberByUserId(String userId){
    _repository.fetchGroupMembers(userId).listen((groupMember){
      if(!_groupMemberesFetcher.isClosed) {
        _groupMembers.add(groupMember);
        _groupMemberesFetcher.sink.add(_groupMembers);
      }
    });
  }

  dispose(){
    _groupMemberesFetcher.close();
  }
}