// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CategoryTableTable extends CategoryTable
    with TableInfo<$CategoryTableTable, CategoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<int> icon = GeneratedColumn<int>(
      'icon', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _parentMeta = const VerificationMeta('parent');
  @override
  late final GeneratedColumn<int> parent = GeneratedColumn<int>(
      'parent', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES category_table (id)'),
      defaultValue: const Constant(-1));
  @override
  List<GeneratedColumn> get $columns => [id, name, icon, parent];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_table';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('parent')) {
      context.handle(_parentMeta,
          parent.isAcceptableOrUnknown(data['parent']!, _parentMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}icon'])!,
      parent: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent'])!,
    );
  }

  @override
  $CategoryTableTable createAlias(String alias) {
    return $CategoryTableTable(attachedDatabase, alias);
  }
}

class CategoryTableData extends DataClass
    implements Insertable<CategoryTableData> {
  final int id;
  final String name;
  final int icon;
  final int parent;
  const CategoryTableData(
      {required this.id,
      required this.name,
      required this.icon,
      required this.parent});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<int>(icon);
    map['parent'] = Variable<int>(parent);
    return map;
  }

  CategoryTableCompanion toCompanion(bool nullToAbsent) {
    return CategoryTableCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      parent: Value(parent),
    );
  }

  factory CategoryTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<int>(json['icon']),
      parent: serializer.fromJson<int>(json['parent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<int>(icon),
      'parent': serializer.toJson<int>(parent),
    };
  }

  CategoryTableData copyWith({int? id, String? name, int? icon, int? parent}) =>
      CategoryTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        parent: parent ?? this.parent,
      );
  CategoryTableData copyWithCompanion(CategoryTableCompanion data) {
    return CategoryTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      parent: data.parent.present ? data.parent.value : this.parent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('parent: $parent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, parent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.parent == this.parent);
}

class CategoryTableCompanion extends UpdateCompanion<CategoryTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> icon;
  final Value<int> parent;
  const CategoryTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.parent = const Value.absent(),
  });
  CategoryTableCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    required int icon,
    this.parent = const Value.absent(),
  }) : icon = Value(icon);
  static Insertable<CategoryTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? icon,
    Expression<int>? parent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (parent != null) 'parent': parent,
    });
  }

  CategoryTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? icon,
      Value<int>? parent}) {
    return CategoryTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      parent: parent ?? this.parent,
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
    if (icon.present) {
      map['icon'] = Variable<int>(icon.value);
    }
    if (parent.present) {
      map['parent'] = Variable<int>(parent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('parent: $parent')
          ..write(')'))
        .toString();
  }
}

class $GovernorateTableTable extends GovernorateTable
    with TableInfo<$GovernorateTableTable, GovernorateTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GovernorateTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'governorate_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<GovernorateTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GovernorateTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GovernorateTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $GovernorateTableTable createAlias(String alias) {
    return $GovernorateTableTable(attachedDatabase, alias);
  }
}

