// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    address,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  /// Primary key — auto-increment unique ID for each customer
  /// Why: Database needs a unique identifier to link complaints to this customer
  final int id;

  /// Customer name or site name
  /// Example: "Acme Corp", "Delhi Office Building 2"
  final String name;

  /// Phone number for the customer
  /// Why: Need to call them when we have updates
  /// Note: Stored as text (preserves +91, formatting, etc.)
  final String phone;

  /// Physical location of the CCTV installation
  /// Example: "Sector 5, Chandigarh"
  final String address;

  /// Notes about this customer/site
  /// Why: Owner might store: "Has 4 cameras", "DVR model XYZ", etc.
  final String? notes;

  /// Timestamp when this customer was added
  /// Why: Useful for reporting ("customers added this month")
  final DateTime createdAt;
  const Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['address'] = Variable<String>(address);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
      address: Value(address),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      address: serializer.fromJson<String>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'address': serializer.toJson<String>(address),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Customer copyWith({
    int? id,
    String? name,
    String? phone,
    String? address,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => Customer(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    address: address ?? this.address,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, address, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> address;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String phone,
    required String address,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       phone = Value(phone),
       address = Value(address);
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CustomersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? phone,
    Value<String>? address,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TechniciansTable extends Technicians
    with TableInfo<$TechniciansTable, Technician> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TechniciansTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _specialtyMeta = const VerificationMeta(
    'specialty',
  );
  @override
  late final GeneratedColumn<String> specialty = GeneratedColumn<String>(
    'specialty',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    specialty,
    active,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'technicians';
  @override
  VerificationContext validateIntegrity(
    Insertable<Technician> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('specialty')) {
      context.handle(
        _specialtyMeta,
        specialty.isAcceptableOrUnknown(data['specialty']!, _specialtyMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Technician map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Technician(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      specialty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}specialty'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TechniciansTable createAlias(String alias) {
    return $TechniciansTable(attachedDatabase, alias);
  }
}

class Technician extends DataClass implements Insertable<Technician> {
  /// Primary key — unique ID for each technician
  final int id;

  /// Technician's name
  final String name;

  /// Technician's phone number
  /// Why: Owner calls them to assign jobs, or customer calls them directly
  final String phone;

  /// Notes about this technician's skills
  /// Example: "Good with DVR systems", "Expert in IP cameras"
  /// Why: Owner remembers which tech to assign based on the issue type
  final String? specialty;

  /// Is this technician currently available?
  /// Example: active=true (available), active=false (terminated, archived)
  /// Why: Owner might want to keep terminated techs in history but not assign new jobs
  final bool active;

  /// When was this technician added to the system
  final DateTime createdAt;
  const Technician({
    required this.id,
    required this.name,
    required this.phone,
    this.specialty,
    required this.active,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    if (!nullToAbsent || specialty != null) {
      map['specialty'] = Variable<String>(specialty);
    }
    map['active'] = Variable<bool>(active);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TechniciansCompanion toCompanion(bool nullToAbsent) {
    return TechniciansCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
      specialty: specialty == null && nullToAbsent
          ? const Value.absent()
          : Value(specialty),
      active: Value(active),
      createdAt: Value(createdAt),
    );
  }

  factory Technician.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Technician(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      specialty: serializer.fromJson<String?>(json['specialty']),
      active: serializer.fromJson<bool>(json['active']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'specialty': serializer.toJson<String?>(specialty),
      'active': serializer.toJson<bool>(active),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Technician copyWith({
    int? id,
    String? name,
    String? phone,
    Value<String?> specialty = const Value.absent(),
    bool? active,
    DateTime? createdAt,
  }) => Technician(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    specialty: specialty.present ? specialty.value : this.specialty,
    active: active ?? this.active,
    createdAt: createdAt ?? this.createdAt,
  );
  Technician copyWithCompanion(TechniciansCompanion data) {
    return Technician(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      specialty: data.specialty.present ? data.specialty.value : this.specialty,
      active: data.active.present ? data.active.value : this.active,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Technician(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('specialty: $specialty, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, phone, specialty, active, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Technician &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.specialty == this.specialty &&
          other.active == this.active &&
          other.createdAt == this.createdAt);
}

class TechniciansCompanion extends UpdateCompanion<Technician> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> phone;
  final Value<String?> specialty;
  final Value<bool> active;
  final Value<DateTime> createdAt;
  const TechniciansCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.specialty = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TechniciansCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String phone,
    this.specialty = const Value.absent(),
    this.active = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       phone = Value(phone);
  static Insertable<Technician> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? specialty,
    Expression<bool>? active,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (specialty != null) 'specialty': specialty,
      if (active != null) 'active': active,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TechniciansCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? phone,
    Value<String?>? specialty,
    Value<bool>? active,
    Value<DateTime>? createdAt,
  }) {
    return TechniciansCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      specialty: specialty ?? this.specialty,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (specialty.present) {
      map['specialty'] = Variable<String>(specialty.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TechniciansCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('specialty: $specialty, ')
          ..write('active: $active, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ComplaintsTable extends Complaints
    with TableInfo<$ComplaintsTable, Complaint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComplaintsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Priority, String> priority =
      GeneratedColumn<String>(
        'priority',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('normal'),
      ).withConverter<Priority>($ComplaintsTable.$converterpriority);
  @override
  late final GeneratedColumnWithTypeConverter<ComplaintStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('newStatus'),
      ).withConverter<ComplaintStatus>($ComplaintsTable.$converterstatus);
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _assignedTechnicianIdMeta =
      const VerificationMeta('assignedTechnicianId');
  @override
  late final GeneratedColumn<int> assignedTechnicianId = GeneratedColumn<int>(
    'assigned_technician_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES technicians (id)',
    ),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _dueByMeta = const VerificationMeta('dueBy');
  @override
  late final GeneratedColumn<DateTime> dueBy = GeneratedColumn<DateTime>(
    'due_by',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resolvedAtMeta = const VerificationMeta(
    'resolvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> resolvedAt = GeneratedColumn<DateTime>(
    'resolved_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoUrisMeta = const VerificationMeta(
    'photoUris',
  );
  @override
  late final GeneratedColumn<String> photoUris = GeneratedColumn<String>(
    'photo_uris',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    priority,
    status,
    customerId,
    assignedTechnicianId,
    createdAt,
    dueBy,
    resolvedAt,
    photoUris,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'complaints';
  @override
  VerificationContext validateIntegrity(
    Insertable<Complaint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('assigned_technician_id')) {
      context.handle(
        _assignedTechnicianIdMeta,
        assignedTechnicianId.isAcceptableOrUnknown(
          data['assigned_technician_id']!,
          _assignedTechnicianIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('due_by')) {
      context.handle(
        _dueByMeta,
        dueBy.isAcceptableOrUnknown(data['due_by']!, _dueByMeta),
      );
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
        _resolvedAtMeta,
        resolvedAt.isAcceptableOrUnknown(data['resolved_at']!, _resolvedAtMeta),
      );
    }
    if (data.containsKey('photo_uris')) {
      context.handle(
        _photoUrisMeta,
        photoUris.isAcceptableOrUnknown(data['photo_uris']!, _photoUrisMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Complaint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Complaint(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      priority: $ComplaintsTable.$converterpriority.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}priority'],
        )!,
      ),
      status: $ComplaintsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_id'],
      )!,
      assignedTechnicianId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assigned_technician_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      dueBy: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_by'],
      ),
      resolvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resolved_at'],
      ),
      photoUris: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_uris'],
      ),
    );
  }

  @override
  $ComplaintsTable createAlias(String alias) {
    return $ComplaintsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Priority, String, String> $converterpriority =
      const EnumNameConverter<Priority>(Priority.values);
  static JsonTypeConverter2<ComplaintStatus, String, String> $converterstatus =
      const EnumNameConverter<ComplaintStatus>(ComplaintStatus.values);
}

class Complaint extends DataClass implements Insertable<Complaint> {
  /// Primary key
  final int id;

  /// Title/summary of the complaint
  /// Example: "Camera 2 not recording", "DVR keeps rebooting"
  /// Why: Owner needs a quick glance at what the issue is
  /// Length: Keep to ~60 chars so it fits on screen
  final String title;

  /// Full description of the complaint
  /// Example: "Camera 2 (front entrance) stopped recording at 2 PM today.
  /// Customer says it was working yesterday. No visible damage to camera."
  final String description;

  /// Priority level
  /// Low: "Nice to fix soon, no rush"
  /// Normal: "Standard issue, routine fix"
  /// Urgent: "System down, critical business impact"
  /// Why: Owner/technician prioritizes work
  /// Type: TEXT (Drift stores enums as strings)
  final Priority priority;

  /// Current status in the workflow
  /// Type: TEXT (Drift stores enums as strings)
  final ComplaintStatus status;

  /// Foreign key: Which customer is this complaint about?
  /// Why: Link complaint to customer to see all their complaints
  /// Example: customerId=5 → links to Customers.id=5
  /// .references(): tells Drift this is a foreign key constraint
  final int customerId;

  /// Foreign key: Which technician is assigned? (Can be null = unassigned)
  /// Why: Owner assigns work, technician sees their jobs
  /// nullable: a complaint can exist without assignment
  final int? assignedTechnicianId;

  /// When was this complaint logged?
  /// Example: "Aug 17, 2026 at 3:45 PM"
  /// Why: Helps identify oldest unresolved complaints
  final DateTime createdAt;

  /// Target resolution time (optional)
  /// Example: Owner says "Fix by tomorrow 5 PM"
  /// Why: Drives overdue notifications
  /// nullable: no deadline if owner doesn't set one
  final DateTime? dueBy;

  /// When was this complaint marked resolved?
  /// Example: "Aug 17, 2026 at 5:30 PM"
  /// nullable: only has a value if status='resolved' or 'reopened'
  /// Why: Track average resolution time, SLA reporting
  final DateTime? resolvedAt;

  /// Photo URI(s) attached to this complaint
  /// Example: "file:///storage/emulated/.../complaint_123_photo1.jpg"
  /// Why: Visual proof of issue (broken camera, torn wiring, etc.)
  /// nullable: not all complaints have photos
  /// Stored as JSON array: ["photo1.jpg", "photo2.jpg"]
  final String? photoUris;
  const Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.customerId,
    this.assignedTechnicianId,
    required this.createdAt,
    this.dueBy,
    this.resolvedAt,
    this.photoUris,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    {
      map['priority'] = Variable<String>(
        $ComplaintsTable.$converterpriority.toSql(priority),
      );
    }
    {
      map['status'] = Variable<String>(
        $ComplaintsTable.$converterstatus.toSql(status),
      );
    }
    map['customer_id'] = Variable<int>(customerId);
    if (!nullToAbsent || assignedTechnicianId != null) {
      map['assigned_technician_id'] = Variable<int>(assignedTechnicianId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || dueBy != null) {
      map['due_by'] = Variable<DateTime>(dueBy);
    }
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt);
    }
    if (!nullToAbsent || photoUris != null) {
      map['photo_uris'] = Variable<String>(photoUris);
    }
    return map;
  }

  ComplaintsCompanion toCompanion(bool nullToAbsent) {
    return ComplaintsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      priority: Value(priority),
      status: Value(status),
      customerId: Value(customerId),
      assignedTechnicianId: assignedTechnicianId == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedTechnicianId),
      createdAt: Value(createdAt),
      dueBy: dueBy == null && nullToAbsent
          ? const Value.absent()
          : Value(dueBy),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
      photoUris: photoUris == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUris),
    );
  }

  factory Complaint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Complaint(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      priority: $ComplaintsTable.$converterpriority.fromJson(
        serializer.fromJson<String>(json['priority']),
      ),
      status: $ComplaintsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      customerId: serializer.fromJson<int>(json['customerId']),
      assignedTechnicianId: serializer.fromJson<int?>(
        json['assignedTechnicianId'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      dueBy: serializer.fromJson<DateTime?>(json['dueBy']),
      resolvedAt: serializer.fromJson<DateTime?>(json['resolvedAt']),
      photoUris: serializer.fromJson<String?>(json['photoUris']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'priority': serializer.toJson<String>(
        $ComplaintsTable.$converterpriority.toJson(priority),
      ),
      'status': serializer.toJson<String>(
        $ComplaintsTable.$converterstatus.toJson(status),
      ),
      'customerId': serializer.toJson<int>(customerId),
      'assignedTechnicianId': serializer.toJson<int?>(assignedTechnicianId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'dueBy': serializer.toJson<DateTime?>(dueBy),
      'resolvedAt': serializer.toJson<DateTime?>(resolvedAt),
      'photoUris': serializer.toJson<String?>(photoUris),
    };
  }

  Complaint copyWith({
    int? id,
    String? title,
    String? description,
    Priority? priority,
    ComplaintStatus? status,
    int? customerId,
    Value<int?> assignedTechnicianId = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> dueBy = const Value.absent(),
    Value<DateTime?> resolvedAt = const Value.absent(),
    Value<String?> photoUris = const Value.absent(),
  }) => Complaint(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    priority: priority ?? this.priority,
    status: status ?? this.status,
    customerId: customerId ?? this.customerId,
    assignedTechnicianId: assignedTechnicianId.present
        ? assignedTechnicianId.value
        : this.assignedTechnicianId,
    createdAt: createdAt ?? this.createdAt,
    dueBy: dueBy.present ? dueBy.value : this.dueBy,
    resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
    photoUris: photoUris.present ? photoUris.value : this.photoUris,
  );
  Complaint copyWithCompanion(ComplaintsCompanion data) {
    return Complaint(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      priority: data.priority.present ? data.priority.value : this.priority,
      status: data.status.present ? data.status.value : this.status,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      assignedTechnicianId: data.assignedTechnicianId.present
          ? data.assignedTechnicianId.value
          : this.assignedTechnicianId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      dueBy: data.dueBy.present ? data.dueBy.value : this.dueBy,
      resolvedAt: data.resolvedAt.present
          ? data.resolvedAt.value
          : this.resolvedAt,
      photoUris: data.photoUris.present ? data.photoUris.value : this.photoUris,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Complaint(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('customerId: $customerId, ')
          ..write('assignedTechnicianId: $assignedTechnicianId, ')
          ..write('createdAt: $createdAt, ')
          ..write('dueBy: $dueBy, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('photoUris: $photoUris')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    priority,
    status,
    customerId,
    assignedTechnicianId,
    createdAt,
    dueBy,
    resolvedAt,
    photoUris,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Complaint &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.priority == this.priority &&
          other.status == this.status &&
          other.customerId == this.customerId &&
          other.assignedTechnicianId == this.assignedTechnicianId &&
          other.createdAt == this.createdAt &&
          other.dueBy == this.dueBy &&
          other.resolvedAt == this.resolvedAt &&
          other.photoUris == this.photoUris);
}

class ComplaintsCompanion extends UpdateCompanion<Complaint> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> description;
  final Value<Priority> priority;
  final Value<ComplaintStatus> status;
  final Value<int> customerId;
  final Value<int?> assignedTechnicianId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> dueBy;
  final Value<DateTime?> resolvedAt;
  final Value<String?> photoUris;
  const ComplaintsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.customerId = const Value.absent(),
    this.assignedTechnicianId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.dueBy = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.photoUris = const Value.absent(),
  });
  ComplaintsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String description,
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    required int customerId,
    this.assignedTechnicianId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.dueBy = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.photoUris = const Value.absent(),
  }) : title = Value(title),
       description = Value(description),
       customerId = Value(customerId);
  static Insertable<Complaint> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? priority,
    Expression<String>? status,
    Expression<int>? customerId,
    Expression<int>? assignedTechnicianId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? dueBy,
    Expression<DateTime>? resolvedAt,
    Expression<String>? photoUris,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (customerId != null) 'customer_id': customerId,
      if (assignedTechnicianId != null)
        'assigned_technician_id': assignedTechnicianId,
      if (createdAt != null) 'created_at': createdAt,
      if (dueBy != null) 'due_by': dueBy,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (photoUris != null) 'photo_uris': photoUris,
    });
  }

  ComplaintsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? description,
    Value<Priority>? priority,
    Value<ComplaintStatus>? status,
    Value<int>? customerId,
    Value<int?>? assignedTechnicianId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? dueBy,
    Value<DateTime?>? resolvedAt,
    Value<String?>? photoUris,
  }) {
    return ComplaintsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      customerId: customerId ?? this.customerId,
      assignedTechnicianId: assignedTechnicianId ?? this.assignedTechnicianId,
      createdAt: createdAt ?? this.createdAt,
      dueBy: dueBy ?? this.dueBy,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      photoUris: photoUris ?? this.photoUris,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(
        $ComplaintsTable.$converterpriority.toSql(priority.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ComplaintsTable.$converterstatus.toSql(status.value),
      );
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (assignedTechnicianId.present) {
      map['assigned_technician_id'] = Variable<int>(assignedTechnicianId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (dueBy.present) {
      map['due_by'] = Variable<DateTime>(dueBy.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt.value);
    }
    if (photoUris.present) {
      map['photo_uris'] = Variable<String>(photoUris.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComplaintsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('customerId: $customerId, ')
          ..write('assignedTechnicianId: $assignedTechnicianId, ')
          ..write('createdAt: $createdAt, ')
          ..write('dueBy: $dueBy, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('photoUris: $photoUris')
          ..write(')'))
        .toString();
  }
}

class $ComplaintNotesTable extends ComplaintNotes
    with TableInfo<$ComplaintNotesTable, ComplaintNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComplaintNotesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _complaintIdMeta = const VerificationMeta(
    'complaintId',
  );
  @override
  late final GeneratedColumn<int> complaintId = GeneratedColumn<int>(
    'complaint_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES complaints (id)',
    ),
  );
  static const VerificationMeta _textNoteMeta = const VerificationMeta(
    'textNote',
  );
  @override
  late final GeneratedColumn<String> textNote = GeneratedColumn<String>(
    'text_note',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, complaintId, textNote, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'complaint_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<ComplaintNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('complaint_id')) {
      context.handle(
        _complaintIdMeta,
        complaintId.isAcceptableOrUnknown(
          data['complaint_id']!,
          _complaintIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_complaintIdMeta);
    }
    if (data.containsKey('text_note')) {
      context.handle(
        _textNoteMeta,
        textNote.isAcceptableOrUnknown(data['text_note']!, _textNoteMeta),
      );
    } else if (isInserting) {
      context.missing(_textNoteMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ComplaintNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ComplaintNote(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      complaintId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}complaint_id'],
      )!,
      textNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_note'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ComplaintNotesTable createAlias(String alias) {
    return $ComplaintNotesTable(attachedDatabase, alias);
  }
}

class ComplaintNote extends DataClass implements Insertable<ComplaintNote> {
  /// Primary key
  final int id;

  /// Which complaint does this note belong to?
  /// Foreign key: must reference existing Complaints.id
  final int complaintId;

  /// The note text
  /// Example: "Called customer, confirmed camera is still broken. Technician will visit Friday 10 AM"
  /// Why: Chronological record of what happened
  final String textNote;

  /// When was this note created?
  /// Example: "Aug 17, 2026 at 4:15 PM"
  /// Why: Activity timeline is meaningless without timestamps
  final DateTime createdAt;
  const ComplaintNote({
    required this.id,
    required this.complaintId,
    required this.textNote,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['complaint_id'] = Variable<int>(complaintId);
    map['text_note'] = Variable<String>(textNote);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ComplaintNotesCompanion toCompanion(bool nullToAbsent) {
    return ComplaintNotesCompanion(
      id: Value(id),
      complaintId: Value(complaintId),
      textNote: Value(textNote),
      createdAt: Value(createdAt),
    );
  }

  factory ComplaintNote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ComplaintNote(
      id: serializer.fromJson<int>(json['id']),
      complaintId: serializer.fromJson<int>(json['complaintId']),
      textNote: serializer.fromJson<String>(json['textNote']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'complaintId': serializer.toJson<int>(complaintId),
      'textNote': serializer.toJson<String>(textNote),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ComplaintNote copyWith({
    int? id,
    int? complaintId,
    String? textNote,
    DateTime? createdAt,
  }) => ComplaintNote(
    id: id ?? this.id,
    complaintId: complaintId ?? this.complaintId,
    textNote: textNote ?? this.textNote,
    createdAt: createdAt ?? this.createdAt,
  );
  ComplaintNote copyWithCompanion(ComplaintNotesCompanion data) {
    return ComplaintNote(
      id: data.id.present ? data.id.value : this.id,
      complaintId: data.complaintId.present
          ? data.complaintId.value
          : this.complaintId,
      textNote: data.textNote.present ? data.textNote.value : this.textNote,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ComplaintNote(')
          ..write('id: $id, ')
          ..write('complaintId: $complaintId, ')
          ..write('textNote: $textNote, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, complaintId, textNote, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ComplaintNote &&
          other.id == this.id &&
          other.complaintId == this.complaintId &&
          other.textNote == this.textNote &&
          other.createdAt == this.createdAt);
}

class ComplaintNotesCompanion extends UpdateCompanion<ComplaintNote> {
  final Value<int> id;
  final Value<int> complaintId;
  final Value<String> textNote;
  final Value<DateTime> createdAt;
  const ComplaintNotesCompanion({
    this.id = const Value.absent(),
    this.complaintId = const Value.absent(),
    this.textNote = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ComplaintNotesCompanion.insert({
    this.id = const Value.absent(),
    required int complaintId,
    required String textNote,
    this.createdAt = const Value.absent(),
  }) : complaintId = Value(complaintId),
       textNote = Value(textNote);
  static Insertable<ComplaintNote> custom({
    Expression<int>? id,
    Expression<int>? complaintId,
    Expression<String>? textNote,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (complaintId != null) 'complaint_id': complaintId,
      if (textNote != null) 'text_note': textNote,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ComplaintNotesCompanion copyWith({
    Value<int>? id,
    Value<int>? complaintId,
    Value<String>? textNote,
    Value<DateTime>? createdAt,
  }) {
    return ComplaintNotesCompanion(
      id: id ?? this.id,
      complaintId: complaintId ?? this.complaintId,
      textNote: textNote ?? this.textNote,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (complaintId.present) {
      map['complaint_id'] = Variable<int>(complaintId.value);
    }
    if (textNote.present) {
      map['text_note'] = Variable<String>(textNote.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComplaintNotesCompanion(')
          ..write('id: $id, ')
          ..write('complaintId: $complaintId, ')
          ..write('textNote: $textNote, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $TechniciansTable technicians = $TechniciansTable(this);
  late final $ComplaintsTable complaints = $ComplaintsTable(this);
  late final $ComplaintNotesTable complaintNotes = $ComplaintNotesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    customers,
    technicians,
    complaints,
    complaintNotes,
  ];
}

typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      required String name,
      required String phone,
      required String address,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> phone,
      Value<String> address,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, Customer> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ComplaintsTable, List<Complaint>>
  _complaintsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.complaints,
    aliasName: 'customers__id__complaints__customer_id',
  );

  $$ComplaintsTableProcessedTableManager get complaintsRefs {
    final manager = $$ComplaintsTableTableManager(
      $_db,
      $_db.complaints,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_complaintsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> complaintsRefs(
    Expression<bool> Function($$ComplaintsTableFilterComposer f) f,
  ) {
    final $$ComplaintsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.complaints,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComplaintsTableFilterComposer(
            $db: $db,
            $table: $db.complaints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> complaintsRefs<T extends Object>(
    Expression<T> Function($$ComplaintsTableAnnotationComposer a) f,
  ) {
    final $$ComplaintsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.complaints,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComplaintsTableAnnotationComposer(
            $db: $db,
            $table: $db.complaints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, $$CustomersTableReferences),
          Customer,
          PrefetchHooks Function({bool complaintsRefs})
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                name: name,
                phone: phone,
                address: address,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String phone,
                required String address,
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                address: address,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomersTable, Customer>(table),
                  $$CustomersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({complaintsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (complaintsRefs) db.complaints],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (complaintsRefs)
                    await $_getPrefetchedData<
                      Customer,
                      $CustomersTable,
                      Complaint
                    >(
                      currentTable: table,
                      referencedTable: $$CustomersTableReferences
                          ._complaintsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CustomersTableReferences(
                            db,
                            table,
                            p0,
                          ).complaintsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.customerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, $$CustomersTableReferences),
      Customer,
      PrefetchHooks Function({bool complaintsRefs})
    >;
typedef $$TechniciansTableCreateCompanionBuilder =
    TechniciansCompanion Function({
      Value<int> id,
      required String name,
      required String phone,
      Value<String?> specialty,
      Value<bool> active,
      Value<DateTime> createdAt,
    });
typedef $$TechniciansTableUpdateCompanionBuilder =
    TechniciansCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> phone,
      Value<String?> specialty,
      Value<bool> active,
      Value<DateTime> createdAt,
    });

final class $$TechniciansTableReferences
    extends BaseReferences<_$AppDatabase, $TechniciansTable, Technician> {
  $$TechniciansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ComplaintsTable, List<Complaint>>
  _complaintsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.complaints,
    aliasName: 'technicians__id__complaints__assigned_technician_id',
  );

  $$ComplaintsTableProcessedTableManager get complaintsRefs {
    final manager = $$ComplaintsTableTableManager($_db, $_db.complaints).filter(
      (f) => f.assignedTechnicianId.id.sqlEquals($_itemColumn<int>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_complaintsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TechniciansTableFilterComposer
    extends Composer<_$AppDatabase, $TechniciansTable> {
  $$TechniciansTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specialty => $composableBuilder(
    column: $table.specialty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> complaintsRefs(
    Expression<bool> Function($$ComplaintsTableFilterComposer f) f,
  ) {
    final $$ComplaintsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.complaints,
      getReferencedColumn: (t) => t.assignedTechnicianId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComplaintsTableFilterComposer(
            $db: $db,
            $table: $db.complaints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TechniciansTableOrderingComposer
    extends Composer<_$AppDatabase, $TechniciansTable> {
  $$TechniciansTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specialty => $composableBuilder(
    column: $table.specialty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TechniciansTableAnnotationComposer
    extends Composer<_$AppDatabase, $TechniciansTable> {
  $$TechniciansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get specialty =>
      $composableBuilder(column: $table.specialty, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> complaintsRefs<T extends Object>(
    Expression<T> Function($$ComplaintsTableAnnotationComposer a) f,
  ) {
    final $$ComplaintsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.complaints,
      getReferencedColumn: (t) => t.assignedTechnicianId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComplaintsTableAnnotationComposer(
            $db: $db,
            $table: $db.complaints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TechniciansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TechniciansTable,
          Technician,
          $$TechniciansTableFilterComposer,
          $$TechniciansTableOrderingComposer,
          $$TechniciansTableAnnotationComposer,
          $$TechniciansTableCreateCompanionBuilder,
          $$TechniciansTableUpdateCompanionBuilder,
          (Technician, $$TechniciansTableReferences),
          Technician,
          PrefetchHooks Function({bool complaintsRefs})
        > {
  $$TechniciansTableTableManager(_$AppDatabase db, $TechniciansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TechniciansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TechniciansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TechniciansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String?> specialty = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TechniciansCompanion(
                id: id,
                name: name,
                phone: phone,
                specialty: specialty,
                active: active,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String phone,
                Value<String?> specialty = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TechniciansCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                specialty: specialty,
                active: active,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TechniciansTable, Technician>(table),
                  $$TechniciansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({complaintsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (complaintsRefs) db.complaints],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (complaintsRefs)
                    await $_getPrefetchedData<
                      Technician,
                      $TechniciansTable,
                      Complaint
                    >(
                      currentTable: table,
                      referencedTable: $$TechniciansTableReferences
                          ._complaintsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TechniciansTableReferences(
                            db,
                            table,
                            p0,
                          ).complaintsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.assignedTechnicianId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TechniciansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TechniciansTable,
      Technician,
      $$TechniciansTableFilterComposer,
      $$TechniciansTableOrderingComposer,
      $$TechniciansTableAnnotationComposer,
      $$TechniciansTableCreateCompanionBuilder,
      $$TechniciansTableUpdateCompanionBuilder,
      (Technician, $$TechniciansTableReferences),
      Technician,
      PrefetchHooks Function({bool complaintsRefs})
    >;
typedef $$ComplaintsTableCreateCompanionBuilder =
    ComplaintsCompanion Function({
      Value<int> id,
      required String title,
      required String description,
      Value<Priority> priority,
      Value<ComplaintStatus> status,
      required int customerId,
      Value<int?> assignedTechnicianId,
      Value<DateTime> createdAt,
      Value<DateTime?> dueBy,
      Value<DateTime?> resolvedAt,
      Value<String?> photoUris,
    });
typedef $$ComplaintsTableUpdateCompanionBuilder =
    ComplaintsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> description,
      Value<Priority> priority,
      Value<ComplaintStatus> status,
      Value<int> customerId,
      Value<int?> assignedTechnicianId,
      Value<DateTime> createdAt,
      Value<DateTime?> dueBy,
      Value<DateTime?> resolvedAt,
      Value<String?> photoUris,
    });

final class $$ComplaintsTableReferences
    extends BaseReferences<_$AppDatabase, $ComplaintsTable, Complaint> {
  $$ComplaintsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('complaints__customer_id__customers__id');

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<int>('customer_id')!;

    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TechniciansTable _assignedTechnicianIdTable(_$AppDatabase db) => db
      .technicians
      .createAlias('complaints__assigned_technician_id__technicians__id');

  $$TechniciansTableProcessedTableManager? get assignedTechnicianId {
    final $_column = $_itemColumn<int>('assigned_technician_id');
    if ($_column == null) return null;
    final manager = $$TechniciansTableTableManager(
      $_db,
      $_db.technicians,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _assignedTechnicianIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ComplaintNotesTable, List<ComplaintNote>>
  _complaintNotesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.complaintNotes,
    aliasName: 'complaints__id__complaint_notes__complaint_id',
  );

  $$ComplaintNotesTableProcessedTableManager get complaintNotesRefs {
    final manager = $$ComplaintNotesTableTableManager(
      $_db,
      $_db.complaintNotes,
    ).filter((f) => f.complaintId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_complaintNotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ComplaintsTableFilterComposer
    extends Composer<_$AppDatabase, $ComplaintsTable> {
  $$ComplaintsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Priority, Priority, String> get priority =>
      $composableBuilder(
        column: $table.priority,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<ComplaintStatus, ComplaintStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueBy => $composableBuilder(
    column: $table.dueBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUris => $composableBuilder(
    column: $table.photoUris,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TechniciansTableFilterComposer get assignedTechnicianId {
    final $$TechniciansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assignedTechnicianId,
      referencedTable: $db.technicians,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TechniciansTableFilterComposer(
            $db: $db,
            $table: $db.technicians,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> complaintNotesRefs(
    Expression<bool> Function($$ComplaintNotesTableFilterComposer f) f,
  ) {
    final $$ComplaintNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.complaintNotes,
      getReferencedColumn: (t) => t.complaintId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComplaintNotesTableFilterComposer(
            $db: $db,
            $table: $db.complaintNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ComplaintsTableOrderingComposer
    extends Composer<_$AppDatabase, $ComplaintsTable> {
  $$ComplaintsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueBy => $composableBuilder(
    column: $table.dueBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUris => $composableBuilder(
    column: $table.photoUris,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TechniciansTableOrderingComposer get assignedTechnicianId {
    final $$TechniciansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assignedTechnicianId,
      referencedTable: $db.technicians,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TechniciansTableOrderingComposer(
            $db: $db,
            $table: $db.technicians,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ComplaintsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComplaintsTable> {
  $$ComplaintsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Priority, String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ComplaintStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get dueBy =>
      $composableBuilder(column: $table.dueBy, builder: (column) => column);

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoUris =>
      $composableBuilder(column: $table.photoUris, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TechniciansTableAnnotationComposer get assignedTechnicianId {
    final $$TechniciansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assignedTechnicianId,
      referencedTable: $db.technicians,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TechniciansTableAnnotationComposer(
            $db: $db,
            $table: $db.technicians,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> complaintNotesRefs<T extends Object>(
    Expression<T> Function($$ComplaintNotesTableAnnotationComposer a) f,
  ) {
    final $$ComplaintNotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.complaintNotes,
      getReferencedColumn: (t) => t.complaintId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComplaintNotesTableAnnotationComposer(
            $db: $db,
            $table: $db.complaintNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ComplaintsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ComplaintsTable,
          Complaint,
          $$ComplaintsTableFilterComposer,
          $$ComplaintsTableOrderingComposer,
          $$ComplaintsTableAnnotationComposer,
          $$ComplaintsTableCreateCompanionBuilder,
          $$ComplaintsTableUpdateCompanionBuilder,
          (Complaint, $$ComplaintsTableReferences),
          Complaint,
          PrefetchHooks Function({
            bool customerId,
            bool assignedTechnicianId,
            bool complaintNotesRefs,
          })
        > {
  $$ComplaintsTableTableManager(_$AppDatabase db, $ComplaintsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComplaintsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComplaintsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComplaintsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<Priority> priority = const Value.absent(),
                Value<ComplaintStatus> status = const Value.absent(),
                Value<int> customerId = const Value.absent(),
                Value<int?> assignedTechnicianId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> dueBy = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<String?> photoUris = const Value.absent(),
              }) => ComplaintsCompanion(
                id: id,
                title: title,
                description: description,
                priority: priority,
                status: status,
                customerId: customerId,
                assignedTechnicianId: assignedTechnicianId,
                createdAt: createdAt,
                dueBy: dueBy,
                resolvedAt: resolvedAt,
                photoUris: photoUris,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String description,
                Value<Priority> priority = const Value.absent(),
                Value<ComplaintStatus> status = const Value.absent(),
                required int customerId,
                Value<int?> assignedTechnicianId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> dueBy = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<String?> photoUris = const Value.absent(),
              }) => ComplaintsCompanion.insert(
                id: id,
                title: title,
                description: description,
                priority: priority,
                status: status,
                customerId: customerId,
                assignedTechnicianId: assignedTechnicianId,
                createdAt: createdAt,
                dueBy: dueBy,
                resolvedAt: resolvedAt,
                photoUris: photoUris,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ComplaintsTable, Complaint>(table),
                  $$ComplaintsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                customerId = false,
                assignedTechnicianId = false,
                complaintNotesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (complaintNotesRefs) db.complaintNotes,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable: $$ComplaintsTableReferences
                                        ._customerIdTable(db),
                                    referencedColumn:
                                        $$ComplaintsTableReferences
                                            ._customerIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (assignedTechnicianId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.assignedTechnicianId,
                                    referencedTable: $$ComplaintsTableReferences
                                        ._assignedTechnicianIdTable(db),
                                    referencedColumn:
                                        $$ComplaintsTableReferences
                                            ._assignedTechnicianIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (complaintNotesRefs)
                        await $_getPrefetchedData<
                          Complaint,
                          $ComplaintsTable,
                          ComplaintNote
                        >(
                          currentTable: table,
                          referencedTable: $$ComplaintsTableReferences
                              ._complaintNotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ComplaintsTableReferences(
                                db,
                                table,
                                p0,
                              ).complaintNotesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.complaintId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ComplaintsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ComplaintsTable,
      Complaint,
      $$ComplaintsTableFilterComposer,
      $$ComplaintsTableOrderingComposer,
      $$ComplaintsTableAnnotationComposer,
      $$ComplaintsTableCreateCompanionBuilder,
      $$ComplaintsTableUpdateCompanionBuilder,
      (Complaint, $$ComplaintsTableReferences),
      Complaint,
      PrefetchHooks Function({
        bool customerId,
        bool assignedTechnicianId,
        bool complaintNotesRefs,
      })
    >;
typedef $$ComplaintNotesTableCreateCompanionBuilder =
    ComplaintNotesCompanion Function({
      Value<int> id,
      required int complaintId,
      required String textNote,
      Value<DateTime> createdAt,
    });
typedef $$ComplaintNotesTableUpdateCompanionBuilder =
    ComplaintNotesCompanion Function({
      Value<int> id,
      Value<int> complaintId,
      Value<String> textNote,
      Value<DateTime> createdAt,
    });

final class $$ComplaintNotesTableReferences
    extends BaseReferences<_$AppDatabase, $ComplaintNotesTable, ComplaintNote> {
  $$ComplaintNotesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ComplaintsTable _complaintIdTable(_$AppDatabase db) => db.complaints
      .createAlias('complaint_notes__complaint_id__complaints__id');

  $$ComplaintsTableProcessedTableManager get complaintId {
    final $_column = $_itemColumn<int>('complaint_id')!;

    final manager = $$ComplaintsTableTableManager(
      $_db,
      $_db.complaints,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_complaintIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ComplaintNotesTableFilterComposer
    extends Composer<_$AppDatabase, $ComplaintNotesTable> {
  $$ComplaintNotesTableFilterComposer({
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

  ColumnFilters<String> get textNote => $composableBuilder(
    column: $table.textNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ComplaintsTableFilterComposer get complaintId {
    final $$ComplaintsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.complaintId,
      referencedTable: $db.complaints,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComplaintsTableFilterComposer(
            $db: $db,
            $table: $db.complaints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ComplaintNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $ComplaintNotesTable> {
  $$ComplaintNotesTableOrderingComposer({
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

  ColumnOrderings<String> get textNote => $composableBuilder(
    column: $table.textNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ComplaintsTableOrderingComposer get complaintId {
    final $$ComplaintsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.complaintId,
      referencedTable: $db.complaints,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComplaintsTableOrderingComposer(
            $db: $db,
            $table: $db.complaints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ComplaintNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComplaintNotesTable> {
  $$ComplaintNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get textNote =>
      $composableBuilder(column: $table.textNote, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ComplaintsTableAnnotationComposer get complaintId {
    final $$ComplaintsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.complaintId,
      referencedTable: $db.complaints,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComplaintsTableAnnotationComposer(
            $db: $db,
            $table: $db.complaints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ComplaintNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ComplaintNotesTable,
          ComplaintNote,
          $$ComplaintNotesTableFilterComposer,
          $$ComplaintNotesTableOrderingComposer,
          $$ComplaintNotesTableAnnotationComposer,
          $$ComplaintNotesTableCreateCompanionBuilder,
          $$ComplaintNotesTableUpdateCompanionBuilder,
          (ComplaintNote, $$ComplaintNotesTableReferences),
          ComplaintNote,
          PrefetchHooks Function({bool complaintId})
        > {
  $$ComplaintNotesTableTableManager(
    _$AppDatabase db,
    $ComplaintNotesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComplaintNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComplaintNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComplaintNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> complaintId = const Value.absent(),
                Value<String> textNote = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ComplaintNotesCompanion(
                id: id,
                complaintId: complaintId,
                textNote: textNote,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int complaintId,
                required String textNote,
                Value<DateTime> createdAt = const Value.absent(),
              }) => ComplaintNotesCompanion.insert(
                id: id,
                complaintId: complaintId,
                textNote: textNote,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ComplaintNotesTable, ComplaintNote>(table),
                  $$ComplaintNotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({complaintId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (complaintId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.complaintId,
                                referencedTable: $$ComplaintNotesTableReferences
                                    ._complaintIdTable(db),
                                referencedColumn:
                                    $$ComplaintNotesTableReferences
                                        ._complaintIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ComplaintNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ComplaintNotesTable,
      ComplaintNote,
      $$ComplaintNotesTableFilterComposer,
      $$ComplaintNotesTableOrderingComposer,
      $$ComplaintNotesTableAnnotationComposer,
      $$ComplaintNotesTableCreateCompanionBuilder,
      $$ComplaintNotesTableUpdateCompanionBuilder,
      (ComplaintNote, $$ComplaintNotesTableReferences),
      ComplaintNote,
      PrefetchHooks Function({bool complaintId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$TechniciansTableTableManager get technicians =>
      $$TechniciansTableTableManager(_db, _db.technicians);
  $$ComplaintsTableTableManager get complaints =>
      $$ComplaintsTableTableManager(_db, _db.complaints);
  $$ComplaintNotesTableTableManager get complaintNotes =>
      $$ComplaintNotesTableTableManager(_db, _db.complaintNotes);
}
