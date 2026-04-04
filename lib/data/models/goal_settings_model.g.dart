// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_settings_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGoalSettingsModelCollection on Isar {
  IsarCollection<GoalSettingsModel> get goalSettingsModels => this.collection();
}

const GoalSettingsModelSchema = CollectionSchema(
  name: r'GoalSettingsModel',
  id: 1313117670211285613,
  properties: {
    r'goalStartDate': PropertySchema(
      id: 0,
      name: r'goalStartDate',
      type: IsarType.dateTime,
    ),
    r'isGoalActive': PropertySchema(
      id: 1,
      name: r'isGoalActive',
      type: IsarType.bool,
    ),
    r'savingsGoalAmount': PropertySchema(
      id: 2,
      name: r'savingsGoalAmount',
      type: IsarType.double,
    )
  },
  estimateSize: _goalSettingsModelEstimateSize,
  serialize: _goalSettingsModelSerialize,
  deserialize: _goalSettingsModelDeserialize,
  deserializeProp: _goalSettingsModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _goalSettingsModelGetId,
  getLinks: _goalSettingsModelGetLinks,
  attach: _goalSettingsModelAttach,
  version: '3.1.0+1',
);

int _goalSettingsModelEstimateSize(
  GoalSettingsModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _goalSettingsModelSerialize(
  GoalSettingsModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.goalStartDate);
  writer.writeBool(offsets[1], object.isGoalActive);
  writer.writeDouble(offsets[2], object.savingsGoalAmount);
}

GoalSettingsModel _goalSettingsModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GoalSettingsModel();
  object.goalStartDate = reader.readDateTimeOrNull(offsets[0]);
  object.id = id;
  object.isGoalActive = reader.readBool(offsets[1]);
  object.savingsGoalAmount = reader.readDouble(offsets[2]);
  return object;
}

P _goalSettingsModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _goalSettingsModelGetId(GoalSettingsModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _goalSettingsModelGetLinks(
    GoalSettingsModel object) {
  return [];
}

void _goalSettingsModelAttach(
    IsarCollection<dynamic> col, Id id, GoalSettingsModel object) {
  object.id = id;
}

extension GoalSettingsModelQueryWhereSort
    on QueryBuilder<GoalSettingsModel, GoalSettingsModel, QWhere> {
  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GoalSettingsModelQueryWhere
    on QueryBuilder<GoalSettingsModel, GoalSettingsModel, QWhereClause> {
  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterWhereClause>
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

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterWhereClause>
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

extension GoalSettingsModelQueryFilter
    on QueryBuilder<GoalSettingsModel, GoalSettingsModel, QFilterCondition> {
  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterFilterCondition>
      goalStartDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'goalStartDate',
      ));
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterFilterCondition>
      goalStartDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'goalStartDate',
      ));
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterFilterCondition>
      goalStartDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goalStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterFilterCondition>
      goalStartDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'goalStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterFilterCondition>
      goalStartDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'goalStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterFilterCondition>
      goalStartDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'goalStartDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterFilterCondition>
      isGoalActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isGoalActive',
        value: value,
      ));
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterFilterCondition>
      savingsGoalAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'savingsGoalAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterFilterCondition>
      savingsGoalAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'savingsGoalAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterFilterCondition>
      savingsGoalAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'savingsGoalAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterFilterCondition>
      savingsGoalAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'savingsGoalAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension GoalSettingsModelQueryObject
    on QueryBuilder<GoalSettingsModel, GoalSettingsModel, QFilterCondition> {}

extension GoalSettingsModelQueryLinks
    on QueryBuilder<GoalSettingsModel, GoalSettingsModel, QFilterCondition> {}

extension GoalSettingsModelQuerySortBy
    on QueryBuilder<GoalSettingsModel, GoalSettingsModel, QSortBy> {
  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterSortBy>
      sortByGoalStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalStartDate', Sort.asc);
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterSortBy>
      sortByGoalStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalStartDate', Sort.desc);
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterSortBy>
      sortByIsGoalActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGoalActive', Sort.asc);
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterSortBy>
      sortByIsGoalActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGoalActive', Sort.desc);
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterSortBy>
      sortBySavingsGoalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savingsGoalAmount', Sort.asc);
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterSortBy>
      sortBySavingsGoalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savingsGoalAmount', Sort.desc);
    });
  }
}

extension GoalSettingsModelQuerySortThenBy
    on QueryBuilder<GoalSettingsModel, GoalSettingsModel, QSortThenBy> {
  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterSortBy>
      thenByGoalStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalStartDate', Sort.asc);
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterSortBy>
      thenByGoalStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalStartDate', Sort.desc);
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterSortBy>
      thenByIsGoalActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGoalActive', Sort.asc);
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterSortBy>
      thenByIsGoalActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGoalActive', Sort.desc);
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterSortBy>
      thenBySavingsGoalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savingsGoalAmount', Sort.asc);
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QAfterSortBy>
      thenBySavingsGoalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savingsGoalAmount', Sort.desc);
    });
  }
}

extension GoalSettingsModelQueryWhereDistinct
    on QueryBuilder<GoalSettingsModel, GoalSettingsModel, QDistinct> {
  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QDistinct>
      distinctByGoalStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalStartDate');
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QDistinct>
      distinctByIsGoalActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isGoalActive');
    });
  }

  QueryBuilder<GoalSettingsModel, GoalSettingsModel, QDistinct>
      distinctBySavingsGoalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'savingsGoalAmount');
    });
  }
}

extension GoalSettingsModelQueryProperty
    on QueryBuilder<GoalSettingsModel, GoalSettingsModel, QQueryProperty> {
  QueryBuilder<GoalSettingsModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GoalSettingsModel, DateTime?, QQueryOperations>
      goalStartDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalStartDate');
    });
  }

  QueryBuilder<GoalSettingsModel, bool, QQueryOperations>
      isGoalActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isGoalActive');
    });
  }

  QueryBuilder<GoalSettingsModel, double, QQueryOperations>
      savingsGoalAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'savingsGoalAmount');
    });
  }
}
