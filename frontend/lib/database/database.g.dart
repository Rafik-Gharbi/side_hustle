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
  static const VerificationMeta _subscribedMeta =
      const VerificationMeta('subscribed');
  @override
  late final GeneratedColumn<int> subscribed = GeneratedColumn<int>(
      'subscribed', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, name, icon, parent, subscribed];
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
    if (data.containsKey('subscribed')) {
      context.handle(
          _subscribedMeta,
          subscribed.isAcceptableOrUnknown(
              data['subscribed']!, _subscribedMeta));
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
      subscribed: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}subscribed'])!,
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
  final int subscribed;
  const CategoryTableData(
      {required this.id,
      required this.name,
      required this.icon,
      required this.parent,
      required this.subscribed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<int>(icon);
    map['parent'] = Variable<int>(parent);
    map['subscribed'] = Variable<int>(subscribed);
    return map;
  }

  CategoryTableCompanion toCompanion(bool nullToAbsent) {
    return CategoryTableCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      parent: Value(parent),
      subscribed: Value(subscribed),
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
      subscribed: serializer.fromJson<int>(json['subscribed']),
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
      'subscribed': serializer.toJson<int>(subscribed),
    };
  }

  CategoryTableData copyWith(
          {int? id, String? name, int? icon, int? parent, int? subscribed}) =>
      CategoryTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        parent: parent ?? this.parent,
        subscribed: subscribed ?? this.subscribed,
      );
  CategoryTableData copyWithCompanion(CategoryTableCompanion data) {
    return CategoryTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      parent: data.parent.present ? data.parent.value : this.parent,
      subscribed:
          data.subscribed.present ? data.subscribed.value : this.subscribed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('parent: $parent, ')
          ..write('subscribed: $subscribed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, parent, subscribed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.parent == this.parent &&
          other.subscribed == this.subscribed);
}

