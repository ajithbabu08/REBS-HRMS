// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $EmployeeTableTable extends EmployeeTable
    with TableInfo<$EmployeeTableTable, EmployeeEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentMeta = const VerificationMeta(
    'department',
  );
  @override
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
    'department',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _designationMeta = const VerificationMeta(
    'designation',
  );
  @override
  late final GeneratedColumn<String> designation = GeneratedColumn<String>(
    'designation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _joinDateMeta = const VerificationMeta(
    'joinDate',
  );
  @override
  late final GeneratedColumn<String> joinDate = GeneratedColumn<String>(
    'join_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _officeLatitudeMeta = const VerificationMeta(
    'officeLatitude',
  );
  @override
  late final GeneratedColumn<double> officeLatitude = GeneratedColumn<double>(
    'office_latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _officeLongitudeMeta = const VerificationMeta(
    'officeLongitude',
  );
  @override
  late final GeneratedColumn<double> officeLongitude = GeneratedColumn<double>(
    'office_longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _officeRadiusMetersMeta =
      const VerificationMeta('officeRadiusMeters');
  @override
  late final GeneratedColumn<double> officeRadiusMeters =
      GeneratedColumn<double>(
        'office_radius_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _companyTimezoneMeta = const VerificationMeta(
    'companyTimezone',
  );
  @override
  late final GeneratedColumn<String> companyTimezone = GeneratedColumn<String>(
    'company_timezone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Asia/Kolkata'),
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    employeeId,
    name,
    department,
    designation,
    email,
    joinDate,
    officeLatitude,
    officeLongitude,
    officeRadiusMeters,
    companyTimezone,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmployeeEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('department')) {
      context.handle(
        _departmentMeta,
        department.isAcceptableOrUnknown(data['department']!, _departmentMeta),
      );
    } else if (isInserting) {
      context.missing(_departmentMeta);
    }
    if (data.containsKey('designation')) {
      context.handle(
        _designationMeta,
        designation.isAcceptableOrUnknown(
          data['designation']!,
          _designationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_designationMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('join_date')) {
      context.handle(
        _joinDateMeta,
        joinDate.isAcceptableOrUnknown(data['join_date']!, _joinDateMeta),
      );
    } else if (isInserting) {
      context.missing(_joinDateMeta);
    }
    if (data.containsKey('office_latitude')) {
      context.handle(
        _officeLatitudeMeta,
        officeLatitude.isAcceptableOrUnknown(
          data['office_latitude']!,
          _officeLatitudeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_officeLatitudeMeta);
    }
    if (data.containsKey('office_longitude')) {
      context.handle(
        _officeLongitudeMeta,
        officeLongitude.isAcceptableOrUnknown(
          data['office_longitude']!,
          _officeLongitudeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_officeLongitudeMeta);
    }
    if (data.containsKey('office_radius_meters')) {
      context.handle(
        _officeRadiusMetersMeta,
        officeRadiusMeters.isAcceptableOrUnknown(
          data['office_radius_meters']!,
          _officeRadiusMetersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_officeRadiusMetersMeta);
    }
    if (data.containsKey('company_timezone')) {
      context.handle(
        _companyTimezoneMeta,
        companyTimezone.isAcceptableOrUnknown(
          data['company_timezone']!,
          _companyTimezoneMeta,
        ),
      );
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {employeeId};
  @override
  EmployeeEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeEntry(
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      department: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department'],
      )!,
      designation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}designation'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      joinDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}join_date'],
      )!,
      officeLatitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}office_latitude'],
      )!,
      officeLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}office_longitude'],
      )!,
      officeRadiusMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}office_radius_meters'],
      )!,
      companyTimezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_timezone'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      )!,
    );
  }

  @override
  $EmployeeTableTable createAlias(String alias) {
    return $EmployeeTableTable(attachedDatabase, alias);
  }
}

