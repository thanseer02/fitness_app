// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNotificationSettingsCollection on Isar {
  IsarCollection<NotificationSettings> get notificationSettings =>
      this.collection();
}

const NotificationSettingsSchema = CollectionSchema(
  name: r'NotificationSettings',
  id: 4766171496376314778,
  properties: {
    r'proteinReminderEnabled': PropertySchema(
      id: 0,
      name: r'proteinReminderEnabled',
      type: IsarType.bool,
    ),
    r'proteinReminderTime': PropertySchema(
      id: 1,
      name: r'proteinReminderTime',
      type: IsarType.string,
    ),
    r'weighInReminderEnabled': PropertySchema(
      id: 2,
      name: r'weighInReminderEnabled',
      type: IsarType.bool,
    ),
    r'weighInReminderTime': PropertySchema(
      id: 3,
      name: r'weighInReminderTime',
      type: IsarType.string,
    ),
    r'workoutReminderEnabled': PropertySchema(
      id: 4,
      name: r'workoutReminderEnabled',
      type: IsarType.bool,
    ),
    r'workoutReminderTime': PropertySchema(
      id: 5,
      name: r'workoutReminderTime',
      type: IsarType.string,
    )
  },
  estimateSize: _notificationSettingsEstimateSize,
  serialize: _notificationSettingsSerialize,
  deserialize: _notificationSettingsDeserialize,
  deserializeProp: _notificationSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _notificationSettingsGetId,
  getLinks: _notificationSettingsGetLinks,
  attach: _notificationSettingsAttach,
  version: '3.1.0+1',
);

int _notificationSettingsEstimateSize(
  NotificationSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.proteinReminderTime.length * 3;
  bytesCount += 3 + object.weighInReminderTime.length * 3;
  bytesCount += 3 + object.workoutReminderTime.length * 3;
  return bytesCount;
}

void _notificationSettingsSerialize(
  NotificationSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.proteinReminderEnabled);
  writer.writeString(offsets[1], object.proteinReminderTime);
  writer.writeBool(offsets[2], object.weighInReminderEnabled);
  writer.writeString(offsets[3], object.weighInReminderTime);
  writer.writeBool(offsets[4], object.workoutReminderEnabled);
  writer.writeString(offsets[5], object.workoutReminderTime);
}

NotificationSettings _notificationSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NotificationSettings(
    proteinReminderEnabled: reader.readBoolOrNull(offsets[0]) ?? true,
    proteinReminderTime: reader.readStringOrNull(offsets[1]) ?? '20:00',
    weighInReminderEnabled: reader.readBoolOrNull(offsets[2]) ?? true,
    weighInReminderTime: reader.readStringOrNull(offsets[3]) ?? '09:00',
    workoutReminderEnabled: reader.readBoolOrNull(offsets[4]) ?? true,
    workoutReminderTime: reader.readStringOrNull(offsets[5]) ?? '08:00',
  );
  object.id = id;
  return object;
}

P _notificationSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? '20:00') as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? '09:00') as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? '08:00') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _notificationSettingsGetId(NotificationSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _notificationSettingsGetLinks(
    NotificationSettings object) {
  return [];
}

void _notificationSettingsAttach(
    IsarCollection<dynamic> col, Id id, NotificationSettings object) {
  object.id = id;
}

extension NotificationSettingsQueryWhereSort
    on QueryBuilder<NotificationSettings, NotificationSettings, QWhere> {
  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NotificationSettingsQueryWhere
    on QueryBuilder<NotificationSettings, NotificationSettings, QWhereClause> {
  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension NotificationSettingsQueryFilter on QueryBuilder<NotificationSettings,
    NotificationSettings, QFilterCondition> {
  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> proteinReminderEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proteinReminderEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> proteinReminderTimeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proteinReminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> proteinReminderTimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'proteinReminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> proteinReminderTimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'proteinReminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> proteinReminderTimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'proteinReminderTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> proteinReminderTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'proteinReminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> proteinReminderTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'proteinReminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
          QAfterFilterCondition>
      proteinReminderTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'proteinReminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
          QAfterFilterCondition>
      proteinReminderTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'proteinReminderTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> proteinReminderTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proteinReminderTime',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> proteinReminderTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'proteinReminderTime',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> weighInReminderEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weighInReminderEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> weighInReminderTimeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weighInReminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> weighInReminderTimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weighInReminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> weighInReminderTimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weighInReminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> weighInReminderTimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weighInReminderTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> weighInReminderTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'weighInReminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> weighInReminderTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'weighInReminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
          QAfterFilterCondition>
      weighInReminderTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'weighInReminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
          QAfterFilterCondition>
      weighInReminderTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'weighInReminderTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> weighInReminderTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weighInReminderTime',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> weighInReminderTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'weighInReminderTime',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> workoutReminderEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workoutReminderEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> workoutReminderTimeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workoutReminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> workoutReminderTimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workoutReminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> workoutReminderTimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workoutReminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> workoutReminderTimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workoutReminderTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> workoutReminderTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'workoutReminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> workoutReminderTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'workoutReminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
          QAfterFilterCondition>
      workoutReminderTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'workoutReminderTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
          QAfterFilterCondition>
      workoutReminderTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'workoutReminderTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> workoutReminderTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workoutReminderTime',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> workoutReminderTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'workoutReminderTime',
        value: '',
      ));
    });
  }
}

