// To parse this JSON data, do
//
//     final question = questionFromJson(jsonString);

import 'dart:convert';

List<Question> questionFromJson(String str) => List<Question>.from(json.decode(str).map((x) => Question.fromJson(x)));

String questionToJson(List<Question> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Question {
  Question({
    this.questionId,
    this.question,
    this.categoryId,
    this.level,
    this.createdBy,
    this.totalPages,
    this.posibleAnswers,
  });

  int questionId;
  String question;
  int categoryId;
  Level level;
  CreatedBy createdBy;
  int totalPages;
  List<PosibleAnswer> posibleAnswers;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    questionId: json["questionId"],
    question: json["question"],
    categoryId: json["categoryId"],
    level: levelValues.map[json["level"]],
    createdBy: createdByValues.map[json["createdBy"]],
    totalPages: json["totalPages"],
    posibleAnswers: List<PosibleAnswer>.from(json["posibleAnswers"].map((x) => PosibleAnswer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "questionId": questionId,
    "question": question,
    "categoryId": categoryId,
    "level": levelValues.reverse[level],
    "createdBy": createdByValues.reverse[createdBy],
    "totalPages": totalPages,
    "posibleAnswers": List<dynamic>.from(posibleAnswers.map((x) => x.toJson())),
  };
}

enum CreatedBy { K2_L0_QSUEW_DY_AIJD_YJ7_E_F_ZFL_X_CG_OL9_N, THE_3_DOY4_YPX_N0_MNYDE_P8_W_WWA_M_LIP_BI3_NF, I2_NOVG0_EFE_MGJ_X67_MMMGSOA_OSI_FAHJ }

final createdByValues = EnumValues({
  "i2NOVG0EFEMgjX67MmmgsoaOSIFahj": CreatedBy.I2_NOVG0_EFE_MGJ_X67_MMMGSOA_OSI_FAHJ,
  "k2l0QsuewDyAijdYJ7eFZflXCgOL9n": CreatedBy.K2_L0_QSUEW_DY_AIJD_YJ7_E_F_ZFL_X_CG_OL9_N,
  "3Doy4YpxN0mnydeP8wWwaMLipBi3Nf": CreatedBy.THE_3_DOY4_YPX_N0_MNYDE_P8_W_WWA_M_LIP_BI3_NF
});

enum Level { HARD, EASY, MEDIUM }

final levelValues = EnumValues({
  "Easy": Level.EASY,
  "Hard": Level.HARD,
  "Medium": Level.MEDIUM
});

class PosibleAnswer {
  PosibleAnswer({
    this.posibleAnswerId,
    this.questionId,
    this.label,
    this.labelValue,
    this.isAnswer,
  });

  int posibleAnswerId;
  int questionId;
  String label;
  String labelValue;
  int isAnswer;

  factory PosibleAnswer.fromJson(Map<String, dynamic> json) => PosibleAnswer(
    posibleAnswerId: json["posibleAnswerId"],
    questionId: json["questionId"],
    label: json["label"],
    labelValue: json["labelValue"],
    isAnswer: json["isAnswer"],
  );

  Map<String, dynamic> toJson() => {
    "posibleAnswerId": posibleAnswerId,
    "questionId": questionId,
    "label": label,
    "labelValue": labelValue,
    "isAnswer": isAnswer,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
