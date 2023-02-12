class ExamResult {
  int _examResultId;
  String _userId;
  int _questionId;
  String _createdAt;
  String _createdBy;

  ExamResult(this._userId, this._questionId,this._createdBy,[this._createdAt]);

  ExamResult.withId(this._examResultId, this._userId,this._questionId,this._createdBy,[this._createdAt]);

  int get examResultId => _examResultId;

  String get userId => _userId;

  int get questionId => _questionId;

  String get createdAt => _createdAt;

  String get createdBy => _createdBy;

  set examResultId(int examResultId) {
    this._examResultId = examResultId;
  }

  set userId(String userId) {
    this._userId = userId;
  }

  set questionId(int questionId) {
    this._questionId = questionId;
  }

  set createdAt(String createdAt) {
    this._createdAt = createdAt;
  }

  set createdBy(String createdBy) {
    this._createdAt = createdBy;
  }

  // Convert  object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_examResultId != null) {
      map['examResultId'] = _examResultId;
    }
    map['userId'] = _userId;
    map['questionId'] = _questionId;
    map['createdBy'] = _createdBy;
    map['createdAt'] = _createdAt;

    return map;
  }

  // Extract object from a Map object
  ExamResult.fromMapObject(Map<String, dynamic> map) {
    this._examResultId = map['examResultId'];
    this._userId = map['userId'];
    this._questionId = map['questionId'];
    this._createdBy = map['createdBy'];
    this._createdAt = map['createdAt'];
  }
}
