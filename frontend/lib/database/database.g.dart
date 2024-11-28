// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CategoryTableTable extends CategoryTable with TableInfo<$CategoryTableTable, CategoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name =
      GeneratedColumn<String>('name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _descriptionMeta = const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description =
      GeneratedColumn<String>('description', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>('icon', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentMeta = const VerificationMeta('parent');
  @override
  late final GeneratedColumn<int> parent = GeneratedColumn<int>('parent', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES category_table (id)'),
      defaultValue: const Constant(-1));
  static const VerificationMeta _subscribedMeta = const VerificationMeta('subscribed');
  @override
  late final GeneratedColumn<int> subscribed =
      GeneratedColumn<int>('subscribed', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false, defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, name, description, icon, parent, subscribed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_table';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryTableData> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('description')) {
      context.handle(_descriptionMeta, description.isAcceptableOrUnknown(data['description']!, _descriptionMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(_iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('parent')) {
      context.handle(_parentMeta, parent.isAcceptableOrUnknown(data['parent']!, _parentMeta));
    }
    if (data.containsKey('subscribed')) {
      context.handle(_subscribedMeta, subscribed.isAcceptableOrUnknown(data['subscribed']!, _subscribedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryTableData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      icon: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      parent: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}parent'])!,
      subscribed: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}subscribed'])!,
    );
  }

  @override
  $CategoryTableTable createAlias(String alias) {
    return $CategoryTableTable(attachedDatabase, alias);
  }
}

class CategoryTableData extends DataClass implements Insertable<CategoryTableData> {
  final int id;
  final String name;
  final String description;
  final String icon;
  final int parent;
  final int subscribed;
  const CategoryTableData({required this.id, required this.name, required this.description, required this.icon, required this.parent, required this.subscribed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['icon'] = Variable<String>(icon);
    map['parent'] = Variable<int>(parent);
    map['subscribed'] = Variable<int>(subscribed);
    return map;
  }

  CategoryTableCompanion toCompanion(bool nullToAbsent) {
    return CategoryTableCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      icon: Value(icon),
      parent: Value(parent),
      subscribed: Value(subscribed),
    );
  }

  factory CategoryTableData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      icon: serializer.fromJson<String>(json['icon']),
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
      'description': serializer.toJson<String>(description),
      'icon': serializer.toJson<String>(icon),
      'parent': serializer.toJson<int>(parent),
      'subscribed': serializer.toJson<int>(subscribed),
    };
  }

  CategoryTableData copyWith({int? id, String? name, String? description, String? icon, int? parent, int? subscribed}) => CategoryTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        icon: icon ?? this.icon,
        parent: parent ?? this.parent,
        subscribed: subscribed ?? this.subscribed,
      );
  CategoryTableData copyWithCompanion(CategoryTableCompanion data) {
    return CategoryTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present ? data.description.value : this.description,
      icon: data.icon.present ? data.icon.value : this.icon,
      parent: data.parent.present ? data.parent.value : this.parent,
      subscribed: data.subscribed.present ? data.subscribed.value : this.subscribed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('parent: $parent, ')
          ..write('subscribed: $subscribed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, icon, parent, subscribed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.icon == this.icon &&
          other.parent == this.parent &&
          other.subscribed == this.subscribed);
}

class CategoryTableCompanion extends UpdateCompanion<CategoryTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> icon;
  final Value<int> parent;
  final Value<int> subscribed;
  const CategoryTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.parent = const Value.absent(),
    this.subscribed = const Value.absent(),
  });
  CategoryTableCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    required String icon,
    this.parent = const Value.absent(),
    this.subscribed = const Value.absent(),
  }) : icon = Value(icon);
  static Insertable<CategoryTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? icon,
    Expression<int>? parent,
    Expression<int>? subscribed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (parent != null) 'parent': parent,
      if (subscribed != null) 'subscribed': subscribed,
    });
  }

  CategoryTableCompanion copyWith({Value<int>? id, Value<String>? name, Value<String>? description, Value<String>? icon, Value<int>? parent, Value<int>? subscribed}) {
    return CategoryTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
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
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('parent: $parent, ')
          ..write('subscribed: $subscribed')
          ..write(')'))
        .toString();
  }
}

class $GovernorateTableTable extends GovernorateTable with TableInfo<$GovernorateTableTable, GovernorateTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GovernorateTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name =
      GeneratedColumn<String>('name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'governorate_table';
  @override
  VerificationContext validateIntegrity(Insertable<GovernorateTableData> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GovernorateTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GovernorateTableData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $GovernorateTableTable createAlias(String alias) {
    return $GovernorateTableTable(attachedDatabase, alias);
  }
}

class GovernorateTableData extends DataClass implements Insertable<GovernorateTableData> {
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

  factory GovernorateTableData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
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

  GovernorateTableData copyWith({int? id, String? name}) => GovernorateTableData(
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
  bool operator ==(Object other) => identical(this, other) || (other is GovernorateTableData && other.id == this.id && other.name == this.name);
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

class $UserTableTable extends UserTable with TableInfo<$UserTableTable, UserTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name =
      GeneratedColumn<String>('name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email =
      GeneratedColumn<String>('email', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone =
      GeneratedColumn<String>('phone', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _pictureMeta = const VerificationMeta('picture');
  @override
  late final GeneratedColumn<String> picture =
      GeneratedColumn<String>('picture', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumnWithTypeConverter<Role, int> role =
      GeneratedColumn<int>('role', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false, defaultValue: const Constant(2))
          .withConverter<Role>($UserTableTable.$converterrole);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumnWithTypeConverter<Gender, int> gender =
      GeneratedColumn<int>('gender', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false, defaultValue: const Constant(2))
          .withConverter<Gender>($UserTableTable.$convertergender);
  static const VerificationMeta _isVerifiedMeta = const VerificationMeta('isVerified');
  @override
  late final GeneratedColumnWithTypeConverter<VerifyIdentityStatus, int> isVerified =
      GeneratedColumn<int>('is_verified', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false, defaultValue: const Constant(2))
          .withConverter<VerifyIdentityStatus>($UserTableTable.$converterisVerified);
  static const VerificationMeta _isMailVerifiedMeta = const VerificationMeta('isMailVerified');
  @override
  late final GeneratedColumn<bool> isMailVerified = GeneratedColumn<bool>('is_mail_verified', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_mail_verified" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _birthdateMeta = const VerificationMeta('birthdate');
  @override
  late final GeneratedColumn<DateTime> birthdate = GeneratedColumn<DateTime>('birthdate', aliasedName, true, type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio =
      GeneratedColumn<String>('bio', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _referralCodeMeta = const VerificationMeta('referralCode');
  @override
  late final GeneratedColumn<String> referralCode =
      GeneratedColumn<String>('referral_code', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _coordinatesMeta = const VerificationMeta('coordinates');
  @override
  late final GeneratedColumn<String> coordinates = GeneratedColumn<String>('coordinates', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _governorateMeta = const VerificationMeta('governorate');
  @override
  late final GeneratedColumn<int> governorate = GeneratedColumn<int>('governorate', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES governorate_table (id)'),
      defaultValue: const Constant(0));
  static const VerificationMeta _coinsMeta = const VerificationMeta('coins');
  @override
  late final GeneratedColumn<int> coins = GeneratedColumn<int>('coins', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false, defaultValue: const Constant(0));
  static const VerificationMeta _availableCoinsMeta = const VerificationMeta('availableCoins');
  @override
  late final GeneratedColumn<int> availableCoins =
      GeneratedColumn<int>('available_coins', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false, defaultValue: const Constant(0));
  static const VerificationMeta _availablePurchasedCoinsMeta = const VerificationMeta('availablePurchasedCoins');
  @override
  late final GeneratedColumn<int> availablePurchasedCoins =
      GeneratedColumn<int>('available_purchased_coins', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false, defaultValue: const Constant(0));
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
        referralCode,
        coordinates,
        governorate,
        coins,
        availableCoins,
        availablePurchasedCoins
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_table';
  @override
  VerificationContext validateIntegrity(Insertable<UserTableData> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('email')) {
      context.handle(_emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(_phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('picture')) {
      context.handle(_pictureMeta, picture.isAcceptableOrUnknown(data['picture']!, _pictureMeta));
    }
    context.handle(_roleMeta, const VerificationResult.success());
    context.handle(_genderMeta, const VerificationResult.success());
    context.handle(_isVerifiedMeta, const VerificationResult.success());
    if (data.containsKey('is_mail_verified')) {
      context.handle(_isMailVerifiedMeta, isMailVerified.isAcceptableOrUnknown(data['is_mail_verified']!, _isMailVerifiedMeta));
    }
    if (data.containsKey('birthdate')) {
      context.handle(_birthdateMeta, birthdate.isAcceptableOrUnknown(data['birthdate']!, _birthdateMeta));
    }
    if (data.containsKey('bio')) {
      context.handle(_bioMeta, bio.isAcceptableOrUnknown(data['bio']!, _bioMeta));
    }
    if (data.containsKey('referral_code')) {
      context.handle(_referralCodeMeta, referralCode.isAcceptableOrUnknown(data['referral_code']!, _referralCodeMeta));
    }
    if (data.containsKey('coordinates')) {
      context.handle(_coordinatesMeta, coordinates.isAcceptableOrUnknown(data['coordinates']!, _coordinatesMeta));
    }
    if (data.containsKey('governorate')) {
      context.handle(_governorateMeta, governorate.isAcceptableOrUnknown(data['governorate']!, _governorateMeta));
    }
    if (data.containsKey('coins')) {
      context.handle(_coinsMeta, coins.isAcceptableOrUnknown(data['coins']!, _coinsMeta));
    }
    if (data.containsKey('available_coins')) {
      context.handle(_availableCoinsMeta, availableCoins.isAcceptableOrUnknown(data['available_coins']!, _availableCoinsMeta));
    }
    if (data.containsKey('available_purchased_coins')) {
      context.handle(_availablePurchasedCoinsMeta, availablePurchasedCoins.isAcceptableOrUnknown(data['available_purchased_coins']!, _availablePurchasedCoinsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserTableData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      email: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      phone: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      picture: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}picture'])!,
      role: $UserTableTable.$converterrole.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}role'])!),
      gender: $UserTableTable.$convertergender.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}gender'])!),
      isVerified: $UserTableTable.$converterisVerified.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}is_verified'])!),
      isMailVerified: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_mail_verified'])!,
      birthdate: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}birthdate']),
      bio: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}bio'])!,
      referralCode: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}referral_code'])!,
      coordinates: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}coordinates']),
      governorate: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}governorate'])!,
      coins: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}coins'])!,
      availableCoins: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}available_coins'])!,
      availablePurchasedCoins: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}available_purchased_coins'])!,
    );
  }

  @override
  $UserTableTable createAlias(String alias) {
    return $UserTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Role, int, int> $converterrole = const EnumIndexConverter<Role>(Role.values);
  static JsonTypeConverter2<Gender, int, int> $convertergender = const EnumIndexConverter<Gender>(Gender.values);
  static JsonTypeConverter2<VerifyIdentityStatus, int, int> $converterisVerified = const EnumIndexConverter<VerifyIdentityStatus>(VerifyIdentityStatus.values);
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
  final String referralCode;
  final String? coordinates;
  final int governorate;
  final int coins;
  final int availableCoins;
  final int availablePurchasedCoins;
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
      required this.referralCode,
      this.coordinates,
      required this.governorate,
      required this.coins,
      required this.availableCoins,
      required this.availablePurchasedCoins});
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
      map['gender'] = Variable<int>($UserTableTable.$convertergender.toSql(gender));
    }
    {
      map['is_verified'] = Variable<int>($UserTableTable.$converterisVerified.toSql(isVerified));
    }
    map['is_mail_verified'] = Variable<bool>(isMailVerified);
    if (!nullToAbsent || birthdate != null) {
      map['birthdate'] = Variable<DateTime>(birthdate);
    }
    map['bio'] = Variable<String>(bio);
    map['referral_code'] = Variable<String>(referralCode);
    if (!nullToAbsent || coordinates != null) {
      map['coordinates'] = Variable<String>(coordinates);
    }
    map['governorate'] = Variable<int>(governorate);
    map['coins'] = Variable<int>(coins);
    map['available_coins'] = Variable<int>(availableCoins);
    map['available_purchased_coins'] = Variable<int>(availablePurchasedCoins);
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
      birthdate: birthdate == null && nullToAbsent ? const Value.absent() : Value(birthdate),
      bio: Value(bio),
      referralCode: Value(referralCode),
      coordinates: coordinates == null && nullToAbsent ? const Value.absent() : Value(coordinates),
      governorate: Value(governorate),
      coins: Value(coins),
      availableCoins: Value(availableCoins),
      availablePurchasedCoins: Value(availablePurchasedCoins),
    );
  }

  factory UserTableData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      phone: serializer.fromJson<String>(json['phone']),
      picture: serializer.fromJson<String>(json['picture']),
      role: $UserTableTable.$converterrole.fromJson(serializer.fromJson<int>(json['role'])),
      gender: $UserTableTable.$convertergender.fromJson(serializer.fromJson<int>(json['gender'])),
      isVerified: $UserTableTable.$converterisVerified.fromJson(serializer.fromJson<int>(json['isVerified'])),
      isMailVerified: serializer.fromJson<bool>(json['isMailVerified']),
      birthdate: serializer.fromJson<DateTime?>(json['birthdate']),
      bio: serializer.fromJson<String>(json['bio']),
      referralCode: serializer.fromJson<String>(json['referralCode']),
      coordinates: serializer.fromJson<String?>(json['coordinates']),
      governorate: serializer.fromJson<int>(json['governorate']),
      coins: serializer.fromJson<int>(json['coins']),
      availableCoins: serializer.fromJson<int>(json['availableCoins']),
      availablePurchasedCoins: serializer.fromJson<int>(json['availablePurchasedCoins']),
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
      'role': serializer.toJson<int>($UserTableTable.$converterrole.toJson(role)),
      'gender': serializer.toJson<int>($UserTableTable.$convertergender.toJson(gender)),
      'isVerified': serializer.toJson<int>($UserTableTable.$converterisVerified.toJson(isVerified)),
      'isMailVerified': serializer.toJson<bool>(isMailVerified),
      'birthdate': serializer.toJson<DateTime?>(birthdate),
      'bio': serializer.toJson<String>(bio),
      'referralCode': serializer.toJson<String>(referralCode),
      'coordinates': serializer.toJson<String?>(coordinates),
      'governorate': serializer.toJson<int>(governorate),
      'coins': serializer.toJson<int>(coins),
      'availableCoins': serializer.toJson<int>(availableCoins),
      'availablePurchasedCoins': serializer.toJson<int>(availablePurchasedCoins),
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
          String? referralCode,
          Value<String?> coordinates = const Value.absent(),
          int? governorate,
          int? coins,
          int? availableCoins,
          int? availablePurchasedCoins}) =>
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
        referralCode: referralCode ?? this.referralCode,
        coordinates: coordinates.present ? coordinates.value : this.coordinates,
        governorate: governorate ?? this.governorate,
        coins: coins ?? this.coins,
        availableCoins: availableCoins ?? this.availableCoins,
        availablePurchasedCoins: availablePurchasedCoins ?? this.availablePurchasedCoins,
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
      isVerified: data.isVerified.present ? data.isVerified.value : this.isVerified,
      isMailVerified: data.isMailVerified.present ? data.isMailVerified.value : this.isMailVerified,
      birthdate: data.birthdate.present ? data.birthdate.value : this.birthdate,
      bio: data.bio.present ? data.bio.value : this.bio,
      referralCode: data.referralCode.present ? data.referralCode.value : this.referralCode,
      coordinates: data.coordinates.present ? data.coordinates.value : this.coordinates,
      governorate: data.governorate.present ? data.governorate.value : this.governorate,
      coins: data.coins.present ? data.coins.value : this.coins,
      availableCoins: data.availableCoins.present ? data.availableCoins.value : this.availableCoins,
      availablePurchasedCoins: data.availablePurchasedCoins.present ? data.availablePurchasedCoins.value : this.availablePurchasedCoins,
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
          ..write('referralCode: $referralCode, ')
          ..write('coordinates: $coordinates, ')
          ..write('governorate: $governorate, ')
          ..write('coins: $coins, ')
          ..write('availableCoins: $availableCoins, ')
          ..write('availablePurchasedCoins: $availablePurchasedCoins')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, email, phone, picture, role, gender, isVerified, isMailVerified, birthdate, bio, referralCode, coordinates, governorate, coins,
      availableCoins, availablePurchasedCoins);
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
          other.referralCode == this.referralCode &&
          other.coordinates == this.coordinates &&
          other.governorate == this.governorate &&
          other.coins == this.coins &&
          other.availableCoins == this.availableCoins &&
          other.availablePurchasedCoins == this.availablePurchasedCoins);
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
  final Value<String> referralCode;
  final Value<String?> coordinates;
  final Value<int> governorate;
  final Value<int> coins;
  final Value<int> availableCoins;
  final Value<int> availablePurchasedCoins;
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
    this.referralCode = const Value.absent(),
    this.coordinates = const Value.absent(),
    this.governorate = const Value.absent(),
    this.coins = const Value.absent(),
    this.availableCoins = const Value.absent(),
    this.availablePurchasedCoins = const Value.absent(),
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
    this.referralCode = const Value.absent(),
    this.coordinates = const Value.absent(),
    this.governorate = const Value.absent(),
    this.coins = const Value.absent(),
    this.availableCoins = const Value.absent(),
    this.availablePurchasedCoins = const Value.absent(),
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
    Expression<String>? referralCode,
    Expression<String>? coordinates,
    Expression<int>? governorate,
    Expression<int>? coins,
    Expression<int>? availableCoins,
    Expression<int>? availablePurchasedCoins,
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
      if (referralCode != null) 'referral_code': referralCode,
      if (coordinates != null) 'coordinates': coordinates,
      if (governorate != null) 'governorate': governorate,
      if (coins != null) 'coins': coins,
      if (availableCoins != null) 'available_coins': availableCoins,
      if (availablePurchasedCoins != null) 'available_purchased_coins': availablePurchasedCoins,
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
      Value<String>? referralCode,
      Value<String?>? coordinates,
      Value<int>? governorate,
      Value<int>? coins,
      Value<int>? availableCoins,
      Value<int>? availablePurchasedCoins}) {
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
      referralCode: referralCode ?? this.referralCode,
      coordinates: coordinates ?? this.coordinates,
      governorate: governorate ?? this.governorate,
      coins: coins ?? this.coins,
      availableCoins: availableCoins ?? this.availableCoins,
      availablePurchasedCoins: availablePurchasedCoins ?? this.availablePurchasedCoins,
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
      map['role'] = Variable<int>($UserTableTable.$converterrole.toSql(role.value));
    }
    if (gender.present) {
      map['gender'] = Variable<int>($UserTableTable.$convertergender.toSql(gender.value));
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<int>($UserTableTable.$converterisVerified.toSql(isVerified.value));
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
    if (referralCode.present) {
      map['referral_code'] = Variable<String>(referralCode.value);
    }
    if (coordinates.present) {
      map['coordinates'] = Variable<String>(coordinates.value);
    }
    if (governorate.present) {
      map['governorate'] = Variable<int>(governorate.value);
    }
    if (coins.present) {
      map['coins'] = Variable<int>(coins.value);
    }
    if (availableCoins.present) {
      map['available_coins'] = Variable<int>(availableCoins.value);
    }
    if (availablePurchasedCoins.present) {
      map['available_purchased_coins'] = Variable<int>(availablePurchasedCoins.value);
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
          ..write('referralCode: $referralCode, ')
          ..write('coordinates: $coordinates, ')
          ..write('governorate: $governorate, ')
          ..write('coins: $coins, ')
          ..write('availableCoins: $availableCoins, ')
          ..write('availablePurchasedCoins: $availablePurchasedCoins')
          ..write(')'))
        .toString();
  }
}

