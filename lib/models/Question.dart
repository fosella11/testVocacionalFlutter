class Question {

  int _id;
  String _tittle;
  int _response;
  int _responded;
  int _amount;

  Question(this._tittle, this._responded, this._response, this._amount);

  Question.withId(this._id, this._tittle, this._responded, this._response, this._amount);

  int get id => _id;

  String get title => _tittle;

  int get response => _response;

  int get responded => _responded;

  int get amount => _amount;

  set response(int updateResponse){
    this._response = updateResponse;
  }

  set responded(int updateResponded){
    this._responded = updateResponded;
  }

  //Convert the Questions into a map of questions
  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    if(id != null) {
      map['id'] = _id;
    }

    map['title'] = _tittle;
    map['response'] = _response;
    map['responded'] = _responded;
    map['amount'] = _amount;

    return map;
  }

  //Just in Case, if we need extract Question from map

  Question.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._tittle = map['title'];
    this._response = map['response'];
    this._responded = map['responded'];
    this._amount = map['amount'];
  }

}