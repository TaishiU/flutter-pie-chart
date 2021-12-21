class Task {
  final int taskVal;
  final String taskDetails;
  final String colorVal;
  Task(this.taskDetails, this.taskVal, this.colorVal);

  Task.fromMap(Map<String, dynamic> map)
      : assert(map['taskDetails'] != null),
        assert(map['taskVal'] != null),
        assert(map['colorVal'] != null),
        taskDetails = map['taskDetails'],
        taskVal = map['taskVal'],
        colorVal = map['colorVal'];

  @override
  String toString() => "Record<$taskVal:$taskDetails>";
}