class EmployeeEntry extends DataClass implements Insertable<EmployeeEntry> {
  final String employeeId;
  final String name;
  final String department;
  final String designation;
  final String email;
  final String joinDate;
  final double officeLatitude;
  final double officeLongitude;
  final double officeRadiusMeters;
  final String companyTimezone;
  final DateTime lastUpdated;
  const EmployeeEntry({
    required this.employeeId,
    required this.name,
    required this.department,
    required this.designation,
    required this.email,
    required this.joinDate,
    required this.officeLatitude,
    required this.officeLongitude,
    required this.officeRadiusMeters,
    required this.companyTimezone,
    required this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['employee_id'] = Variable<String>(employeeId);
    map['name'] = Variable<String>(name);
    map['department'] = Variable<String>(department);
    map['designation'] = Variable<String>(designation);
    map['email'] = Variable<String>(email);
    map['join_date'] = Variable<String>(joinDate);
    map['office_latitude'] = Variable<double>(officeLatitude);
    map['office_longitude'] = Variable<double>(officeLongitude);
    map['office_radius_meters'] = Variable<double>(officeRadiusMeters);
    map['company_timezone'] = Variable<String>(companyTimezone);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  EmployeeTableCompanion toCompanion(bool nullToAbsent) {
    return EmployeeTableCompanion(
      employeeId: Value(employeeId),
      name: Value(name),
      department: Value(department),
      designation: Value(designation),
      email: Value(email),
      joinDate: Value(joinDate),
      officeLatitude: Value(officeLatitude),
      officeLongitude: Value(officeLongitude),
      officeRadiusMeters: Value(officeRadiusMeters),
      companyTimezone: Value(companyTimezone),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory EmployeeEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeEntry(
      employeeId: serializer.fromJson<String>(json['employeeId']),
      name: serializer.fromJson<String>(json['name']),
      department: serializer.fromJson<String>(json['department']),
      designation: serializer.fromJson<String>(json['designation']),
      email: serializer.fromJson<String>(json['email']),
      joinDate: serializer.fromJson<String>(json['joinDate']),
      officeLatitude: serializer.fromJson<double>(json['officeLatitude']),
      officeLongitude: serializer.fromJson<double>(json['officeLongitude']),
      officeRadiusMeters: serializer.fromJson<double>(
        json['officeRadiusMeters'],
      ),
      companyTimezone: serializer.fromJson<String>(json['companyTimezone']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'employeeId': serializer.toJson<String>(employeeId),
      'name': serializer.toJson<String>(name),
      'department': serializer.toJson<String>(department),
      'designation': serializer.toJson<String>(designation),
      'email': serializer.toJson<String>(email),
      'joinDate': serializer.toJson<String>(joinDate),
      'officeLatitude': serializer.toJson<double>(officeLatitude),
      'officeLongitude': serializer.toJson<double>(officeLongitude),
      'officeRadiusMeters': serializer.toJson<double>(officeRadiusMeters),
      'companyTimezone': serializer.toJson<String>(companyTimezone),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  EmployeeEntry copyWith({
    String? employeeId,
    String? name,
    String? department,
    String? designation,
    String? email,
    String? joinDate,
    double? officeLatitude,
    double? officeLongitude,
    double? officeRadiusMeters,
    String? companyTimezone,
    DateTime? lastUpdated,
  }) => EmployeeEntry(
    employeeId: employeeId ?? this.employeeId,
    name: name ?? this.name,
    department: department ?? this.department,
    designation: designation ?? this.designation,
    email: email ?? this.email,
    joinDate: joinDate ?? this.joinDate,
    officeLatitude: officeLatitude ?? this.officeLatitude,
    officeLongitude: officeLongitude ?? this.officeLongitude,
    officeRadiusMeters: officeRadiusMeters ?? this.officeRadiusMeters,
    companyTimezone: companyTimezone ?? this.companyTimezone,
    lastUpdated: lastUpdated ?? this.lastUpdated,
  );
  EmployeeEntry copyWithCompanion(EmployeeTableCompanion data) {
    return EmployeeEntry(
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      name: data.name.present ? data.name.value : this.name,
      department: data.department.present
          ? data.department.value
          : this.department,
      designation: data.designation.present
          ? data.designation.value
          : this.designation,
      email: data.email.present ? data.email.value : this.email,
      joinDate: data.joinDate.present ? data.joinDate.value : this.joinDate,
      officeLatitude: data.officeLatitude.present
          ? data.officeLatitude.value
          : this.officeLatitude,
      officeLongitude: data.officeLongitude.present
          ? data.officeLongitude.value
          : this.officeLongitude,
      officeRadiusMeters: data.officeRadiusMeters.present
          ? data.officeRadiusMeters.value
          : this.officeRadiusMeters,
      companyTimezone: data.companyTimezone.present
          ? data.companyTimezone.value
          : this.companyTimezone,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeEntry(')
          ..write('employeeId: $employeeId, ')
          ..write('name: $name, ')
          ..write('department: $department, ')
          ..write('designation: $designation, ')
          ..write('email: $email, ')
          ..write('joinDate: $joinDate, ')
          ..write('officeLatitude: $officeLatitude, ')
          ..write('officeLongitude: $officeLongitude, ')
          ..write('officeRadiusMeters: $officeRadiusMeters, ')
          ..write('companyTimezone: $companyTimezone, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    employeeId,
    name,
    department,
    designation,
    email,
    joinDate,
    officeLatitude,
    officeLongitude,
    officeRadiusMeters,
    companyTimezone,
    lastUpdated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeEntry &&
          other.employeeId == this.employeeId &&
          other.name == this.name &&
          other.department == this.department &&
          other.designation == this.designation &&
          other.email == this.email &&
          other.joinDate == this.joinDate &&
          other.officeLatitude == this.officeLatitude &&
          other.officeLongitude == this.officeLongitude &&
          other.officeRadiusMeters == this.officeRadiusMeters &&
          other.companyTimezone == this.companyTimezone &&
          other.lastUpdated == this.lastUpdated);
}

class EmployeeTableCompanion extends UpdateCompanion<EmployeeEntry> {
  final Value<String> employeeId;
  final Value<String> name;
  final Value<String> department;
  final Value<String> designation;
  final Value<String> email;
  final Value<String> joinDate;
  final Value<double> officeLatitude;
  final Value<double> officeLongitude;
  final Value<double> officeRadiusMeters;
  final Value<String> companyTimezone;
  final Value<DateTime> lastUpdated;
  final Value<int> rowid;
  const EmployeeTableCompanion({
    this.employeeId = const Value.absent(),
    this.name = const Value.absent(),
    this.department = const Value.absent(),
    this.designation = const Value.absent(),
    this.email = const Value.absent(),
    this.joinDate = const Value.absent(),
    this.officeLatitude = const Value.absent(),
    this.officeLongitude = const Value.absent(),
    this.officeRadiusMeters = const Value.absent(),
    this.companyTimezone = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeTableCompanion.insert({
    required String employeeId,
    required String name,
    required String department,
    required String designation,
    required String email,
    required String joinDate,
    required double officeLatitude,
    required double officeLongitude,
    required double officeRadiusMeters,
    this.companyTimezone = const Value.absent(),
    required DateTime lastUpdated,
    this.rowid = const Value.absent(),
  }) : employeeId = Value(employeeId),
       name = Value(name),
       department = Value(department),
       designation = Value(designation),
       email = Value(email),
       joinDate = Value(joinDate),
       officeLatitude = Value(officeLatitude),
       officeLongitude = Value(officeLongitude),
       officeRadiusMeters = Value(officeRadiusMeters),
       lastUpdated = Value(lastUpdated);
  static Insertable<EmployeeEntry> custom({
    Expression<String>? employeeId,
    Expression<String>? name,
    Expression<String>? department,
    Expression<String>? designation,
    Expression<String>? email,
    Expression<String>? joinDate,
    Expression<double>? officeLatitude,
    Expression<double>? officeLongitude,
    Expression<double>? officeRadiusMeters,
    Expression<String>? companyTimezone,
    Expression<DateTime>? lastUpdated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (employeeId != null) 'employee_id': employeeId,
      if (name != null) 'name': name,
      if (department != null) 'department': department,
      if (designation != null) 'designation': designation,
      if (email != null) 'email': email,
      if (joinDate != null) 'join_date': joinDate,
      if (officeLatitude != null) 'office_latitude': officeLatitude,
      if (officeLongitude != null) 'office_longitude': officeLongitude,
      if (officeRadiusMeters != null)
        'office_radius_meters': officeRadiusMeters,
      if (companyTimezone != null) 'company_timezone': companyTimezone,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeTableCompanion copyWith({
    Value<String>? employeeId,
    Value<String>? name,
    Value<String>? department,
    Value<String>? designation,
    Value<String>? email,
    Value<String>? joinDate,
    Value<double>? officeLatitude,
    Value<double>? officeLongitude,
    Value<double>? officeRadiusMeters,
    Value<String>? companyTimezone,
    Value<DateTime>? lastUpdated,
    Value<int>? rowid,
  }) {
    return EmployeeTableCompanion(
      employeeId: employeeId ?? this.employeeId,
      name: name ?? this.name,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      email: email ?? this.email,
      joinDate: joinDate ?? this.joinDate,
      officeLatitude: officeLatitude ?? this.officeLatitude,
      officeLongitude: officeLongitude ?? this.officeLongitude,
      officeRadiusMeters: officeRadiusMeters ?? this.officeRadiusMeters,
      companyTimezone: companyTimezone ?? this.companyTimezone,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (designation.present) {
      map['designation'] = Variable<String>(designation.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (joinDate.present) {
      map['join_date'] = Variable<String>(joinDate.value);
    }
    if (officeLatitude.present) {
      map['office_latitude'] = Variable<double>(officeLatitude.value);
    }
    if (officeLongitude.present) {
      map['office_longitude'] = Variable<double>(officeLongitude.value);
    }
    if (officeRadiusMeters.present) {
      map['office_radius_meters'] = Variable<double>(officeRadiusMeters.value);
    }
    if (companyTimezone.present) {
      map['company_timezone'] = Variable<String>(companyTimezone.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeTableCompanion(')
          ..write('employeeId: $employeeId, ')
          ..write('name: $name, ')
          ..write('department: $department, ')
          ..write('designation: $designation, ')
          ..write('email: $email, ')
          ..write('joinDate: $joinDate, ')
          ..write('officeLatitude: $officeLatitude, ')
          ..write('officeLongitude: $officeLongitude, ')
          ..write('officeRadiusMeters: $officeRadiusMeters, ')
          ..write('companyTimezone: $companyTimezone, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttendanceTableTable extends AttendanceTable
    with TableInfo<$AttendanceTableTable, AttendanceEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTimestampMeta = const VerificationMeta(
    'eventTimestamp',
  );
  @override
  late final GeneratedColumn<DateTime> eventTimestamp =
      GeneratedColumn<DateTime>(
        'event_timestamp',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _officeDistanceMetersMeta =
      const VerificationMeta('officeDistanceMeters');
  @override
  late final GeneratedColumn<double> officeDistanceMeters =
      GeneratedColumn<double>(
        'office_distance_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _companyDateMeta = const VerificationMeta(
    'companyDate',
  );
  @override
  late final GeneratedColumn<String> companyDate = GeneratedColumn<String>(
    'company_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localSequenceMeta = const VerificationMeta(
    'localSequence',
  );
  @override
  late final GeneratedColumn<int> localSequence = GeneratedColumn<int>(
    'local_sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDING'),
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastAttemptAtMeta = const VerificationMeta(
    'lastAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverAttendanceIdMeta =
      const VerificationMeta('serverAttendanceId');
  @override
  late final GeneratedColumn<String> serverAttendanceId =
      GeneratedColumn<String>(
        'server_attendance_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventId,
    employeeId,
    eventType,
    eventTimestamp,
    latitude,
    longitude,
    officeDistanceMeters,
    companyDate,
    localSequence,
    createdAt,
    syncStatus,
    retryCount,
    lastAttemptAt,
    lastError,
    serverAttendanceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttendanceEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('event_timestamp')) {
      context.handle(
        _eventTimestampMeta,
        eventTimestamp.isAcceptableOrUnknown(
          data['event_timestamp']!,
          _eventTimestampMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_eventTimestampMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('office_distance_meters')) {
      context.handle(
        _officeDistanceMetersMeta,
        officeDistanceMeters.isAcceptableOrUnknown(
          data['office_distance_meters']!,
          _officeDistanceMetersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_officeDistanceMetersMeta);
    }
    if (data.containsKey('company_date')) {
      context.handle(
        _companyDateMeta,
        companyDate.isAcceptableOrUnknown(
          data['company_date']!,
          _companyDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_companyDateMeta);
    }
    if (data.containsKey('local_sequence')) {
      context.handle(
        _localSequenceMeta,
        localSequence.isAcceptableOrUnknown(
          data['local_sequence']!,
          _localSequenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localSequenceMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
        _lastAttemptAtMeta,
        lastAttemptAt.isAcceptableOrUnknown(
          data['last_attempt_at']!,
          _lastAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('server_attendance_id')) {
      context.handle(
        _serverAttendanceIdMeta,
        serverAttendanceId.isAcceptableOrUnknown(
          data['server_attendance_id']!,
          _serverAttendanceIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttendanceEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      eventTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}event_timestamp'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      officeDistanceMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}office_distance_meters'],
      )!,
      companyDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_date'],
      )!,
      localSequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_sequence'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      lastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt_at'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      serverAttendanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_attendance_id'],
      ),
    );
  }

  @override
  $AttendanceTableTable createAlias(String alias) {
    return $AttendanceTableTable(attachedDatabase, alias);
  }
}

class AttendanceEntry extends DataClass implements Insertable<AttendanceEntry> {
  final int id;
  final String eventId;
  final String employeeId;
  final String eventType;
  final DateTime eventTimestamp;
  final double latitude;
  final double longitude;
  final double officeDistanceMeters;
  final String companyDate;
  final int localSequence;
  final DateTime createdAt;
  final String syncStatus;
  final int retryCount;
  final DateTime? lastAttemptAt;
  final String? lastError;
  final String? serverAttendanceId;
  const AttendanceEntry({
    required this.id,
    required this.eventId,
    required this.employeeId,
    required this.eventType,
    required this.eventTimestamp,
    required this.latitude,
    required this.longitude,
    required this.officeDistanceMeters,
    required this.companyDate,
    required this.localSequence,
    required this.createdAt,
    required this.syncStatus,
    required this.retryCount,
    this.lastAttemptAt,
    this.lastError,
    this.serverAttendanceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_id'] = Variable<String>(eventId);
    map['employee_id'] = Variable<String>(employeeId);
    map['event_type'] = Variable<String>(eventType);
    map['event_timestamp'] = Variable<DateTime>(eventTimestamp);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['office_distance_meters'] = Variable<double>(officeDistanceMeters);
    map['company_date'] = Variable<String>(companyDate);
    map['local_sequence'] = Variable<int>(localSequence);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sync_status'] = Variable<String>(syncStatus);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || serverAttendanceId != null) {
      map['server_attendance_id'] = Variable<String>(serverAttendanceId);
    }
    return map;
  }

  AttendanceTableCompanion toCompanion(bool nullToAbsent) {
    return AttendanceTableCompanion(
      id: Value(id),
      eventId: Value(eventId),
      employeeId: Value(employeeId),
      eventType: Value(eventType),
      eventTimestamp: Value(eventTimestamp),
      latitude: Value(latitude),
      longitude: Value(longitude),
      officeDistanceMeters: Value(officeDistanceMeters),
      companyDate: Value(companyDate),
      localSequence: Value(localSequence),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
      retryCount: Value(retryCount),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      serverAttendanceId: serverAttendanceId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverAttendanceId),
    );
  }

  factory AttendanceEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceEntry(
      id: serializer.fromJson<int>(json['id']),
      eventId: serializer.fromJson<String>(json['eventId']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      eventType: serializer.fromJson<String>(json['eventType']),
      eventTimestamp: serializer.fromJson<DateTime>(json['eventTimestamp']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      officeDistanceMeters: serializer.fromJson<double>(
        json['officeDistanceMeters'],
      ),
      companyDate: serializer.fromJson<String>(json['companyDate']),
      localSequence: serializer.fromJson<int>(json['localSequence']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      serverAttendanceId: serializer.fromJson<String?>(
        json['serverAttendanceId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventId': serializer.toJson<String>(eventId),
      'employeeId': serializer.toJson<String>(employeeId),
      'eventType': serializer.toJson<String>(eventType),
      'eventTimestamp': serializer.toJson<DateTime>(eventTimestamp),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'officeDistanceMeters': serializer.toJson<double>(officeDistanceMeters),
      'companyDate': serializer.toJson<String>(companyDate),
      'localSequence': serializer.toJson<int>(localSequence),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
      'lastError': serializer.toJson<String?>(lastError),
      'serverAttendanceId': serializer.toJson<String?>(serverAttendanceId),
    };
  }

  AttendanceEntry copyWith({
    int? id,
    String? eventId,
    String? employeeId,
    String? eventType,
    DateTime? eventTimestamp,
    double? latitude,
    double? longitude,
    double? officeDistanceMeters,
    String? companyDate,
    int? localSequence,
    DateTime? createdAt,
    String? syncStatus,
    int? retryCount,
    Value<DateTime?> lastAttemptAt = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
    Value<String?> serverAttendanceId = const Value.absent(),
  }) => AttendanceEntry(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    employeeId: employeeId ?? this.employeeId,
    eventType: eventType ?? this.eventType,
    eventTimestamp: eventTimestamp ?? this.eventTimestamp,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    officeDistanceMeters: officeDistanceMeters ?? this.officeDistanceMeters,
    companyDate: companyDate ?? this.companyDate,
    localSequence: localSequence ?? this.localSequence,
    createdAt: createdAt ?? this.createdAt,
    syncStatus: syncStatus ?? this.syncStatus,
    retryCount: retryCount ?? this.retryCount,
    lastAttemptAt: lastAttemptAt.present
        ? lastAttemptAt.value
        : this.lastAttemptAt,
    lastError: lastError.present ? lastError.value : this.lastError,
    serverAttendanceId: serverAttendanceId.present
        ? serverAttendanceId.value
        : this.serverAttendanceId,
  );
  AttendanceEntry copyWithCompanion(AttendanceTableCompanion data) {
    return AttendanceEntry(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      eventTimestamp: data.eventTimestamp.present
          ? data.eventTimestamp.value
          : this.eventTimestamp,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      officeDistanceMeters: data.officeDistanceMeters.present
          ? data.officeDistanceMeters.value
          : this.officeDistanceMeters,
      companyDate: data.companyDate.present
          ? data.companyDate.value
          : this.companyDate,
      localSequence: data.localSequence.present
          ? data.localSequence.value
          : this.localSequence,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      serverAttendanceId: data.serverAttendanceId.present
          ? data.serverAttendanceId.value
          : this.serverAttendanceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceEntry(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('employeeId: $employeeId, ')
          ..write('eventType: $eventType, ')
          ..write('eventTimestamp: $eventTimestamp, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('officeDistanceMeters: $officeDistanceMeters, ')
          ..write('companyDate: $companyDate, ')
          ..write('localSequence: $localSequence, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('serverAttendanceId: $serverAttendanceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventId,
    employeeId,
    eventType,
    eventTimestamp,
    latitude,
    longitude,
    officeDistanceMeters,
    companyDate,
    localSequence,
    createdAt,
    syncStatus,
    retryCount,
    lastAttemptAt,
    lastError,
    serverAttendanceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceEntry &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.employeeId == this.employeeId &&
          other.eventType == this.eventType &&
          other.eventTimestamp == this.eventTimestamp &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.officeDistanceMeters == this.officeDistanceMeters &&
          other.companyDate == this.companyDate &&
          other.localSequence == this.localSequence &&
          other.createdAt == this.createdAt &&
          other.syncStatus == this.syncStatus &&
          other.retryCount == this.retryCount &&
          other.lastAttemptAt == this.lastAttemptAt &&
          other.lastError == this.lastError &&
          other.serverAttendanceId == this.serverAttendanceId);
}

class AttendanceTableCompanion extends UpdateCompanion<AttendanceEntry> {
  final Value<int> id;
  final Value<String> eventId;
  final Value<String> employeeId;
  final Value<String> eventType;
  final Value<DateTime> eventTimestamp;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> officeDistanceMeters;
  final Value<String> companyDate;
  final Value<int> localSequence;
  final Value<DateTime> createdAt;
  final Value<String> syncStatus;
  final Value<int> retryCount;
  final Value<DateTime?> lastAttemptAt;
  final Value<String?> lastError;
  final Value<String?> serverAttendanceId;
  const AttendanceTableCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.eventTimestamp = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.officeDistanceMeters = const Value.absent(),
    this.companyDate = const Value.absent(),
    this.localSequence = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.serverAttendanceId = const Value.absent(),
  });
  AttendanceTableCompanion.insert({
    this.id = const Value.absent(),
    required String eventId,
    required String employeeId,
    required String eventType,
    required DateTime eventTimestamp,
    required double latitude,
    required double longitude,
    required double officeDistanceMeters,
    required String companyDate,
    required int localSequence,
    required DateTime createdAt,
    this.syncStatus = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.serverAttendanceId = const Value.absent(),
  }) : eventId = Value(eventId),
       employeeId = Value(employeeId),
       eventType = Value(eventType),
       eventTimestamp = Value(eventTimestamp),
       latitude = Value(latitude),
       longitude = Value(longitude),
       officeDistanceMeters = Value(officeDistanceMeters),
       companyDate = Value(companyDate),
       localSequence = Value(localSequence),
       createdAt = Value(createdAt);
  static Insertable<AttendanceEntry> custom({
    Expression<int>? id,
    Expression<String>? eventId,
    Expression<String>? employeeId,
    Expression<String>? eventType,
    Expression<DateTime>? eventTimestamp,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? officeDistanceMeters,
    Expression<String>? companyDate,
    Expression<int>? localSequence,
    Expression<DateTime>? createdAt,
    Expression<String>? syncStatus,
    Expression<int>? retryCount,
    Expression<DateTime>? lastAttemptAt,
    Expression<String>? lastError,
    Expression<String>? serverAttendanceId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (employeeId != null) 'employee_id': employeeId,
      if (eventType != null) 'event_type': eventType,
      if (eventTimestamp != null) 'event_timestamp': eventTimestamp,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (officeDistanceMeters != null)
        'office_distance_meters': officeDistanceMeters,
      if (companyDate != null) 'company_date': companyDate,
      if (localSequence != null) 'local_sequence': localSequence,
      if (createdAt != null) 'created_at': createdAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (lastError != null) 'last_error': lastError,
      if (serverAttendanceId != null)
        'server_attendance_id': serverAttendanceId,
    });
  }

  AttendanceTableCompanion copyWith({
    Value<int>? id,
    Value<String>? eventId,
    Value<String>? employeeId,
    Value<String>? eventType,
    Value<DateTime>? eventTimestamp,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<double>? officeDistanceMeters,
    Value<String>? companyDate,
    Value<int>? localSequence,
    Value<DateTime>? createdAt,
    Value<String>? syncStatus,
    Value<int>? retryCount,
    Value<DateTime?>? lastAttemptAt,
    Value<String?>? lastError,
    Value<String?>? serverAttendanceId,
  }) {
    return AttendanceTableCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      employeeId: employeeId ?? this.employeeId,
      eventType: eventType ?? this.eventType,
      eventTimestamp: eventTimestamp ?? this.eventTimestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      officeDistanceMeters: officeDistanceMeters ?? this.officeDistanceMeters,
      companyDate: companyDate ?? this.companyDate,
      localSequence: localSequence ?? this.localSequence,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      retryCount: retryCount ?? this.retryCount,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      lastError: lastError ?? this.lastError,
      serverAttendanceId: serverAttendanceId ?? this.serverAttendanceId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (eventTimestamp.present) {
      map['event_timestamp'] = Variable<DateTime>(eventTimestamp.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (officeDistanceMeters.present) {
      map['office_distance_meters'] = Variable<double>(
        officeDistanceMeters.value,
      );
    }
    if (companyDate.present) {
      map['company_date'] = Variable<String>(companyDate.value);
    }
    if (localSequence.present) {
      map['local_sequence'] = Variable<int>(localSequence.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (serverAttendanceId.present) {
      map['server_attendance_id'] = Variable<String>(serverAttendanceId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceTableCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('employeeId: $employeeId, ')
          ..write('eventType: $eventType, ')
          ..write('eventTimestamp: $eventTimestamp, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('officeDistanceMeters: $officeDistanceMeters, ')
          ..write('companyDate: $companyDate, ')
          ..write('localSequence: $localSequence, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('serverAttendanceId: $serverAttendanceId')
          ..write(')'))
        .toString();
  }
}

class $LeaveBalanceTableTable extends LeaveBalanceTable
    with TableInfo<$LeaveBalanceTableTable, LeaveBalanceEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeaveBalanceTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _casualLeavesMeta = const VerificationMeta(
    'casualLeaves',
  );
  @override
  late final GeneratedColumn<int> casualLeaves = GeneratedColumn<int>(
    'casual_leaves',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sickLeavesMeta = const VerificationMeta(
    'sickLeaves',
  );
  @override
  late final GeneratedColumn<int> sickLeaves = GeneratedColumn<int>(
    'sick_leaves',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    employeeId,
    casualLeaves,
    sickLeaves,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leave_balance_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeaveBalanceEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('casual_leaves')) {
      context.handle(
        _casualLeavesMeta,
        casualLeaves.isAcceptableOrUnknown(
          data['casual_leaves']!,
          _casualLeavesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_casualLeavesMeta);
    }
    if (data.containsKey('sick_leaves')) {
      context.handle(
        _sickLeavesMeta,
        sickLeaves.isAcceptableOrUnknown(data['sick_leaves']!, _sickLeavesMeta),
      );
    } else if (isInserting) {
      context.missing(_sickLeavesMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {employeeId};
  @override
  LeaveBalanceEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeaveBalanceEntry(
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      )!,
      casualLeaves: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}casual_leaves'],
      )!,
      sickLeaves: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sick_leaves'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      )!,
    );
  }

  @override
  $LeaveBalanceTableTable createAlias(String alias) {
    return $LeaveBalanceTableTable(attachedDatabase, alias);
  }
}

class LeaveBalanceEntry extends DataClass
    implements Insertable<LeaveBalanceEntry> {
  final String employeeId;
  final int casualLeaves;
  final int sickLeaves;
  final DateTime lastUpdated;
  const LeaveBalanceEntry({
    required this.employeeId,
    required this.casualLeaves,
    required this.sickLeaves,
    required this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['employee_id'] = Variable<String>(employeeId);
    map['casual_leaves'] = Variable<int>(casualLeaves);
    map['sick_leaves'] = Variable<int>(sickLeaves);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  LeaveBalanceTableCompanion toCompanion(bool nullToAbsent) {
    return LeaveBalanceTableCompanion(
      employeeId: Value(employeeId),
      casualLeaves: Value(casualLeaves),
      sickLeaves: Value(sickLeaves),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory LeaveBalanceEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeaveBalanceEntry(
      employeeId: serializer.fromJson<String>(json['employeeId']),
      casualLeaves: serializer.fromJson<int>(json['casualLeaves']),
      sickLeaves: serializer.fromJson<int>(json['sickLeaves']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'employeeId': serializer.toJson<String>(employeeId),
      'casualLeaves': serializer.toJson<int>(casualLeaves),
      'sickLeaves': serializer.toJson<int>(sickLeaves),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  LeaveBalanceEntry copyWith({
    String? employeeId,
    int? casualLeaves,
    int? sickLeaves,
    DateTime? lastUpdated,
  }) => LeaveBalanceEntry(
    employeeId: employeeId ?? this.employeeId,
    casualLeaves: casualLeaves ?? this.casualLeaves,
    sickLeaves: sickLeaves ?? this.sickLeaves,
    lastUpdated: lastUpdated ?? this.lastUpdated,
  );
  LeaveBalanceEntry copyWithCompanion(LeaveBalanceTableCompanion data) {
    return LeaveBalanceEntry(
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      casualLeaves: data.casualLeaves.present
          ? data.casualLeaves.value
          : this.casualLeaves,
      sickLeaves: data.sickLeaves.present
          ? data.sickLeaves.value
          : this.sickLeaves,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeaveBalanceEntry(')
          ..write('employeeId: $employeeId, ')
          ..write('casualLeaves: $casualLeaves, ')
          ..write('sickLeaves: $sickLeaves, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(employeeId, casualLeaves, sickLeaves, lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeaveBalanceEntry &&
          other.employeeId == this.employeeId &&
          other.casualLeaves == this.casualLeaves &&
          other.sickLeaves == this.sickLeaves &&
          other.lastUpdated == this.lastUpdated);
}

class LeaveBalanceTableCompanion extends UpdateCompanion<LeaveBalanceEntry> {
  final Value<String> employeeId;
  final Value<int> casualLeaves;
  final Value<int> sickLeaves;
  final Value<DateTime> lastUpdated;
  final Value<int> rowid;
  const LeaveBalanceTableCompanion({
    this.employeeId = const Value.absent(),
    this.casualLeaves = const Value.absent(),
    this.sickLeaves = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LeaveBalanceTableCompanion.insert({
    required String employeeId,
    required int casualLeaves,
    required int sickLeaves,
    required DateTime lastUpdated,
    this.rowid = const Value.absent(),
  }) : employeeId = Value(employeeId),
       casualLeaves = Value(casualLeaves),
       sickLeaves = Value(sickLeaves),
       lastUpdated = Value(lastUpdated);
  static Insertable<LeaveBalanceEntry> custom({
    Expression<String>? employeeId,
    Expression<int>? casualLeaves,
    Expression<int>? sickLeaves,
    Expression<DateTime>? lastUpdated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (employeeId != null) 'employee_id': employeeId,
      if (casualLeaves != null) 'casual_leaves': casualLeaves,
      if (sickLeaves != null) 'sick_leaves': sickLeaves,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LeaveBalanceTableCompanion copyWith({
    Value<String>? employeeId,
    Value<int>? casualLeaves,
    Value<int>? sickLeaves,
    Value<DateTime>? lastUpdated,
    Value<int>? rowid,
  }) {
    return LeaveBalanceTableCompanion(
      employeeId: employeeId ?? this.employeeId,
      casualLeaves: casualLeaves ?? this.casualLeaves,
      sickLeaves: sickLeaves ?? this.sickLeaves,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (casualLeaves.present) {
      map['casual_leaves'] = Variable<int>(casualLeaves.value);
    }
    if (sickLeaves.present) {
      map['sick_leaves'] = Variable<int>(sickLeaves.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeaveBalanceTableCompanion(')
          ..write('employeeId: $employeeId, ')
          ..write('casualLeaves: $casualLeaves, ')
          ..write('sickLeaves: $sickLeaves, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LeaveRequestTableTable extends LeaveRequestTable
    with TableInfo<$LeaveRequestTableTable, LeaveRequestEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeaveRequestTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _leaveRequestIdMeta = const VerificationMeta(
    'leaveRequestId',
  );
  @override
  late final GeneratedColumn<String> leaveRequestId = GeneratedColumn<String>(
    'leave_request_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _leaveTypeMeta = const VerificationMeta(
    'leaveType',
  );
  @override
  late final GeneratedColumn<String> leaveType = GeneratedColumn<String>(
    'leave_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDING'),
  );
  static const VerificationMeta _submittedAtMeta = const VerificationMeta(
    'submittedAt',
  );
  @override
  late final GeneratedColumn<DateTime> submittedAt = GeneratedColumn<DateTime>(
    'submitted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numberOfDaysMeta = const VerificationMeta(
    'numberOfDays',
  );
  @override
  late final GeneratedColumn<int> numberOfDays = GeneratedColumn<int>(
    'number_of_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    leaveRequestId,
    employeeId,
    leaveType,
    startDate,
    endDate,
    reason,
    status,
    submittedAt,
    numberOfDays,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leave_request_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeaveRequestEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('leave_request_id')) {
      context.handle(
        _leaveRequestIdMeta,
        leaveRequestId.isAcceptableOrUnknown(
          data['leave_request_id']!,
          _leaveRequestIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_leaveRequestIdMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('leave_type')) {
      context.handle(
        _leaveTypeMeta,
        leaveType.isAcceptableOrUnknown(data['leave_type']!, _leaveTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_leaveTypeMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('submitted_at')) {
      context.handle(
        _submittedAtMeta,
        submittedAt.isAcceptableOrUnknown(
          data['submitted_at']!,
          _submittedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_submittedAtMeta);
    }
    if (data.containsKey('number_of_days')) {
      context.handle(
        _numberOfDaysMeta,
        numberOfDays.isAcceptableOrUnknown(
          data['number_of_days']!,
          _numberOfDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numberOfDaysMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LeaveRequestEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeaveRequestEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      leaveRequestId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}leave_request_id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      )!,
      leaveType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}leave_type'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      submittedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}submitted_at'],
      )!,
      numberOfDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number_of_days'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      )!,
    );
  }

  @override
  $LeaveRequestTableTable createAlias(String alias) {
    return $LeaveRequestTableTable(attachedDatabase, alias);
  }
}

class LeaveRequestEntry extends DataClass
    implements Insertable<LeaveRequestEntry> {
  final int id;
  final String leaveRequestId;
  final String employeeId;
  final String leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status;
  final DateTime submittedAt;
  final int numberOfDays;
  final DateTime lastUpdated;
  const LeaveRequestEntry({
    required this.id,
    required this.leaveRequestId,
    required this.employeeId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    required this.submittedAt,
    required this.numberOfDays,
    required this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['leave_request_id'] = Variable<String>(leaveRequestId);
    map['employee_id'] = Variable<String>(employeeId);
    map['leave_type'] = Variable<String>(leaveType);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['reason'] = Variable<String>(reason);
    map['status'] = Variable<String>(status);
    map['submitted_at'] = Variable<DateTime>(submittedAt);
    map['number_of_days'] = Variable<int>(numberOfDays);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  LeaveRequestTableCompanion toCompanion(bool nullToAbsent) {
    return LeaveRequestTableCompanion(
      id: Value(id),
      leaveRequestId: Value(leaveRequestId),
      employeeId: Value(employeeId),
      leaveType: Value(leaveType),
      startDate: Value(startDate),
      endDate: Value(endDate),
      reason: Value(reason),
      status: Value(status),
      submittedAt: Value(submittedAt),
      numberOfDays: Value(numberOfDays),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory LeaveRequestEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeaveRequestEntry(
      id: serializer.fromJson<int>(json['id']),
      leaveRequestId: serializer.fromJson<String>(json['leaveRequestId']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      leaveType: serializer.fromJson<String>(json['leaveType']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      reason: serializer.fromJson<String>(json['reason']),
      status: serializer.fromJson<String>(json['status']),
      submittedAt: serializer.fromJson<DateTime>(json['submittedAt']),
      numberOfDays: serializer.fromJson<int>(json['numberOfDays']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'leaveRequestId': serializer.toJson<String>(leaveRequestId),
      'employeeId': serializer.toJson<String>(employeeId),
      'leaveType': serializer.toJson<String>(leaveType),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'reason': serializer.toJson<String>(reason),
      'status': serializer.toJson<String>(status),
      'submittedAt': serializer.toJson<DateTime>(submittedAt),
      'numberOfDays': serializer.toJson<int>(numberOfDays),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  LeaveRequestEntry copyWith({
    int? id,
    String? leaveRequestId,
    String? employeeId,
    String? leaveType,
    DateTime? startDate,
    DateTime? endDate,
    String? reason,
    String? status,
    DateTime? submittedAt,
    int? numberOfDays,
    DateTime? lastUpdated,
  }) => LeaveRequestEntry(
    id: id ?? this.id,
    leaveRequestId: leaveRequestId ?? this.leaveRequestId,
    employeeId: employeeId ?? this.employeeId,
    leaveType: leaveType ?? this.leaveType,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    reason: reason ?? this.reason,
    status: status ?? this.status,
    submittedAt: submittedAt ?? this.submittedAt,
    numberOfDays: numberOfDays ?? this.numberOfDays,
    lastUpdated: lastUpdated ?? this.lastUpdated,
  );
  LeaveRequestEntry copyWithCompanion(LeaveRequestTableCompanion data) {
    return LeaveRequestEntry(
      id: data.id.present ? data.id.value : this.id,
      leaveRequestId: data.leaveRequestId.present
          ? data.leaveRequestId.value
          : this.leaveRequestId,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      leaveType: data.leaveType.present ? data.leaveType.value : this.leaveType,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      reason: data.reason.present ? data.reason.value : this.reason,
      status: data.status.present ? data.status.value : this.status,
      submittedAt: data.submittedAt.present
          ? data.submittedAt.value
          : this.submittedAt,
      numberOfDays: data.numberOfDays.present
          ? data.numberOfDays.value
          : this.numberOfDays,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeaveRequestEntry(')
          ..write('id: $id, ')
          ..write('leaveRequestId: $leaveRequestId, ')
          ..write('employeeId: $employeeId, ')
          ..write('leaveType: $leaveType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('numberOfDays: $numberOfDays, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    leaveRequestId,
    employeeId,
    leaveType,
    startDate,
    endDate,
    reason,
    status,
    submittedAt,
    numberOfDays,
    lastUpdated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeaveRequestEntry &&
          other.id == this.id &&
          other.leaveRequestId == this.leaveRequestId &&
          other.employeeId == this.employeeId &&
          other.leaveType == this.leaveType &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.reason == this.reason &&
          other.status == this.status &&
          other.submittedAt == this.submittedAt &&
          other.numberOfDays == this.numberOfDays &&
          other.lastUpdated == this.lastUpdated);
}

class LeaveRequestTableCompanion extends UpdateCompanion<LeaveRequestEntry> {
  final Value<int> id;
  final Value<String> leaveRequestId;
  final Value<String> employeeId;
  final Value<String> leaveType;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<String> reason;
  final Value<String> status;
  final Value<DateTime> submittedAt;
  final Value<int> numberOfDays;
  final Value<DateTime> lastUpdated;
  const LeaveRequestTableCompanion({
    this.id = const Value.absent(),
    this.leaveRequestId = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.leaveType = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.reason = const Value.absent(),
    this.status = const Value.absent(),
    this.submittedAt = const Value.absent(),
    this.numberOfDays = const Value.absent(),
    this.lastUpdated = const Value.absent(),
  });
  LeaveRequestTableCompanion.insert({
    this.id = const Value.absent(),
    required String leaveRequestId,
    required String employeeId,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    this.status = const Value.absent(),
    required DateTime submittedAt,
    required int numberOfDays,
    required DateTime lastUpdated,
  }) : leaveRequestId = Value(leaveRequestId),
       employeeId = Value(employeeId),
       leaveType = Value(leaveType),
       startDate = Value(startDate),
       endDate = Value(endDate),
       reason = Value(reason),
       submittedAt = Value(submittedAt),
       numberOfDays = Value(numberOfDays),
       lastUpdated = Value(lastUpdated);
  static Insertable<LeaveRequestEntry> custom({
    Expression<int>? id,
    Expression<String>? leaveRequestId,
    Expression<String>? employeeId,
    Expression<String>? leaveType,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? reason,
    Expression<String>? status,
    Expression<DateTime>? submittedAt,
    Expression<int>? numberOfDays,
    Expression<DateTime>? lastUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (leaveRequestId != null) 'leave_request_id': leaveRequestId,
      if (employeeId != null) 'employee_id': employeeId,
      if (leaveType != null) 'leave_type': leaveType,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (reason != null) 'reason': reason,
      if (status != null) 'status': status,
      if (submittedAt != null) 'submitted_at': submittedAt,
      if (numberOfDays != null) 'number_of_days': numberOfDays,
      if (lastUpdated != null) 'last_updated': lastUpdated,
    });
  }

  LeaveRequestTableCompanion copyWith({
    Value<int>? id,
    Value<String>? leaveRequestId,
    Value<String>? employeeId,
    Value<String>? leaveType,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<String>? reason,
    Value<String>? status,
    Value<DateTime>? submittedAt,
    Value<int>? numberOfDays,
    Value<DateTime>? lastUpdated,
  }) {
    return LeaveRequestTableCompanion(
      id: id ?? this.id,
      leaveRequestId: leaveRequestId ?? this.leaveRequestId,
      employeeId: employeeId ?? this.employeeId,
      leaveType: leaveType ?? this.leaveType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (leaveRequestId.present) {
      map['leave_request_id'] = Variable<String>(leaveRequestId.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (leaveType.present) {
      map['leave_type'] = Variable<String>(leaveType.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (submittedAt.present) {
      map['submitted_at'] = Variable<DateTime>(submittedAt.value);
    }
    if (numberOfDays.present) {
      map['number_of_days'] = Variable<int>(numberOfDays.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeaveRequestTableCompanion(')
          ..write('id: $id, ')
          ..write('leaveRequestId: $leaveRequestId, ')
          ..write('employeeId: $employeeId, ')
          ..write('leaveType: $leaveType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('reason: $reason, ')
          ..write('status: $status, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('numberOfDays: $numberOfDays, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EmployeeTableTable employeeTable = $EmployeeTableTable(this);
  late final $AttendanceTableTable attendanceTable = $AttendanceTableTable(
    this,
  );
  late final $LeaveBalanceTableTable leaveBalanceTable =
      $LeaveBalanceTableTable(this);
  late final $LeaveRequestTableTable leaveRequestTable =
      $LeaveRequestTableTable(this);
  late final EmployeeDao employeeDao = EmployeeDao(this as AppDatabase);
  late final AttendanceDao attendanceDao = AttendanceDao(this as AppDatabase);
  late final LeaveDao leaveDao = LeaveDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    employeeTable,
    attendanceTable,
    leaveBalanceTable,
    leaveRequestTable,
  ];
}

typedef $$EmployeeTableTableCreateCompanionBuilder =
    EmployeeTableCompanion Function({
      required String employeeId,
      required String name,
      required String department,
      required String designation,
      required String email,
      required String joinDate,
      required double officeLatitude,
      required double officeLongitude,
      required double officeRadiusMeters,
      Value<String> companyTimezone,
      required DateTime lastUpdated,
      Value<int> rowid,
    });
typedef $$EmployeeTableTableUpdateCompanionBuilder =
    EmployeeTableCompanion Function({
      Value<String> employeeId,
      Value<String> name,
      Value<String> department,
      Value<String> designation,
      Value<String> email,
      Value<String> joinDate,
      Value<double> officeLatitude,
      Value<double> officeLongitude,
      Value<double> officeRadiusMeters,
      Value<String> companyTimezone,
      Value<DateTime> lastUpdated,
      Value<int> rowid,
    });

class $$EmployeeTableTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeeTableTable> {
  $$EmployeeTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get designation => $composableBuilder(
    column: $table.designation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get joinDate => $composableBuilder(
    column: $table.joinDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get officeLatitude => $composableBuilder(
    column: $table.officeLatitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get officeLongitude => $composableBuilder(
    column: $table.officeLongitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get officeRadiusMeters => $composableBuilder(
    column: $table.officeRadiusMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyTimezone => $composableBuilder(
    column: $table.companyTimezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmployeeTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeeTableTable> {
  $$EmployeeTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get designation => $composableBuilder(
    column: $table.designation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get joinDate => $composableBuilder(
    column: $table.joinDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get officeLatitude => $composableBuilder(
    column: $table.officeLatitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get officeLongitude => $composableBuilder(
    column: $table.officeLongitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get officeRadiusMeters => $composableBuilder(
    column: $table.officeRadiusMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyTimezone => $composableBuilder(
    column: $table.companyTimezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmployeeTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeeTableTable> {
  $$EmployeeTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => column,
  );

  GeneratedColumn<String> get designation => $composableBuilder(
    column: $table.designation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get joinDate =>
      $composableBuilder(column: $table.joinDate, builder: (column) => column);

  GeneratedColumn<double> get officeLatitude => $composableBuilder(
    column: $table.officeLatitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get officeLongitude => $composableBuilder(
    column: $table.officeLongitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get officeRadiusMeters => $composableBuilder(
    column: $table.officeRadiusMeters,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyTimezone => $composableBuilder(
    column: $table.companyTimezone,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );
}

class $$EmployeeTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmployeeTableTable,
          EmployeeEntry,
          $$EmployeeTableTableFilterComposer,
          $$EmployeeTableTableOrderingComposer,
          $$EmployeeTableTableAnnotationComposer,
          $$EmployeeTableTableCreateCompanionBuilder,
          $$EmployeeTableTableUpdateCompanionBuilder,
          (
            EmployeeEntry,
            BaseReferences<_$AppDatabase, $EmployeeTableTable, EmployeeEntry>,
          ),
          EmployeeEntry,
          PrefetchHooks Function()
        > {
  $$EmployeeTableTableTableManager(_$AppDatabase db, $EmployeeTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeeTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeeTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> employeeId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> department = const Value.absent(),
                Value<String> designation = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> joinDate = const Value.absent(),
                Value<double> officeLatitude = const Value.absent(),
                Value<double> officeLongitude = const Value.absent(),
                Value<double> officeRadiusMeters = const Value.absent(),
                Value<String> companyTimezone = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmployeeTableCompanion(
                employeeId: employeeId,
                name: name,
                department: department,
                designation: designation,
                email: email,
                joinDate: joinDate,
                officeLatitude: officeLatitude,
                officeLongitude: officeLongitude,
                officeRadiusMeters: officeRadiusMeters,
                companyTimezone: companyTimezone,
                lastUpdated: lastUpdated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String employeeId,
                required String name,
                required String department,
                required String designation,
                required String email,
                required String joinDate,
                required double officeLatitude,
                required double officeLongitude,
                required double officeRadiusMeters,
                Value<String> companyTimezone = const Value.absent(),
                required DateTime lastUpdated,
                Value<int> rowid = const Value.absent(),
              }) => EmployeeTableCompanion.insert(
                employeeId: employeeId,
                name: name,
                department: department,
                designation: designation,
                email: email,
                joinDate: joinDate,
                officeLatitude: officeLatitude,
                officeLongitude: officeLongitude,
                officeRadiusMeters: officeRadiusMeters,
                companyTimezone: companyTimezone,
                lastUpdated: lastUpdated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmployeeTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmployeeTableTable,
      EmployeeEntry,
      $$EmployeeTableTableFilterComposer,
      $$EmployeeTableTableOrderingComposer,
      $$EmployeeTableTableAnnotationComposer,
      $$EmployeeTableTableCreateCompanionBuilder,
      $$EmployeeTableTableUpdateCompanionBuilder,
      (
        EmployeeEntry,
        BaseReferences<_$AppDatabase, $EmployeeTableTable, EmployeeEntry>,
      ),
      EmployeeEntry,
      PrefetchHooks Function()
    >;
typedef $$AttendanceTableTableCreateCompanionBuilder =
    AttendanceTableCompanion Function({
      Value<int> id,
      required String eventId,
      required String employeeId,
      required String eventType,
      required DateTime eventTimestamp,
      required double latitude,
      required double longitude,
      required double officeDistanceMeters,
      required String companyDate,
      required int localSequence,
      required DateTime createdAt,
      Value<String> syncStatus,
      Value<int> retryCount,
      Value<DateTime?> lastAttemptAt,
      Value<String?> lastError,
      Value<String?> serverAttendanceId,
    });
typedef $$AttendanceTableTableUpdateCompanionBuilder =
    AttendanceTableCompanion Function({
      Value<int> id,
      Value<String> eventId,
      Value<String> employeeId,
      Value<String> eventType,
      Value<DateTime> eventTimestamp,
      Value<double> latitude,
      Value<double> longitude,
      Value<double> officeDistanceMeters,
      Value<String> companyDate,
      Value<int> localSequence,
      Value<DateTime> createdAt,
      Value<String> syncStatus,
      Value<int> retryCount,
      Value<DateTime?> lastAttemptAt,
      Value<String?> lastError,
      Value<String?> serverAttendanceId,
    });

class $$AttendanceTableTableFilterComposer
    extends Composer<_$AppDatabase, $AttendanceTableTable> {
  $$AttendanceTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get eventTimestamp => $composableBuilder(
    column: $table.eventTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get officeDistanceMeters => $composableBuilder(
    column: $table.officeDistanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyDate => $composableBuilder(
    column: $table.companyDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localSequence => $composableBuilder(
    column: $table.localSequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverAttendanceId => $composableBuilder(
    column: $table.serverAttendanceId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AttendanceTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendanceTableTable> {
  $$AttendanceTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get eventTimestamp => $composableBuilder(
    column: $table.eventTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get officeDistanceMeters => $composableBuilder(
    column: $table.officeDistanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyDate => $composableBuilder(
    column: $table.companyDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localSequence => $composableBuilder(
    column: $table.localSequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverAttendanceId => $composableBuilder(
    column: $table.serverAttendanceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttendanceTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendanceTableTable> {
  $$AttendanceTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<DateTime> get eventTimestamp => $composableBuilder(
    column: $table.eventTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get officeDistanceMeters => $composableBuilder(
    column: $table.officeDistanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyDate => $composableBuilder(
    column: $table.companyDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get localSequence => $composableBuilder(
    column: $table.localSequence,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get serverAttendanceId => $composableBuilder(
    column: $table.serverAttendanceId,
    builder: (column) => column,
  );
}

class $$AttendanceTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttendanceTableTable,
          AttendanceEntry,
          $$AttendanceTableTableFilterComposer,
          $$AttendanceTableTableOrderingComposer,
          $$AttendanceTableTableAnnotationComposer,
          $$AttendanceTableTableCreateCompanionBuilder,
          $$AttendanceTableTableUpdateCompanionBuilder,
          (
            AttendanceEntry,
            BaseReferences<
              _$AppDatabase,
              $AttendanceTableTable,
              AttendanceEntry
            >,
          ),
          AttendanceEntry,
          PrefetchHooks Function()
        > {
  $$AttendanceTableTableTableManager(
    _$AppDatabase db,
    $AttendanceTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendanceTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendanceTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendanceTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> eventId = const Value.absent(),
                Value<String> employeeId = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<DateTime> eventTimestamp = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double> officeDistanceMeters = const Value.absent(),
                Value<String> companyDate = const Value.absent(),
                Value<int> localSequence = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String?> serverAttendanceId = const Value.absent(),
              }) => AttendanceTableCompanion(
                id: id,
                eventId: eventId,
                employeeId: employeeId,
                eventType: eventType,
                eventTimestamp: eventTimestamp,
                latitude: latitude,
                longitude: longitude,
                officeDistanceMeters: officeDistanceMeters,
                companyDate: companyDate,
                localSequence: localSequence,
                createdAt: createdAt,
                syncStatus: syncStatus,
                retryCount: retryCount,
                lastAttemptAt: lastAttemptAt,
                lastError: lastError,
                serverAttendanceId: serverAttendanceId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String eventId,
                required String employeeId,
                required String eventType,
                required DateTime eventTimestamp,
                required double latitude,
                required double longitude,
                required double officeDistanceMeters,
                required String companyDate,
                required int localSequence,
                required DateTime createdAt,
                Value<String> syncStatus = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String?> serverAttendanceId = const Value.absent(),
              }) => AttendanceTableCompanion.insert(
                id: id,
                eventId: eventId,
                employeeId: employeeId,
                eventType: eventType,
                eventTimestamp: eventTimestamp,
                latitude: latitude,
                longitude: longitude,
                officeDistanceMeters: officeDistanceMeters,
                companyDate: companyDate,
                localSequence: localSequence,
                createdAt: createdAt,
                syncStatus: syncStatus,
                retryCount: retryCount,
                lastAttemptAt: lastAttemptAt,
                lastError: lastError,
                serverAttendanceId: serverAttendanceId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttendanceTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttendanceTableTable,
      AttendanceEntry,
      $$AttendanceTableTableFilterComposer,
      $$AttendanceTableTableOrderingComposer,
      $$AttendanceTableTableAnnotationComposer,
      $$AttendanceTableTableCreateCompanionBuilder,
      $$AttendanceTableTableUpdateCompanionBuilder,
      (
        AttendanceEntry,
        BaseReferences<_$AppDatabase, $AttendanceTableTable, AttendanceEntry>,
      ),
      AttendanceEntry,
      PrefetchHooks Function()
    >;
typedef $$LeaveBalanceTableTableCreateCompanionBuilder =
    LeaveBalanceTableCompanion Function({
      required String employeeId,
      required int casualLeaves,
      required int sickLeaves,
      required DateTime lastUpdated,
      Value<int> rowid,
    });
typedef $$LeaveBalanceTableTableUpdateCompanionBuilder =
    LeaveBalanceTableCompanion Function({
      Value<String> employeeId,
      Value<int> casualLeaves,
      Value<int> sickLeaves,
      Value<DateTime> lastUpdated,
      Value<int> rowid,
    });

class $$LeaveBalanceTableTableFilterComposer
    extends Composer<_$AppDatabase, $LeaveBalanceTableTable> {
  $$LeaveBalanceTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get casualLeaves => $composableBuilder(
    column: $table.casualLeaves,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sickLeaves => $composableBuilder(
    column: $table.sickLeaves,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LeaveBalanceTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LeaveBalanceTableTable> {
  $$LeaveBalanceTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get casualLeaves => $composableBuilder(
    column: $table.casualLeaves,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sickLeaves => $composableBuilder(
    column: $table.sickLeaves,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LeaveBalanceTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeaveBalanceTableTable> {
  $$LeaveBalanceTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get casualLeaves => $composableBuilder(
    column: $table.casualLeaves,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sickLeaves => $composableBuilder(
    column: $table.sickLeaves,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );
}

class $$LeaveBalanceTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeaveBalanceTableTable,
          LeaveBalanceEntry,
          $$LeaveBalanceTableTableFilterComposer,
          $$LeaveBalanceTableTableOrderingComposer,
          $$LeaveBalanceTableTableAnnotationComposer,
          $$LeaveBalanceTableTableCreateCompanionBuilder,
          $$LeaveBalanceTableTableUpdateCompanionBuilder,
          (
            LeaveBalanceEntry,
            BaseReferences<
              _$AppDatabase,
              $LeaveBalanceTableTable,
              LeaveBalanceEntry
            >,
          ),
          LeaveBalanceEntry,
          PrefetchHooks Function()
        > {
  $$LeaveBalanceTableTableTableManager(
    _$AppDatabase db,
    $LeaveBalanceTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeaveBalanceTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeaveBalanceTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeaveBalanceTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> employeeId = const Value.absent(),
                Value<int> casualLeaves = const Value.absent(),
                Value<int> sickLeaves = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeaveBalanceTableCompanion(
                employeeId: employeeId,
                casualLeaves: casualLeaves,
                sickLeaves: sickLeaves,
                lastUpdated: lastUpdated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String employeeId,
                required int casualLeaves,
                required int sickLeaves,
                required DateTime lastUpdated,
                Value<int> rowid = const Value.absent(),
              }) => LeaveBalanceTableCompanion.insert(
                employeeId: employeeId,
                casualLeaves: casualLeaves,
                sickLeaves: sickLeaves,
                lastUpdated: lastUpdated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LeaveBalanceTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeaveBalanceTableTable,
      LeaveBalanceEntry,
      $$LeaveBalanceTableTableFilterComposer,
      $$LeaveBalanceTableTableOrderingComposer,
      $$LeaveBalanceTableTableAnnotationComposer,
      $$LeaveBalanceTableTableCreateCompanionBuilder,
      $$LeaveBalanceTableTableUpdateCompanionBuilder,
      (
        LeaveBalanceEntry,
        BaseReferences<
          _$AppDatabase,
          $LeaveBalanceTableTable,
          LeaveBalanceEntry
        >,
      ),
      LeaveBalanceEntry,
      PrefetchHooks Function()
    >;
typedef $$LeaveRequestTableTableCreateCompanionBuilder =
    LeaveRequestTableCompanion Function({
      Value<int> id,
      required String leaveRequestId,
      required String employeeId,
      required String leaveType,
      required DateTime startDate,
      required DateTime endDate,
      required String reason,
      Value<String> status,
      required DateTime submittedAt,
      required int numberOfDays,
      required DateTime lastUpdated,
    });
typedef $$LeaveRequestTableTableUpdateCompanionBuilder =
    LeaveRequestTableCompanion Function({
      Value<int> id,
      Value<String> leaveRequestId,
      Value<String> employeeId,
      Value<String> leaveType,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<String> reason,
      Value<String> status,
      Value<DateTime> submittedAt,
      Value<int> numberOfDays,
      Value<DateTime> lastUpdated,
    });

class $$LeaveRequestTableTableFilterComposer
    extends Composer<_$AppDatabase, $LeaveRequestTableTable> {
  $$LeaveRequestTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leaveRequestId => $composableBuilder(
    column: $table.leaveRequestId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leaveType => $composableBuilder(
    column: $table.leaveType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numberOfDays => $composableBuilder(
    column: $table.numberOfDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LeaveRequestTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LeaveRequestTableTable> {
  $$LeaveRequestTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leaveRequestId => $composableBuilder(
    column: $table.leaveRequestId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leaveType => $composableBuilder(
    column: $table.leaveType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numberOfDays => $composableBuilder(
    column: $table.numberOfDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LeaveRequestTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeaveRequestTableTable> {
  $$LeaveRequestTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get leaveRequestId => $composableBuilder(
    column: $table.leaveRequestId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get leaveType =>
      $composableBuilder(column: $table.leaveType, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get numberOfDays => $composableBuilder(
    column: $table.numberOfDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );
}

class $$LeaveRequestTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeaveRequestTableTable,
          LeaveRequestEntry,
          $$LeaveRequestTableTableFilterComposer,
          $$LeaveRequestTableTableOrderingComposer,
          $$LeaveRequestTableTableAnnotationComposer,
          $$LeaveRequestTableTableCreateCompanionBuilder,
          $$LeaveRequestTableTableUpdateCompanionBuilder,
          (
            LeaveRequestEntry,
            BaseReferences<
              _$AppDatabase,
              $LeaveRequestTableTable,
              LeaveRequestEntry
            >,
          ),
          LeaveRequestEntry,
          PrefetchHooks Function()
        > {
  $$LeaveRequestTableTableTableManager(
    _$AppDatabase db,
    $LeaveRequestTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeaveRequestTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeaveRequestTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeaveRequestTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> leaveRequestId = const Value.absent(),
                Value<String> employeeId = const Value.absent(),
                Value<String> leaveType = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> submittedAt = const Value.absent(),
                Value<int> numberOfDays = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
              }) => LeaveRequestTableCompanion(
                id: id,
                leaveRequestId: leaveRequestId,
                employeeId: employeeId,
                leaveType: leaveType,
                startDate: startDate,
                endDate: endDate,
                reason: reason,
                status: status,
                submittedAt: submittedAt,
                numberOfDays: numberOfDays,
                lastUpdated: lastUpdated,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String leaveRequestId,
                required String employeeId,
                required String leaveType,
                required DateTime startDate,
                required DateTime endDate,
                required String reason,
                Value<String> status = const Value.absent(),
                required DateTime submittedAt,
                required int numberOfDays,
                required DateTime lastUpdated,
              }) => LeaveRequestTableCompanion.insert(
                id: id,
                leaveRequestId: leaveRequestId,
                employeeId: employeeId,
                leaveType: leaveType,
                startDate: startDate,
                endDate: endDate,
                reason: reason,
                status: status,
                submittedAt: submittedAt,
                numberOfDays: numberOfDays,
                lastUpdated: lastUpdated,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LeaveRequestTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeaveRequestTableTable,
      LeaveRequestEntry,
      $$LeaveRequestTableTableFilterComposer,
      $$LeaveRequestTableTableOrderingComposer,
      $$LeaveRequestTableTableAnnotationComposer,
      $$LeaveRequestTableTableCreateCompanionBuilder,
      $$LeaveRequestTableTableUpdateCompanionBuilder,
      (
        LeaveRequestEntry,
        BaseReferences<
          _$AppDatabase,
          $LeaveRequestTableTable,
          LeaveRequestEntry
        >,
      ),
      LeaveRequestEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EmployeeTableTableTableManager get employeeTable =>
      $$EmployeeTableTableTableManager(_db, _db.employeeTable);
  $$AttendanceTableTableTableManager get attendanceTable =>
      $$AttendanceTableTableTableManager(_db, _db.attendanceTable);
  $$LeaveBalanceTableTableTableManager get leaveBalanceTable =>
      $$LeaveBalanceTableTableTableManager(_db, _db.leaveBalanceTable);
  $$LeaveRequestTableTableTableManager get leaveRequestTable =>
      $$LeaveRequestTableTableTableManager(_db, _db.leaveRequestTable);
}