class CategoryTableCompanion extends UpdateCompanion<CategoryTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> icon;
  final Value<int> parent;
  final Value<int> subscribed;
  const CategoryTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.parent = const Value.absent(),
    this.subscribed = const Value.absent(),
  });
  CategoryTableCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    required int icon,
    this.parent = const Value.absent(),
    this.subscribed = const Value.absent(),
  }) : icon = Value(icon);
  static Insertable<CategoryTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? icon,
    Expression<int>? parent,
    Expression<int>? subscribed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (parent != null) 'parent': parent,
      if (subscribed != null) 'subscribed': subscribed,
    });
  }

  CategoryTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? icon,
      Value<int>? parent,
      Value<int>? subscribed}) {
    return CategoryTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      parent: parent ?? this.parent,
      subscribed: subscribed ?? this.subscribed,
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
    if (subscribed.present) {
      map['subscribed'] = Variable<int>(subscribed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('parent: $parent, ')
          ..write('subscribed: $subscribed')
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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
    } else if (isInserting) {
      context.missing(_idMeta);
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
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  TaskTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
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
  final String id;
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
    map['id'] = Variable<String>(id);
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
      id: serializer.fromJson<String>(json['id']),
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
      'id': serializer.toJson<String>(id),
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
          {String? id,
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
  final Value<String> id;
  final Value<double> price;
  final Value<String> title;
  final Value<String> description;
  final Value<int> category;
  final Value<int?> governorate;
  final Value<int?> owner;
  final Value<DateTime> dueDate;
  final Value<String> delivrables;
  final Value<bool> isfavorite;
  final Value<int> rowid;
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
    this.rowid = const Value.absent(),
  });
  TaskTableCompanion.insert({
    required String id,
    this.price = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    required int category,
    this.governorate = const Value.absent(),
    this.owner = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.delivrables = const Value.absent(),
    this.isfavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        category = Value(category);
  static Insertable<TaskTableData> custom({
    Expression<String>? id,
    Expression<double>? price,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? category,
    Expression<int>? governorate,
    Expression<int>? owner,
    Expression<DateTime>? dueDate,
    Expression<String>? delivrables,
    Expression<bool>? isfavorite,
    Expression<int>? rowid,
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
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskTableCompanion copyWith(
      {Value<String>? id,
      Value<double>? price,
      Value<String>? title,
      Value<String>? description,
      Value<int>? category,
      Value<int?>? governorate,
      Value<int?>? owner,
      Value<DateTime>? dueDate,
      Value<String>? delivrables,
      Value<bool>? isfavorite,
      Value<int>? rowid}) {
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
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
          ..write('isfavorite: $isfavorite, ')
          ..write('rowid: $rowid')
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
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, true,
      type: DriftSqlType.string,
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
          .read(DriftSqlType.string, data['${effectivePrefix}task_id']),
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
  final String? taskId;
  const TaskAttachmentTableData(
      {required this.id, required this.url, required this.type, this.taskId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['url'] = Variable<String>(url);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
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
      taskId: serializer.fromJson<String?>(json['taskId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'url': serializer.toJson<String>(url),
      'type': serializer.toJson<String>(type),
      'taskId': serializer.toJson<String?>(taskId),
    };
  }

  TaskAttachmentTableData copyWith(
          {int? id,
          String? url,
          String? type,
          Value<String?> taskId = const Value.absent()}) =>
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
  final Value<String?> taskId;
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
    Expression<String>? taskId,
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
      Value<String?>? taskId}) {
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
      map['task_id'] = Variable<String>(taskId.value);
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

class $StoreTableTable extends StoreTable
    with TableInfo<$StoreTableTable, StoreTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoreTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
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
  static const VerificationMeta _coordinatesMeta =
      const VerificationMeta('coordinates');
  @override
  late final GeneratedColumn<String> coordinates = GeneratedColumn<String>(
      'coordinates', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
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
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        picture,
        coordinates,
        governorate,
        owner,
        isFavorite
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'store_table';
  @override
  VerificationContext validateIntegrity(Insertable<StoreTableData> instance,
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
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('picture')) {
      context.handle(_pictureMeta,
          picture.isAcceptableOrUnknown(data['picture']!, _pictureMeta));
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
    if (data.containsKey('owner')) {
      context.handle(
          _ownerMeta, owner.isAcceptableOrUnknown(data['owner']!, _ownerMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoreTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoreTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      picture: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}picture'])!,
      coordinates: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}coordinates'])!,
      governorate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}governorate']),
      owner: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}owner']),
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
    );
  }

  @override
  $StoreTableTable createAlias(String alias) {
    return $StoreTableTable(attachedDatabase, alias);
  }
}

class StoreTableData extends DataClass implements Insertable<StoreTableData> {
  final int id;
  final String name;
  final String description;
  final String picture;
  final String coordinates;
  final int? governorate;
  final int? owner;
  final bool isFavorite;
  const StoreTableData(
      {required this.id,
      required this.name,
      required this.description,
      required this.picture,
      required this.coordinates,
      this.governorate,
      this.owner,
      required this.isFavorite});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['picture'] = Variable<String>(picture);
    map['coordinates'] = Variable<String>(coordinates);
    if (!nullToAbsent || governorate != null) {
      map['governorate'] = Variable<int>(governorate);
    }
    if (!nullToAbsent || owner != null) {
      map['owner'] = Variable<int>(owner);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  StoreTableCompanion toCompanion(bool nullToAbsent) {
    return StoreTableCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      picture: Value(picture),
      coordinates: Value(coordinates),
      governorate: governorate == null && nullToAbsent
          ? const Value.absent()
          : Value(governorate),
      owner:
          owner == null && nullToAbsent ? const Value.absent() : Value(owner),
      isFavorite: Value(isFavorite),
    );
  }

  factory StoreTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoreTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      picture: serializer.fromJson<String>(json['picture']),
      coordinates: serializer.fromJson<String>(json['coordinates']),
      governorate: serializer.fromJson<int?>(json['governorate']),
      owner: serializer.fromJson<int?>(json['owner']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'picture': serializer.toJson<String>(picture),
      'coordinates': serializer.toJson<String>(coordinates),
      'governorate': serializer.toJson<int?>(governorate),
      'owner': serializer.toJson<int?>(owner),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  StoreTableData copyWith(
          {int? id,
          String? name,
          String? description,
          String? picture,
          String? coordinates,
          Value<int?> governorate = const Value.absent(),
          Value<int?> owner = const Value.absent(),
          bool? isFavorite}) =>
      StoreTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        picture: picture ?? this.picture,
        coordinates: coordinates ?? this.coordinates,
        governorate: governorate.present ? governorate.value : this.governorate,
        owner: owner.present ? owner.value : this.owner,
        isFavorite: isFavorite ?? this.isFavorite,
      );
  StoreTableData copyWithCompanion(StoreTableCompanion data) {
    return StoreTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      picture: data.picture.present ? data.picture.value : this.picture,
      coordinates:
          data.coordinates.present ? data.coordinates.value : this.coordinates,
      governorate:
          data.governorate.present ? data.governorate.value : this.governorate,
      owner: data.owner.present ? data.owner.value : this.owner,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoreTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('picture: $picture, ')
          ..write('coordinates: $coordinates, ')
          ..write('governorate: $governorate, ')
          ..write('owner: $owner, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, picture, coordinates,
      governorate, owner, isFavorite);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoreTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.picture == this.picture &&
          other.coordinates == this.coordinates &&
          other.governorate == this.governorate &&
          other.owner == this.owner &&
          other.isFavorite == this.isFavorite);
}

class StoreTableCompanion extends UpdateCompanion<StoreTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> picture;
  final Value<String> coordinates;
  final Value<int?> governorate;
  final Value<int?> owner;
  final Value<bool> isFavorite;
  const StoreTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.picture = const Value.absent(),
    this.coordinates = const Value.absent(),
    this.governorate = const Value.absent(),
    this.owner = const Value.absent(),
    this.isFavorite = const Value.absent(),
  });
  StoreTableCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.picture = const Value.absent(),
    this.coordinates = const Value.absent(),
    this.governorate = const Value.absent(),
    this.owner = const Value.absent(),
    this.isFavorite = const Value.absent(),
  });
  static Insertable<StoreTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? picture,
    Expression<String>? coordinates,
    Expression<int>? governorate,
    Expression<int>? owner,
    Expression<bool>? isFavorite,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (picture != null) 'picture': picture,
      if (coordinates != null) 'coordinates': coordinates,
      if (governorate != null) 'governorate': governorate,
      if (owner != null) 'owner': owner,
      if (isFavorite != null) 'is_favorite': isFavorite,
    });
  }

  StoreTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? description,
      Value<String>? picture,
      Value<String>? coordinates,
      Value<int?>? governorate,
      Value<int?>? owner,
      Value<bool>? isFavorite}) {
    return StoreTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      picture: picture ?? this.picture,
      coordinates: coordinates ?? this.coordinates,
      governorate: governorate ?? this.governorate,
      owner: owner ?? this.owner,
      isFavorite: isFavorite ?? this.isFavorite,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (picture.present) {
      map['picture'] = Variable<String>(picture.value);
    }
    if (coordinates.present) {
      map['coordinates'] = Variable<String>(coordinates.value);
    }
    if (governorate.present) {
      map['governorate'] = Variable<int>(governorate.value);
    }
    if (owner.present) {
      map['owner'] = Variable<int>(owner.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoreTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('picture: $picture, ')
          ..write('coordinates: $coordinates, ')
          ..write('governorate: $governorate, ')
          ..write('owner: $owner, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }
}

class $ServiceTableTable extends ServiceTable
    with TableInfo<$ServiceTableTable, ServiceTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
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
      'category', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES category_table (id)'));
  static const VerificationMeta _storeMeta = const VerificationMeta('store');
  @override
  late final GeneratedColumn<int> store = GeneratedColumn<int>(
      'store', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES store_table (id)'));
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, description, category, store, price];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_table';
  @override
  VerificationContext validateIntegrity(Insertable<ServiceTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
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
    }
    if (data.containsKey('store')) {
      context.handle(
          _storeMeta, store.isAcceptableOrUnknown(data['store']!, _storeMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  ServiceTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category']),
      store: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}store']),
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
    );
  }

  @override
  $ServiceTableTable createAlias(String alias) {
    return $ServiceTableTable(attachedDatabase, alias);
  }
}

class ServiceTableData extends DataClass
    implements Insertable<ServiceTableData> {
  final String id;
  final String name;
  final String description;
  final int? category;
  final int? store;
  final double price;
  const ServiceTableData(
      {required this.id,
      required this.name,
      required this.description,
      this.category,
      this.store,
      required this.price});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<int>(category);
    }
    if (!nullToAbsent || store != null) {
      map['store'] = Variable<int>(store);
    }
    map['price'] = Variable<double>(price);
    return map;
  }

  ServiceTableCompanion toCompanion(bool nullToAbsent) {
    return ServiceTableCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      store:
          store == null && nullToAbsent ? const Value.absent() : Value(store),
      price: Value(price),
    );
  }

  factory ServiceTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<int?>(json['category']),
      store: serializer.fromJson<int?>(json['store']),
      price: serializer.fromJson<double>(json['price']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<int?>(category),
      'store': serializer.toJson<int?>(store),
      'price': serializer.toJson<double>(price),
    };
  }

  ServiceTableData copyWith(
          {String? id,
          String? name,
          String? description,
          Value<int?> category = const Value.absent(),
          Value<int?> store = const Value.absent(),
          double? price}) =>
      ServiceTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        category: category.present ? category.value : this.category,
        store: store.present ? store.value : this.store,
        price: price ?? this.price,
      );
  ServiceTableData copyWithCompanion(ServiceTableCompanion data) {
    return ServiceTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      category: data.category.present ? data.category.value : this.category,
      store: data.store.present ? data.store.value : this.store,
      price: data.price.present ? data.price.value : this.price,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('store: $store, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, category, store, price);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.category == this.category &&
          other.store == this.store &&
          other.price == this.price);
}