class GovernorateTableData extends DataClass
    implements Insertable<GovernorateTableData> {
  final int id;
  final String name;
  const GovernorateTableData({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  GovernorateTableCompanion toCompanion(bool nullToAbsent) {
    return GovernorateTableCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory GovernorateTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GovernorateTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  GovernorateTableData copyWith({int? id, String? name}) =>
      GovernorateTableData(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  GovernorateTableData copyWithCompanion(GovernorateTableCompanion data) {
    return GovernorateTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GovernorateTableData(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GovernorateTableData &&
          other.id == this.id &&
          other.name == this.name);
}

class GovernorateTableCompanion extends UpdateCompanion<GovernorateTableData> {
  final Value<int> id;
  final Value<String> name;
  const GovernorateTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  GovernorateTableCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  static Insertable<GovernorateTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  GovernorateTableCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return GovernorateTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GovernorateTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $UserTableTable extends UserTable
    with TableInfo<$UserTableTable, UserTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _pictureMeta =
      const VerificationMeta('picture');
  @override
  late final GeneratedColumn<String> picture = GeneratedColumn<String>(
      'picture', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumnWithTypeConverter<Role, int> role =
      GeneratedColumn<int>('role', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(2))
          .withConverter<Role>($UserTableTable.$converterrole);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumnWithTypeConverter<Gender, int> gender =
      GeneratedColumn<int>('gender', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(2))
          .withConverter<Gender>($UserTableTable.$convertergender);
  static const VerificationMeta _isVerifiedMeta =
      const VerificationMeta('isVerified');
  @override
  late final GeneratedColumnWithTypeConverter<VerifyIdentityStatus, int>
      isVerified = GeneratedColumn<int>('is_verified', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(2))
          .withConverter<VerifyIdentityStatus>(
              $UserTableTable.$converterisVerified);
  static const VerificationMeta _isMailVerifiedMeta =
      const VerificationMeta('isMailVerified');
  @override
  late final GeneratedColumn<bool> isMailVerified = GeneratedColumn<bool>(
      'is_mail_verified', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_mail_verified" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _birthdateMeta =
      const VerificationMeta('birthdate');
  @override
  late final GeneratedColumn<DateTime> birthdate = GeneratedColumn<DateTime>(
      'birthdate', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
      'bio', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _coordinatesMeta =
      const VerificationMeta('coordinates');
  @override
  late final GeneratedColumn<String> coordinates = GeneratedColumn<String>(
      'coordinates', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _governorateMeta =
      const VerificationMeta('governorate');
  @override
  late final GeneratedColumn<int> governorate = GeneratedColumn<int>(
      'governorate', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES governorate_table (id)'),
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        email,
        phone,
        picture,
        role,
        gender,
        isVerified,
        isMailVerified,
        birthdate,
        bio,
        coordinates,
        governorate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_table';
  @override
  VerificationContext validateIntegrity(Insertable<UserTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('picture')) {
      context.handle(_pictureMeta,
          picture.isAcceptableOrUnknown(data['picture']!, _pictureMeta));
    }
    context.handle(_roleMeta, const VerificationResult.success());
    context.handle(_genderMeta, const VerificationResult.success());
    context.handle(_isVerifiedMeta, const VerificationResult.success());
    if (data.containsKey('is_mail_verified')) {
      context.handle(
          _isMailVerifiedMeta,
          isMailVerified.isAcceptableOrUnknown(
              data['is_mail_verified']!, _isMailVerifiedMeta));
    }
    if (data.containsKey('birthdate')) {
      context.handle(_birthdateMeta,
          birthdate.isAcceptableOrUnknown(data['birthdate']!, _birthdateMeta));
    }
    if (data.containsKey('bio')) {
      context.handle(
          _bioMeta, bio.isAcceptableOrUnknown(data['bio']!, _bioMeta));
    }
    if (data.containsKey('coordinates')) {
      context.handle(
          _coordinatesMeta,
          coordinates.isAcceptableOrUnknown(
              data['coordinates']!, _coordinatesMeta));
    }
    if (data.containsKey('governorate')) {
      context.handle(
          _governorateMeta,
          governorate.isAcceptableOrUnknown(
              data['governorate']!, _governorateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      picture: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}picture'])!,
      role: $UserTableTable.$converterrole.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}role'])!),
      gender: $UserTableTable.$convertergender.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gender'])!),
      isVerified: $UserTableTable.$converterisVerified.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_verified'])!),
      isMailVerified: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_mail_verified'])!,
      birthdate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}birthdate']),
      bio: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bio'])!,
      coordinates: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}coordinates']),
      governorate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}governorate'])!,
    );
  }

  @override
  $UserTableTable createAlias(String alias) {
    return $UserTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Role, int, int> $converterrole =
      const EnumIndexConverter<Role>(Role.values);
  static JsonTypeConverter2<Gender, int, int> $convertergender =
      const EnumIndexConverter<Gender>(Gender.values);
  static JsonTypeConverter2<VerifyIdentityStatus, int, int>
      $converterisVerified = const EnumIndexConverter<VerifyIdentityStatus>(
          VerifyIdentityStatus.values);
}

class UserTableData extends DataClass implements Insertable<UserTableData> {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String picture;
  final Role role;
  final Gender gender;
  final VerifyIdentityStatus isVerified;
  final bool isMailVerified;
  final DateTime? birthdate;
  final String bio;
  final String? coordinates;
  final int governorate;
  const UserTableData(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.picture,
      required this.role,
      required this.gender,
      required this.isVerified,
      required this.isMailVerified,
      this.birthdate,
      required this.bio,
      this.coordinates,
      required this.governorate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['phone'] = Variable<String>(phone);
    map['picture'] = Variable<String>(picture);
    {
      map['role'] = Variable<int>($UserTableTable.$converterrole.toSql(role));
    }
    {
      map['gender'] =
          Variable<int>($UserTableTable.$convertergender.toSql(gender));
    }
    {
      map['is_verified'] =
          Variable<int>($UserTableTable.$converterisVerified.toSql(isVerified));
    }
    map['is_mail_verified'] = Variable<bool>(isMailVerified);
    if (!nullToAbsent || birthdate != null) {
      map['birthdate'] = Variable<DateTime>(birthdate);
    }
    map['bio'] = Variable<String>(bio);
    if (!nullToAbsent || coordinates != null) {
      map['coordinates'] = Variable<String>(coordinates);
    }
    map['governorate'] = Variable<int>(governorate);
    return map;
  }

  UserTableCompanion toCompanion(bool nullToAbsent) {
    return UserTableCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      phone: Value(phone),
      picture: Value(picture),
      role: Value(role),
      gender: Value(gender),
      isVerified: Value(isVerified),
      isMailVerified: Value(isMailVerified),
      birthdate: birthdate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthdate),
      bio: Value(bio),
      coordinates: coordinates == null && nullToAbsent
          ? const Value.absent()
          : Value(coordinates),
      governorate: Value(governorate),
    );
  }

  factory UserTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      phone: serializer.fromJson<String>(json['phone']),
      picture: serializer.fromJson<String>(json['picture']),
      role: $UserTableTable.$converterrole
          .fromJson(serializer.fromJson<int>(json['role'])),
      gender: $UserTableTable.$convertergender
          .fromJson(serializer.fromJson<int>(json['gender'])),
      isVerified: $UserTableTable.$converterisVerified
          .fromJson(serializer.fromJson<int>(json['isVerified'])),
      isMailVerified: serializer.fromJson<bool>(json['isMailVerified']),
      birthdate: serializer.fromJson<DateTime?>(json['birthdate']),
      bio: serializer.fromJson<String>(json['bio']),
      coordinates: serializer.fromJson<String?>(json['coordinates']),
      governorate: serializer.fromJson<int>(json['governorate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'phone': serializer.toJson<String>(phone),
      'picture': serializer.toJson<String>(picture),
      'role':
          serializer.toJson<int>($UserTableTable.$converterrole.toJson(role)),
      'gender': serializer
          .toJson<int>($UserTableTable.$convertergender.toJson(gender)),
      'isVerified': serializer
          .toJson<int>($UserTableTable.$converterisVerified.toJson(isVerified)),
      'isMailVerified': serializer.toJson<bool>(isMailVerified),
      'birthdate': serializer.toJson<DateTime?>(birthdate),
      'bio': serializer.toJson<String>(bio),
      'coordinates': serializer.toJson<String?>(coordinates),
      'governorate': serializer.toJson<int>(governorate),
    };
  }

  UserTableData copyWith(
          {int? id,
          String? name,
          String? email,
          String? phone,
          String? picture,
          Role? role,
          Gender? gender,
          VerifyIdentityStatus? isVerified,
          bool? isMailVerified,
          Value<DateTime?> birthdate = const Value.absent(),
          String? bio,
          Value<String?> coordinates = const Value.absent(),
          int? governorate}) =>
      UserTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        picture: picture ?? this.picture,
        role: role ?? this.role,
        gender: gender ?? this.gender,
        isVerified: isVerified ?? this.isVerified,
        isMailVerified: isMailVerified ?? this.isMailVerified,
        birthdate: birthdate.present ? birthdate.value : this.birthdate,
        bio: bio ?? this.bio,
        coordinates: coordinates.present ? coordinates.value : this.coordinates,
        governorate: governorate ?? this.governorate,
      );
  UserTableData copyWithCompanion(UserTableCompanion data) {
    return UserTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      picture: data.picture.present ? data.picture.value : this.picture,
      role: data.role.present ? data.role.value : this.role,
      gender: data.gender.present ? data.gender.value : this.gender,
      isVerified:
          data.isVerified.present ? data.isVerified.value : this.isVerified,
      isMailVerified: data.isMailVerified.present
          ? data.isMailVerified.value
          : this.isMailVerified,
      birthdate: data.birthdate.present ? data.birthdate.value : this.birthdate,
      bio: data.bio.present ? data.bio.value : this.bio,
      coordinates:
          data.coordinates.present ? data.coordinates.value : this.coordinates,
      governorate:
          data.governorate.present ? data.governorate.value : this.governorate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('picture: $picture, ')
          ..write('role: $role, ')
          ..write('gender: $gender, ')
          ..write('isVerified: $isVerified, ')
          ..write('isMailVerified: $isMailVerified, ')
          ..write('birthdate: $birthdate, ')
          ..write('bio: $bio, ')
          ..write('coordinates: $coordinates, ')
          ..write('governorate: $governorate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, email, phone, picture, role, gender,
      isVerified, isMailVerified, birthdate, bio, coordinates, governorate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.picture == this.picture &&
          other.role == this.role &&
          other.gender == this.gender &&
          other.isVerified == this.isVerified &&
          other.isMailVerified == this.isMailVerified &&
          other.birthdate == this.birthdate &&
          other.bio == this.bio &&
          other.coordinates == this.coordinates &&
          other.governorate == this.governorate);
}

class UserTableCompanion extends UpdateCompanion<UserTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> phone;
  final Value<String> picture;
  final Value<Role> role;
  final Value<Gender> gender;
  final Value<VerifyIdentityStatus> isVerified;
  final Value<bool> isMailVerified;
  final Value<DateTime?> birthdate;
  final Value<String> bio;
  final Value<String?> coordinates;
  final Value<int> governorate;
  const UserTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.picture = const Value.absent(),
    this.role = const Value.absent(),
    this.gender = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.isMailVerified = const Value.absent(),
    this.birthdate = const Value.absent(),
    this.bio = const Value.absent(),
    this.coordinates = const Value.absent(),
    this.governorate = const Value.absent(),
  });
  UserTableCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.picture = const Value.absent(),
    this.role = const Value.absent(),
    this.gender = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.isMailVerified = const Value.absent(),
    this.birthdate = const Value.absent(),
    this.bio = const Value.absent(),
    this.coordinates = const Value.absent(),
    this.governorate = const Value.absent(),
  });
  static Insertable<UserTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? picture,
    Expression<int>? role,
    Expression<int>? gender,
    Expression<int>? isVerified,
    Expression<bool>? isMailVerified,
    Expression<DateTime>? birthdate,
    Expression<String>? bio,
    Expression<String>? coordinates,
    Expression<int>? governorate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (picture != null) 'picture': picture,
      if (role != null) 'role': role,
      if (gender != null) 'gender': gender,
      if (isVerified != null) 'is_verified': isVerified,
      if (isMailVerified != null) 'is_mail_verified': isMailVerified,
      if (birthdate != null) 'birthdate': birthdate,
      if (bio != null) 'bio': bio,
      if (coordinates != null) 'coordinates': coordinates,
      if (governorate != null) 'governorate': governorate,
    });
  }

  UserTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? email,
      Value<String>? phone,
      Value<String>? picture,
      Value<Role>? role,
      Value<Gender>? gender,
      Value<VerifyIdentityStatus>? isVerified,
      Value<bool>? isMailVerified,
      Value<DateTime?>? birthdate,
      Value<String>? bio,
      Value<String?>? coordinates,
      Value<int>? governorate}) {
    return UserTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      picture: picture ?? this.picture,
      role: role ?? this.role,
      gender: gender ?? this.gender,
      isVerified: isVerified ?? this.isVerified,
      isMailVerified: isMailVerified ?? this.isMailVerified,
      birthdate: birthdate ?? this.birthdate,
      bio: bio ?? this.bio,
      coordinates: coordinates ?? this.coordinates,
      governorate: governorate ?? this.governorate,
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
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (picture.present) {
      map['picture'] = Variable<String>(picture.value);
    }
    if (role.present) {
      map['role'] =
          Variable<int>($UserTableTable.$converterrole.toSql(role.value));
    }
    if (gender.present) {
      map['gender'] =
          Variable<int>($UserTableTable.$convertergender.toSql(gender.value));
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<int>(
          $UserTableTable.$converterisVerified.toSql(isVerified.value));
    }
    if (isMailVerified.present) {
      map['is_mail_verified'] = Variable<bool>(isMailVerified.value);
    }
    if (birthdate.present) {
      map['birthdate'] = Variable<DateTime>(birthdate.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (coordinates.present) {
      map['coordinates'] = Variable<String>(coordinates.value);
    }
    if (governorate.present) {
      map['governorate'] = Variable<int>(governorate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('picture: $picture, ')
          ..write('role: $role, ')
          ..write('gender: $gender, ')
          ..write('isVerified: $isVerified, ')
          ..write('isMailVerified: $isMailVerified, ')
          ..write('birthdate: $birthdate, ')
          ..write('bio: $bio, ')
          ..write('coordinates: $coordinates, ')
          ..write('governorate: $governorate')
          ..write(')'))
        .toString();
  }
}

class $TaskTableTable extends TaskTable
    with TableInfo<$TaskTableTable, TaskTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<int> category = GeneratedColumn<int>(
      'category', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES category_table (id)'));
  static const VerificationMeta _governorateMeta =
      const VerificationMeta('governorate');
  @override
  late final GeneratedColumn<int> governorate = GeneratedColumn<int>(
      'governorate', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES governorate_table (id)'));
  static const VerificationMeta _ownerMeta = const VerificationMeta('owner');
  @override
  late final GeneratedColumn<int> owner = GeneratedColumn<int>(
      'owner', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES user_table (id)'));
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 23, 59)));
  static const VerificationMeta _delivrablesMeta =
      const VerificationMeta('delivrables');
  @override
  late final GeneratedColumn<String> delivrables = GeneratedColumn<String>(
      'delivrables', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _isfavoriteMeta =
      const VerificationMeta('isfavorite');
  @override
  late final GeneratedColumn<bool> isfavorite = GeneratedColumn<bool>(
      'isfavorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("isfavorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        price,
        title,
        description,
        category,
        governorate,
        owner,
        dueDate,
        delivrables,
        isfavorite
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_table';
  @override
  VerificationContext validateIntegrity(Insertable<TaskTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('governorate')) {
      context.handle(
          _governorateMeta,
          governorate.isAcceptableOrUnknown(
              data['governorate']!, _governorateMeta));
    }
    if (data.containsKey('owner')) {
      context.handle(
          _ownerMeta, owner.isAcceptableOrUnknown(data['owner']!, _ownerMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('delivrables')) {
      context.handle(
          _delivrablesMeta,
          delivrables.isAcceptableOrUnknown(
              data['delivrables']!, _delivrablesMeta));
    }
    if (data.containsKey('isfavorite')) {
      context.handle(
          _isfavoriteMeta,
          isfavorite.isAcceptableOrUnknown(
              data['isfavorite']!, _isfavoriteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category'])!,
      governorate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}governorate']),
      owner: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}owner']),
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date'])!,
      delivrables: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}delivrables'])!,
      isfavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}isfavorite'])!,
    );
  }

  @override
  $TaskTableTable createAlias(String alias) {
    return $TaskTableTable(attachedDatabase, alias);
  }
}

class TaskTableData extends DataClass implements Insertable<TaskTableData> {
  final int id;
  final double price;
  final String title;
  final String description;
  final int category;
  final int? governorate;
  final int? owner;
  final DateTime dueDate;
  final String delivrables;
  final bool isfavorite;
  const TaskTableData(
      {required this.id,
      required this.price,
      required this.title,
      required this.description,
      required this.category,
      this.governorate,
      this.owner,
      required this.dueDate,
      required this.delivrables,
      required this.isfavorite});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['price'] = Variable<double>(price);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['category'] = Variable<int>(category);
    if (!nullToAbsent || governorate != null) {
      map['governorate'] = Variable<int>(governorate);
    }
    if (!nullToAbsent || owner != null) {
      map['owner'] = Variable<int>(owner);
    }
    map['due_date'] = Variable<DateTime>(dueDate);
    map['delivrables'] = Variable<String>(delivrables);
    map['isfavorite'] = Variable<bool>(isfavorite);
    return map;
  }

  TaskTableCompanion toCompanion(bool nullToAbsent) {
    return TaskTableCompanion(
      id: Value(id),
      price: Value(price),
      title: Value(title),
      description: Value(description),
      category: Value(category),
      governorate: governorate == null && nullToAbsent
          ? const Value.absent()
          : Value(governorate),
      owner:
          owner == null && nullToAbsent ? const Value.absent() : Value(owner),
      dueDate: Value(dueDate),
      delivrables: Value(delivrables),
      isfavorite: Value(isfavorite),
    );
  }

  factory TaskTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskTableData(
      id: serializer.fromJson<int>(json['id']),
      price: serializer.fromJson<double>(json['price']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<int>(json['category']),
      governorate: serializer.fromJson<int?>(json['governorate']),
      owner: serializer.fromJson<int?>(json['owner']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      delivrables: serializer.fromJson<String>(json['delivrables']),
      isfavorite: serializer.fromJson<bool>(json['isfavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'price': serializer.toJson<double>(price),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<int>(category),
      'governorate': serializer.toJson<int?>(governorate),
      'owner': serializer.toJson<int?>(owner),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'delivrables': serializer.toJson<String>(delivrables),
      'isfavorite': serializer.toJson<bool>(isfavorite),
    };
  }

  TaskTableData copyWith(
          {int? id,
          double? price,
          String? title,
          String? description,
          int? category,
          Value<int?> governorate = const Value.absent(),
          Value<int?> owner = const Value.absent(),
          DateTime? dueDate,
          String? delivrables,
          bool? isfavorite}) =>
      TaskTableData(
        id: id ?? this.id,
        price: price ?? this.price,
        title: title ?? this.title,
        description: description ?? this.description,
        category: category ?? this.category,
        governorate: governorate.present ? governorate.value : this.governorate,
        owner: owner.present ? owner.value : this.owner,
        dueDate: dueDate ?? this.dueDate,
        delivrables: delivrables ?? this.delivrables,
        isfavorite: isfavorite ?? this.isfavorite,
      );
  TaskTableData copyWithCompanion(TaskTableCompanion data) {
    return TaskTableData(
      id: data.id.present ? data.id.value : this.id,
      price: data.price.present ? data.price.value : this.price,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      category: data.category.present ? data.category.value : this.category,
      governorate:
          data.governorate.present ? data.governorate.value : this.governorate,
      owner: data.owner.present ? data.owner.value : this.owner,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      delivrables:
          data.delivrables.present ? data.delivrables.value : this.delivrables,
      isfavorite:
          data.isfavorite.present ? data.isfavorite.value : this.isfavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskTableData(')
          ..write('id: $id, ')
          ..write('price: $price, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('governorate: $governorate, ')
          ..write('owner: $owner, ')
          ..write('dueDate: $dueDate, ')
          ..write('delivrables: $delivrables, ')
          ..write('isfavorite: $isfavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, price, title, description, category,
      governorate, owner, dueDate, delivrables, isfavorite);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskTableData &&
          other.id == this.id &&
          other.price == this.price &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.governorate == this.governorate &&
          other.owner == this.owner &&
          other.dueDate == this.dueDate &&
          other.delivrables == this.delivrables &&
          other.isfavorite == this.isfavorite);
}

class TaskTableCompanion extends UpdateCompanion<TaskTableData> {
  final Value<int> id;
  final Value<double> price;
  final Value<String> title;
  final Value<String> description;
  final Value<int> category;
  final Value<int?> governorate;
  final Value<int?> owner;
  final Value<DateTime> dueDate;
  final Value<String> delivrables;
  final Value<bool> isfavorite;
  const TaskTableCompanion({
    this.id = const Value.absent(),
    this.price = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.governorate = const Value.absent(),
    this.owner = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.delivrables = const Value.absent(),
    this.isfavorite = const Value.absent(),
  });
  TaskTableCompanion.insert({
    this.id = const Value.absent(),
    this.price = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    required int category,
    this.governorate = const Value.absent(),
    this.owner = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.delivrables = const Value.absent(),
    this.isfavorite = const Value.absent(),
  }) : category = Value(category);
  static Insertable<TaskTableData> custom({
    Expression<int>? id,
    Expression<double>? price,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? category,
    Expression<int>? governorate,
    Expression<int>? owner,
    Expression<DateTime>? dueDate,
    Expression<String>? delivrables,
    Expression<bool>? isfavorite,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (price != null) 'price': price,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (governorate != null) 'governorate': governorate,
      if (owner != null) 'owner': owner,
      if (dueDate != null) 'due_date': dueDate,
      if (delivrables != null) 'delivrables': delivrables,
      if (isfavorite != null) 'isfavorite': isfavorite,
    });
  }

  TaskTableCompanion copyWith(
      {Value<int>? id,
      Value<double>? price,
      Value<String>? title,
      Value<String>? description,
      Value<int>? category,
      Value<int?>? governorate,
      Value<int?>? owner,
      Value<DateTime>? dueDate,
      Value<String>? delivrables,
      Value<bool>? isfavorite}) {
    return TaskTableCompanion(
      id: id ?? this.id,
      price: price ?? this.price,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      governorate: governorate ?? this.governorate,
      owner: owner ?? this.owner,
      dueDate: dueDate ?? this.dueDate,
      delivrables: delivrables ?? this.delivrables,
      isfavorite: isfavorite ?? this.isfavorite,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(category.value);
    }
    if (governorate.present) {
      map['governorate'] = Variable<int>(governorate.value);
    }
    if (owner.present) {
      map['owner'] = Variable<int>(owner.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (delivrables.present) {
      map['delivrables'] = Variable<String>(delivrables.value);
    }
    if (isfavorite.present) {
      map['isfavorite'] = Variable<bool>(isfavorite.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskTableCompanion(')
          ..write('id: $id, ')
          ..write('price: $price, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('governorate: $governorate, ')
          ..write('owner: $owner, ')
          ..write('dueDate: $dueDate, ')
          ..write('delivrables: $delivrables, ')
          ..write('isfavorite: $isfavorite')
          ..write(')'))
        .toString();
  }
}

class $TaskAttachmentTableTable extends TaskAttachmentTable
    with TableInfo<$TaskAttachmentTableTable, TaskAttachmentTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskAttachmentTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
      'task_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES task_table (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, url, type, taskId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_attachment_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<TaskAttachmentTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskAttachmentTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskAttachmentTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}task_id']),
    );
  }

  @override
  $TaskAttachmentTableTable createAlias(String alias) {
    return $TaskAttachmentTableTable(attachedDatabase, alias);
  }
}

class TaskAttachmentTableData extends DataClass
    implements Insertable<TaskAttachmentTableData> {
  final int id;
  final String url;
  final String type;
  final int? taskId;
  const TaskAttachmentTableData(
      {required this.id, required this.url, required this.type, this.taskId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['url'] = Variable<String>(url);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<int>(taskId);
    }
    return map;
  }

  TaskAttachmentTableCompanion toCompanion(bool nullToAbsent) {
    return TaskAttachmentTableCompanion(
      id: Value(id),
      url: Value(url),
      type: Value(type),
      taskId:
          taskId == null && nullToAbsent ? const Value.absent() : Value(taskId),
    );
  }

  factory TaskAttachmentTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskAttachmentTableData(
      id: serializer.fromJson<int>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      type: serializer.fromJson<String>(json['type']),
      taskId: serializer.fromJson<int?>(json['taskId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'url': serializer.toJson<String>(url),
      'type': serializer.toJson<String>(type),
      'taskId': serializer.toJson<int?>(taskId),
    };
  }

  TaskAttachmentTableData copyWith(
          {int? id,
          String? url,
          String? type,
          Value<int?> taskId = const Value.absent()}) =>
      TaskAttachmentTableData(
        id: id ?? this.id,
        url: url ?? this.url,
        type: type ?? this.type,
        taskId: taskId.present ? taskId.value : this.taskId,
      );
  TaskAttachmentTableData copyWithCompanion(TaskAttachmentTableCompanion data) {
    return TaskAttachmentTableData(
      id: data.id.present ? data.id.value : this.id,
      url: data.url.present ? data.url.value : this.url,
      type: data.type.present ? data.type.value : this.type,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskAttachmentTableData(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('type: $type, ')
          ..write('taskId: $taskId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, url, type, taskId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskAttachmentTableData &&
          other.id == this.id &&
          other.url == this.url &&
          other.type == this.type &&
          other.taskId == this.taskId);
}

class TaskAttachmentTableCompanion
    extends UpdateCompanion<TaskAttachmentTableData> {
  final Value<int> id;
  final Value<String> url;
  final Value<String> type;
  final Value<int?> taskId;
  const TaskAttachmentTableCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.type = const Value.absent(),
    this.taskId = const Value.absent(),
  });
  TaskAttachmentTableCompanion.insert({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.type = const Value.absent(),
    this.taskId = const Value.absent(),
  });
  static Insertable<TaskAttachmentTableData> custom({
    Expression<int>? id,
    Expression<String>? url,
    Expression<String>? type,
    Expression<int>? taskId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (type != null) 'type': type,
      if (taskId != null) 'task_id': taskId,
    });
  }

  TaskAttachmentTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? url,
      Value<String>? type,
      Value<int?>? taskId}) {
    return TaskAttachmentTableCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      type: type ?? this.type,
      taskId: taskId ?? this.taskId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskAttachmentTableCompanion(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('type: $type, ')
          ..write('taskId: $taskId')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  $DatabaseManager get managers => $DatabaseManager(this);
  late final $CategoryTableTable categoryTable = $CategoryTableTable(this);
  late final $GovernorateTableTable governorateTable =
      $GovernorateTableTable(this);
  late final $UserTableTable userTable = $UserTableTable(this);
  late final $TaskTableTable taskTable = $TaskTableTable(this);
  late final $TaskAttachmentTableTable taskAttachmentTable =
      $TaskAttachmentTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        categoryTable,
        governorateTable,
        userTable,
        taskTable,
        taskAttachmentTable
      ];
}

typedef $$CategoryTableTableCreateCompanionBuilder = CategoryTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  required int icon,
  Value<int> parent,
});
typedef $$CategoryTableTableUpdateCompanionBuilder = CategoryTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<int> icon,
  Value<int> parent,
});

class $$CategoryTableTableTableManager extends RootTableManager<
    _$Database,
    $CategoryTableTable,
    CategoryTableData,
    $$CategoryTableTableFilterComposer,
    $$CategoryTableTableOrderingComposer,
    $$CategoryTableTableCreateCompanionBuilder,
    $$CategoryTableTableUpdateCompanionBuilder> {
  $$CategoryTableTableTableManager(_$Database db, $CategoryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CategoryTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CategoryTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> icon = const Value.absent(),
            Value<int> parent = const Value.absent(),
          }) =>
              CategoryTableCompanion(
            id: id,
            name: name,
            icon: icon,
            parent: parent,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            required int icon,
            Value<int> parent = const Value.absent(),
          }) =>
              CategoryTableCompanion.insert(
            id: id,
            name: name,
            icon: icon,
            parent: parent,
          ),
        ));
}

