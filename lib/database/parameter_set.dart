class ParameterSet {
  final int?      id;
  final DateTime  dateTime;
  final String    title;
  final double    speed;
  final double    speedMax;
  final double    speedMin;
  final double    kp;
  final double    kpMax;
  final double    kpMin;
  final double    ki;
  final double    kiMax;
  final double    kiMin;
  final double    kd;
  final double    kdMax;
  final double    kdMin;
  final int       sensor0;
  final int       sensor1;
  final int       sensor2;
  final int       sensor3;
  final int       sensor4;
  final int       sensor5;
  final int       sensor6;
  final int       sensor7;
  final int       sensorMax;
  final int       sensorMin;

  ParameterSet({
    this.id,
    required this.dateTime,
    required this.title,
    required this.speed,
    required this.speedMax,
    required this.speedMin,
    required this.kp,
    required this.kpMax,
    required this.kpMin,
    required this.ki,
    required this.kiMax,
    required this.kiMin,
    required this.kd,
    required this.kdMax,
    required this.kdMin,
    required this.sensor0,
    required this.sensor1,
    required this.sensor2,
    required this.sensor3,
    required this.sensor4,
    required this.sensor5,
    required this.sensor6,
    required this.sensor7,
    required this.sensorMax,
    required this.sensorMin
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'dateTime'  : dateTime.toIso8601String(),
      'title'     : title,
      'speed'     : speed,
      'speedMax'  : speedMax,
      'speedMin'  : speedMin,
      'kp'        : kp,
      'kpMax'     : kpMax,
      'kpMin'     : kpMin,
      'ki'        : ki,
      'kiMax'     : kiMax,
      'kiMin'     : kiMin,
      'kd'        : kd,
      'kdMax'     : kdMax,
      'kdMin'     : kdMin,
      'sensor0'    : sensor0,
      'sensor1'    : sensor1,
      'sensor2'    : sensor2,
      'sensor3'    : sensor3,
      'sensor4'    : sensor4,
      'sensor5'    : sensor5,
      'sensor6'    : sensor6,
      'sensor7'    : sensor7,
      'sensorMax' : sensorMax,
      'sensorMin' : sensorMin
    };
  }

  factory ParameterSet.fromMap(Map<String, dynamic> map) {
    return ParameterSet(
      id: map['_id'],
      dateTime: DateTime.parse(map['dateTime']),
      title: map['title'],
      speed: map['speed'],
      speedMax: map['speedMax'],
      speedMin: map['speedMin'],
      kp: map['kp'],
      kpMax: map['kpMax'],
      kpMin: map['kpMin'],
      ki: map['ki'],
      kiMax: map['kiMax'],
      kiMin: map['kiMin'],
      kd: map['kd'],
      kdMax: map['kdMax'],
      kdMin: map['kdMin'],
      sensor0: map['sensor0'],
      sensor1: map['sensor1'],
      sensor2: map['sensor2'],
      sensor3: map['sensor3'],
      sensor4: map['sensor4'],
      sensor5: map['sensor5'],
      sensor6: map['sensor6'],
      sensor7: map['sensor7'],
      sensorMax: map['sensorMax'],
      sensorMin: map['sensorMin']
    );
  }
}