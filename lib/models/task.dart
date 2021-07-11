class Task {
  int _id;
  String _task, _startDate, _endDate, _timeLeft,_status;

  Task(this._task, this._startDate, this._endDate,this._timeLeft, this._status);
  Task.withId(this._id, this._task, this._startDate, this._endDate, this._status);

  int get id => _id;
  String get task => _task;
  String get startDate => _startDate;
  String get endDate => _endDate;
  String get timeLeft => _timeLeft;
  String get status => _status;

  set task(String newTask) {
    if (newTask.length <= 255) {
      this._task = newTask;
    }
  }

  set startDate(String newstartDate) => this._startDate = newstartDate;

  set endDate(String newendDate) => this._endDate = newendDate;

  set timeLeft(String newtimeLeft) => this._endDate = newtimeLeft;

  set status(String newStatus) => this._status = newStatus;

  //Convert Task object into MAP object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) map['id'] = _id;
    map['task'] = _task;
    map['startDate'] = _startDate;
    map['endDate'] = _endDate;
    map['timeLeft'] = _timeLeft;
    map['status'] = _status;
    return map;
  }

  //Extract Task object from MAP object
  Task.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._task = map['task'];
    this._startDate = map['startDate'];
    this._endDate = map['endDate'];
    this._timeLeft = map['timeLeft'];
    this._status = map['status'];
  }
}
