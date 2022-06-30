/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Patient type in your schema. */
@immutable
class Patient extends Model {
  static const classType = const _PatientModelType();
  final String id;
  final double? _velocity;
  final int? _age;
  final double? _duration;
  final TemporalDateTime? _datetime;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  double? get velocity {
    return _velocity;
  }
  
  int? get age {
    return _age;
  }
  
  double? get duration {
    return _duration;
  }
  
  TemporalDateTime? get datetime {
    return _datetime;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Patient._internal({required this.id, velocity, age, duration, datetime, createdAt, updatedAt}): _velocity = velocity, _age = age, _duration = duration, _datetime = datetime, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Patient({String? id, double? velocity, int? age, double? duration, TemporalDateTime? datetime}) {
    return Patient._internal(
      id: id == null ? UUID.getUUID() : id,
      velocity: velocity,
      age: age,
      duration: duration,
      datetime: datetime);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Patient &&
      id == other.id &&
      _velocity == other._velocity &&
      _age == other._age &&
      _duration == other._duration &&
      _datetime == other._datetime;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Patient {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("velocity=" + (_velocity != null ? _velocity!.toString() : "null") + ", ");
    buffer.write("age=" + (_age != null ? _age!.toString() : "null") + ", ");
    buffer.write("duration=" + (_duration != null ? _duration!.toString() : "null") + ", ");
    buffer.write("datetime=" + (_datetime != null ? _datetime!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Patient copyWith({String? id, double? velocity, int? age, double? duration, TemporalDateTime? datetime}) {
    return Patient._internal(
      id: id ?? this.id,
      velocity: velocity ?? this.velocity,
      age: age ?? this.age,
      duration: duration ?? this.duration,
      datetime: datetime ?? this.datetime);
  }
  
  Patient.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _velocity = (json['velocity'] as num?)?.toDouble(),
      _age = (json['age'] as num?)?.toInt(),
      _duration = (json['duration'] as num?)?.toDouble(),
      _datetime = json['datetime'] != null ? TemporalDateTime.fromString(json['datetime']) : null,
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'velocity': _velocity, 'age': _age, 'duration': _duration, 'datetime': _datetime?.format(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };

  static final QueryField ID = QueryField(fieldName: "patient.id");
  static final QueryField VELOCITY = QueryField(fieldName: "velocity");
  static final QueryField AGE = QueryField(fieldName: "age");
  static final QueryField DURATION = QueryField(fieldName: "duration");
  static final QueryField DATETIME = QueryField(fieldName: "datetime");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Patient";
    modelSchemaDefinition.pluralName = "Patients";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Patient.VELOCITY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Patient.AGE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Patient.DURATION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Patient.DATETIME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _PatientModelType extends ModelType<Patient> {
  const _PatientModelType();
  
  @override
  Patient fromJson(Map<String, dynamic> jsonData) {
    return Patient.fromJson(jsonData);
  }
}