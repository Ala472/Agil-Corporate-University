import 'package:cloud_firestore/cloud_firestore.dart';

class TypeCourse {
  final String desc;
  final String fileName;
  final String idCours;
  final String type;
  final String filePlaceHolder;

  TypeCourse({ this.desc, this.fileName, this.idCours, this.type, this.filePlaceHolder });
  TypeCourse.fromMap(Map<String, dynamic> map)
      : assert(map['description'] != null ?? ''),
        assert(map['fileName'] != null),
        assert(map['idCours'] != null),
        assert(map['type'] != null),
        assert(map['fileNamePlaceholder'] != null),

        desc = map['description'],
        fileName = map['fileName'],
        idCours = map['idCours'],
        type = map['type'],
        filePlaceHolder = map['fileNamePlaceholder'];
  TypeCourse.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data());
}