class ServiceTableCompanion extends UpdateCompanion<ServiceTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<int?> category;
  final Value<int?> store;
  final Value<double> price;
  final Value<int> rowid;
  const ServiceTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.store = const Value.absent(),
    this.price = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServiceTableCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.store = const Value.absent(),
    this.price = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<ServiceTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? category,
    Expression<int>? store,
    Expression<double>? price,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (store != null) 'store': store,
      if (price != null) 'price': price,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServiceTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? description,
      Value<int?>? category,
      Value<int?>? store,
      Value<double>? price,
      Value<int>? rowid}) {
    return ServiceTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      store: store ?? this.store,
      price: price ?? this.price,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(category.value);
    }
    if (store.present) {
      map['store'] = Variable<int>(store.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('store: $store, ')
          ..write('price: $price, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServiceGalleryTableTable extends ServiceGalleryTable
    with TableInfo<$ServiceGalleryTableTable, ServiceGalleryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceGalleryTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _serviceIdMeta =
      const VerificationMeta('serviceId');
  @override
  late final GeneratedColumn<String> serviceId = GeneratedColumn<String>(
      'service_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES service_table (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, url, type, serviceId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_gallery_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ServiceGalleryTableData> instance,
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
    if (data.containsKey('service_id')) {
      context.handle(_serviceIdMeta,
          serviceId.isAcceptableOrUnknown(data['service_id']!, _serviceIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceGalleryTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceGalleryTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      serviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}service_id']),
    );
  }

  @override
  $ServiceGalleryTableTable createAlias(String alias) {
    return $ServiceGalleryTableTable(attachedDatabase, alias);
  }
}

class ServiceGalleryTableData extends DataClass
    implements Insertable<ServiceGalleryTableData> {
  final int id;
  final String url;
  final String type;
  final String? serviceId;
  const ServiceGalleryTableData(
      {required this.id,
      required this.url,
      required this.type,
      this.serviceId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['url'] = Variable<String>(url);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || serviceId != null) {
      map['service_id'] = Variable<String>(serviceId);
    }
    return map;
  }

  ServiceGalleryTableCompanion toCompanion(bool nullToAbsent) {
    return ServiceGalleryTableCompanion(
      id: Value(id),
      url: Value(url),
      type: Value(type),
      serviceId: serviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(serviceId),
    );
  }

  factory ServiceGalleryTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceGalleryTableData(
      id: serializer.fromJson<int>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      type: serializer.fromJson<String>(json['type']),
      serviceId: serializer.fromJson<String?>(json['serviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'url': serializer.toJson<String>(url),
      'type': serializer.toJson<String>(type),
      'serviceId': serializer.toJson<String?>(serviceId),
    };
  }

  ServiceGalleryTableData copyWith(
          {int? id,
          String? url,
          String? type,
          Value<String?> serviceId = const Value.absent()}) =>
      ServiceGalleryTableData(
        id: id ?? this.id,
        url: url ?? this.url,
        type: type ?? this.type,
        serviceId: serviceId.present ? serviceId.value : this.serviceId,
      );
  ServiceGalleryTableData copyWithCompanion(ServiceGalleryTableCompanion data) {
    return ServiceGalleryTableData(
      id: data.id.present ? data.id.value : this.id,
      url: data.url.present ? data.url.value : this.url,
      type: data.type.present ? data.type.value : this.type,
      serviceId: data.serviceId.present ? data.serviceId.value : this.serviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceGalleryTableData(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('type: $type, ')
          ..write('serviceId: $serviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, url, type, serviceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceGalleryTableData &&
          other.id == this.id &&
          other.url == this.url &&
          other.type == this.type &&
          other.serviceId == this.serviceId);
}

class ServiceGalleryTableCompanion
    extends UpdateCompanion<ServiceGalleryTableData> {
  final Value<int> id;
  final Value<String> url;
  final Value<String> type;
  final Value<String?> serviceId;
  const ServiceGalleryTableCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.type = const Value.absent(),
    this.serviceId = const Value.absent(),
  });
  ServiceGalleryTableCompanion.insert({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.type = const Value.absent(),
    this.serviceId = const Value.absent(),
  });
  static Insertable<ServiceGalleryTableData> custom({
    Expression<int>? id,
    Expression<String>? url,
    Expression<String>? type,
    Expression<String>? serviceId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (type != null) 'type': type,
      if (serviceId != null) 'service_id': serviceId,
    });
  }

  ServiceGalleryTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? url,
      Value<String>? type,
      Value<String?>? serviceId}) {
    return ServiceGalleryTableCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      type: type ?? this.type,
      serviceId: serviceId ?? this.serviceId,
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
    if (serviceId.present) {
      map['service_id'] = Variable<String>(serviceId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceGalleryTableCompanion(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('type: $type, ')
          ..write('serviceId: $serviceId')
          ..write(')'))
        .toString();
  }
}

class $ReservationTableTable extends ReservationTable
    with TableInfo<$ReservationTableTable, ReservationTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReservationTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taskMeta = const VerificationMeta('task');
  @override
  late final GeneratedColumn<String> task = GeneratedColumn<String>(
      'task', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES task_table (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  static const VerificationMeta _totalPriceMeta =
      const VerificationMeta('totalPrice');
  @override
  late final GeneratedColumn<double> totalPrice = GeneratedColumn<double>(
      'total_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _proposedPriceMeta =
      const VerificationMeta('proposedPrice');
  @override
  late final GeneratedColumn<double> proposedPrice = GeneratedColumn<double>(
      'proposed_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _couponMeta = const VerificationMeta('coupon');
  @override
  late final GeneratedColumn<String> coupon = GeneratedColumn<String>(
      'coupon', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<RequestStatus, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(0))
          .withConverter<RequestStatus>(
              $ReservationTableTable.$converterstatus);
  static const VerificationMeta _userMeta = const VerificationMeta('user');
  @override
  late final GeneratedColumn<int> user = GeneratedColumn<int>(
      'user', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES user_table (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, task, date, totalPrice, proposedPrice, coupon, note, status, user];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reservation_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ReservationTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task')) {
      context.handle(
          _taskMeta, task.isAcceptableOrUnknown(data['task']!, _taskMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('total_price')) {
      context.handle(
          _totalPriceMeta,
          totalPrice.isAcceptableOrUnknown(
              data['total_price']!, _totalPriceMeta));
    }
    if (data.containsKey('proposed_price')) {
      context.handle(
          _proposedPriceMeta,
          proposedPrice.isAcceptableOrUnknown(
              data['proposed_price']!, _proposedPriceMeta));
    }
    if (data.containsKey('coupon')) {
      context.handle(_couponMeta,
          coupon.isAcceptableOrUnknown(data['coupon']!, _couponMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('user')) {
      context.handle(
          _userMeta, user.isAcceptableOrUnknown(data['user']!, _userMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  ReservationTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReservationTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      task: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      totalPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_price'])!,
      proposedPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}proposed_price']),
      coupon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}coupon'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      status: $ReservationTableTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      user: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user']),
    );
  }

  @override
  $ReservationTableTable createAlias(String alias) {
    return $ReservationTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RequestStatus, int, int> $converterstatus =
      const EnumIndexConverter<RequestStatus>(RequestStatus.values);
}

class ReservationTableData extends DataClass
    implements Insertable<ReservationTableData> {
  final String id;
  final String? task;
  final DateTime date;
  final double totalPrice;
  final double? proposedPrice;
  final String coupon;
  final String note;
  final RequestStatus status;
  final int? user;
  const ReservationTableData(
      {required this.id,
      this.task,
      required this.date,
      required this.totalPrice,
      this.proposedPrice,
      required this.coupon,
      required this.note,
      required this.status,
      this.user});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || task != null) {
      map['task'] = Variable<String>(task);
    }
    map['date'] = Variable<DateTime>(date);
    map['total_price'] = Variable<double>(totalPrice);
    if (!nullToAbsent || proposedPrice != null) {
      map['proposed_price'] = Variable<double>(proposedPrice);
    }
    map['coupon'] = Variable<String>(coupon);
    map['note'] = Variable<String>(note);
    {
      map['status'] =
          Variable<int>($ReservationTableTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || user != null) {
      map['user'] = Variable<int>(user);
    }
    return map;
  }

  ReservationTableCompanion toCompanion(bool nullToAbsent) {
    return ReservationTableCompanion(
      id: Value(id),
      task: task == null && nullToAbsent ? const Value.absent() : Value(task),
      date: Value(date),
      totalPrice: Value(totalPrice),
      proposedPrice: proposedPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(proposedPrice),
      coupon: Value(coupon),
      note: Value(note),
      status: Value(status),
      user: user == null && nullToAbsent ? const Value.absent() : Value(user),
    );
  }

  factory ReservationTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReservationTableData(
      id: serializer.fromJson<String>(json['id']),
      task: serializer.fromJson<String?>(json['task']),
      date: serializer.fromJson<DateTime>(json['date']),
      totalPrice: serializer.fromJson<double>(json['totalPrice']),
      proposedPrice: serializer.fromJson<double?>(json['proposedPrice']),
      coupon: serializer.fromJson<String>(json['coupon']),
      note: serializer.fromJson<String>(json['note']),
      status: $ReservationTableTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      user: serializer.fromJson<int?>(json['user']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'task': serializer.toJson<String?>(task),
      'date': serializer.toJson<DateTime>(date),
      'totalPrice': serializer.toJson<double>(totalPrice),
      'proposedPrice': serializer.toJson<double?>(proposedPrice),
      'coupon': serializer.toJson<String>(coupon),
      'note': serializer.toJson<String>(note),
      'status': serializer
          .toJson<int>($ReservationTableTable.$converterstatus.toJson(status)),
      'user': serializer.toJson<int?>(user),
    };
  }

  ReservationTableData copyWith(
          {String? id,
          Value<String?> task = const Value.absent(),
          DateTime? date,
          double? totalPrice,
          Value<double?> proposedPrice = const Value.absent(),
          String? coupon,
          String? note,
          RequestStatus? status,
          Value<int?> user = const Value.absent()}) =>
      ReservationTableData(
        id: id ?? this.id,
        task: task.present ? task.value : this.task,
        date: date ?? this.date,
        totalPrice: totalPrice ?? this.totalPrice,
        proposedPrice:
            proposedPrice.present ? proposedPrice.value : this.proposedPrice,
        coupon: coupon ?? this.coupon,
        note: note ?? this.note,
        status: status ?? this.status,
        user: user.present ? user.value : this.user,
      );
  ReservationTableData copyWithCompanion(ReservationTableCompanion data) {
    return ReservationTableData(
      id: data.id.present ? data.id.value : this.id,
      task: data.task.present ? data.task.value : this.task,
      date: data.date.present ? data.date.value : this.date,
      totalPrice:
          data.totalPrice.present ? data.totalPrice.value : this.totalPrice,
      proposedPrice: data.proposedPrice.present
          ? data.proposedPrice.value
          : this.proposedPrice,
      coupon: data.coupon.present ? data.coupon.value : this.coupon,
      note: data.note.present ? data.note.value : this.note,
      status: data.status.present ? data.status.value : this.status,
      user: data.user.present ? data.user.value : this.user,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReservationTableData(')
          ..write('id: $id, ')
          ..write('task: $task, ')
          ..write('date: $date, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('proposedPrice: $proposedPrice, ')
          ..write('coupon: $coupon, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('user: $user')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, task, date, totalPrice, proposedPrice, coupon, note, status, user);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReservationTableData &&
          other.id == this.id &&
          other.task == this.task &&
          other.date == this.date &&
          other.totalPrice == this.totalPrice &&
          other.proposedPrice == this.proposedPrice &&
          other.coupon == this.coupon &&
          other.note == this.note &&
          other.status == this.status &&
          other.user == this.user);
}

class ReservationTableCompanion extends UpdateCompanion<ReservationTableData> {
  final Value<String> id;
  final Value<String?> task;
  final Value<DateTime> date;
  final Value<double> totalPrice;
  final Value<double?> proposedPrice;
  final Value<String> coupon;
  final Value<String> note;
  final Value<RequestStatus> status;
  final Value<int?> user;
  final Value<int> rowid;
  const ReservationTableCompanion({
    this.id = const Value.absent(),
    this.task = const Value.absent(),
    this.date = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.proposedPrice = const Value.absent(),
    this.coupon = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.user = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReservationTableCompanion.insert({
    required String id,
    this.task = const Value.absent(),
    this.date = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.proposedPrice = const Value.absent(),
    this.coupon = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.user = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<ReservationTableData> custom({
    Expression<String>? id,
    Expression<String>? task,
    Expression<DateTime>? date,
    Expression<double>? totalPrice,
    Expression<double>? proposedPrice,
    Expression<String>? coupon,
    Expression<String>? note,
    Expression<int>? status,
    Expression<int>? user,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (task != null) 'task': task,
      if (date != null) 'date': date,
      if (totalPrice != null) 'total_price': totalPrice,
      if (proposedPrice != null) 'proposed_price': proposedPrice,
      if (coupon != null) 'coupon': coupon,
      if (note != null) 'note': note,
      if (status != null) 'status': status,
      if (user != null) 'user': user,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReservationTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? task,
      Value<DateTime>? date,
      Value<double>? totalPrice,
      Value<double?>? proposedPrice,
      Value<String>? coupon,
      Value<String>? note,
      Value<RequestStatus>? status,
      Value<int?>? user,
      Value<int>? rowid}) {
    return ReservationTableCompanion(
      id: id ?? this.id,
      task: task ?? this.task,
      date: date ?? this.date,
      totalPrice: totalPrice ?? this.totalPrice,
      proposedPrice: proposedPrice ?? this.proposedPrice,
      coupon: coupon ?? this.coupon,
      note: note ?? this.note,
      status: status ?? this.status,
      user: user ?? this.user,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (task.present) {
      map['task'] = Variable<String>(task.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (totalPrice.present) {
      map['total_price'] = Variable<double>(totalPrice.value);
    }
    if (proposedPrice.present) {
      map['proposed_price'] = Variable<double>(proposedPrice.value);
    }
    if (coupon.present) {
      map['coupon'] = Variable<String>(coupon.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
          $ReservationTableTable.$converterstatus.toSql(status.value));
    }
    if (user.present) {
      map['user'] = Variable<int>(user.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReservationTableCompanion(')
          ..write('id: $id, ')
          ..write('task: $task, ')
          ..write('date: $date, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('proposedPrice: $proposedPrice, ')
          ..write('coupon: $coupon, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('user: $user, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookingTableTable extends BookingTable
    with TableInfo<$BookingTableTable, BookingTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookingTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _serviceMeta =
      const VerificationMeta('service');
  @override
  late final GeneratedColumn<String> service = GeneratedColumn<String>(
      'service', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES service_table (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  static const VerificationMeta _totalPriceMeta =
      const VerificationMeta('totalPrice');
  @override
  late final GeneratedColumn<double> totalPrice = GeneratedColumn<double>(
      'total_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _couponMeta = const VerificationMeta('coupon');
  @override
  late final GeneratedColumn<String> coupon = GeneratedColumn<String>(
      'coupon', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<RequestStatus, int> status =
      GeneratedColumn<int>('status', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(0))
          .withConverter<RequestStatus>($BookingTableTable.$converterstatus);
  static const VerificationMeta _userMeta = const VerificationMeta('user');
  @override
  late final GeneratedColumn<int> user = GeneratedColumn<int>(
      'user', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES user_table (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, service, date, totalPrice, coupon, note, status, user];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'booking_table';
  @override
  VerificationContext validateIntegrity(Insertable<BookingTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('service')) {
      context.handle(_serviceMeta,
          service.isAcceptableOrUnknown(data['service']!, _serviceMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('total_price')) {
      context.handle(
          _totalPriceMeta,
          totalPrice.isAcceptableOrUnknown(
              data['total_price']!, _totalPriceMeta));
    }
    if (data.containsKey('coupon')) {
      context.handle(_couponMeta,
          coupon.isAcceptableOrUnknown(data['coupon']!, _couponMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('user')) {
      context.handle(
          _userMeta, user.isAcceptableOrUnknown(data['user']!, _userMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  BookingTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookingTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      service: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}service']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      totalPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_price'])!,
      coupon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}coupon'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      status: $BookingTableTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      user: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user']),
    );
  }

  @override
  $BookingTableTable createAlias(String alias) {
    return $BookingTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RequestStatus, int, int> $converterstatus =
      const EnumIndexConverter<RequestStatus>(RequestStatus.values);
}

class BookingTableData extends DataClass
    implements Insertable<BookingTableData> {
  final String id;
  final String? service;
  final DateTime date;
  final double totalPrice;
  final String coupon;
  final String note;
  final RequestStatus status;
  final int? user;
  const BookingTableData(
      {required this.id,
      this.service,
      required this.date,
      required this.totalPrice,
      required this.coupon,
      required this.note,
      required this.status,
      this.user});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || service != null) {
      map['service'] = Variable<String>(service);
    }
    map['date'] = Variable<DateTime>(date);
    map['total_price'] = Variable<double>(totalPrice);
    map['coupon'] = Variable<String>(coupon);
    map['note'] = Variable<String>(note);
    {
      map['status'] =
          Variable<int>($BookingTableTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || user != null) {
      map['user'] = Variable<int>(user);
    }
    return map;
  }

  BookingTableCompanion toCompanion(bool nullToAbsent) {
    return BookingTableCompanion(
      id: Value(id),
      service: service == null && nullToAbsent
          ? const Value.absent()
          : Value(service),
      date: Value(date),
      totalPrice: Value(totalPrice),
      coupon: Value(coupon),
      note: Value(note),
      status: Value(status),
      user: user == null && nullToAbsent ? const Value.absent() : Value(user),
    );
  }

  factory BookingTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookingTableData(
      id: serializer.fromJson<String>(json['id']),
      service: serializer.fromJson<String?>(json['service']),
      date: serializer.fromJson<DateTime>(json['date']),
      totalPrice: serializer.fromJson<double>(json['totalPrice']),
      coupon: serializer.fromJson<String>(json['coupon']),
      note: serializer.fromJson<String>(json['note']),
      status: $BookingTableTable.$converterstatus
          .fromJson(serializer.fromJson<int>(json['status'])),
      user: serializer.fromJson<int?>(json['user']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'service': serializer.toJson<String?>(service),
      'date': serializer.toJson<DateTime>(date),
      'totalPrice': serializer.toJson<double>(totalPrice),
      'coupon': serializer.toJson<String>(coupon),
      'note': serializer.toJson<String>(note),
      'status': serializer
          .toJson<int>($BookingTableTable.$converterstatus.toJson(status)),
      'user': serializer.toJson<int?>(user),
    };
  }

  BookingTableData copyWith(
          {String? id,
          Value<String?> service = const Value.absent(),
          DateTime? date,
          double? totalPrice,
          String? coupon,
          String? note,
          RequestStatus? status,
          Value<int?> user = const Value.absent()}) =>
      BookingTableData(
        id: id ?? this.id,
        service: service.present ? service.value : this.service,
        date: date ?? this.date,
        totalPrice: totalPrice ?? this.totalPrice,
        coupon: coupon ?? this.coupon,
        note: note ?? this.note,
        status: status ?? this.status,
        user: user.present ? user.value : this.user,
      );
  BookingTableData copyWithCompanion(BookingTableCompanion data) {
    return BookingTableData(
      id: data.id.present ? data.id.value : this.id,
      service: data.service.present ? data.service.value : this.service,
      date: data.date.present ? data.date.value : this.date,
      totalPrice:
          data.totalPrice.present ? data.totalPrice.value : this.totalPrice,
      coupon: data.coupon.present ? data.coupon.value : this.coupon,
      note: data.note.present ? data.note.value : this.note,
      status: data.status.present ? data.status.value : this.status,
      user: data.user.present ? data.user.value : this.user,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookingTableData(')
          ..write('id: $id, ')
          ..write('service: $service, ')
          ..write('date: $date, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('coupon: $coupon, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('user: $user')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, service, date, totalPrice, coupon, note, status, user);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookingTableData &&
          other.id == this.id &&
          other.service == this.service &&
          other.date == this.date &&
          other.totalPrice == this.totalPrice &&
          other.coupon == this.coupon &&
          other.note == this.note &&
          other.status == this.status &&
          other.user == this.user);
}

class BookingTableCompanion extends UpdateCompanion<BookingTableData> {
  final Value<String> id;
  final Value<String?> service;
  final Value<DateTime> date;
  final Value<double> totalPrice;
  final Value<String> coupon;
  final Value<String> note;
  final Value<RequestStatus> status;
  final Value<int?> user;
  final Value<int> rowid;
  const BookingTableCompanion({
    this.id = const Value.absent(),
    this.service = const Value.absent(),
    this.date = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.coupon = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.user = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookingTableCompanion.insert({
    required String id,
    this.service = const Value.absent(),
    this.date = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.coupon = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.user = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<BookingTableData> custom({
    Expression<String>? id,
    Expression<String>? service,
    Expression<DateTime>? date,
    Expression<double>? totalPrice,
    Expression<String>? coupon,
    Expression<String>? note,
    Expression<int>? status,
    Expression<int>? user,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (service != null) 'service': service,
      if (date != null) 'date': date,
      if (totalPrice != null) 'total_price': totalPrice,
      if (coupon != null) 'coupon': coupon,
      if (note != null) 'note': note,
      if (status != null) 'status': status,
      if (user != null) 'user': user,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookingTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? service,
      Value<DateTime>? date,
      Value<double>? totalPrice,
      Value<String>? coupon,
      Value<String>? note,
      Value<RequestStatus>? status,
      Value<int?>? user,
      Value<int>? rowid}) {
    return BookingTableCompanion(
      id: id ?? this.id,
      service: service ?? this.service,
      date: date ?? this.date,
      totalPrice: totalPrice ?? this.totalPrice,
      coupon: coupon ?? this.coupon,
      note: note ?? this.note,
      status: status ?? this.status,
      user: user ?? this.user,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (service.present) {
      map['service'] = Variable<String>(service.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (totalPrice.present) {
      map['total_price'] = Variable<double>(totalPrice.value);
    }
    if (coupon.present) {
      map['coupon'] = Variable<String>(coupon.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
          $BookingTableTable.$converterstatus.toSql(status.value));
    }
    if (user.present) {
      map['user'] = Variable<int>(user.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookingTableCompanion(')
          ..write('id: $id, ')
          ..write('service: $service, ')
          ..write('date: $date, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('coupon: $coupon, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('user: $user, ')
          ..write('rowid: $rowid')
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
  late final $StoreTableTable storeTable = $StoreTableTable(this);
  late final $ServiceTableTable serviceTable = $ServiceTableTable(this);
  late final $ServiceGalleryTableTable serviceGalleryTable =
      $ServiceGalleryTableTable(this);
  late final $ReservationTableTable reservationTable =
      $ReservationTableTable(this);
  late final $BookingTableTable bookingTable = $BookingTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        categoryTable,
        governorateTable,
        userTable,
        taskTable,
        taskAttachmentTable,
        storeTable,
        serviceTable,
        serviceGalleryTable,
        reservationTable,
        bookingTable
      ];
}

typedef $$CategoryTableTableCreateCompanionBuilder = CategoryTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  required int icon,
  Value<int> parent,
  Value<int> subscribed,
});
typedef $$CategoryTableTableUpdateCompanionBuilder = CategoryTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<int> icon,
  Value<int> parent,
  Value<int> subscribed,
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
            Value<int> subscribed = const Value.absent(),
          }) =>
              CategoryTableCompanion(
            id: id,
            name: name,
            icon: icon,
            parent: parent,
            subscribed: subscribed,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            required int icon,
            Value<int> parent = const Value.absent(),
            Value<int> subscribed = const Value.absent(),
          }) =>
              CategoryTableCompanion.insert(
            id: id,
            name: name,
            icon: icon,
            parent: parent,
            subscribed: subscribed,
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

  ColumnFilters<int> get subscribed => $state.composableBuilder(
      column: $state.table.subscribed,
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

  ComposableFilter serviceTableRefs(
      ComposableFilter Function($$ServiceTableTableFilterComposer f) f) {
    final $$ServiceTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.serviceTable,
        getReferencedColumn: (t) => t.category,
        builder: (joinBuilder, parentComposers) =>
            $$ServiceTableTableFilterComposer(ComposerState($state.db,
                $state.db.serviceTable, joinBuilder, parentComposers)));
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

  ColumnOrderings<int> get subscribed => $state.composableBuilder(
      column: $state.table.subscribed,
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

  ComposableFilter storeTableRefs(
      ComposableFilter Function($$StoreTableTableFilterComposer f) f) {
    final $$StoreTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.storeTable,
        getReferencedColumn: (t) => t.governorate,
        builder: (joinBuilder, parentComposers) =>
            $$StoreTableTableFilterComposer(ComposerState($state.db,
                $state.db.storeTable, joinBuilder, parentComposers)));
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

  ComposableFilter storeTableRefs(
      ComposableFilter Function($$StoreTableTableFilterComposer f) f) {
    final $$StoreTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.storeTable,
        getReferencedColumn: (t) => t.owner,
        builder: (joinBuilder, parentComposers) =>
            $$StoreTableTableFilterComposer(ComposerState($state.db,
                $state.db.storeTable, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter reservationTableRefs(
      ComposableFilter Function($$ReservationTableTableFilterComposer f) f) {
    final $$ReservationTableTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.reservationTable,
            getReferencedColumn: (t) => t.user,
            builder: (joinBuilder, parentComposers) =>
                $$ReservationTableTableFilterComposer(ComposerState($state.db,
                    $state.db.reservationTable, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter bookingTableRefs(
      ComposableFilter Function($$BookingTableTableFilterComposer f) f) {
    final $$BookingTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.bookingTable,
        getReferencedColumn: (t) => t.user,
        builder: (joinBuilder, parentComposers) =>
            $$BookingTableTableFilterComposer(ComposerState($state.db,
                $state.db.bookingTable, joinBuilder, parentComposers)));
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
  required String id,
  Value<double> price,
  Value<String> title,
  Value<String> description,
  required int category,
  Value<int?> governorate,
  Value<int?> owner,
  Value<DateTime> dueDate,
  Value<String> delivrables,
  Value<bool> isfavorite,
  Value<int> rowid,
});
typedef $$TaskTableTableUpdateCompanionBuilder = TaskTableCompanion Function({
  Value<String> id,
  Value<double> price,
  Value<String> title,
  Value<String> description,
  Value<int> category,
  Value<int?> governorate,
  Value<int?> owner,
  Value<DateTime> dueDate,
  Value<String> delivrables,
  Value<bool> isfavorite,
  Value<int> rowid,
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
            Value<String> id = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int> category = const Value.absent(),
            Value<int?> governorate = const Value.absent(),
            Value<int?> owner = const Value.absent(),
            Value<DateTime> dueDate = const Value.absent(),
            Value<String> delivrables = const Value.absent(),
            Value<bool> isfavorite = const Value.absent(),
            Value<int> rowid = const Value.absent(),
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
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<double> price = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            required int category,
            Value<int?> governorate = const Value.absent(),
            Value<int?> owner = const Value.absent(),
            Value<DateTime> dueDate = const Value.absent(),
            Value<String> delivrables = const Value.absent(),
            Value<bool> isfavorite = const Value.absent(),
            Value<int> rowid = const Value.absent(),
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
            rowid: rowid,
          ),
        ));
}

class $$TaskTableTableFilterComposer
    extends FilterComposer<_$Database, $TaskTableTable> {
  $$TaskTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
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

  ComposableFilter reservationTableRefs(
      ComposableFilter Function($$ReservationTableTableFilterComposer f) f) {
    final $$ReservationTableTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.reservationTable,
            getReferencedColumn: (t) => t.task,
            builder: (joinBuilder, parentComposers) =>
                $$ReservationTableTableFilterComposer(ComposerState($state.db,
                    $state.db.reservationTable, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$TaskTableTableOrderingComposer
    extends OrderingComposer<_$Database, $TaskTableTable> {
  $$TaskTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
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
  Value<String?> taskId,
});
typedef $$TaskAttachmentTableTableUpdateCompanionBuilder
    = TaskAttachmentTableCompanion Function({
  Value<int> id,
  Value<String> url,
  Value<String> type,
  Value<String?> taskId,
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
            Value<String?> taskId = const Value.absent(),
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
            Value<String?> taskId = const Value.absent(),
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

typedef $$StoreTableTableCreateCompanionBuilder = StoreTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> description,
  Value<String> picture,
  Value<String> coordinates,
  Value<int?> governorate,
  Value<int?> owner,
  Value<bool> isFavorite,
});
typedef $$StoreTableTableUpdateCompanionBuilder = StoreTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> description,
  Value<String> picture,
  Value<String> coordinates,
  Value<int?> governorate,
  Value<int?> owner,
  Value<bool> isFavorite,
});

class $$StoreTableTableTableManager extends RootTableManager<
    _$Database,
    $StoreTableTable,
    StoreTableData,
    $$StoreTableTableFilterComposer,
    $$StoreTableTableOrderingComposer,
    $$StoreTableTableCreateCompanionBuilder,
    $$StoreTableTableUpdateCompanionBuilder> {
  $$StoreTableTableTableManager(_$Database db, $StoreTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$StoreTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$StoreTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> picture = const Value.absent(),
            Value<String> coordinates = const Value.absent(),
            Value<int?> governorate = const Value.absent(),
            Value<int?> owner = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
          }) =>
              StoreTableCompanion(
            id: id,
            name: name,
            description: description,
            picture: picture,
            coordinates: coordinates,
            governorate: governorate,
            owner: owner,
            isFavorite: isFavorite,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> picture = const Value.absent(),
            Value<String> coordinates = const Value.absent(),
            Value<int?> governorate = const Value.absent(),
            Value<int?> owner = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
          }) =>
              StoreTableCompanion.insert(
            id: id,
            name: name,
            description: description,
            picture: picture,
            coordinates: coordinates,
            governorate: governorate,
            owner: owner,
            isFavorite: isFavorite,
          ),
        ));
}

class $$StoreTableTableFilterComposer
    extends FilterComposer<_$Database, $StoreTableTable> {
  $$StoreTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get picture => $state.composableBuilder(
      column: $state.table.picture,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get coordinates => $state.composableBuilder(
      column: $state.table.coordinates,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isFavorite => $state.composableBuilder(
      column: $state.table.isFavorite,
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

  ComposableFilter serviceTableRefs(
      ComposableFilter Function($$ServiceTableTableFilterComposer f) f) {
    final $$ServiceTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.serviceTable,
        getReferencedColumn: (t) => t.store,
        builder: (joinBuilder, parentComposers) =>
            $$ServiceTableTableFilterComposer(ComposerState($state.db,
                $state.db.serviceTable, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$StoreTableTableOrderingComposer
    extends OrderingComposer<_$Database, $StoreTableTable> {
  $$StoreTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get picture => $state.composableBuilder(
      column: $state.table.picture,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get coordinates => $state.composableBuilder(
      column: $state.table.coordinates,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isFavorite => $state.composableBuilder(
      column: $state.table.isFavorite,
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

typedef $$ServiceTableTableCreateCompanionBuilder = ServiceTableCompanion
    Function({
  required String id,
  Value<String> name,
  Value<String> description,
  Value<int?> category,
  Value<int?> store,
  Value<double> price,
  Value<int> rowid,
});
typedef $$ServiceTableTableUpdateCompanionBuilder = ServiceTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> description,
  Value<int?> category,
  Value<int?> store,
  Value<double> price,
  Value<int> rowid,
});

class $$ServiceTableTableTableManager extends RootTableManager<
    _$Database,
    $ServiceTableTable,
    ServiceTableData,
    $$ServiceTableTableFilterComposer,
    $$ServiceTableTableOrderingComposer,
    $$ServiceTableTableCreateCompanionBuilder,
    $$ServiceTableTableUpdateCompanionBuilder> {
  $$ServiceTableTableTableManager(_$Database db, $ServiceTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ServiceTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ServiceTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int?> category = const Value.absent(),
            Value<int?> store = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ServiceTableCompanion(
            id: id,
            name: name,
            description: description,
            category: category,
            store: store,
            price: price,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<int?> category = const Value.absent(),
            Value<int?> store = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ServiceTableCompanion.insert(
            id: id,
            name: name,
            description: description,
            category: category,
            store: store,
            price: price,
            rowid: rowid,
          ),
        ));
}

class $$ServiceTableTableFilterComposer
    extends FilterComposer<_$Database, $ServiceTableTable> {
  $$ServiceTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get price => $state.composableBuilder(
      column: $state.table.price,
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

  $$StoreTableTableFilterComposer get store {
    final $$StoreTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.store,
        referencedTable: $state.db.storeTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$StoreTableTableFilterComposer(ComposerState($state.db,
                $state.db.storeTable, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter serviceGalleryTableRefs(
      ComposableFilter Function($$ServiceGalleryTableTableFilterComposer f) f) {
    final $$ServiceGalleryTableTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $state.db.serviceGalleryTable,
            getReferencedColumn: (t) => t.serviceId,
            builder: (joinBuilder, parentComposers) =>
                $$ServiceGalleryTableTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.serviceGalleryTable,
                    joinBuilder,
                    parentComposers)));
    return f(composer);
  }

  ComposableFilter bookingTableRefs(
      ComposableFilter Function($$BookingTableTableFilterComposer f) f) {
    final $$BookingTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.bookingTable,
        getReferencedColumn: (t) => t.service,
        builder: (joinBuilder, parentComposers) =>
            $$BookingTableTableFilterComposer(ComposerState($state.db,
                $state.db.bookingTable, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$ServiceTableTableOrderingComposer
    extends OrderingComposer<_$Database, $ServiceTableTable> {
  $$ServiceTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get price => $state.composableBuilder(
      column: $state.table.price,
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

  $$StoreTableTableOrderingComposer get store {
    final $$StoreTableTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.store,
        referencedTable: $state.db.storeTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$StoreTableTableOrderingComposer(ComposerState($state.db,
                $state.db.storeTable, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$ServiceGalleryTableTableCreateCompanionBuilder
    = ServiceGalleryTableCompanion Function({
  Value<int> id,
  Value<String> url,
  Value<String> type,
  Value<String?> serviceId,
});
typedef $$ServiceGalleryTableTableUpdateCompanionBuilder
    = ServiceGalleryTableCompanion Function({
  Value<int> id,
  Value<String> url,
  Value<String> type,
  Value<String?> serviceId,
});

class $$ServiceGalleryTableTableTableManager extends RootTableManager<
    _$Database,
    $ServiceGalleryTableTable,
    ServiceGalleryTableData,
    $$ServiceGalleryTableTableFilterComposer,
    $$ServiceGalleryTableTableOrderingComposer,
    $$ServiceGalleryTableTableCreateCompanionBuilder,
    $$ServiceGalleryTableTableUpdateCompanionBuilder> {
  $$ServiceGalleryTableTableTableManager(
      _$Database db, $ServiceGalleryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer: $$ServiceGalleryTableTableFilterComposer(
              ComposerState(db, table)),
          orderingComposer: $$ServiceGalleryTableTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> serviceId = const Value.absent(),
          }) =>
              ServiceGalleryTableCompanion(
            id: id,
            url: url,
            type: type,
            serviceId: serviceId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> serviceId = const Value.absent(),
          }) =>
              ServiceGalleryTableCompanion.insert(
            id: id,
            url: url,
            type: type,
            serviceId: serviceId,
          ),
        ));
}

class $$ServiceGalleryTableTableFilterComposer
    extends FilterComposer<_$Database, $ServiceGalleryTableTable> {
  $$ServiceGalleryTableTableFilterComposer(super.$state);
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

  $$ServiceTableTableFilterComposer get serviceId {
    final $$ServiceTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serviceId,
        referencedTable: $state.db.serviceTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ServiceTableTableFilterComposer(ComposerState($state.db,
                $state.db.serviceTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$ServiceGalleryTableTableOrderingComposer
    extends OrderingComposer<_$Database, $ServiceGalleryTableTable> {
  $$ServiceGalleryTableTableOrderingComposer(super.$state);
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

  $$ServiceTableTableOrderingComposer get serviceId {
    final $$ServiceTableTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serviceId,
        referencedTable: $state.db.serviceTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ServiceTableTableOrderingComposer(ComposerState($state.db,
                $state.db.serviceTable, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$ReservationTableTableCreateCompanionBuilder
    = ReservationTableCompanion Function({
  required String id,
  Value<String?> task,
  Value<DateTime> date,
  Value<double> totalPrice,
  Value<double?> proposedPrice,
  Value<String> coupon,
  Value<String> note,
  Value<RequestStatus> status,
  Value<int?> user,
  Value<int> rowid,
});
typedef $$ReservationTableTableUpdateCompanionBuilder
    = ReservationTableCompanion Function({
  Value<String> id,
  Value<String?> task,
  Value<DateTime> date,
  Value<double> totalPrice,
  Value<double?> proposedPrice,
  Value<String> coupon,
  Value<String> note,
  Value<RequestStatus> status,
  Value<int?> user,
  Value<int> rowid,
});

class $$ReservationTableTableTableManager extends RootTableManager<
    _$Database,
    $ReservationTableTable,
    ReservationTableData,
    $$ReservationTableTableFilterComposer,
    $$ReservationTableTableOrderingComposer,
    $$ReservationTableTableCreateCompanionBuilder,
    $$ReservationTableTableUpdateCompanionBuilder> {
  $$ReservationTableTableTableManager(
      _$Database db, $ReservationTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ReservationTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ReservationTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> task = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<double> totalPrice = const Value.absent(),
            Value<double?> proposedPrice = const Value.absent(),
            Value<String> coupon = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<RequestStatus> status = const Value.absent(),
            Value<int?> user = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReservationTableCompanion(
            id: id,
            task: task,
            date: date,
            totalPrice: totalPrice,
            proposedPrice: proposedPrice,
            coupon: coupon,
            note: note,
            status: status,
            user: user,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> task = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<double> totalPrice = const Value.absent(),
            Value<double?> proposedPrice = const Value.absent(),
            Value<String> coupon = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<RequestStatus> status = const Value.absent(),
            Value<int?> user = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReservationTableCompanion.insert(
            id: id,
            task: task,
            date: date,
            totalPrice: totalPrice,
            proposedPrice: proposedPrice,
            coupon: coupon,
            note: note,
            status: status,
            user: user,
            rowid: rowid,
          ),
        ));
}

class $$ReservationTableTableFilterComposer
    extends FilterComposer<_$Database, $ReservationTableTable> {
  $$ReservationTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get totalPrice => $state.composableBuilder(
      column: $state.table.totalPrice,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get proposedPrice => $state.composableBuilder(
      column: $state.table.proposedPrice,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get coupon => $state.composableBuilder(
      column: $state.table.coupon,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<RequestStatus, RequestStatus, int>
      get status => $state.composableBuilder(
          column: $state.table.status,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  $$TaskTableTableFilterComposer get task {
    final $$TaskTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.task,
        referencedTable: $state.db.taskTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$TaskTableTableFilterComposer(ComposerState(
                $state.db, $state.db.taskTable, joinBuilder, parentComposers)));
    return composer;
  }

  $$UserTableTableFilterComposer get user {
    final $$UserTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.user,
        referencedTable: $state.db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$UserTableTableFilterComposer(ComposerState(
                $state.db, $state.db.userTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$ReservationTableTableOrderingComposer
    extends OrderingComposer<_$Database, $ReservationTableTable> {
  $$ReservationTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get totalPrice => $state.composableBuilder(
      column: $state.table.totalPrice,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get proposedPrice => $state.composableBuilder(
      column: $state.table.proposedPrice,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get coupon => $state.composableBuilder(
      column: $state.table.coupon,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$TaskTableTableOrderingComposer get task {
    final $$TaskTableTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.task,
        referencedTable: $state.db.taskTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$TaskTableTableOrderingComposer(ComposerState(
                $state.db, $state.db.taskTable, joinBuilder, parentComposers)));
    return composer;
  }

  $$UserTableTableOrderingComposer get user {
    final $$UserTableTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.user,
        referencedTable: $state.db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$UserTableTableOrderingComposer(ComposerState(
                $state.db, $state.db.userTable, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$BookingTableTableCreateCompanionBuilder = BookingTableCompanion
    Function({
  required String id,
  Value<String?> service,
  Value<DateTime> date,
  Value<double> totalPrice,
  Value<String> coupon,
  Value<String> note,
  Value<RequestStatus> status,
  Value<int?> user,
  Value<int> rowid,
});
typedef $$BookingTableTableUpdateCompanionBuilder = BookingTableCompanion
    Function({
  Value<String> id,
  Value<String?> service,
  Value<DateTime> date,
  Value<double> totalPrice,
  Value<String> coupon,
  Value<String> note,
  Value<RequestStatus> status,
  Value<int?> user,
  Value<int> rowid,
});

class $$BookingTableTableTableManager extends RootTableManager<
    _$Database,
    $BookingTableTable,
    BookingTableData,
    $$BookingTableTableFilterComposer,
    $$BookingTableTableOrderingComposer,
    $$BookingTableTableCreateCompanionBuilder,
    $$BookingTableTableUpdateCompanionBuilder> {
  $$BookingTableTableTableManager(_$Database db, $BookingTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BookingTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BookingTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> service = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<double> totalPrice = const Value.absent(),
            Value<String> coupon = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<RequestStatus> status = const Value.absent(),
            Value<int?> user = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BookingTableCompanion(
            id: id,
            service: service,
            date: date,
            totalPrice: totalPrice,
            coupon: coupon,
            note: note,
            status: status,
            user: user,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> service = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<double> totalPrice = const Value.absent(),
            Value<String> coupon = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<RequestStatus> status = const Value.absent(),
            Value<int?> user = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BookingTableCompanion.insert(
            id: id,
            service: service,
            date: date,
            totalPrice: totalPrice,
            coupon: coupon,
            note: note,
            status: status,
            user: user,
            rowid: rowid,
          ),
        ));
}

class $$BookingTableTableFilterComposer
    extends FilterComposer<_$Database, $BookingTableTable> {
  $$BookingTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get totalPrice => $state.composableBuilder(
      column: $state.table.totalPrice,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get coupon => $state.composableBuilder(
      column: $state.table.coupon,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<RequestStatus, RequestStatus, int>
      get status => $state.composableBuilder(
          column: $state.table.status,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  $$ServiceTableTableFilterComposer get service {
    final $$ServiceTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.service,
        referencedTable: $state.db.serviceTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ServiceTableTableFilterComposer(ComposerState($state.db,
                $state.db.serviceTable, joinBuilder, parentComposers)));
    return composer;
  }

  $$UserTableTableFilterComposer get user {
    final $$UserTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.user,
        referencedTable: $state.db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$UserTableTableFilterComposer(ComposerState(
                $state.db, $state.db.userTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$BookingTableTableOrderingComposer
    extends OrderingComposer<_$Database, $BookingTableTable> {
  $$BookingTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get totalPrice => $state.composableBuilder(
      column: $state.table.totalPrice,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get coupon => $state.composableBuilder(
      column: $state.table.coupon,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$ServiceTableTableOrderingComposer get service {
    final $$ServiceTableTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.service,
        referencedTable: $state.db.serviceTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ServiceTableTableOrderingComposer(ComposerState($state.db,
                $state.db.serviceTable, joinBuilder, parentComposers)));
    return composer;
  }

  $$UserTableTableOrderingComposer get user {
    final $$UserTableTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.user,
        referencedTable: $state.db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$UserTableTableOrderingComposer(ComposerState(
                $state.db, $state.db.userTable, joinBuilder, parentComposers)));
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
  $$StoreTableTableTableManager get storeTable =>
      $$StoreTableTableTableManager(_db, _db.storeTable);
  $$ServiceTableTableTableManager get serviceTable =>
      $$ServiceTableTableTableManager(_db, _db.serviceTable);
  $$ServiceGalleryTableTableTableManager get serviceGalleryTable =>
      $$ServiceGalleryTableTableTableManager(_db, _db.serviceGalleryTable);
  $$ReservationTableTableTableManager get reservationTable =>
      $$ReservationTableTableTableManager(_db, _db.reservationTable);
  $$BookingTableTableTableManager get bookingTable =>
      $$BookingTableTableTableManager(_db, _db.bookingTable);
}