class $TaskTableTable extends TaskTable with TableInfo<$TaskTableTable, TaskTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price =
      GeneratedColumn<double>('price', aliasedName, false, type: DriftSqlType.double, requiredDuringInsert: false, defaultValue: const Constant(0));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title =
      GeneratedColumn<String>('title', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _descriptionMeta = const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description =
      GeneratedColumn<String>('description', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _categoryMeta = const VerificationMeta('category');
  @override
  late final GeneratedColumn<int> category = GeneratedColumn<int>('category', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES category_table (id)'));
  static const VerificationMeta _governorateMeta = const VerificationMeta('governorate');
  @override
  late final GeneratedColumn<int> governorate = GeneratedColumn<int>('governorate', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES governorate_table (id)'));
  static const VerificationMeta _ownerMeta = const VerificationMeta('owner');
  @override
  late final GeneratedColumn<int> owner = GeneratedColumn<int>('owner', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES user_table (id)'));
  static const VerificationMeta _dueDateMeta = const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>('due_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: false, defaultValue: Constant(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59)));
  static const VerificationMeta _delivrablesMeta = const VerificationMeta('delivrables');
  @override
  late final GeneratedColumn<String> delivrables =
      GeneratedColumn<String>('delivrables', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _isfavoriteMeta = const VerificationMeta('isfavorite');
  @override
  late final GeneratedColumn<bool> isfavorite = GeneratedColumn<bool>('isfavorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("isfavorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, price, title, description, category, governorate, owner, dueDate, delivrables, isfavorite];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_table';
  @override
  VerificationContext validateIntegrity(Insertable<TaskTableData> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('price')) {
      context.handle(_priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('description')) {
      context.handle(_descriptionMeta, description.isAcceptableOrUnknown(data['description']!, _descriptionMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta, category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('governorate')) {
      context.handle(_governorateMeta, governorate.isAcceptableOrUnknown(data['governorate']!, _governorateMeta));
    }
    if (data.containsKey('owner')) {
      context.handle(_ownerMeta, owner.isAcceptableOrUnknown(data['owner']!, _ownerMeta));
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta, dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    }
    if (data.containsKey('delivrables')) {
      context.handle(_delivrablesMeta, delivrables.isAcceptableOrUnknown(data['delivrables']!, _delivrablesMeta));
    }
    if (data.containsKey('isfavorite')) {
      context.handle(_isfavoriteMeta, isfavorite.isAcceptableOrUnknown(data['isfavorite']!, _isfavoriteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  TaskTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskTableData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      price: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      title: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      category: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}category'])!,
      governorate: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}governorate']),
      owner: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}owner']),
      dueDate: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}due_date'])!,
      delivrables: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}delivrables'])!,
      isfavorite: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}isfavorite'])!,
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
      governorate: governorate == null && nullToAbsent ? const Value.absent() : Value(governorate),
      owner: owner == null && nullToAbsent ? const Value.absent() : Value(owner),
      dueDate: Value(dueDate),
      delivrables: Value(delivrables),
      isfavorite: Value(isfavorite),
    );
  }

  factory TaskTableData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
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
      description: data.description.present ? data.description.value : this.description,
      category: data.category.present ? data.category.value : this.category,
      governorate: data.governorate.present ? data.governorate.value : this.governorate,
      owner: data.owner.present ? data.owner.value : this.owner,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      delivrables: data.delivrables.present ? data.delivrables.value : this.delivrables,
      isfavorite: data.isfavorite.present ? data.isfavorite.value : this.isfavorite,
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
  int get hashCode => Object.hash(id, price, title, description, category, governorate, owner, dueDate, delivrables, isfavorite);
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

class $TaskAttachmentTableTable extends TaskAttachmentTable with TableInfo<$TaskAttachmentTableTable, TaskAttachmentTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskAttachmentTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url =
      GeneratedColumn<String>('url', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type =
      GeneratedColumn<String>('type', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>('task_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES task_table (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, url, type, taskId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_attachment_table';
  @override
  VerificationContext validateIntegrity(Insertable<TaskAttachmentTableData> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('url')) {
      context.handle(_urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    }
    if (data.containsKey('type')) {
      context.handle(_typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta, taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskAttachmentTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskAttachmentTableData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      url: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      type: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      taskId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}task_id']),
    );
  }

  @override
  $TaskAttachmentTableTable createAlias(String alias) {
    return $TaskAttachmentTableTable(attachedDatabase, alias);
  }
}

class TaskAttachmentTableData extends DataClass implements Insertable<TaskAttachmentTableData> {
  final int id;
  final String url;
  final String type;
  final String? taskId;
  const TaskAttachmentTableData({required this.id, required this.url, required this.type, this.taskId});
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
      taskId: taskId == null && nullToAbsent ? const Value.absent() : Value(taskId),
    );
  }

  factory TaskAttachmentTableData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
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

  TaskAttachmentTableData copyWith({int? id, String? url, String? type, Value<String?> taskId = const Value.absent()}) => TaskAttachmentTableData(
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
      identical(this, other) || (other is TaskAttachmentTableData && other.id == this.id && other.url == this.url && other.type == this.type && other.taskId == this.taskId);
}

class TaskAttachmentTableCompanion extends UpdateCompanion<TaskAttachmentTableData> {
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

  TaskAttachmentTableCompanion copyWith({Value<int>? id, Value<String>? url, Value<String>? type, Value<String?>? taskId}) {
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

class $StoreTableTable extends StoreTable with TableInfo<$StoreTableTable, StoreTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoreTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name =
      GeneratedColumn<String>('name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _descriptionMeta = const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description =
      GeneratedColumn<String>('description', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _pictureMeta = const VerificationMeta('picture');
  @override
  late final GeneratedColumn<String> picture =
      GeneratedColumn<String>('picture', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _coordinatesMeta = const VerificationMeta('coordinates');
  @override
  late final GeneratedColumn<String> coordinates =
      GeneratedColumn<String>('coordinates', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _governorateMeta = const VerificationMeta('governorate');
  @override
  late final GeneratedColumn<int> governorate = GeneratedColumn<int>('governorate', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES governorate_table (id)'));
  static const VerificationMeta _ownerMeta = const VerificationMeta('owner');
  @override
  late final GeneratedColumn<int> owner = GeneratedColumn<int>('owner', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES user_table (id)'));
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>('is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, name, description, picture, coordinates, governorate, owner, isFavorite];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'store_table';
  @override
  VerificationContext validateIntegrity(Insertable<StoreTableData> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('description')) {
      context.handle(_descriptionMeta, description.isAcceptableOrUnknown(data['description']!, _descriptionMeta));
    }
    if (data.containsKey('picture')) {
      context.handle(_pictureMeta, picture.isAcceptableOrUnknown(data['picture']!, _pictureMeta));
    }
    if (data.containsKey('coordinates')) {
      context.handle(_coordinatesMeta, coordinates.isAcceptableOrUnknown(data['coordinates']!, _coordinatesMeta));
    }
    if (data.containsKey('governorate')) {
      context.handle(_governorateMeta, governorate.isAcceptableOrUnknown(data['governorate']!, _governorateMeta));
    }
    if (data.containsKey('owner')) {
      context.handle(_ownerMeta, owner.isAcceptableOrUnknown(data['owner']!, _ownerMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(_isFavoriteMeta, isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoreTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoreTableData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      picture: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}picture'])!,
      coordinates: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}coordinates'])!,
      governorate: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}governorate']),
      owner: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}owner']),
      isFavorite: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
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
      {required this.id, required this.name, required this.description, required this.picture, required this.coordinates, this.governorate, this.owner, required this.isFavorite});
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
      governorate: governorate == null && nullToAbsent ? const Value.absent() : Value(governorate),
      owner: owner == null && nullToAbsent ? const Value.absent() : Value(owner),
      isFavorite: Value(isFavorite),
    );
  }

  factory StoreTableData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
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
      description: data.description.present ? data.description.value : this.description,
      picture: data.picture.present ? data.picture.value : this.picture,
      coordinates: data.coordinates.present ? data.coordinates.value : this.coordinates,
      governorate: data.governorate.present ? data.governorate.value : this.governorate,
      owner: data.owner.present ? data.owner.value : this.owner,
      isFavorite: data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
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
  int get hashCode => Object.hash(id, name, description, picture, coordinates, governorate, owner, isFavorite);
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

class $ServiceTableTable extends ServiceTable with TableInfo<$ServiceTableTable, ServiceTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name =
      GeneratedColumn<String>('name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _descriptionMeta = const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description =
      GeneratedColumn<String>('description', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _categoryMeta = const VerificationMeta('category');
  @override
  late final GeneratedColumn<int> category = GeneratedColumn<int>('category', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES category_table (id)'));
  static const VerificationMeta _storeMeta = const VerificationMeta('store');
  @override
  late final GeneratedColumn<int> store = GeneratedColumn<int>('store', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES store_table (id)'));
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price =
      GeneratedColumn<double>('price', aliasedName, false, type: DriftSqlType.double, requiredDuringInsert: false, defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, name, description, category, store, price];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_table';
  @override
  VerificationContext validateIntegrity(Insertable<ServiceTableData> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('description')) {
      context.handle(_descriptionMeta, description.isAcceptableOrUnknown(data['description']!, _descriptionMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta, category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('store')) {
      context.handle(_storeMeta, store.isAcceptableOrUnknown(data['store']!, _storeMeta));
    }
    if (data.containsKey('price')) {
      context.handle(_priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  ServiceTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceTableData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      category: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}category']),
      store: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}store']),
      price: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}price'])!,
    );
  }

  @override
  $ServiceTableTable createAlias(String alias) {
    return $ServiceTableTable(attachedDatabase, alias);
  }
}

class ServiceTableData extends DataClass implements Insertable<ServiceTableData> {
  final String id;
  final String name;
  final String description;
  final int? category;
  final int? store;
  final double price;
  const ServiceTableData({required this.id, required this.name, required this.description, this.category, this.store, required this.price});
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
      category: category == null && nullToAbsent ? const Value.absent() : Value(category),
      store: store == null && nullToAbsent ? const Value.absent() : Value(store),
      price: Value(price),
    );
  }

  factory ServiceTableData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
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
          {String? id, String? name, String? description, Value<int?> category = const Value.absent(), Value<int?> store = const Value.absent(), double? price}) =>
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
      description: data.description.present ? data.description.value : this.description,
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
  int get hashCode => Object.hash(id, name, description, category, store, price);
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
      {Value<String>? id, Value<String>? name, Value<String>? description, Value<int?>? category, Value<int?>? store, Value<double>? price, Value<int>? rowid}) {
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

class $ServiceGalleryTableTable extends ServiceGalleryTable with TableInfo<$ServiceGalleryTableTable, ServiceGalleryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceGalleryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url =
      GeneratedColumn<String>('url', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type =
      GeneratedColumn<String>('type', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _serviceIdMeta = const VerificationMeta('serviceId');
  @override
  late final GeneratedColumn<String> serviceId = GeneratedColumn<String>('service_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES service_table (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, url, type, serviceId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_gallery_table';
  @override
  VerificationContext validateIntegrity(Insertable<ServiceGalleryTableData> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('url')) {
      context.handle(_urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    }
    if (data.containsKey('type')) {
      context.handle(_typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('service_id')) {
      context.handle(_serviceIdMeta, serviceId.isAcceptableOrUnknown(data['service_id']!, _serviceIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceGalleryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceGalleryTableData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      url: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      type: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      serviceId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}service_id']),
    );
  }

  @override
  $ServiceGalleryTableTable createAlias(String alias) {
    return $ServiceGalleryTableTable(attachedDatabase, alias);
  }
}

class ServiceGalleryTableData extends DataClass implements Insertable<ServiceGalleryTableData> {
  final int id;
  final String url;
  final String type;
  final String? serviceId;
  const ServiceGalleryTableData({required this.id, required this.url, required this.type, this.serviceId});
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
      serviceId: serviceId == null && nullToAbsent ? const Value.absent() : Value(serviceId),
    );
  }

  factory ServiceGalleryTableData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
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

  ServiceGalleryTableData copyWith({int? id, String? url, String? type, Value<String?> serviceId = const Value.absent()}) => ServiceGalleryTableData(
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
      identical(this, other) || (other is ServiceGalleryTableData && other.id == this.id && other.url == this.url && other.type == this.type && other.serviceId == this.serviceId);
}

class ServiceGalleryTableCompanion extends UpdateCompanion<ServiceGalleryTableData> {
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

  ServiceGalleryTableCompanion copyWith({Value<int>? id, Value<String>? url, Value<String>? type, Value<String?>? serviceId}) {
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

class $ReservationTableTable extends ReservationTable with TableInfo<$ReservationTableTable, ReservationTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReservationTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taskMeta = const VerificationMeta('task');
  @override
  late final GeneratedColumn<String> task = GeneratedColumn<String>('task', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES task_table (id)'));
  static const VerificationMeta _serviceMeta = const VerificationMeta('service');
  @override
  late final GeneratedColumn<String> service = GeneratedColumn<String>('service', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES task_table (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date =
      GeneratedColumn<DateTime>('date', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: false, defaultValue: Constant(DateTime.now()));
  static const VerificationMeta _totalPriceMeta = const VerificationMeta('totalPrice');
  @override
  late final GeneratedColumn<double> totalPrice =
      GeneratedColumn<double>('total_price', aliasedName, false, type: DriftSqlType.double, requiredDuringInsert: false, defaultValue: const Constant(0));
  static const VerificationMeta _proposedPriceMeta = const VerificationMeta('proposedPrice');
  @override
  late final GeneratedColumn<double> proposedPrice = GeneratedColumn<double>('proposed_price', aliasedName, true, type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _couponMeta = const VerificationMeta('coupon');
  @override
  late final GeneratedColumn<String> coupon =
      GeneratedColumn<String>('coupon', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note =
      GeneratedColumn<String>('note', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant(''));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<RequestStatus, int> status =
      GeneratedColumn<int>('status', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false, defaultValue: const Constant(0))
          .withConverter<RequestStatus>($ReservationTableTable.$converterstatus);
  static const VerificationMeta _coinsMeta = const VerificationMeta('coins');
  @override
  late final GeneratedColumn<int> coins = GeneratedColumn<int>('coins', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false, defaultValue: const Constant(0));
  static const VerificationMeta _userMeta = const VerificationMeta('user');
  @override
  late final GeneratedColumn<int> user = GeneratedColumn<int>('user', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES user_table (id)'));
  static const VerificationMeta _providerMeta = const VerificationMeta('provider');
  @override
  late final GeneratedColumn<int> provider = GeneratedColumn<int>('provider', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES user_table (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, task, service, date, totalPrice, proposedPrice, coupon, note, status, coins, user, provider];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reservation_table';
  @override
  VerificationContext validateIntegrity(Insertable<ReservationTableData> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task')) {
      context.handle(_taskMeta, task.isAcceptableOrUnknown(data['task']!, _taskMeta));
    }
    if (data.containsKey('service')) {
      context.handle(_serviceMeta, service.isAcceptableOrUnknown(data['service']!, _serviceMeta));
    }
    if (data.containsKey('date')) {
      context.handle(_dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('total_price')) {
      context.handle(_totalPriceMeta, totalPrice.isAcceptableOrUnknown(data['total_price']!, _totalPriceMeta));
    }
    if (data.containsKey('proposed_price')) {
      context.handle(_proposedPriceMeta, proposedPrice.isAcceptableOrUnknown(data['proposed_price']!, _proposedPriceMeta));
    }
    if (data.containsKey('coupon')) {
      context.handle(_couponMeta, coupon.isAcceptableOrUnknown(data['coupon']!, _couponMeta));
    }
    if (data.containsKey('note')) {
      context.handle(_noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('coins')) {
      context.handle(_coinsMeta, coins.isAcceptableOrUnknown(data['coins']!, _coinsMeta));
    }
    if (data.containsKey('user')) {
      context.handle(_userMeta, user.isAcceptableOrUnknown(data['user']!, _userMeta));
    }
    if (data.containsKey('provider')) {
      context.handle(_providerMeta, provider.isAcceptableOrUnknown(data['provider']!, _providerMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  ReservationTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReservationTableData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      task: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}task']),
      service: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}service']),
      date: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      totalPrice: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}total_price'])!,
      proposedPrice: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}proposed_price']),
      coupon: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}coupon'])!,
      note: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      status: $ReservationTableTable.$converterstatus.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}status'])!),
      coins: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}coins'])!,
      user: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}user']),
      provider: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}provider']),
    );
  }

  @override
  $ReservationTableTable createAlias(String alias) {
    return $ReservationTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RequestStatus, int, int> $converterstatus = const EnumIndexConverter<RequestStatus>(RequestStatus.values);
}

class ReservationTableData extends DataClass implements Insertable<ReservationTableData> {
  final String id;
  final String? task;
  final String? service;
  final DateTime date;
  final double totalPrice;
  final double? proposedPrice;
  final String coupon;
  final String note;
  final RequestStatus status;
  final int coins;
  final int? user;
  final int? provider;
  const ReservationTableData(
      {required this.id,
      this.task,
      this.service,
      required this.date,
      required this.totalPrice,
      this.proposedPrice,
      required this.coupon,
      required this.note,
      required this.status,
      required this.coins,
      this.user,
      this.provider});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || task != null) {
      map['task'] = Variable<String>(task);
    }
    if (!nullToAbsent || service != null) {
      map['service'] = Variable<String>(service);
    }
    map['date'] = Variable<DateTime>(date);
    map['total_price'] = Variable<double>(totalPrice);
    if (!nullToAbsent || proposedPrice != null) {
      map['proposed_price'] = Variable<double>(proposedPrice);
    }
    map['coupon'] = Variable<String>(coupon);
    map['note'] = Variable<String>(note);
    {
      map['status'] = Variable<int>($ReservationTableTable.$converterstatus.toSql(status));
    }
    map['coins'] = Variable<int>(coins);
    if (!nullToAbsent || user != null) {
      map['user'] = Variable<int>(user);
    }
    if (!nullToAbsent || provider != null) {
      map['provider'] = Variable<int>(provider);
    }
    return map;
  }

  ReservationTableCompanion toCompanion(bool nullToAbsent) {
    return ReservationTableCompanion(
      id: Value(id),
      task: task == null && nullToAbsent ? const Value.absent() : Value(task),
      service: service == null && nullToAbsent ? const Value.absent() : Value(service),
      date: Value(date),
      totalPrice: Value(totalPrice),
      proposedPrice: proposedPrice == null && nullToAbsent ? const Value.absent() : Value(proposedPrice),
      coupon: Value(coupon),
      note: Value(note),
      status: Value(status),
      coins: Value(coins),
      user: user == null && nullToAbsent ? const Value.absent() : Value(user),
      provider: provider == null && nullToAbsent ? const Value.absent() : Value(provider),
    );
  }

  factory ReservationTableData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReservationTableData(
      id: serializer.fromJson<String>(json['id']),
      task: serializer.fromJson<String?>(json['task']),
      service: serializer.fromJson<String?>(json['service']),
      date: serializer.fromJson<DateTime>(json['date']),
      totalPrice: serializer.fromJson<double>(json['totalPrice']),
      proposedPrice: serializer.fromJson<double?>(json['proposedPrice']),
      coupon: serializer.fromJson<String>(json['coupon']),
      note: serializer.fromJson<String>(json['note']),
      status: $ReservationTableTable.$converterstatus.fromJson(serializer.fromJson<int>(json['status'])),
      coins: serializer.fromJson<int>(json['coins']),
      user: serializer.fromJson<int?>(json['user']),
      provider: serializer.fromJson<int?>(json['provider']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'task': serializer.toJson<String?>(task),
      'service': serializer.toJson<String?>(service),
      'date': serializer.toJson<DateTime>(date),
      'totalPrice': serializer.toJson<double>(totalPrice),
      'proposedPrice': serializer.toJson<double?>(proposedPrice),
      'coupon': serializer.toJson<String>(coupon),
      'note': serializer.toJson<String>(note),
      'status': serializer.toJson<int>($ReservationTableTable.$converterstatus.toJson(status)),
      'coins': serializer.toJson<int>(coins),
      'user': serializer.toJson<int?>(user),
      'provider': serializer.toJson<int?>(provider),
    };
  }

  ReservationTableData copyWith(
          {String? id,
          Value<String?> task = const Value.absent(),
          Value<String?> service = const Value.absent(),
          DateTime? date,
          double? totalPrice,
          Value<double?> proposedPrice = const Value.absent(),
          String? coupon,
          String? note,
          RequestStatus? status,
          int? coins,
          Value<int?> user = const Value.absent(),
          Value<int?> provider = const Value.absent()}) =>
      ReservationTableData(
        id: id ?? this.id,
        task: task.present ? task.value : this.task,
        service: service.present ? service.value : this.service,
        date: date ?? this.date,
        totalPrice: totalPrice ?? this.totalPrice,
        proposedPrice: proposedPrice.present ? proposedPrice.value : this.proposedPrice,
        coupon: coupon ?? this.coupon,
        note: note ?? this.note,
        status: status ?? this.status,
        coins: coins ?? this.coins,
        user: user.present ? user.value : this.user,
        provider: provider.present ? provider.value : this.provider,
      );
  ReservationTableData copyWithCompanion(ReservationTableCompanion data) {
    return ReservationTableData(
      id: data.id.present ? data.id.value : this.id,
      task: data.task.present ? data.task.value : this.task,
      service: data.service.present ? data.service.value : this.service,
      date: data.date.present ? data.date.value : this.date,
      totalPrice: data.totalPrice.present ? data.totalPrice.value : this.totalPrice,
      proposedPrice: data.proposedPrice.present ? data.proposedPrice.value : this.proposedPrice,
      coupon: data.coupon.present ? data.coupon.value : this.coupon,
      note: data.note.present ? data.note.value : this.note,
      status: data.status.present ? data.status.value : this.status,
      coins: data.coins.present ? data.coins.value : this.coins,
      user: data.user.present ? data.user.value : this.user,
      provider: data.provider.present ? data.provider.value : this.provider,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReservationTableData(')
          ..write('id: $id, ')
          ..write('task: $task, ')
          ..write('service: $service, ')
          ..write('date: $date, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('proposedPrice: $proposedPrice, ')
          ..write('coupon: $coupon, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('coins: $coins, ')
          ..write('user: $user, ')
          ..write('provider: $provider')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, task, service, date, totalPrice, proposedPrice, coupon, note, status, coins, user, provider);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReservationTableData &&
          other.id == this.id &&
          other.task == this.task &&
          other.service == this.service &&
          other.date == this.date &&
          other.totalPrice == this.totalPrice &&
          other.proposedPrice == this.proposedPrice &&
          other.coupon == this.coupon &&
          other.note == this.note &&
          other.status == this.status &&
          other.coins == this.coins &&
          other.user == this.user &&
          other.provider == this.provider);
}

class ReservationTableCompanion extends UpdateCompanion<ReservationTableData> {
  final Value<String> id;
  final Value<String?> task;
  final Value<String?> service;
  final Value<DateTime> date;
  final Value<double> totalPrice;
  final Value<double?> proposedPrice;
  final Value<String> coupon;
  final Value<String> note;
  final Value<RequestStatus> status;
  final Value<int> coins;
  final Value<int?> user;
  final Value<int?> provider;
  final Value<int> rowid;
  const ReservationTableCompanion({
    this.id = const Value.absent(),
    this.task = const Value.absent(),
    this.service = const Value.absent(),
    this.date = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.proposedPrice = const Value.absent(),
    this.coupon = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.coins = const Value.absent(),
    this.user = const Value.absent(),
    this.provider = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReservationTableCompanion.insert({
    required String id,
    this.task = const Value.absent(),
    this.service = const Value.absent(),
    this.date = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.proposedPrice = const Value.absent(),
    this.coupon = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.coins = const Value.absent(),
    this.user = const Value.absent(),
    this.provider = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<ReservationTableData> custom({
    Expression<String>? id,
    Expression<String>? task,
    Expression<String>? service,
    Expression<DateTime>? date,
    Expression<double>? totalPrice,
    Expression<double>? proposedPrice,
    Expression<String>? coupon,
    Expression<String>? note,
    Expression<int>? status,
    Expression<int>? coins,
    Expression<int>? user,
    Expression<int>? provider,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (task != null) 'task': task,
      if (service != null) 'service': service,
      if (date != null) 'date': date,
      if (totalPrice != null) 'total_price': totalPrice,
      if (proposedPrice != null) 'proposed_price': proposedPrice,
      if (coupon != null) 'coupon': coupon,
      if (note != null) 'note': note,
      if (status != null) 'status': status,
      if (coins != null) 'coins': coins,
      if (user != null) 'user': user,
      if (provider != null) 'provider': provider,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReservationTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? task,
      Value<String?>? service,
      Value<DateTime>? date,
      Value<double>? totalPrice,
      Value<double?>? proposedPrice,
      Value<String>? coupon,
      Value<String>? note,
      Value<RequestStatus>? status,
      Value<int>? coins,
      Value<int?>? user,
      Value<int?>? provider,
      Value<int>? rowid}) {
    return ReservationTableCompanion(
      id: id ?? this.id,
      task: task ?? this.task,
      service: service ?? this.service,
      date: date ?? this.date,
      totalPrice: totalPrice ?? this.totalPrice,
      proposedPrice: proposedPrice ?? this.proposedPrice,
      coupon: coupon ?? this.coupon,
      note: note ?? this.note,
      status: status ?? this.status,
      coins: coins ?? this.coins,
      user: user ?? this.user,
      provider: provider ?? this.provider,
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
    if (service.present) {
      map['service'] = Variable<String>(service.value);
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
      map['status'] = Variable<int>($ReservationTableTable.$converterstatus.toSql(status.value));
    }
    if (coins.present) {
      map['coins'] = Variable<int>(coins.value);
    }
    if (user.present) {
      map['user'] = Variable<int>(user.value);
    }
    if (provider.present) {
      map['provider'] = Variable<int>(provider.value);
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
          ..write('service: $service, ')
          ..write('date: $date, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('proposedPrice: $proposedPrice, ')
          ..write('coupon: $coupon, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('coins: $coins, ')
          ..write('user: $user, ')
          ..write('provider: $provider, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  $DatabaseManager get managers => $DatabaseManager(this);
  late final $CategoryTableTable categoryTable = $CategoryTableTable(this);
  late final $GovernorateTableTable governorateTable = $GovernorateTableTable(this);
  late final $UserTableTable userTable = $UserTableTable(this);
  late final $TaskTableTable taskTable = $TaskTableTable(this);
  late final $TaskAttachmentTableTable taskAttachmentTable = $TaskAttachmentTableTable(this);
  late final $StoreTableTable storeTable = $StoreTableTable(this);
  late final $ServiceTableTable serviceTable = $ServiceTableTable(this);
  late final $ServiceGalleryTableTable serviceGalleryTable = $ServiceGalleryTableTable(this);
  late final $ReservationTableTable reservationTable = $ReservationTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [categoryTable, governorateTable, userTable, taskTable, taskAttachmentTable, storeTable, serviceTable, serviceGalleryTable, reservationTable];
}

typedef $$CategoryTableTableCreateCompanionBuilder = CategoryTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> description,
  required String icon,
  Value<int> parent,
  Value<int> subscribed,
});
typedef $$CategoryTableTableUpdateCompanionBuilder = CategoryTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> description,
  Value<String> icon,
  Value<int> parent,
  Value<int> subscribed,
});

final class $$CategoryTableTableReferences extends BaseReferences<_$Database, $CategoryTableTable, CategoryTableData> {
  $$CategoryTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoryTableTable _parentTable(_$Database db) => db.categoryTable.createAlias($_aliasNameGenerator(db.categoryTable.parent, db.categoryTable.id));

  $$CategoryTableTableProcessedTableManager? get parent {
    final manager = $$CategoryTableTableTableManager($_db, $_db.categoryTable).filter((f) => f.id($_item.parent));
    final item = $_typedResult.readTableOrNull(_parentTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TaskTableTable, List<TaskTableData>> _taskTableRefsTable(_$Database db) =>
      MultiTypedResultKey.fromTable(db.taskTable, aliasName: $_aliasNameGenerator(db.categoryTable.id, db.taskTable.category));

  $$TaskTableTableProcessedTableManager get taskTableRefs {
    final manager = $$TaskTableTableTableManager($_db, $_db.taskTable).filter((f) => f.category.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_taskTableRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ServiceTableTable, List<ServiceTableData>> _serviceTableRefsTable(_$Database db) =>
      MultiTypedResultKey.fromTable(db.serviceTable, aliasName: $_aliasNameGenerator(db.categoryTable.id, db.serviceTable.category));

  $$ServiceTableTableProcessedTableManager get serviceTableRefs {
    final manager = $$ServiceTableTableTableManager($_db, $_db.serviceTable).filter((f) => f.category.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_serviceTableRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoryTableTableFilterComposer extends Composer<_$Database, $CategoryTableTable> {
  $$CategoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get subscribed => $composableBuilder(column: $table.subscribed, builder: (column) => ColumnFilters(column));

  $$CategoryTableTableFilterComposer get parent {
    final $$CategoryTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parent,
        referencedTable: $db.categoryTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$CategoryTableTableFilterComposer(
              $db: $db,
              $table: $db.categoryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> taskTableRefs(Expression<bool> Function($$TaskTableTableFilterComposer f) f) {
    final $$TaskTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.taskTable,
        getReferencedColumn: (t) => t.category,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$TaskTableTableFilterComposer(
              $db: $db,
              $table: $db.taskTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> serviceTableRefs(Expression<bool> Function($$ServiceTableTableFilterComposer f) f) {
    final $$ServiceTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serviceTable,
        getReferencedColumn: (t) => t.category,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$ServiceTableTableFilterComposer(
              $db: $db,
              $table: $db.serviceTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoryTableTableOrderingComposer extends Composer<_$Database, $CategoryTableTable> {
  $$CategoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get subscribed => $composableBuilder(column: $table.subscribed, builder: (column) => ColumnOrderings(column));

  $$CategoryTableTableOrderingComposer get parent {
    final $$CategoryTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parent,
        referencedTable: $db.categoryTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$CategoryTableTableOrderingComposer(
              $db: $db,
              $table: $db.categoryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CategoryTableTableAnnotationComposer extends Composer<_$Database, $CategoryTableTable> {
  $$CategoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get icon => $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get subscribed => $composableBuilder(column: $table.subscribed, builder: (column) => column);

  $$CategoryTableTableAnnotationComposer get parent {
    final $$CategoryTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parent,
        referencedTable: $db.categoryTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$CategoryTableTableAnnotationComposer(
              $db: $db,
              $table: $db.categoryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> taskTableRefs<T extends Object>(Expression<T> Function($$TaskTableTableAnnotationComposer a) f) {
    final $$TaskTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.taskTable,
        getReferencedColumn: (t) => t.category,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$TaskTableTableAnnotationComposer(
              $db: $db,
              $table: $db.taskTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> serviceTableRefs<T extends Object>(Expression<T> Function($$ServiceTableTableAnnotationComposer a) f) {
    final $$ServiceTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serviceTable,
        getReferencedColumn: (t) => t.category,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$ServiceTableTableAnnotationComposer(
              $db: $db,
              $table: $db.serviceTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoryTableTableTableManager extends RootTableManager<
    _$Database,
    $CategoryTableTable,
    CategoryTableData,
    $$CategoryTableTableFilterComposer,
    $$CategoryTableTableOrderingComposer,
    $$CategoryTableTableAnnotationComposer,
    $$CategoryTableTableCreateCompanionBuilder,
    $$CategoryTableTableUpdateCompanionBuilder,
    (CategoryTableData, $$CategoryTableTableReferences),
    CategoryTableData,
    PrefetchHooks Function({bool parent, bool taskTableRefs, bool serviceTableRefs})> {
  $$CategoryTableTableTableManager(_$Database db, $CategoryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$CategoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$CategoryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$CategoryTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<int> parent = const Value.absent(),
            Value<int> subscribed = const Value.absent(),
          }) =>
              CategoryTableCompanion(
            id: id,
            name: name,
            description: description,
            icon: icon,
            parent: parent,
            subscribed: subscribed,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            required String icon,
            Value<int> parent = const Value.absent(),
            Value<int> subscribed = const Value.absent(),
          }) =>
              CategoryTableCompanion.insert(
            id: id,
            name: name,
            description: description,
            icon: icon,
            parent: parent,
            subscribed: subscribed,
          ),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), $$CategoryTableTableReferences(db, table, e))).toList(),
          prefetchHooksCallback: ({parent = false, taskTableRefs = false, serviceTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (taskTableRefs) db.taskTable, if (serviceTableRefs) db.serviceTable],
              addJoins: <T extends TableManagerState<dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic>>(state) {
                if (parent) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parent,
                    referencedTable: $$CategoryTableTableReferences._parentTable(db),
                    referencedColumn: $$CategoryTableTableReferences._parentTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$CategoryTableTableReferences._taskTableRefsTable(db),
                        managerFromTypedResult: (p0) => $$CategoryTableTableReferences(db, table, p0).taskTableRefs,
                        referencedItemsForCurrentItem: (item, referencedItems) => referencedItems.where((e) => e.category == item.id),
                        typedResults: items),
                  if (serviceTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$CategoryTableTableReferences._serviceTableRefsTable(db),
                        managerFromTypedResult: (p0) => $$CategoryTableTableReferences(db, table, p0).serviceTableRefs,
                        referencedItemsForCurrentItem: (item, referencedItems) => referencedItems.where((e) => e.category == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoryTableTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $CategoryTableTable,
    CategoryTableData,
    $$CategoryTableTableFilterComposer,
    $$CategoryTableTableOrderingComposer,
    $$CategoryTableTableAnnotationComposer,
    $$CategoryTableTableCreateCompanionBuilder,
    $$CategoryTableTableUpdateCompanionBuilder,
    (CategoryTableData, $$CategoryTableTableReferences),
    CategoryTableData,
    PrefetchHooks Function({bool parent, bool taskTableRefs, bool serviceTableRefs})>;
typedef $$GovernorateTableTableCreateCompanionBuilder = GovernorateTableCompanion Function({
  Value<int> id,
  Value<String> name,
});
typedef $$GovernorateTableTableUpdateCompanionBuilder = GovernorateTableCompanion Function({
  Value<int> id,
  Value<String> name,
});

final class $$GovernorateTableTableReferences extends BaseReferences<_$Database, $GovernorateTableTable, GovernorateTableData> {
  $$GovernorateTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UserTableTable, List<UserTableData>> _userTableRefsTable(_$Database db) =>
      MultiTypedResultKey.fromTable(db.userTable, aliasName: $_aliasNameGenerator(db.governorateTable.id, db.userTable.governorate));

  $$UserTableTableProcessedTableManager get userTableRefs {
    final manager = $$UserTableTableTableManager($_db, $_db.userTable).filter((f) => f.governorate.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_userTableRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TaskTableTable, List<TaskTableData>> _taskTableRefsTable(_$Database db) =>
      MultiTypedResultKey.fromTable(db.taskTable, aliasName: $_aliasNameGenerator(db.governorateTable.id, db.taskTable.governorate));

  $$TaskTableTableProcessedTableManager get taskTableRefs {
    final manager = $$TaskTableTableTableManager($_db, $_db.taskTable).filter((f) => f.governorate.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_taskTableRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$StoreTableTable, List<StoreTableData>> _storeTableRefsTable(_$Database db) =>
      MultiTypedResultKey.fromTable(db.storeTable, aliasName: $_aliasNameGenerator(db.governorateTable.id, db.storeTable.governorate));

  $$StoreTableTableProcessedTableManager get storeTableRefs {
    final manager = $$StoreTableTableTableManager($_db, $_db.storeTable).filter((f) => f.governorate.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_storeTableRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$GovernorateTableTableFilterComposer extends Composer<_$Database, $GovernorateTableTable> {
  $$GovernorateTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  Expression<bool> userTableRefs(Expression<bool> Function($$UserTableTableFilterComposer f) f) {
    final $$UserTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.userTable,
        getReferencedColumn: (t) => t.governorate,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$UserTableTableFilterComposer(
              $db: $db,
              $table: $db.userTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> taskTableRefs(Expression<bool> Function($$TaskTableTableFilterComposer f) f) {
    final $$TaskTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.taskTable,
        getReferencedColumn: (t) => t.governorate,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$TaskTableTableFilterComposer(
              $db: $db,
              $table: $db.taskTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> storeTableRefs(Expression<bool> Function($$StoreTableTableFilterComposer f) f) {
    final $$StoreTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.storeTable,
        getReferencedColumn: (t) => t.governorate,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$StoreTableTableFilterComposer(
              $db: $db,
              $table: $db.storeTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GovernorateTableTableOrderingComposer extends Composer<_$Database, $GovernorateTableTable> {
  $$GovernorateTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$GovernorateTableTableAnnotationComposer extends Composer<_$Database, $GovernorateTableTable> {
  $$GovernorateTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> userTableRefs<T extends Object>(Expression<T> Function($$UserTableTableAnnotationComposer a) f) {
    final $$UserTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.userTable,
        getReferencedColumn: (t) => t.governorate,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$UserTableTableAnnotationComposer(
              $db: $db,
              $table: $db.userTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> taskTableRefs<T extends Object>(Expression<T> Function($$TaskTableTableAnnotationComposer a) f) {
    final $$TaskTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.taskTable,
        getReferencedColumn: (t) => t.governorate,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$TaskTableTableAnnotationComposer(
              $db: $db,
              $table: $db.taskTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> storeTableRefs<T extends Object>(Expression<T> Function($$StoreTableTableAnnotationComposer a) f) {
    final $$StoreTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.storeTable,
        getReferencedColumn: (t) => t.governorate,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$StoreTableTableAnnotationComposer(
              $db: $db,
              $table: $db.storeTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GovernorateTableTableTableManager extends RootTableManager<
    _$Database,
    $GovernorateTableTable,
    GovernorateTableData,
    $$GovernorateTableTableFilterComposer,
    $$GovernorateTableTableOrderingComposer,
    $$GovernorateTableTableAnnotationComposer,
    $$GovernorateTableTableCreateCompanionBuilder,
    $$GovernorateTableTableUpdateCompanionBuilder,
    (GovernorateTableData, $$GovernorateTableTableReferences),
    GovernorateTableData,
    PrefetchHooks Function({bool userTableRefs, bool taskTableRefs, bool storeTableRefs})> {
  $$GovernorateTableTableTableManager(_$Database db, $GovernorateTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$GovernorateTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$GovernorateTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$GovernorateTableTableAnnotationComposer($db: db, $table: table),
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
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), $$GovernorateTableTableReferences(db, table, e))).toList(),
          prefetchHooksCallback: ({userTableRefs = false, taskTableRefs = false, storeTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (userTableRefs) db.userTable, if (taskTableRefs) db.taskTable, if (storeTableRefs) db.storeTable],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (userTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$GovernorateTableTableReferences._userTableRefsTable(db),
                        managerFromTypedResult: (p0) => $$GovernorateTableTableReferences(db, table, p0).userTableRefs,
                        referencedItemsForCurrentItem: (item, referencedItems) => referencedItems.where((e) => e.governorate == item.id),
                        typedResults: items),
                  if (taskTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$GovernorateTableTableReferences._taskTableRefsTable(db),
                        managerFromTypedResult: (p0) => $$GovernorateTableTableReferences(db, table, p0).taskTableRefs,
                        referencedItemsForCurrentItem: (item, referencedItems) => referencedItems.where((e) => e.governorate == item.id),
                        typedResults: items),
                  if (storeTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$GovernorateTableTableReferences._storeTableRefsTable(db),
                        managerFromTypedResult: (p0) => $$GovernorateTableTableReferences(db, table, p0).storeTableRefs,
                        referencedItemsForCurrentItem: (item, referencedItems) => referencedItems.where((e) => e.governorate == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$GovernorateTableTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $GovernorateTableTable,
    GovernorateTableData,
    $$GovernorateTableTableFilterComposer,
    $$GovernorateTableTableOrderingComposer,
    $$GovernorateTableTableAnnotationComposer,
    $$GovernorateTableTableCreateCompanionBuilder,
    $$GovernorateTableTableUpdateCompanionBuilder,
    (GovernorateTableData, $$GovernorateTableTableReferences),
    GovernorateTableData,
    PrefetchHooks Function({bool userTableRefs, bool taskTableRefs, bool storeTableRefs})>;
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
  Value<String> referralCode,
  Value<String?> coordinates,
  Value<int> governorate,
  Value<int> coins,
  Value<int> availableCoins,
  Value<int> availablePurchasedCoins,
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
  Value<String> referralCode,
  Value<String?> coordinates,
  Value<int> governorate,
  Value<int> coins,
  Value<int> availableCoins,
  Value<int> availablePurchasedCoins,
});

final class $$UserTableTableReferences extends BaseReferences<_$Database, $UserTableTable, UserTableData> {
  $$UserTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GovernorateTableTable _governorateTable(_$Database db) => db.governorateTable.createAlias($_aliasNameGenerator(db.userTable.governorate, db.governorateTable.id));

  $$GovernorateTableTableProcessedTableManager? get governorate {
    final manager = $$GovernorateTableTableTableManager($_db, $_db.governorateTable).filter((f) => f.id($_item.governorate));
    final item = $_typedResult.readTableOrNull(_governorateTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TaskTableTable, List<TaskTableData>> _taskTableRefsTable(_$Database db) =>
      MultiTypedResultKey.fromTable(db.taskTable, aliasName: $_aliasNameGenerator(db.userTable.id, db.taskTable.owner));

  $$TaskTableTableProcessedTableManager get taskTableRefs {
    final manager = $$TaskTableTableTableManager($_db, $_db.taskTable).filter((f) => f.owner.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_taskTableRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$StoreTableTable, List<StoreTableData>> _storeTableRefsTable(_$Database db) =>
      MultiTypedResultKey.fromTable(db.storeTable, aliasName: $_aliasNameGenerator(db.userTable.id, db.storeTable.owner));

  $$StoreTableTableProcessedTableManager get storeTableRefs {
    final manager = $$StoreTableTableTableManager($_db, $_db.storeTable).filter((f) => f.owner.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_storeTableRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UserTableTableFilterComposer extends Composer<_$Database, $UserTableTable> {
  $$UserTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get picture => $composableBuilder(column: $table.picture, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Role, Role, int> get role => $composableBuilder(column: $table.role, builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Gender, Gender, int> get gender => $composableBuilder(column: $table.gender, builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<VerifyIdentityStatus, VerifyIdentityStatus, int> get isVerified =>
      $composableBuilder(column: $table.isVerified, builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get isMailVerified => $composableBuilder(column: $table.isMailVerified, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get birthdate => $composableBuilder(column: $table.birthdate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bio => $composableBuilder(column: $table.bio, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referralCode => $composableBuilder(column: $table.referralCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coordinates => $composableBuilder(column: $table.coordinates, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get coins => $composableBuilder(column: $table.coins, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get availableCoins => $composableBuilder(column: $table.availableCoins, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get availablePurchasedCoins => $composableBuilder(column: $table.availablePurchasedCoins, builder: (column) => ColumnFilters(column));

  $$GovernorateTableTableFilterComposer get governorate {
    final $$GovernorateTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.governorate,
        referencedTable: $db.governorateTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$GovernorateTableTableFilterComposer(
              $db: $db,
              $table: $db.governorateTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> taskTableRefs(Expression<bool> Function($$TaskTableTableFilterComposer f) f) {
    final $$TaskTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.taskTable,
        getReferencedColumn: (t) => t.owner,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$TaskTableTableFilterComposer(
              $db: $db,
              $table: $db.taskTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> storeTableRefs(Expression<bool> Function($$StoreTableTableFilterComposer f) f) {
    final $$StoreTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.storeTable,
        getReferencedColumn: (t) => t.owner,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$StoreTableTableFilterComposer(
              $db: $db,
              $table: $db.storeTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UserTableTableOrderingComposer extends Composer<_$Database, $UserTableTable> {
  $$UserTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get picture => $composableBuilder(column: $table.picture, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get role => $composableBuilder(column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gender => $composableBuilder(column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isVerified => $composableBuilder(column: $table.isVerified, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isMailVerified => $composableBuilder(column: $table.isMailVerified, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get birthdate => $composableBuilder(column: $table.birthdate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bio => $composableBuilder(column: $table.bio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referralCode => $composableBuilder(column: $table.referralCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coordinates => $composableBuilder(column: $table.coordinates, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get coins => $composableBuilder(column: $table.coins, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get availableCoins => $composableBuilder(column: $table.availableCoins, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get availablePurchasedCoins => $composableBuilder(column: $table.availablePurchasedCoins, builder: (column) => ColumnOrderings(column));

  $$GovernorateTableTableOrderingComposer get governorate {
    final $$GovernorateTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.governorate,
        referencedTable: $db.governorateTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$GovernorateTableTableOrderingComposer(
              $db: $db,
              $table: $db.governorateTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UserTableTableAnnotationComposer extends Composer<_$Database, $UserTableTable> {
  $$UserTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email => $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone => $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get picture => $composableBuilder(column: $table.picture, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Role, int> get role => $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Gender, int> get gender => $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumnWithTypeConverter<VerifyIdentityStatus, int> get isVerified => $composableBuilder(column: $table.isVerified, builder: (column) => column);

  GeneratedColumn<bool> get isMailVerified => $composableBuilder(column: $table.isMailVerified, builder: (column) => column);

  GeneratedColumn<DateTime> get birthdate => $composableBuilder(column: $table.birthdate, builder: (column) => column);

  GeneratedColumn<String> get bio => $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<String> get referralCode => $composableBuilder(column: $table.referralCode, builder: (column) => column);

  GeneratedColumn<String> get coordinates => $composableBuilder(column: $table.coordinates, builder: (column) => column);

  GeneratedColumn<int> get coins => $composableBuilder(column: $table.coins, builder: (column) => column);

  GeneratedColumn<int> get availableCoins => $composableBuilder(column: $table.availableCoins, builder: (column) => column);

  GeneratedColumn<int> get availablePurchasedCoins => $composableBuilder(column: $table.availablePurchasedCoins, builder: (column) => column);

  $$GovernorateTableTableAnnotationComposer get governorate {
    final $$GovernorateTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.governorate,
        referencedTable: $db.governorateTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$GovernorateTableTableAnnotationComposer(
              $db: $db,
              $table: $db.governorateTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> taskTableRefs<T extends Object>(Expression<T> Function($$TaskTableTableAnnotationComposer a) f) {
    final $$TaskTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.taskTable,
        getReferencedColumn: (t) => t.owner,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$TaskTableTableAnnotationComposer(
              $db: $db,
              $table: $db.taskTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> storeTableRefs<T extends Object>(Expression<T> Function($$StoreTableTableAnnotationComposer a) f) {
    final $$StoreTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.storeTable,
        getReferencedColumn: (t) => t.owner,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$StoreTableTableAnnotationComposer(
              $db: $db,
              $table: $db.storeTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UserTableTableTableManager extends RootTableManager<
    _$Database,
    $UserTableTable,
    UserTableData,
    $$UserTableTableFilterComposer,
    $$UserTableTableOrderingComposer,
    $$UserTableTableAnnotationComposer,
    $$UserTableTableCreateCompanionBuilder,
    $$UserTableTableUpdateCompanionBuilder,
    (UserTableData, $$UserTableTableReferences),
    UserTableData,
    PrefetchHooks Function({bool governorate, bool taskTableRefs, bool storeTableRefs})> {
  $$UserTableTableTableManager(_$Database db, $UserTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$UserTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$UserTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$UserTableTableAnnotationComposer($db: db, $table: table),
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
            Value<String> referralCode = const Value.absent(),
            Value<String?> coordinates = const Value.absent(),
            Value<int> governorate = const Value.absent(),
            Value<int> coins = const Value.absent(),
            Value<int> availableCoins = const Value.absent(),
            Value<int> availablePurchasedCoins = const Value.absent(),
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
            referralCode: referralCode,
            coordinates: coordinates,
            governorate: governorate,
            coins: coins,
            availableCoins: availableCoins,
            availablePurchasedCoins: availablePurchasedCoins,
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
            Value<String> referralCode = const Value.absent(),
            Value<String?> coordinates = const Value.absent(),
            Value<int> governorate = const Value.absent(),
            Value<int> coins = const Value.absent(),
            Value<int> availableCoins = const Value.absent(),
            Value<int> availablePurchasedCoins = const Value.absent(),
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
            referralCode: referralCode,
            coordinates: coordinates,
            governorate: governorate,
            coins: coins,
            availableCoins: availableCoins,
            availablePurchasedCoins: availablePurchasedCoins,
          ),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), $$UserTableTableReferences(db, table, e))).toList(),
          prefetchHooksCallback: ({governorate = false, taskTableRefs = false, storeTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (taskTableRefs) db.taskTable, if (storeTableRefs) db.storeTable],
              addJoins: <T extends TableManagerState<dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic>>(state) {
                if (governorate) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.governorate,
                    referencedTable: $$UserTableTableReferences._governorateTable(db),
                    referencedColumn: $$UserTableTableReferences._governorateTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$UserTableTableReferences._taskTableRefsTable(db),
                        managerFromTypedResult: (p0) => $$UserTableTableReferences(db, table, p0).taskTableRefs,
                        referencedItemsForCurrentItem: (item, referencedItems) => referencedItems.where((e) => e.owner == item.id),
                        typedResults: items),
                  if (storeTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$UserTableTableReferences._storeTableRefsTable(db),
                        managerFromTypedResult: (p0) => $$UserTableTableReferences(db, table, p0).storeTableRefs,
                        referencedItemsForCurrentItem: (item, referencedItems) => referencedItems.where((e) => e.owner == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UserTableTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $UserTableTable,
    UserTableData,
    $$UserTableTableFilterComposer,
    $$UserTableTableOrderingComposer,
    $$UserTableTableAnnotationComposer,
    $$UserTableTableCreateCompanionBuilder,
    $$UserTableTableUpdateCompanionBuilder,
    (UserTableData, $$UserTableTableReferences),
    UserTableData,
    PrefetchHooks Function({bool governorate, bool taskTableRefs, bool storeTableRefs})>;
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

final class $$TaskTableTableReferences extends BaseReferences<_$Database, $TaskTableTable, TaskTableData> {
  $$TaskTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoryTableTable _categoryTable(_$Database db) => db.categoryTable.createAlias($_aliasNameGenerator(db.taskTable.category, db.categoryTable.id));

  $$CategoryTableTableProcessedTableManager? get category {
    final manager = $$CategoryTableTableTableManager($_db, $_db.categoryTable).filter((f) => f.id($_item.category));
    final item = $_typedResult.readTableOrNull(_categoryTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static $GovernorateTableTable _governorateTable(_$Database db) => db.governorateTable.createAlias($_aliasNameGenerator(db.taskTable.governorate, db.governorateTable.id));

  $$GovernorateTableTableProcessedTableManager? get governorate {
    if ($_item.governorate == null) return null;
    final manager = $$GovernorateTableTableTableManager($_db, $_db.governorateTable).filter((f) => f.id($_item.governorate!));
    final item = $_typedResult.readTableOrNull(_governorateTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UserTableTable _ownerTable(_$Database db) => db.userTable.createAlias($_aliasNameGenerator(db.taskTable.owner, db.userTable.id));

  $$UserTableTableProcessedTableManager? get owner {
    if ($_item.owner == null) return null;
    final manager = $$UserTableTableTableManager($_db, $_db.userTable).filter((f) => f.id($_item.owner!));
    final item = $_typedResult.readTableOrNull(_ownerTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TaskAttachmentTableTable, List<TaskAttachmentTableData>> _taskAttachmentTableRefsTable(_$Database db) =>
      MultiTypedResultKey.fromTable(db.taskAttachmentTable, aliasName: $_aliasNameGenerator(db.taskTable.id, db.taskAttachmentTable.taskId));

  $$TaskAttachmentTableTableProcessedTableManager get taskAttachmentTableRefs {
    final manager = $$TaskAttachmentTableTableTableManager($_db, $_db.taskAttachmentTable).filter((f) => f.taskId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_taskAttachmentTableRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TaskTableTableFilterComposer extends Composer<_$Database, $TaskTableTable> {
  $$TaskTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueDate => $composableBuilder(column: $table.dueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get delivrables => $composableBuilder(column: $table.delivrables, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isfavorite => $composableBuilder(column: $table.isfavorite, builder: (column) => ColumnFilters(column));

  $$CategoryTableTableFilterComposer get category {
    final $$CategoryTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.category,
        referencedTable: $db.categoryTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$CategoryTableTableFilterComposer(
              $db: $db,
              $table: $db.categoryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GovernorateTableTableFilterComposer get governorate {
    final $$GovernorateTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.governorate,
        referencedTable: $db.governorateTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$GovernorateTableTableFilterComposer(
              $db: $db,
              $table: $db.governorateTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UserTableTableFilterComposer get owner {
    final $$UserTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.owner,
        referencedTable: $db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$UserTableTableFilterComposer(
              $db: $db,
              $table: $db.userTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> taskAttachmentTableRefs(Expression<bool> Function($$TaskAttachmentTableTableFilterComposer f) f) {
    final $$TaskAttachmentTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.taskAttachmentTable,
        getReferencedColumn: (t) => t.taskId,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$TaskAttachmentTableTableFilterComposer(
              $db: $db,
              $table: $db.taskAttachmentTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TaskTableTableOrderingComposer extends Composer<_$Database, $TaskTableTable> {
  $$TaskTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(column: $table.dueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get delivrables => $composableBuilder(column: $table.delivrables, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isfavorite => $composableBuilder(column: $table.isfavorite, builder: (column) => ColumnOrderings(column));

  $$CategoryTableTableOrderingComposer get category {
    final $$CategoryTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.category,
        referencedTable: $db.categoryTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$CategoryTableTableOrderingComposer(
              $db: $db,
              $table: $db.categoryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GovernorateTableTableOrderingComposer get governorate {
    final $$GovernorateTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.governorate,
        referencedTable: $db.governorateTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$GovernorateTableTableOrderingComposer(
              $db: $db,
              $table: $db.governorateTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UserTableTableOrderingComposer get owner {
    final $$UserTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.owner,
        referencedTable: $db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$UserTableTableOrderingComposer(
              $db: $db,
              $table: $db.userTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TaskTableTableAnnotationComposer extends Composer<_$Database, $TaskTableTable> {
  $$TaskTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get price => $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get title => $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate => $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get delivrables => $composableBuilder(column: $table.delivrables, builder: (column) => column);

  GeneratedColumn<bool> get isfavorite => $composableBuilder(column: $table.isfavorite, builder: (column) => column);

  $$CategoryTableTableAnnotationComposer get category {
    final $$CategoryTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.category,
        referencedTable: $db.categoryTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$CategoryTableTableAnnotationComposer(
              $db: $db,
              $table: $db.categoryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GovernorateTableTableAnnotationComposer get governorate {
    final $$GovernorateTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.governorate,
        referencedTable: $db.governorateTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$GovernorateTableTableAnnotationComposer(
              $db: $db,
              $table: $db.governorateTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UserTableTableAnnotationComposer get owner {
    final $$UserTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.owner,
        referencedTable: $db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$UserTableTableAnnotationComposer(
              $db: $db,
              $table: $db.userTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> taskAttachmentTableRefs<T extends Object>(Expression<T> Function($$TaskAttachmentTableTableAnnotationComposer a) f) {
    final $$TaskAttachmentTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.taskAttachmentTable,
        getReferencedColumn: (t) => t.taskId,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$TaskAttachmentTableTableAnnotationComposer(
              $db: $db,
              $table: $db.taskAttachmentTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TaskTableTableTableManager extends RootTableManager<
    _$Database,
    $TaskTableTable,
    TaskTableData,
    $$TaskTableTableFilterComposer,
    $$TaskTableTableOrderingComposer,
    $$TaskTableTableAnnotationComposer,
    $$TaskTableTableCreateCompanionBuilder,
    $$TaskTableTableUpdateCompanionBuilder,
    (TaskTableData, $$TaskTableTableReferences),
    TaskTableData,
    PrefetchHooks Function({bool category, bool governorate, bool owner, bool taskAttachmentTableRefs})> {
  $$TaskTableTableTableManager(_$Database db, $TaskTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$TaskTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$TaskTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$TaskTableTableAnnotationComposer($db: db, $table: table),
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
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), $$TaskTableTableReferences(db, table, e))).toList(),
          prefetchHooksCallback: ({category = false, governorate = false, owner = false, taskAttachmentTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (taskAttachmentTableRefs) db.taskAttachmentTable],
              addJoins: <T extends TableManagerState<dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic>>(state) {
                if (category) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.category,
                    referencedTable: $$TaskTableTableReferences._categoryTable(db),
                    referencedColumn: $$TaskTableTableReferences._categoryTable(db).id,
                  ) as T;
                }
                if (governorate) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.governorate,
                    referencedTable: $$TaskTableTableReferences._governorateTable(db),
                    referencedColumn: $$TaskTableTableReferences._governorateTable(db).id,
                  ) as T;
                }
                if (owner) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.owner,
                    referencedTable: $$TaskTableTableReferences._ownerTable(db),
                    referencedColumn: $$TaskTableTableReferences._ownerTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (taskAttachmentTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$TaskTableTableReferences._taskAttachmentTableRefsTable(db),
                        managerFromTypedResult: (p0) => $$TaskTableTableReferences(db, table, p0).taskAttachmentTableRefs,
                        referencedItemsForCurrentItem: (item, referencedItems) => referencedItems.where((e) => e.taskId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TaskTableTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $TaskTableTable,
    TaskTableData,
    $$TaskTableTableFilterComposer,
    $$TaskTableTableOrderingComposer,
    $$TaskTableTableAnnotationComposer,
    $$TaskTableTableCreateCompanionBuilder,
    $$TaskTableTableUpdateCompanionBuilder,
    (TaskTableData, $$TaskTableTableReferences),
    TaskTableData,
    PrefetchHooks Function({bool category, bool governorate, bool owner, bool taskAttachmentTableRefs})>;
typedef $$TaskAttachmentTableTableCreateCompanionBuilder = TaskAttachmentTableCompanion Function({
  Value<int> id,
  Value<String> url,
  Value<String> type,
  Value<String?> taskId,
});
typedef $$TaskAttachmentTableTableUpdateCompanionBuilder = TaskAttachmentTableCompanion Function({
  Value<int> id,
  Value<String> url,
  Value<String> type,
  Value<String?> taskId,
});

final class $$TaskAttachmentTableTableReferences extends BaseReferences<_$Database, $TaskAttachmentTableTable, TaskAttachmentTableData> {
  $$TaskAttachmentTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TaskTableTable _taskIdTable(_$Database db) => db.taskTable.createAlias($_aliasNameGenerator(db.taskAttachmentTable.taskId, db.taskTable.id));

  $$TaskTableTableProcessedTableManager? get taskId {
    if ($_item.taskId == null) return null;
    final manager = $$TaskTableTableTableManager($_db, $_db.taskTable).filter((f) => f.id($_item.taskId!));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TaskAttachmentTableTableFilterComposer extends Composer<_$Database, $TaskAttachmentTableTable> {
  $$TaskAttachmentTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(column: $table.type, builder: (column) => ColumnFilters(column));

  $$TaskTableTableFilterComposer get taskId {
    final $$TaskTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskId,
        referencedTable: $db.taskTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$TaskTableTableFilterComposer(
              $db: $db,
              $table: $db.taskTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TaskAttachmentTableTableOrderingComposer extends Composer<_$Database, $TaskAttachmentTableTable> {
  $$TaskAttachmentTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(column: $table.type, builder: (column) => ColumnOrderings(column));

  $$TaskTableTableOrderingComposer get taskId {
    final $$TaskTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskId,
        referencedTable: $db.taskTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$TaskTableTableOrderingComposer(
              $db: $db,
              $table: $db.taskTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TaskAttachmentTableTableAnnotationComposer extends Composer<_$Database, $TaskAttachmentTableTable> {
  $$TaskAttachmentTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get url => $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get type => $composableBuilder(column: $table.type, builder: (column) => column);

  $$TaskTableTableAnnotationComposer get taskId {
    final $$TaskTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taskId,
        referencedTable: $db.taskTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$TaskTableTableAnnotationComposer(
              $db: $db,
              $table: $db.taskTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TaskAttachmentTableTableTableManager extends RootTableManager<
    _$Database,
    $TaskAttachmentTableTable,
    TaskAttachmentTableData,
    $$TaskAttachmentTableTableFilterComposer,
    $$TaskAttachmentTableTableOrderingComposer,
    $$TaskAttachmentTableTableAnnotationComposer,
    $$TaskAttachmentTableTableCreateCompanionBuilder,
    $$TaskAttachmentTableTableUpdateCompanionBuilder,
    (TaskAttachmentTableData, $$TaskAttachmentTableTableReferences),
    TaskAttachmentTableData,
    PrefetchHooks Function({bool taskId})> {
  $$TaskAttachmentTableTableTableManager(_$Database db, $TaskAttachmentTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$TaskAttachmentTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$TaskAttachmentTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$TaskAttachmentTableTableAnnotationComposer($db: db, $table: table),
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
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), $$TaskAttachmentTableTableReferences(db, table, e))).toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <T extends TableManagerState<dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic>>(state) {
                if (taskId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.taskId,
                    referencedTable: $$TaskAttachmentTableTableReferences._taskIdTable(db),
                    referencedColumn: $$TaskAttachmentTableTableReferences._taskIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TaskAttachmentTableTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $TaskAttachmentTableTable,
    TaskAttachmentTableData,
    $$TaskAttachmentTableTableFilterComposer,
    $$TaskAttachmentTableTableOrderingComposer,
    $$TaskAttachmentTableTableAnnotationComposer,
    $$TaskAttachmentTableTableCreateCompanionBuilder,
    $$TaskAttachmentTableTableUpdateCompanionBuilder,
    (TaskAttachmentTableData, $$TaskAttachmentTableTableReferences),
    TaskAttachmentTableData,
    PrefetchHooks Function({bool taskId})>;
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

final class $$StoreTableTableReferences extends BaseReferences<_$Database, $StoreTableTable, StoreTableData> {
  $$StoreTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GovernorateTableTable _governorateTable(_$Database db) => db.governorateTable.createAlias($_aliasNameGenerator(db.storeTable.governorate, db.governorateTable.id));

  $$GovernorateTableTableProcessedTableManager? get governorate {
    if ($_item.governorate == null) return null;
    final manager = $$GovernorateTableTableTableManager($_db, $_db.governorateTable).filter((f) => f.id($_item.governorate!));
    final item = $_typedResult.readTableOrNull(_governorateTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UserTableTable _ownerTable(_$Database db) => db.userTable.createAlias($_aliasNameGenerator(db.storeTable.owner, db.userTable.id));

  $$UserTableTableProcessedTableManager? get owner {
    if ($_item.owner == null) return null;
    final manager = $$UserTableTableTableManager($_db, $_db.userTable).filter((f) => f.id($_item.owner!));
    final item = $_typedResult.readTableOrNull(_ownerTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ServiceTableTable, List<ServiceTableData>> _serviceTableRefsTable(_$Database db) =>
      MultiTypedResultKey.fromTable(db.serviceTable, aliasName: $_aliasNameGenerator(db.storeTable.id, db.serviceTable.store));

  $$ServiceTableTableProcessedTableManager get serviceTableRefs {
    final manager = $$ServiceTableTableTableManager($_db, $_db.serviceTable).filter((f) => f.store.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_serviceTableRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$StoreTableTableFilterComposer extends Composer<_$Database, $StoreTableTable> {
  $$StoreTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get picture => $composableBuilder(column: $table.picture, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coordinates => $composableBuilder(column: $table.coordinates, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  $$GovernorateTableTableFilterComposer get governorate {
    final $$GovernorateTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.governorate,
        referencedTable: $db.governorateTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$GovernorateTableTableFilterComposer(
              $db: $db,
              $table: $db.governorateTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UserTableTableFilterComposer get owner {
    final $$UserTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.owner,
        referencedTable: $db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$UserTableTableFilterComposer(
              $db: $db,
              $table: $db.userTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> serviceTableRefs(Expression<bool> Function($$ServiceTableTableFilterComposer f) f) {
    final $$ServiceTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serviceTable,
        getReferencedColumn: (t) => t.store,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$ServiceTableTableFilterComposer(
              $db: $db,
              $table: $db.serviceTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$StoreTableTableOrderingComposer extends Composer<_$Database, $StoreTableTable> {
  $$StoreTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get picture => $composableBuilder(column: $table.picture, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coordinates => $composableBuilder(column: $table.coordinates, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(column: $table.isFavorite, builder: (column) => ColumnOrderings(column));

  $$GovernorateTableTableOrderingComposer get governorate {
    final $$GovernorateTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.governorate,
        referencedTable: $db.governorateTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$GovernorateTableTableOrderingComposer(
              $db: $db,
              $table: $db.governorateTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UserTableTableOrderingComposer get owner {
    final $$UserTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.owner,
        referencedTable: $db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$UserTableTableOrderingComposer(
              $db: $db,
              $table: $db.userTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StoreTableTableAnnotationComposer extends Composer<_$Database, $StoreTableTable> {
  $$StoreTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get picture => $composableBuilder(column: $table.picture, builder: (column) => column);

  GeneratedColumn<String> get coordinates => $composableBuilder(column: $table.coordinates, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(column: $table.isFavorite, builder: (column) => column);

  $$GovernorateTableTableAnnotationComposer get governorate {
    final $$GovernorateTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.governorate,
        referencedTable: $db.governorateTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$GovernorateTableTableAnnotationComposer(
              $db: $db,
              $table: $db.governorateTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UserTableTableAnnotationComposer get owner {
    final $$UserTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.owner,
        referencedTable: $db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$UserTableTableAnnotationComposer(
              $db: $db,
              $table: $db.userTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> serviceTableRefs<T extends Object>(Expression<T> Function($$ServiceTableTableAnnotationComposer a) f) {
    final $$ServiceTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serviceTable,
        getReferencedColumn: (t) => t.store,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$ServiceTableTableAnnotationComposer(
              $db: $db,
              $table: $db.serviceTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$StoreTableTableTableManager extends RootTableManager<
    _$Database,
    $StoreTableTable,
    StoreTableData,
    $$StoreTableTableFilterComposer,
    $$StoreTableTableOrderingComposer,
    $$StoreTableTableAnnotationComposer,
    $$StoreTableTableCreateCompanionBuilder,
    $$StoreTableTableUpdateCompanionBuilder,
    (StoreTableData, $$StoreTableTableReferences),
    StoreTableData,
    PrefetchHooks Function({bool governorate, bool owner, bool serviceTableRefs})> {
  $$StoreTableTableTableManager(_$Database db, $StoreTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$StoreTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$StoreTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$StoreTableTableAnnotationComposer($db: db, $table: table),
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
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), $$StoreTableTableReferences(db, table, e))).toList(),
          prefetchHooksCallback: ({governorate = false, owner = false, serviceTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (serviceTableRefs) db.serviceTable],
              addJoins: <T extends TableManagerState<dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic>>(state) {
                if (governorate) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.governorate,
                    referencedTable: $$StoreTableTableReferences._governorateTable(db),
                    referencedColumn: $$StoreTableTableReferences._governorateTable(db).id,
                  ) as T;
                }
                if (owner) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.owner,
                    referencedTable: $$StoreTableTableReferences._ownerTable(db),
                    referencedColumn: $$StoreTableTableReferences._ownerTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (serviceTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$StoreTableTableReferences._serviceTableRefsTable(db),
                        managerFromTypedResult: (p0) => $$StoreTableTableReferences(db, table, p0).serviceTableRefs,
                        referencedItemsForCurrentItem: (item, referencedItems) => referencedItems.where((e) => e.store == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$StoreTableTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $StoreTableTable,
    StoreTableData,
    $$StoreTableTableFilterComposer,
    $$StoreTableTableOrderingComposer,
    $$StoreTableTableAnnotationComposer,
    $$StoreTableTableCreateCompanionBuilder,
    $$StoreTableTableUpdateCompanionBuilder,
    (StoreTableData, $$StoreTableTableReferences),
    StoreTableData,
    PrefetchHooks Function({bool governorate, bool owner, bool serviceTableRefs})>;
typedef $$ServiceTableTableCreateCompanionBuilder = ServiceTableCompanion Function({
  required String id,
  Value<String> name,
  Value<String> description,
  Value<int?> category,
  Value<int?> store,
  Value<double> price,
  Value<int> rowid,
});
typedef $$ServiceTableTableUpdateCompanionBuilder = ServiceTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> description,
  Value<int?> category,
  Value<int?> store,
  Value<double> price,
  Value<int> rowid,
});

final class $$ServiceTableTableReferences extends BaseReferences<_$Database, $ServiceTableTable, ServiceTableData> {
  $$ServiceTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoryTableTable _categoryTable(_$Database db) => db.categoryTable.createAlias($_aliasNameGenerator(db.serviceTable.category, db.categoryTable.id));

  $$CategoryTableTableProcessedTableManager? get category {
    if ($_item.category == null) return null;
    final manager = $$CategoryTableTableTableManager($_db, $_db.categoryTable).filter((f) => f.id($_item.category!));
    final item = $_typedResult.readTableOrNull(_categoryTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static $StoreTableTable _storeTable(_$Database db) => db.storeTable.createAlias($_aliasNameGenerator(db.serviceTable.store, db.storeTable.id));

  $$StoreTableTableProcessedTableManager? get store {
    if ($_item.store == null) return null;
    final manager = $$StoreTableTableTableManager($_db, $_db.storeTable).filter((f) => f.id($_item.store!));
    final item = $_typedResult.readTableOrNull(_storeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ServiceGalleryTableTable, List<ServiceGalleryTableData>> _serviceGalleryTableRefsTable(_$Database db) =>
      MultiTypedResultKey.fromTable(db.serviceGalleryTable, aliasName: $_aliasNameGenerator(db.serviceTable.id, db.serviceGalleryTable.serviceId));

  $$ServiceGalleryTableTableProcessedTableManager get serviceGalleryTableRefs {
    final manager = $$ServiceGalleryTableTableTableManager($_db, $_db.serviceGalleryTable).filter((f) => f.serviceId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_serviceGalleryTableRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ServiceTableTableFilterComposer extends Composer<_$Database, $ServiceTableTable> {
  $$ServiceTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(column: $table.price, builder: (column) => ColumnFilters(column));

  $$CategoryTableTableFilterComposer get category {
    final $$CategoryTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.category,
        referencedTable: $db.categoryTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$CategoryTableTableFilterComposer(
              $db: $db,
              $table: $db.categoryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$StoreTableTableFilterComposer get store {
    final $$StoreTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.store,
        referencedTable: $db.storeTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$StoreTableTableFilterComposer(
              $db: $db,
              $table: $db.storeTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> serviceGalleryTableRefs(Expression<bool> Function($$ServiceGalleryTableTableFilterComposer f) f) {
    final $$ServiceGalleryTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serviceGalleryTable,
        getReferencedColumn: (t) => t.serviceId,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$ServiceGalleryTableTableFilterComposer(
              $db: $db,
              $table: $db.serviceGalleryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ServiceTableTableOrderingComposer extends Composer<_$Database, $ServiceTableTable> {
  $$ServiceTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(column: $table.price, builder: (column) => ColumnOrderings(column));

  $$CategoryTableTableOrderingComposer get category {
    final $$CategoryTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.category,
        referencedTable: $db.categoryTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$CategoryTableTableOrderingComposer(
              $db: $db,
              $table: $db.categoryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$StoreTableTableOrderingComposer get store {
    final $$StoreTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.store,
        referencedTable: $db.storeTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$StoreTableTableOrderingComposer(
              $db: $db,
              $table: $db.storeTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ServiceTableTableAnnotationComposer extends Composer<_$Database, $ServiceTableTable> {
  $$ServiceTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get price => $composableBuilder(column: $table.price, builder: (column) => column);

  $$CategoryTableTableAnnotationComposer get category {
    final $$CategoryTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.category,
        referencedTable: $db.categoryTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$CategoryTableTableAnnotationComposer(
              $db: $db,
              $table: $db.categoryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$StoreTableTableAnnotationComposer get store {
    final $$StoreTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.store,
        referencedTable: $db.storeTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$StoreTableTableAnnotationComposer(
              $db: $db,
              $table: $db.storeTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> serviceGalleryTableRefs<T extends Object>(Expression<T> Function($$ServiceGalleryTableTableAnnotationComposer a) f) {
    final $$ServiceGalleryTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.serviceGalleryTable,
        getReferencedColumn: (t) => t.serviceId,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$ServiceGalleryTableTableAnnotationComposer(
              $db: $db,
              $table: $db.serviceGalleryTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ServiceTableTableTableManager extends RootTableManager<
    _$Database,
    $ServiceTableTable,
    ServiceTableData,
    $$ServiceTableTableFilterComposer,
    $$ServiceTableTableOrderingComposer,
    $$ServiceTableTableAnnotationComposer,
    $$ServiceTableTableCreateCompanionBuilder,
    $$ServiceTableTableUpdateCompanionBuilder,
    (ServiceTableData, $$ServiceTableTableReferences),
    ServiceTableData,
    PrefetchHooks Function({bool category, bool store, bool serviceGalleryTableRefs})> {
  $$ServiceTableTableTableManager(_$Database db, $ServiceTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ServiceTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ServiceTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$ServiceTableTableAnnotationComposer($db: db, $table: table),
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
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), $$ServiceTableTableReferences(db, table, e))).toList(),
          prefetchHooksCallback: ({category = false, store = false, serviceGalleryTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (serviceGalleryTableRefs) db.serviceGalleryTable],
              addJoins: <T extends TableManagerState<dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic>>(state) {
                if (category) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.category,
                    referencedTable: $$ServiceTableTableReferences._categoryTable(db),
                    referencedColumn: $$ServiceTableTableReferences._categoryTable(db).id,
                  ) as T;
                }
                if (store) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.store,
                    referencedTable: $$ServiceTableTableReferences._storeTable(db),
                    referencedColumn: $$ServiceTableTableReferences._storeTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (serviceGalleryTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$ServiceTableTableReferences._serviceGalleryTableRefsTable(db),
                        managerFromTypedResult: (p0) => $$ServiceTableTableReferences(db, table, p0).serviceGalleryTableRefs,
                        referencedItemsForCurrentItem: (item, referencedItems) => referencedItems.where((e) => e.serviceId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ServiceTableTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $ServiceTableTable,
    ServiceTableData,
    $$ServiceTableTableFilterComposer,
    $$ServiceTableTableOrderingComposer,
    $$ServiceTableTableAnnotationComposer,
    $$ServiceTableTableCreateCompanionBuilder,
    $$ServiceTableTableUpdateCompanionBuilder,
    (ServiceTableData, $$ServiceTableTableReferences),
    ServiceTableData,
    PrefetchHooks Function({bool category, bool store, bool serviceGalleryTableRefs})>;
typedef $$ServiceGalleryTableTableCreateCompanionBuilder = ServiceGalleryTableCompanion Function({
  Value<int> id,
  Value<String> url,
  Value<String> type,
  Value<String?> serviceId,
});
typedef $$ServiceGalleryTableTableUpdateCompanionBuilder = ServiceGalleryTableCompanion Function({
  Value<int> id,
  Value<String> url,
  Value<String> type,
  Value<String?> serviceId,
});

final class $$ServiceGalleryTableTableReferences extends BaseReferences<_$Database, $ServiceGalleryTableTable, ServiceGalleryTableData> {
  $$ServiceGalleryTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ServiceTableTable _serviceIdTable(_$Database db) => db.serviceTable.createAlias($_aliasNameGenerator(db.serviceGalleryTable.serviceId, db.serviceTable.id));

  $$ServiceTableTableProcessedTableManager? get serviceId {
    if ($_item.serviceId == null) return null;
    final manager = $$ServiceTableTableTableManager($_db, $_db.serviceTable).filter((f) => f.id($_item.serviceId!));
    final item = $_typedResult.readTableOrNull(_serviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ServiceGalleryTableTableFilterComposer extends Composer<_$Database, $ServiceGalleryTableTable> {
  $$ServiceGalleryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(column: $table.type, builder: (column) => ColumnFilters(column));

  $$ServiceTableTableFilterComposer get serviceId {
    final $$ServiceTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serviceId,
        referencedTable: $db.serviceTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$ServiceTableTableFilterComposer(
              $db: $db,
              $table: $db.serviceTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ServiceGalleryTableTableOrderingComposer extends Composer<_$Database, $ServiceGalleryTableTable> {
  $$ServiceGalleryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(column: $table.type, builder: (column) => ColumnOrderings(column));

  $$ServiceTableTableOrderingComposer get serviceId {
    final $$ServiceTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serviceId,
        referencedTable: $db.serviceTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$ServiceTableTableOrderingComposer(
              $db: $db,
              $table: $db.serviceTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ServiceGalleryTableTableAnnotationComposer extends Composer<_$Database, $ServiceGalleryTableTable> {
  $$ServiceGalleryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get url => $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get type => $composableBuilder(column: $table.type, builder: (column) => column);

  $$ServiceTableTableAnnotationComposer get serviceId {
    final $$ServiceTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.serviceId,
        referencedTable: $db.serviceTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$ServiceTableTableAnnotationComposer(
              $db: $db,
              $table: $db.serviceTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ServiceGalleryTableTableTableManager extends RootTableManager<
    _$Database,
    $ServiceGalleryTableTable,
    ServiceGalleryTableData,
    $$ServiceGalleryTableTableFilterComposer,
    $$ServiceGalleryTableTableOrderingComposer,
    $$ServiceGalleryTableTableAnnotationComposer,
    $$ServiceGalleryTableTableCreateCompanionBuilder,
    $$ServiceGalleryTableTableUpdateCompanionBuilder,
    (ServiceGalleryTableData, $$ServiceGalleryTableTableReferences),
    ServiceGalleryTableData,
    PrefetchHooks Function({bool serviceId})> {
  $$ServiceGalleryTableTableTableManager(_$Database db, $ServiceGalleryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ServiceGalleryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ServiceGalleryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$ServiceGalleryTableTableAnnotationComposer($db: db, $table: table),
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
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), $$ServiceGalleryTableTableReferences(db, table, e))).toList(),
          prefetchHooksCallback: ({serviceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <T extends TableManagerState<dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic>>(state) {
                if (serviceId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.serviceId,
                    referencedTable: $$ServiceGalleryTableTableReferences._serviceIdTable(db),
                    referencedColumn: $$ServiceGalleryTableTableReferences._serviceIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ServiceGalleryTableTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $ServiceGalleryTableTable,
    ServiceGalleryTableData,
    $$ServiceGalleryTableTableFilterComposer,
    $$ServiceGalleryTableTableOrderingComposer,
    $$ServiceGalleryTableTableAnnotationComposer,
    $$ServiceGalleryTableTableCreateCompanionBuilder,
    $$ServiceGalleryTableTableUpdateCompanionBuilder,
    (ServiceGalleryTableData, $$ServiceGalleryTableTableReferences),
    ServiceGalleryTableData,
    PrefetchHooks Function({bool serviceId})>;
typedef $$ReservationTableTableCreateCompanionBuilder = ReservationTableCompanion Function({
  required String id,
  Value<String?> task,
  Value<String?> service,
  Value<DateTime> date,
  Value<double> totalPrice,
  Value<double?> proposedPrice,
  Value<String> coupon,
  Value<String> note,
  Value<RequestStatus> status,
  Value<int> coins,
  Value<int?> user,
  Value<int?> provider,
  Value<int> rowid,
});
typedef $$ReservationTableTableUpdateCompanionBuilder = ReservationTableCompanion Function({
  Value<String> id,
  Value<String?> task,
  Value<String?> service,
  Value<DateTime> date,
  Value<double> totalPrice,
  Value<double?> proposedPrice,
  Value<String> coupon,
  Value<String> note,
  Value<RequestStatus> status,
  Value<int> coins,
  Value<int?> user,
  Value<int?> provider,
  Value<int> rowid,
});

final class $$ReservationTableTableReferences extends BaseReferences<_$Database, $ReservationTableTable, ReservationTableData> {
  $$ReservationTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TaskTableTable _taskTable(_$Database db) => db.taskTable.createAlias($_aliasNameGenerator(db.reservationTable.task, db.taskTable.id));

  $$TaskTableTableProcessedTableManager? get task {
    if ($_item.task == null) return null;
    final manager = $$TaskTableTableTableManager($_db, $_db.taskTable).filter((f) => f.id($_item.task!));
    final item = $_typedResult.readTableOrNull(_taskTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TaskTableTable _serviceTable(_$Database db) => db.taskTable.createAlias($_aliasNameGenerator(db.reservationTable.service, db.taskTable.id));

  $$TaskTableTableProcessedTableManager? get service {
    if ($_item.service == null) return null;
    final manager = $$TaskTableTableTableManager($_db, $_db.taskTable).filter((f) => f.id($_item.service!));
    final item = $_typedResult.readTableOrNull(_serviceTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UserTableTable _userTable(_$Database db) => db.userTable.createAlias($_aliasNameGenerator(db.reservationTable.user, db.userTable.id));

  $$UserTableTableProcessedTableManager? get user {
    if ($_item.user == null) return null;
    final manager = $$UserTableTableTableManager($_db, $_db.userTable).filter((f) => f.id($_item.user!));
    final item = $_typedResult.readTableOrNull(_userTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UserTableTable _providerTable(_$Database db) => db.userTable.createAlias($_aliasNameGenerator(db.reservationTable.provider, db.userTable.id));

  $$UserTableTableProcessedTableManager? get provider {
    if ($_item.provider == null) return null;
    final manager = $$UserTableTableTableManager($_db, $_db.userTable).filter((f) => f.id($_item.provider!));
    final item = $_typedResult.readTableOrNull(_providerTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ReservationTableTableFilterComposer extends Composer<_$Database, $ReservationTableTable> {
  $$ReservationTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalPrice => $composableBuilder(column: $table.totalPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get proposedPrice => $composableBuilder(column: $table.proposedPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coupon => $composableBuilder(column: $table.coupon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<RequestStatus, RequestStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get coins => $composableBuilder(column: $table.coins, builder: (column) => ColumnFilters(column));

  $$TaskTableTableFilterComposer get task {
    final $$TaskTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.task,
        referencedTable: $db.taskTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$TaskTableTableFilterComposer(
              $db: $db,
              $table: $db.taskTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TaskTableTableFilterComposer get service {
    final $$TaskTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.service,
        referencedTable: $db.taskTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$TaskTableTableFilterComposer(
              $db: $db,
              $table: $db.taskTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UserTableTableFilterComposer get user {
    final $$UserTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.user,
        referencedTable: $db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$UserTableTableFilterComposer(
              $db: $db,
              $table: $db.userTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UserTableTableFilterComposer get provider {
    final $$UserTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.provider,
        referencedTable: $db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$UserTableTableFilterComposer(
              $db: $db,
              $table: $db.userTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReservationTableTableOrderingComposer extends Composer<_$Database, $ReservationTableTable> {
  $$ReservationTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalPrice => $composableBuilder(column: $table.totalPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get proposedPrice => $composableBuilder(column: $table.proposedPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coupon => $composableBuilder(column: $table.coupon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get coins => $composableBuilder(column: $table.coins, builder: (column) => ColumnOrderings(column));

  $$TaskTableTableOrderingComposer get task {
    final $$TaskTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.task,
        referencedTable: $db.taskTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$TaskTableTableOrderingComposer(
              $db: $db,
              $table: $db.taskTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TaskTableTableOrderingComposer get service {
    final $$TaskTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.service,
        referencedTable: $db.taskTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$TaskTableTableOrderingComposer(
              $db: $db,
              $table: $db.taskTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UserTableTableOrderingComposer get user {
    final $$UserTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.user,
        referencedTable: $db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$UserTableTableOrderingComposer(
              $db: $db,
              $table: $db.userTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UserTableTableOrderingComposer get provider {
    final $$UserTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.provider,
        referencedTable: $db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$UserTableTableOrderingComposer(
              $db: $db,
              $table: $db.userTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReservationTableTableAnnotationComposer extends Composer<_$Database, $ReservationTableTable> {
  $$ReservationTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date => $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get totalPrice => $composableBuilder(column: $table.totalPrice, builder: (column) => column);

  GeneratedColumn<double> get proposedPrice => $composableBuilder(column: $table.proposedPrice, builder: (column) => column);

  GeneratedColumn<String> get coupon => $composableBuilder(column: $table.coupon, builder: (column) => column);

  GeneratedColumn<String> get note => $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RequestStatus, int> get status => $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get coins => $composableBuilder(column: $table.coins, builder: (column) => column);

  $$TaskTableTableAnnotationComposer get task {
    final $$TaskTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.task,
        referencedTable: $db.taskTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$TaskTableTableAnnotationComposer(
              $db: $db,
              $table: $db.taskTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TaskTableTableAnnotationComposer get service {
    final $$TaskTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.service,
        referencedTable: $db.taskTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$TaskTableTableAnnotationComposer(
              $db: $db,
              $table: $db.taskTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UserTableTableAnnotationComposer get user {
    final $$UserTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.user,
        referencedTable: $db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$UserTableTableAnnotationComposer(
              $db: $db,
              $table: $db.userTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UserTableTableAnnotationComposer get provider {
    final $$UserTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.provider,
        referencedTable: $db.userTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) => $$UserTableTableAnnotationComposer(
              $db: $db,
              $table: $db.userTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReservationTableTableTableManager extends RootTableManager<
    _$Database,
    $ReservationTableTable,
    ReservationTableData,
    $$ReservationTableTableFilterComposer,
    $$ReservationTableTableOrderingComposer,
    $$ReservationTableTableAnnotationComposer,
    $$ReservationTableTableCreateCompanionBuilder,
    $$ReservationTableTableUpdateCompanionBuilder,
    (ReservationTableData, $$ReservationTableTableReferences),
    ReservationTableData,
    PrefetchHooks Function({bool task, bool service, bool user, bool provider})> {
  $$ReservationTableTableTableManager(_$Database db, $ReservationTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ReservationTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ReservationTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$ReservationTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> task = const Value.absent(),
            Value<String?> service = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<double> totalPrice = const Value.absent(),
            Value<double?> proposedPrice = const Value.absent(),
            Value<String> coupon = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<RequestStatus> status = const Value.absent(),
            Value<int> coins = const Value.absent(),
            Value<int?> user = const Value.absent(),
            Value<int?> provider = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReservationTableCompanion(
            id: id,
            task: task,
            service: service,
            date: date,
            totalPrice: totalPrice,
            proposedPrice: proposedPrice,
            coupon: coupon,
            note: note,
            status: status,
            coins: coins,
            user: user,
            provider: provider,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> task = const Value.absent(),
            Value<String?> service = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<double> totalPrice = const Value.absent(),
            Value<double?> proposedPrice = const Value.absent(),
            Value<String> coupon = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<RequestStatus> status = const Value.absent(),
            Value<int> coins = const Value.absent(),
            Value<int?> user = const Value.absent(),
            Value<int?> provider = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReservationTableCompanion.insert(
            id: id,
            task: task,
            service: service,
            date: date,
            totalPrice: totalPrice,
            proposedPrice: proposedPrice,
            coupon: coupon,
            note: note,
            status: status,
            coins: coins,
            user: user,
            provider: provider,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), $$ReservationTableTableReferences(db, table, e))).toList(),
          prefetchHooksCallback: ({task = false, service = false, user = false, provider = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <T extends TableManagerState<dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic, dynamic>>(state) {
                if (task) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.task,
                    referencedTable: $$ReservationTableTableReferences._taskTable(db),
                    referencedColumn: $$ReservationTableTableReferences._taskTable(db).id,
                  ) as T;
                }
                if (service) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.service,
                    referencedTable: $$ReservationTableTableReferences._serviceTable(db),
                    referencedColumn: $$ReservationTableTableReferences._serviceTable(db).id,
                  ) as T;
                }
                if (user) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.user,
                    referencedTable: $$ReservationTableTableReferences._userTable(db),
                    referencedColumn: $$ReservationTableTableReferences._userTable(db).id,
                  ) as T;
                }
                if (provider) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.provider,
                    referencedTable: $$ReservationTableTableReferences._providerTable(db),
                    referencedColumn: $$ReservationTableTableReferences._providerTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ReservationTableTableProcessedTableManager = ProcessedTableManager<
    _$Database,
    $ReservationTableTable,
    ReservationTableData,
    $$ReservationTableTableFilterComposer,
    $$ReservationTableTableOrderingComposer,
    $$ReservationTableTableAnnotationComposer,
    $$ReservationTableTableCreateCompanionBuilder,
    $$ReservationTableTableUpdateCompanionBuilder,
    (ReservationTableData, $$ReservationTableTableReferences),
    ReservationTableData,
    PrefetchHooks Function({bool task, bool service, bool user, bool provider})>;

class $DatabaseManager {
  final _$Database _db;
  $DatabaseManager(this._db);
  $$CategoryTableTableTableManager get categoryTable => $$CategoryTableTableTableManager(_db, _db.categoryTable);
  $$GovernorateTableTableTableManager get governorateTable => $$GovernorateTableTableTableManager(_db, _db.governorateTable);
  $$UserTableTableTableManager get userTable => $$UserTableTableTableManager(_db, _db.userTable);
  $$TaskTableTableTableManager get taskTable => $$TaskTableTableTableManager(_db, _db.taskTable);
  $$TaskAttachmentTableTableTableManager get taskAttachmentTable => $$TaskAttachmentTableTableTableManager(_db, _db.taskAttachmentTable);
  $$StoreTableTableTableManager get storeTable => $$StoreTableTableTableManager(_db, _db.storeTable);
  $$ServiceTableTableTableManager get serviceTable => $$ServiceTableTableTableManager(_db, _db.serviceTable);
  $$ServiceGalleryTableTableTableManager get serviceGalleryTable => $$ServiceGalleryTableTableTableManager(_db, _db.serviceGalleryTable);
  $$ReservationTableTableTableManager get reservationTable => $$ReservationTableTableTableManager(_db, _db.reservationTable);
}