class $$CategoryTableTableFilterComposer
    extends FilterComposer<_$Database, $CategoryTableTable> {
  $$CategoryTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get icon => $state.composableBuilder(
      column: $state.table.icon,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$CategoryTableTableFilterComposer get parent {
    final $$CategoryTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parent,
        referencedTable: $state.db.categoryTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CategoryTableTableFilterComposer(ComposerState($state.db,
                $state.db.categoryTable, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter taskTableRefs(
      ComposableFilter Function($$TaskTableTableFilterComposer f) f) {
    final $$TaskTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.taskTable,
        getReferencedColumn: (t) => t.category,
        builder: (joinBuilder, parentComposers) =>
            $$TaskTableTableFilterComposer(ComposerState(
                $state.db, $state.db.taskTable, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$CategoryTableTableOrderingComposer
    extends OrderingComposer<_$Database, $CategoryTableTable> {
  $$CategoryTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get icon => $state.composableBuilder(
      column: $state.table.icon,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$CategoryTableTableOrderingComposer get parent {
    final $$CategoryTableTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.parent,
            referencedTable: $state.db.categoryTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$CategoryTableTableOrderingComposer(ComposerState($state.db,
                    $state.db.categoryTable, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$GovernorateTableTableCreateCompanionBuilder
    = GovernorateTableCompanion Function({
  Value<int> id,
  Value<String> name,
});
typedef $$GovernorateTableTableUpdateCompanionBuilder
    = GovernorateTableCompanion Function({
  Value<int> id,
  Value<String> name,
});

class $$GovernorateTableTableTableManager extends RootTableManager<
    _$Database,
    $GovernorateTableTable,
    GovernorateTableData,
    $$GovernorateTableTableFilterComposer,
    $$GovernorateTableTableOrderingComposer,
    $$GovernorateTableTableCreateCompanionBuilder,
    $$GovernorateTableTableUpdateCompanionBuilder> {
  $$GovernorateTableTableTableManager(
      _$Database db, $GovernorateTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$GovernorateTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$GovernorateTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              GovernorateTableCompanion(
            id: id,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              GovernorateTableCompanion.insert(
            id: id,
            name: name,
          ),
        ));
}

class $$GovernorateTableTableFilterComposer
    extends FilterComposer<_$Database, $GovernorateTableTable> {
  $$GovernorateTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter userTableRefs(
      ComposableFilter Function($$UserTableTableFilterComposer f) f) {
    final $$UserTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.userTable,
        getReferencedColumn: (t) => t.governorate,
        builder: (joinBuilder, parentComposers) =>
            $$UserTableTableFilterComposer(ComposerState(
                $state.db, $state.db.userTable, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter taskTableRefs(
      ComposableFilter Function($$TaskTableTableFilterComposer f) f) {
    final $$TaskTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.taskTable,
        getReferencedColumn: (t) => t.governorate,
        builder: (joinBuilder, parentComposers) =>
            $$TaskTableTableFilterComposer(ComposerState(
                $state.db, $state.db.taskTable, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$GovernorateTableTableOrderingComposer
    extends OrderingComposer<_$Database, $GovernorateTableTable> {
  $$GovernorateTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$UserTableTableCreateCompanionBuilder = UserTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> email,
  Value<String> phone,
  Value<String> picture,
  Value<Role> role,
  Value<Gender> gender,
  Value<VerifyIdentityStatus> isVerified,
  Value<bool> isMailVerified,
  Value<DateTime?> birthdate,
  Value<String> bio,
  Value<String?> coordinates,
  Value<int> governorate,
});
typedef $$UserTableTableUpdateCompanionBuilder = UserTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> email,
  Value<String> phone,
  Value<String> picture,
  Value<Role> role,
  Value<Gender> gender,
  Value<VerifyIdentityStatus> isVerified,
  Value<bool> isMailVerified,
  Value<DateTime?> birthdate,
  Value<String> bio,
  Value<String?> coordinates,
  Value<int> governorate,
});

class $$UserTableTableTableManager extends RootTableManager<
    _$Database,
    $UserTableTable,
    UserTableData,
    $$UserTableTableFilterComposer,
    $$UserTableTableOrderingComposer,
    $$UserTableTableCreateCompanionBuilder,
    $$UserTableTableUpdateCompanionBuilder> {
  $$UserTableTableTableManager(_$Database db, $UserTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$UserTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$UserTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> picture = const Value.absent(),
            Value<Role> role = const Value.absent(),
            Value<Gender> gender = const Value.absent(),
            Value<VerifyIdentityStatus> isVerified = const Value.absent(),
            Value<bool> isMailVerified = const Value.absent(),
            Value<DateTime?> birthdate = const Value.absent(),
            Value<String> bio = const Value.absent(),
            Value<String?> coordinates = const Value.absent(),
            Value<int> governorate = const Value.absent(),
          }) =>
              UserTableCompanion(
            id: id,
            name: name,
            email: email,
            phone: phone,
            picture: picture,
            role: role,
            gender: gender,
            isVerified: isVerified,
            isMailVerified: isMailVerified,
            birthdate: birthdate,
            bio: bio,
            coordinates: coordinates,
            governorate: governorate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> picture = const Value.absent(),
            Value<Role> role = const Value.absent(),
            Value<Gender> gender = const Value.absent(),
            Value<VerifyIdentityStatus> isVerified = const Value.absent(),
            Value<bool> isMailVerified = const Value.absent(),
            Value<DateTime?> birthdate = const Value.absent(),
            Value<String> bio = const Value.absent(),
            Value<String?> coordinates = const Value.absent(),
            Value<int> governorate = const Value.absent(),
          }) =>
              UserTableCompanion.insert(
            id: id,
            name: name,
            email: email,
            phone: phone,
            picture: picture,
            role: role,
            gender: gender,
            isVerified: isVerified,
            isMailVerified: isMailVerified,
            birthdate: birthdate,
            bio: bio,
            coordinates: coordinates,
            governorate: governorate,
          ),
        ));
}

class $$UserTableTableFilterComposer
    extends FilterComposer<_$Database, $UserTableTable> {
  $$UserTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get phone => $state.composableBuilder(
      column: $state.table.phone,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get picture => $state.composableBuilder(
      column: $state.table.picture,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<Role, Role, int> get role =>
      $state.composableBuilder(
          column: $state.table.role,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<Gender, Gender, int> get gender =>
      $state.composableBuilder(
          column: $state.table.gender,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<VerifyIdentityStatus, VerifyIdentityStatus,
          int>
      get isVerified => $state.composableBuilder(
          column: $state.table.isVerified,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<bool> get isMailVerified => $state.composableBuilder(
      column: $state.table.isMailVerified,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get birthdate => $state.composableBuilder(
      column: $state.table.birthdate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get bio => $state.composableBuilder(
      column: $state.table.bio,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get coordinates => $state.composableBuilder(
      column: $state.table.coordinates,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$GovernorateTableTableFilterComposer get governorate {
    final $$GovernorateTableTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.governorate,
            referencedTable: $state.db.governorateTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$GovernorateTableTableFilterComposer(ComposerState($state.db,
                    $state.db.governorateTable, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter taskTableRefs(
      ComposableFilter Function($$TaskTableTableFilterComposer f) f) {
    final $$TaskTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.taskTable,
        getReferencedColumn: (t) => t.owner,
        builder: (joinBuilder, parentComposers) =>
            $$TaskTableTableFilterComposer(ComposerState(
                $state.db, $state.db.taskTable, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$UserTableTableOrderingComposer
    extends OrderingComposer<_$Database, $UserTableTable> {
  $$UserTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get phone => $state.composableBuilder(
      column: $state.table.phone,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get picture => $state.composableBuilder(
      column: $state.table.picture,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get role => $state.composableBuilder(
      column: $state.table.role,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get gender => $state.composableBuilder(
      column: $state.table.gender,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get isVerified => $state.composableBuilder(
      column: $state.table.isVerified,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isMailVerified => $state.composableBuilder(
      column: $state.table.isMailVerified,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get birthdate => $state.composableBuilder(
      column: $state.table.birthdate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get bio => $state.composableBuilder(
      column: $state.table.bio,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get coordinates => $state.composableBuilder(
      column: $state.table.coordinates,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$GovernorateTableTableOrderingComposer get governorate {
    final $$GovernorateTableTableOrderingComposer composer = $state
        .composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.governorate,
            referencedTable: $state.db.governorateTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$GovernorateTableTableOrderingComposer(ComposerState($state.db,
                    $state.db.governorateTable, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$TaskTableTableCreateCompanionBuilder = TaskTableCompanion Function({
  Value<int> id,
  Value<double> price,
  Value<String> title,
  Value<String> description,
  required int category,
  Value<int?> governorate,
  Value<int?> owner,
  Value<DateTime> dueDate,
  Value<String> delivrables,
  Value<bool> isfavorite,
});
typedef $$TaskTableTableUpdateCompanionBuilder = TaskTableCompanion Function({
  Value<int> id,
  Value<double> price,
  Value<String> title,
  Value<String> description,
  Value<int> category,
  Value<int?> governorate,
  Value<int?> owner,
  Value<DateTime> dueDate,
  Value<String> delivrables,
  Value<bool> isfavorite,
});

class $$TaskTableTableTableManager extends RootTableManager<
    _$Database,
    $TaskTableTable,
    TaskTableData,
    $$TaskTableTableFilterComposer,
    $$TaskTableTableOrderingComposer,
    $$TaskTableTableCreateCompanionBuilder,
    $$TaskTableTableUpdateCompanionBuilder> {
  $$TaskTableTableTableManager(_$Database db, $TaskTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TaskTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TaskTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> category = const Value.absent(),
            Value<int?> governorate = const Value.absent(),
            Value<int?> owner = const Value.absent(),
            Value<DateTime> dueDate = const Value.absent(),
            Value<String> delivrables = const Value.absent(),
            Value<bool> isfavorite = const Value.absent(),
          }) =>
              TaskTableCompanion(
            id: id,
            price: price,
            title: title,
            description: description,
            category: category,
            governorate: governorate,
            owner: owner,
            dueDate: dueDate,
            delivrables: delivrables,
            isfavorite: isfavorite,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            required int category,
            Value<int?> governorate = const Value.absent(),
            Value<int?> owner = const Value.absent(),
            Value<DateTime> dueDate = const Value.absent(),
            Value<String> delivrables = const Value.absent(),
            Value<bool> isfavorite = const Value.absent(),
          }) =>
              TaskTableCompanion.insert(
            id: id,
            price: price,
            title: title,
            description: description,
            category: category,
            governorate: governorate,
            owner: owner,
            dueDate: dueDate,
            delivrables: delivrables,
            isfavorite: isfavorite,
          ),
        ));
}

class $$TaskTableTableFilterComposer
    extends FilterComposer<_$Database, $TaskTableTable> {
  $$TaskTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get price => $state.composableBuilder(
      column: $state.table.price,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get dueDate => $state.composableBuilder(
      column: $state.table.dueDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get delivrables => $state.composableBuilder(
      column: $state.table.delivrables,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isfavorite => $state.composableBuilder(
      column: $state.table.isfavorite,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$CategoryTableTableFilterComposer get category {
    final $$CategoryTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.category,
        referencedTable: $state.db.categoryTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CategoryTableTableFilterComposer(ComposerState($state.db,
                $state.db.categoryTable, joinBuilder, parentComposers)));
    return composer;
  }

  $$GovernorateTableTableFilterComposer get governorate {
    final $$GovernorateTableTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.governorate,
            referencedTable: $state.db.governorateTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$GovernorateTableTableFilterComposer(ComposerState($state.db,
                    $state.db.governorateTable, joinBuilder, parentComposers)));
    return composer;
  }

  $$UserTableTableFilterComposer get owner {
    final $$UserTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.owner,
        referencedTable: $state.db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$UserTableTableFilterComposer(ComposerState(
                $state.db, $state.db.userTable, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter taskAttachmentTableRefs(
      ComposableFilter Function($$TaskAttachmentTableTableFilterComposer f) f) {
    final $$TaskAttachmentTableTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.taskAttachmentTable,
            getReferencedColumn: (t) => t.taskId,
            builder: (joinBuilder, parentComposers) =>
                $$TaskAttachmentTableTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.taskAttachmentTable,
                    joinBuilder,
                    parentComposers)));
    return f(composer);
  }
}

class $$TaskTableTableOrderingComposer
    extends OrderingComposer<_$Database, $TaskTableTable> {
  $$TaskTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get price => $state.composableBuilder(
      column: $state.table.price,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get dueDate => $state.composableBuilder(
      column: $state.table.dueDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get delivrables => $state.composableBuilder(
      column: $state.table.delivrables,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isfavorite => $state.composableBuilder(
      column: $state.table.isfavorite,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$CategoryTableTableOrderingComposer get category {
    final $$CategoryTableTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.category,
            referencedTable: $state.db.categoryTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$CategoryTableTableOrderingComposer(ComposerState($state.db,
                    $state.db.categoryTable, joinBuilder, parentComposers)));
    return composer;
  }

  $$GovernorateTableTableOrderingComposer get governorate {
    final $$GovernorateTableTableOrderingComposer composer = $state
        .composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.governorate,
            referencedTable: $state.db.governorateTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$GovernorateTableTableOrderingComposer(ComposerState($state.db,
                    $state.db.governorateTable, joinBuilder, parentComposers)));
    return composer;
  }

  $$UserTableTableOrderingComposer get owner {
    final $$UserTableTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.owner,
        referencedTable: $state.db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$UserTableTableOrderingComposer(ComposerState(
                $state.db, $state.db.userTable, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$TaskAttachmentTableTableCreateCompanionBuilder
    = TaskAttachmentTableCompanion Function({
  Value<int> id,
  Value<String> url,
  Value<String> type,
  Value<int?> taskId,
});
typedef $$TaskAttachmentTableTableUpdateCompanionBuilder
    = TaskAttachmentTableCompanion Function({
  Value<int> id,
  Value<String> url,
  Value<String> type,
  Value<int?> taskId,
});

class $$TaskAttachmentTableTableTableManager extends RootTableManager<
    _$Database,
    $TaskAttachmentTableTable,
    TaskAttachmentTableData,
    $$TaskAttachmentTableTableFilterComposer,
    $$TaskAttachmentTableTableOrderingComposer,
    $$TaskAttachmentTableTableCreateCompanionBuilder,
    $$TaskAttachmentTableTableUpdateCompanionBuilder> {
  $$TaskAttachmentTableTableTableManager(
      _$Database db, $TaskAttachmentTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$TaskAttachmentTableTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$TaskAttachmentTableTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int?> taskId = const Value.absent(),
          }) =>
              TaskAttachmentTableCompanion(
            id: id,
            url: url,
            type: type,
            taskId: taskId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int?> taskId = const Value.absent(),
          }) =>
              TaskAttachmentTableCompanion.insert(
            id: id,
            url: url,
            type: type,
            taskId: taskId,
          ),
        ));
}

class $$TaskAttachmentTableTableFilterComposer
    extends FilterComposer<_$Database, $TaskAttachmentTableTable> {
  $$TaskAttachmentTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get url => $state.composableBuilder(
      column: $state.table.url,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$TaskTableTableFilterComposer get taskId {
    final $$TaskTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskId,
        referencedTable: $state.db.taskTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$TaskTableTableFilterComposer(ComposerState(
                $state.db, $state.db.taskTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$TaskAttachmentTableTableOrderingComposer
    extends OrderingComposer<_$Database, $TaskAttachmentTableTable> {
  $$TaskAttachmentTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get url => $state.composableBuilder(
      column: $state.table.url,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$TaskTableTableOrderingComposer get taskId {
    final $$TaskTableTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskId,
        referencedTable: $state.db.taskTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$TaskTableTableOrderingComposer(ComposerState(
                $state.db, $state.db.taskTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class $DatabaseManager {
  final _$Database _db;
  $DatabaseManager(this._db);
  $$CategoryTableTableTableManager get categoryTable =>
      $$CategoryTableTableTableManager(_db, _db.categoryTable);
  $$GovernorateTableTableTableManager get governorateTable =>
      $$GovernorateTableTableTableManager(_db, _db.governorateTable);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db, _db.userTable);
  $$TaskTableTableTableManager get taskTable =>
      $$TaskTableTableTableManager(_db, _db.taskTable);
  $$TaskAttachmentTableTableTableManager get taskAttachmentTable =>
      $$TaskAttachmentTableTableTableManager(_db, _db.taskAttachmentTable);
}