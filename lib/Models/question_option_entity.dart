class QuestionOptionEntity {
  int _questionId;
  int _categoryId;
  String _question;
  String _level;
  String _createdAt;
  String _createdBy;
  int _optionId;
  String _label;
  String _labelValue;
  int _isAnswer;

  QuestionOptionEntity(this._question,this._categoryId, this._level,this._label,this._optionId,this._labelValue,this._isAnswer, this._createdBy,[this._createdAt]);

  QuestionOptionEntity.withId(this._questionId,this._categoryId, this._question,this._optionId,this._label, this._labelValue,this._isAnswer, this._createdBy, [this._createdAt]);

  int get questionId => _questionId;

  int get categoryId => _categoryId;

  String get question => _question;

  String get level => _level;

  String get createdBy => _createdBy;

  String get createdAt => _createdAt;

  int get optionId => _optionId;

  String get label => _label;

  String get labelValue => _labelValue;

  int get isAnswer => _isAnswer;

  set question(String question) {
    this._question = question;
  }
  set categoryId(int categoryId) {
    this._categoryId = categoryId;
  }

  set level(String level) {
    this._level = level;
  }

  set createdAt(String createdAt) {
    this._createdAt = createdAt;
  }
  set createdBy(String createdBy) {
    this._createdBy = createdBy;
  }
  set label(String label) {
    this._label = label;
  }
  set questionId(int questionId) {
    this._questionId = questionId;
  }
  set optionId(int optionId) {
    this._optionId = optionId;
  }

  set labelValue(String labelValue) {
    this._labelValue = labelValue;
  }
  set isAnswer(int isAnswer) {
    this._isAnswer = isAnswer;
  }




  // Convert a Category object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (questionId != null) {
      map['questionId'] = _questionId;
    }
    map['question'] = _question;
    map['categoryId'] = _categoryId;
    map['level'] = _level;
    map['createdAt'] = _createdAt;
    map['createdBy'] = _createdBy;
    map['label'] = _label;
    map['optionId'] = _optionId;
    map['labelValue'] = _labelValue;
    map['isAnswer'] = _isAnswer;

    return map;
  }

  // Extract a Category object from a Map object
  QuestionOptionEntity.fromMapObject(Map<String, dynamic> map) {
    this._questionId = map['questionId'];
    this._categoryId = map['categoryId'];
    this._question = map['question'];
    this._level = map['level'];
    this._createdBy = map['createdBy'];
    this._createdAt = map['createdAt'];
    this._optionId = map['optionId'];
    this._label = map['label'];
    this._labelValue = map['labelValue'];
    this._isAnswer = map['isAnswer'];
  }
}