extension NotificationSettingsQueryObject on QueryBuilder<NotificationSettings,
    NotificationSettings, QFilterCondition> {}

extension NotificationSettingsQueryLinks on QueryBuilder<NotificationSettings,
    NotificationSettings, QFilterCondition> {}

extension NotificationSettingsQuerySortBy
    on QueryBuilder<NotificationSettings, NotificationSettings, QSortBy> {
  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByProteinReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinReminderEnabled', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByProteinReminderEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinReminderEnabled', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByProteinReminderTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinReminderTime', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByProteinReminderTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinReminderTime', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByWeighInReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighInReminderEnabled', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByWeighInReminderEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighInReminderEnabled', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByWeighInReminderTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighInReminderTime', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByWeighInReminderTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighInReminderTime', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByWorkoutReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutReminderEnabled', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByWorkoutReminderEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutReminderEnabled', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByWorkoutReminderTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutReminderTime', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByWorkoutReminderTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutReminderTime', Sort.desc);
    });
  }
}

extension NotificationSettingsQuerySortThenBy
    on QueryBuilder<NotificationSettings, NotificationSettings, QSortThenBy> {
  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByProteinReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinReminderEnabled', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByProteinReminderEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinReminderEnabled', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByProteinReminderTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinReminderTime', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByProteinReminderTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinReminderTime', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByWeighInReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighInReminderEnabled', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByWeighInReminderEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighInReminderEnabled', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByWeighInReminderTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighInReminderTime', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByWeighInReminderTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weighInReminderTime', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByWorkoutReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutReminderEnabled', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByWorkoutReminderEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutReminderEnabled', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByWorkoutReminderTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutReminderTime', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByWorkoutReminderTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutReminderTime', Sort.desc);
    });
  }
}

extension NotificationSettingsQueryWhereDistinct
    on QueryBuilder<NotificationSettings, NotificationSettings, QDistinct> {
  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByProteinReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proteinReminderEnabled');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByProteinReminderTime({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proteinReminderTime',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByWeighInReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weighInReminderEnabled');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByWeighInReminderTime({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weighInReminderTime',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByWorkoutReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workoutReminderEnabled');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByWorkoutReminderTime({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workoutReminderTime',
          caseSensitive: caseSensitive);
    });
  }
}

extension NotificationSettingsQueryProperty on QueryBuilder<
    NotificationSettings, NotificationSettings, QQueryProperty> {
  QueryBuilder<NotificationSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NotificationSettings, bool, QQueryOperations>
      proteinReminderEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proteinReminderEnabled');
    });
  }

  QueryBuilder<NotificationSettings, String, QQueryOperations>
      proteinReminderTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proteinReminderTime');
    });
  }

  QueryBuilder<NotificationSettings, bool, QQueryOperations>
      weighInReminderEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weighInReminderEnabled');
    });
  }

  QueryBuilder<NotificationSettings, String, QQueryOperations>
      weighInReminderTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weighInReminderTime');
    });
  }

  QueryBuilder<NotificationSettings, bool, QQueryOperations>
      workoutReminderEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutReminderEnabled');
    });
  }

  QueryBuilder<NotificationSettings, String, QQueryOperations>
      workoutReminderTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutReminderTime');
    });
  }
}
