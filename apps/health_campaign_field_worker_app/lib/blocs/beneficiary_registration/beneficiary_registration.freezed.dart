// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'beneficiary_registration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BeneficiaryRegistrationEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AddressModel model) saveAddress,
    required TResult Function(HouseholdModel household, bool isConsent)
        saveHouseholdConsent,
    required TResult Function(
            HouseholdModel household, DateTime registrationDate)
        saveHouseholdDetails,
    required TResult Function(IndividualModel model, bool isHeadOfHousehold)
        saveIndividualDetails,
    required TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)
        addMember,
    required TResult Function(
            HouseholdModel household, AddressModel? addressModel)
        updateHouseholdDetails,
    required TResult Function(IndividualModel model, AddressModel addressModel)
        updateIndividualDetails,
    required TResult Function(
            String userUuid, String projectId, BoundaryModel boundary)
        create,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AddressModel model)? saveAddress,
    TResult? Function(HouseholdModel household, bool isConsent)?
        saveHouseholdConsent,
    TResult? Function(HouseholdModel household, DateTime registrationDate)?
        saveHouseholdDetails,
    TResult? Function(IndividualModel model, bool isHeadOfHousehold)?
        saveIndividualDetails,
    TResult? Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)?
        addMember,
    TResult? Function(HouseholdModel household, AddressModel? addressModel)?
        updateHouseholdDetails,
    TResult? Function(IndividualModel model, AddressModel addressModel)?
        updateIndividualDetails,
    TResult? Function(
            String userUuid, String projectId, BoundaryModel boundary)?
        create,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AddressModel model)? saveAddress,
    TResult Function(HouseholdModel household, bool isConsent)?
        saveHouseholdConsent,
    TResult Function(HouseholdModel household, DateTime registrationDate)?
        saveHouseholdDetails,
    TResult Function(IndividualModel model, bool isHeadOfHousehold)?
        saveIndividualDetails,
    TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)?
        addMember,
    TResult Function(HouseholdModel household, AddressModel? addressModel)?
        updateHouseholdDetails,
    TResult Function(IndividualModel model, AddressModel addressModel)?
        updateIndividualDetails,
    TResult Function(String userUuid, String projectId, BoundaryModel boundary)?
        create,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeneficiaryRegistrationSaveAddressEvent value)
        saveAddress,
    required TResult Function(
            BeneficiaryRegistrationSaveHouseholdConsentEvent value)
        saveHouseholdConsent,
    required TResult Function(
            BeneficiaryRegistrationSaveHouseholdDetailsEvent value)
        saveHouseholdDetails,
    required TResult Function(
            BeneficiaryRegistrationSaveIndividualDetailsEvent value)
        saveIndividualDetails,
    required TResult Function(BeneficiaryRegistrationAddMemberEvent value)
        addMember,
    required TResult Function(
            BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)
        updateHouseholdDetails,
    required TResult Function(
            BeneficiaryRegistrationUpdateIndividualDetailsEvent value)
        updateIndividualDetails,
    required TResult Function(BeneficiaryRegistrationCreateEvent value) create,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BeneficiaryRegistrationSaveAddressEvent value)?
        saveAddress,
    TResult? Function(BeneficiaryRegistrationSaveHouseholdConsentEvent value)?
        saveHouseholdConsent,
    TResult? Function(BeneficiaryRegistrationSaveHouseholdDetailsEvent value)?
        saveHouseholdDetails,
    TResult? Function(BeneficiaryRegistrationSaveIndividualDetailsEvent value)?
        saveIndividualDetails,
    TResult? Function(BeneficiaryRegistrationAddMemberEvent value)? addMember,
    TResult? Function(BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)?
        updateHouseholdDetails,
    TResult? Function(
            BeneficiaryRegistrationUpdateIndividualDetailsEvent value)?
        updateIndividualDetails,
    TResult? Function(BeneficiaryRegistrationCreateEvent value)? create,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeneficiaryRegistrationSaveAddressEvent value)?
        saveAddress,
    TResult Function(BeneficiaryRegistrationSaveHouseholdConsentEvent value)?
        saveHouseholdConsent,
    TResult Function(BeneficiaryRegistrationSaveHouseholdDetailsEvent value)?
        saveHouseholdDetails,
    TResult Function(BeneficiaryRegistrationSaveIndividualDetailsEvent value)?
        saveIndividualDetails,
    TResult Function(BeneficiaryRegistrationAddMemberEvent value)? addMember,
    TResult Function(BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)?
        updateHouseholdDetails,
    TResult Function(BeneficiaryRegistrationUpdateIndividualDetailsEvent value)?
        updateIndividualDetails,
    TResult Function(BeneficiaryRegistrationCreateEvent value)? create,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BeneficiaryRegistrationEventCopyWith<$Res> {
  factory $BeneficiaryRegistrationEventCopyWith(
          BeneficiaryRegistrationEvent value,
          $Res Function(BeneficiaryRegistrationEvent) then) =
      _$BeneficiaryRegistrationEventCopyWithImpl<$Res,
          BeneficiaryRegistrationEvent>;
}

/// @nodoc
class _$BeneficiaryRegistrationEventCopyWithImpl<$Res,
        $Val extends BeneficiaryRegistrationEvent>
    implements $BeneficiaryRegistrationEventCopyWith<$Res> {
  _$BeneficiaryRegistrationEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$BeneficiaryRegistrationSaveAddressEventImplCopyWith<$Res> {
  factory _$$BeneficiaryRegistrationSaveAddressEventImplCopyWith(
          _$BeneficiaryRegistrationSaveAddressEventImpl value,
          $Res Function(_$BeneficiaryRegistrationSaveAddressEventImpl) then) =
      __$$BeneficiaryRegistrationSaveAddressEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AddressModel model});
}

/// @nodoc
class __$$BeneficiaryRegistrationSaveAddressEventImplCopyWithImpl<$Res>
    extends _$BeneficiaryRegistrationEventCopyWithImpl<$Res,
        _$BeneficiaryRegistrationSaveAddressEventImpl>
    implements _$$BeneficiaryRegistrationSaveAddressEventImplCopyWith<$Res> {
  __$$BeneficiaryRegistrationSaveAddressEventImplCopyWithImpl(
      _$BeneficiaryRegistrationSaveAddressEventImpl _value,
      $Res Function(_$BeneficiaryRegistrationSaveAddressEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? model = null,
  }) {
    return _then(_$BeneficiaryRegistrationSaveAddressEventImpl(
      null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as AddressModel,
    ));
  }
}

/// @nodoc

class _$BeneficiaryRegistrationSaveAddressEventImpl
    implements BeneficiaryRegistrationSaveAddressEvent {
  const _$BeneficiaryRegistrationSaveAddressEventImpl(this.model);

  @override
  final AddressModel model;

  @override
  String toString() {
    return 'BeneficiaryRegistrationEvent.saveAddress(model: $model)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BeneficiaryRegistrationSaveAddressEventImpl &&
            (identical(other.model, model) || other.model == model));
  }

  @override
  int get hashCode => Object.hash(runtimeType, model);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BeneficiaryRegistrationSaveAddressEventImplCopyWith<
          _$BeneficiaryRegistrationSaveAddressEventImpl>
      get copyWith =>
          __$$BeneficiaryRegistrationSaveAddressEventImplCopyWithImpl<
              _$BeneficiaryRegistrationSaveAddressEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AddressModel model) saveAddress,
    required TResult Function(HouseholdModel household, bool isConsent)
        saveHouseholdConsent,
    required TResult Function(
            HouseholdModel household, DateTime registrationDate)
        saveHouseholdDetails,
    required TResult Function(IndividualModel model, bool isHeadOfHousehold)
        saveIndividualDetails,
    required TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)
        addMember,
    required TResult Function(
            HouseholdModel household, AddressModel? addressModel)
        updateHouseholdDetails,
    required TResult Function(IndividualModel model, AddressModel addressModel)
        updateIndividualDetails,
    required TResult Function(
            String userUuid, String projectId, BoundaryModel boundary)
        create,
  }) {
    return saveAddress(model);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AddressModel model)? saveAddress,
    TResult? Function(HouseholdModel household, bool isConsent)?
        saveHouseholdConsent,
    TResult? Function(HouseholdModel household, DateTime registrationDate)?
        saveHouseholdDetails,
    TResult? Function(IndividualModel model, bool isHeadOfHousehold)?
        saveIndividualDetails,
    TResult? Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)?
        addMember,
    TResult? Function(HouseholdModel household, AddressModel? addressModel)?
        updateHouseholdDetails,
    TResult? Function(IndividualModel model, AddressModel addressModel)?
        updateIndividualDetails,
    TResult? Function(
            String userUuid, String projectId, BoundaryModel boundary)?
        create,
  }) {
    return saveAddress?.call(model);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AddressModel model)? saveAddress,
    TResult Function(HouseholdModel household, bool isConsent)?
        saveHouseholdConsent,
    TResult Function(HouseholdModel household, DateTime registrationDate)?
        saveHouseholdDetails,
    TResult Function(IndividualModel model, bool isHeadOfHousehold)?
        saveIndividualDetails,
    TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)?
        addMember,
    TResult Function(HouseholdModel household, AddressModel? addressModel)?
        updateHouseholdDetails,
    TResult Function(IndividualModel model, AddressModel addressModel)?
        updateIndividualDetails,
    TResult Function(String userUuid, String projectId, BoundaryModel boundary)?
        create,
    required TResult orElse(),
  }) {
    if (saveAddress != null) {
      return saveAddress(model);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeneficiaryRegistrationSaveAddressEvent value)
        saveAddress,
    required TResult Function(
            BeneficiaryRegistrationSaveHouseholdConsentEvent value)
        saveHouseholdConsent,
    required TResult Function(
            BeneficiaryRegistrationSaveHouseholdDetailsEvent value)
        saveHouseholdDetails,
    required TResult Function(
            BeneficiaryRegistrationSaveIndividualDetailsEvent value)
        saveIndividualDetails,
    required TResult Function(BeneficiaryRegistrationAddMemberEvent value)
        addMember,
    required TResult Function(
            BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)
        updateHouseholdDetails,
    required TResult Function(
            BeneficiaryRegistrationUpdateIndividualDetailsEvent value)
        updateIndividualDetails,
    required TResult Function(BeneficiaryRegistrationCreateEvent value) create,
  }) {
    return saveAddress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BeneficiaryRegistrationSaveAddressEvent value)?
        saveAddress,
    TResult? Function(BeneficiaryRegistrationSaveHouseholdConsentEvent value)?
        saveHouseholdConsent,
    TResult? Function(BeneficiaryRegistrationSaveHouseholdDetailsEvent value)?
        saveHouseholdDetails,
    TResult? Function(BeneficiaryRegistrationSaveIndividualDetailsEvent value)?
        saveIndividualDetails,
    TResult? Function(BeneficiaryRegistrationAddMemberEvent value)? addMember,
    TResult? Function(BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)?
        updateHouseholdDetails,
    TResult? Function(
            BeneficiaryRegistrationUpdateIndividualDetailsEvent value)?
        updateIndividualDetails,
    TResult? Function(BeneficiaryRegistrationCreateEvent value)? create,
  }) {
    return saveAddress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeneficiaryRegistrationSaveAddressEvent value)?
        saveAddress,
    TResult Function(BeneficiaryRegistrationSaveHouseholdConsentEvent value)?
        saveHouseholdConsent,
    TResult Function(BeneficiaryRegistrationSaveHouseholdDetailsEvent value)?
        saveHouseholdDetails,
    TResult Function(BeneficiaryRegistrationSaveIndividualDetailsEvent value)?
        saveIndividualDetails,
    TResult Function(BeneficiaryRegistrationAddMemberEvent value)? addMember,
    TResult Function(BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)?
        updateHouseholdDetails,
    TResult Function(BeneficiaryRegistrationUpdateIndividualDetailsEvent value)?
        updateIndividualDetails,
    TResult Function(BeneficiaryRegistrationCreateEvent value)? create,
    required TResult orElse(),
  }) {
    if (saveAddress != null) {
      return saveAddress(this);
    }
    return orElse();
  }
}

abstract class BeneficiaryRegistrationSaveAddressEvent
    implements BeneficiaryRegistrationEvent {
  const factory BeneficiaryRegistrationSaveAddressEvent(
      final AddressModel model) = _$BeneficiaryRegistrationSaveAddressEventImpl;

  AddressModel get model;
  @JsonKey(ignore: true)
  _$$BeneficiaryRegistrationSaveAddressEventImplCopyWith<
          _$BeneficiaryRegistrationSaveAddressEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BeneficiaryRegistrationSaveHouseholdConsentEventImplCopyWith<
    $Res> {
  factory _$$BeneficiaryRegistrationSaveHouseholdConsentEventImplCopyWith(
          _$BeneficiaryRegistrationSaveHouseholdConsentEventImpl value,
          $Res Function(_$BeneficiaryRegistrationSaveHouseholdConsentEventImpl)
              then) =
      __$$BeneficiaryRegistrationSaveHouseholdConsentEventImplCopyWithImpl<
          $Res>;
  @useResult
  $Res call({HouseholdModel household, bool isConsent});
}

/// @nodoc
class __$$BeneficiaryRegistrationSaveHouseholdConsentEventImplCopyWithImpl<$Res>
    extends _$BeneficiaryRegistrationEventCopyWithImpl<$Res,
        _$BeneficiaryRegistrationSaveHouseholdConsentEventImpl>
    implements
        _$$BeneficiaryRegistrationSaveHouseholdConsentEventImplCopyWith<$Res> {
  __$$BeneficiaryRegistrationSaveHouseholdConsentEventImplCopyWithImpl(
      _$BeneficiaryRegistrationSaveHouseholdConsentEventImpl _value,
      $Res Function(_$BeneficiaryRegistrationSaveHouseholdConsentEventImpl)
          _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? household = null,
    Object? isConsent = null,
  }) {
    return _then(_$BeneficiaryRegistrationSaveHouseholdConsentEventImpl(
      household: null == household
          ? _value.household
          : household // ignore: cast_nullable_to_non_nullable
              as HouseholdModel,
      isConsent: null == isConsent
          ? _value.isConsent
          : isConsent // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BeneficiaryRegistrationSaveHouseholdConsentEventImpl
    implements BeneficiaryRegistrationSaveHouseholdConsentEvent {
  const _$BeneficiaryRegistrationSaveHouseholdConsentEventImpl(
      {required this.household, required this.isConsent});

  @override
  final HouseholdModel household;
  @override
  final bool isConsent;

  @override
  String toString() {
    return 'BeneficiaryRegistrationEvent.saveHouseholdConsent(household: $household, isConsent: $isConsent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BeneficiaryRegistrationSaveHouseholdConsentEventImpl &&
            (identical(other.household, household) ||
                other.household == household) &&
            (identical(other.isConsent, isConsent) ||
                other.isConsent == isConsent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, household, isConsent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BeneficiaryRegistrationSaveHouseholdConsentEventImplCopyWith<
          _$BeneficiaryRegistrationSaveHouseholdConsentEventImpl>
      get copyWith =>
          __$$BeneficiaryRegistrationSaveHouseholdConsentEventImplCopyWithImpl<
                  _$BeneficiaryRegistrationSaveHouseholdConsentEventImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AddressModel model) saveAddress,
    required TResult Function(HouseholdModel household, bool isConsent)
        saveHouseholdConsent,
    required TResult Function(
            HouseholdModel household, DateTime registrationDate)
        saveHouseholdDetails,
    required TResult Function(IndividualModel model, bool isHeadOfHousehold)
        saveIndividualDetails,
    required TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)
        addMember,
    required TResult Function(
            HouseholdModel household, AddressModel? addressModel)
        updateHouseholdDetails,
    required TResult Function(IndividualModel model, AddressModel addressModel)
        updateIndividualDetails,
    required TResult Function(
            String userUuid, String projectId, BoundaryModel boundary)
        create,
  }) {
    return saveHouseholdConsent(household, isConsent);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AddressModel model)? saveAddress,
    TResult? Function(HouseholdModel household, bool isConsent)?
        saveHouseholdConsent,
    TResult? Function(HouseholdModel household, DateTime registrationDate)?
        saveHouseholdDetails,
    TResult? Function(IndividualModel model, bool isHeadOfHousehold)?
        saveIndividualDetails,
    TResult? Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)?
        addMember,
    TResult? Function(HouseholdModel household, AddressModel? addressModel)?
        updateHouseholdDetails,
    TResult? Function(IndividualModel model, AddressModel addressModel)?
        updateIndividualDetails,
    TResult? Function(
            String userUuid, String projectId, BoundaryModel boundary)?
        create,
  }) {
    return saveHouseholdConsent?.call(household, isConsent);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AddressModel model)? saveAddress,
    TResult Function(HouseholdModel household, bool isConsent)?
        saveHouseholdConsent,
    TResult Function(HouseholdModel household, DateTime registrationDate)?
        saveHouseholdDetails,
    TResult Function(IndividualModel model, bool isHeadOfHousehold)?
        saveIndividualDetails,
    TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)?
        addMember,
    TResult Function(HouseholdModel household, AddressModel? addressModel)?
        updateHouseholdDetails,
    TResult Function(IndividualModel model, AddressModel addressModel)?
        updateIndividualDetails,
    TResult Function(String userUuid, String projectId, BoundaryModel boundary)?
        create,
    required TResult orElse(),
  }) {
    if (saveHouseholdConsent != null) {
      return saveHouseholdConsent(household, isConsent);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeneficiaryRegistrationSaveAddressEvent value)
        saveAddress,
    required TResult Function(
            BeneficiaryRegistrationSaveHouseholdConsentEvent value)
        saveHouseholdConsent,
    required TResult Function(
            BeneficiaryRegistrationSaveHouseholdDetailsEvent value)
        saveHouseholdDetails,
    required TResult Function(
            BeneficiaryRegistrationSaveIndividualDetailsEvent value)
        saveIndividualDetails,
    required TResult Function(BeneficiaryRegistrationAddMemberEvent value)
        addMember,
    required TResult Function(
            BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)
        updateHouseholdDetails,
    required TResult Function(
            BeneficiaryRegistrationUpdateIndividualDetailsEvent value)
        updateIndividualDetails,
    required TResult Function(BeneficiaryRegistrationCreateEvent value) create,
  }) {
    return saveHouseholdConsent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BeneficiaryRegistrationSaveAddressEvent value)?
        saveAddress,
    TResult? Function(BeneficiaryRegistrationSaveHouseholdConsentEvent value)?
        saveHouseholdConsent,
    TResult? Function(BeneficiaryRegistrationSaveHouseholdDetailsEvent value)?
        saveHouseholdDetails,
    TResult? Function(BeneficiaryRegistrationSaveIndividualDetailsEvent value)?
        saveIndividualDetails,
    TResult? Function(BeneficiaryRegistrationAddMemberEvent value)? addMember,
    TResult? Function(BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)?
        updateHouseholdDetails,
    TResult? Function(
            BeneficiaryRegistrationUpdateIndividualDetailsEvent value)?
        updateIndividualDetails,
    TResult? Function(BeneficiaryRegistrationCreateEvent value)? create,
  }) {
    return saveHouseholdConsent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeneficiaryRegistrationSaveAddressEvent value)?
        saveAddress,
    TResult Function(BeneficiaryRegistrationSaveHouseholdConsentEvent value)?
        saveHouseholdConsent,
    TResult Function(BeneficiaryRegistrationSaveHouseholdDetailsEvent value)?
        saveHouseholdDetails,
    TResult Function(BeneficiaryRegistrationSaveIndividualDetailsEvent value)?
        saveIndividualDetails,
    TResult Function(BeneficiaryRegistrationAddMemberEvent value)? addMember,
    TResult Function(BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)?
        updateHouseholdDetails,
    TResult Function(BeneficiaryRegistrationUpdateIndividualDetailsEvent value)?
        updateIndividualDetails,
    TResult Function(BeneficiaryRegistrationCreateEvent value)? create,
    required TResult orElse(),
  }) {
    if (saveHouseholdConsent != null) {
      return saveHouseholdConsent(this);
    }
    return orElse();
  }
}

abstract class BeneficiaryRegistrationSaveHouseholdConsentEvent
    implements BeneficiaryRegistrationEvent {
  const factory BeneficiaryRegistrationSaveHouseholdConsentEvent(
          {required final HouseholdModel household,
          required final bool isConsent}) =
      _$BeneficiaryRegistrationSaveHouseholdConsentEventImpl;

  HouseholdModel get household;
  bool get isConsent;
  @JsonKey(ignore: true)
  _$$BeneficiaryRegistrationSaveHouseholdConsentEventImplCopyWith<
          _$BeneficiaryRegistrationSaveHouseholdConsentEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BeneficiaryRegistrationSaveHouseholdDetailsEventImplCopyWith<
    $Res> {
  factory _$$BeneficiaryRegistrationSaveHouseholdDetailsEventImplCopyWith(
          _$BeneficiaryRegistrationSaveHouseholdDetailsEventImpl value,
          $Res Function(_$BeneficiaryRegistrationSaveHouseholdDetailsEventImpl)
              then) =
      __$$BeneficiaryRegistrationSaveHouseholdDetailsEventImplCopyWithImpl<
          $Res>;
  @useResult
  $Res call({HouseholdModel household, DateTime registrationDate});
}

/// @nodoc
class __$$BeneficiaryRegistrationSaveHouseholdDetailsEventImplCopyWithImpl<$Res>
    extends _$BeneficiaryRegistrationEventCopyWithImpl<$Res,
        _$BeneficiaryRegistrationSaveHouseholdDetailsEventImpl>
    implements
        _$$BeneficiaryRegistrationSaveHouseholdDetailsEventImplCopyWith<$Res> {
  __$$BeneficiaryRegistrationSaveHouseholdDetailsEventImplCopyWithImpl(
      _$BeneficiaryRegistrationSaveHouseholdDetailsEventImpl _value,
      $Res Function(_$BeneficiaryRegistrationSaveHouseholdDetailsEventImpl)
          _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? household = null,
    Object? registrationDate = null,
  }) {
    return _then(_$BeneficiaryRegistrationSaveHouseholdDetailsEventImpl(
      household: null == household
          ? _value.household
          : household // ignore: cast_nullable_to_non_nullable
              as HouseholdModel,
      registrationDate: null == registrationDate
          ? _value.registrationDate
          : registrationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$BeneficiaryRegistrationSaveHouseholdDetailsEventImpl
    implements BeneficiaryRegistrationSaveHouseholdDetailsEvent {
  const _$BeneficiaryRegistrationSaveHouseholdDetailsEventImpl(
      {required this.household, required this.registrationDate});

  @override
  final HouseholdModel household;
  @override
  final DateTime registrationDate;

  @override
  String toString() {
    return 'BeneficiaryRegistrationEvent.saveHouseholdDetails(household: $household, registrationDate: $registrationDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BeneficiaryRegistrationSaveHouseholdDetailsEventImpl &&
            (identical(other.household, household) ||
                other.household == household) &&
            (identical(other.registrationDate, registrationDate) ||
                other.registrationDate == registrationDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, household, registrationDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BeneficiaryRegistrationSaveHouseholdDetailsEventImplCopyWith<
          _$BeneficiaryRegistrationSaveHouseholdDetailsEventImpl>
      get copyWith =>
          __$$BeneficiaryRegistrationSaveHouseholdDetailsEventImplCopyWithImpl<
                  _$BeneficiaryRegistrationSaveHouseholdDetailsEventImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AddressModel model) saveAddress,
    required TResult Function(HouseholdModel household, bool isConsent)
        saveHouseholdConsent,
    required TResult Function(
            HouseholdModel household, DateTime registrationDate)
        saveHouseholdDetails,
    required TResult Function(IndividualModel model, bool isHeadOfHousehold)
        saveIndividualDetails,
    required TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)
        addMember,
    required TResult Function(
            HouseholdModel household, AddressModel? addressModel)
        updateHouseholdDetails,
    required TResult Function(IndividualModel model, AddressModel addressModel)
        updateIndividualDetails,
    required TResult Function(
            String userUuid, String projectId, BoundaryModel boundary)
        create,
  }) {
    return saveHouseholdDetails(household, registrationDate);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AddressModel model)? saveAddress,
    TResult? Function(HouseholdModel household, bool isConsent)?
        saveHouseholdConsent,
    TResult? Function(HouseholdModel household, DateTime registrationDate)?
        saveHouseholdDetails,
    TResult? Function(IndividualModel model, bool isHeadOfHousehold)?
        saveIndividualDetails,
    TResult? Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)?
        addMember,
    TResult? Function(HouseholdModel household, AddressModel? addressModel)?
        updateHouseholdDetails,
    TResult? Function(IndividualModel model, AddressModel addressModel)?
        updateIndividualDetails,
    TResult? Function(
            String userUuid, String projectId, BoundaryModel boundary)?
        create,
  }) {
    return saveHouseholdDetails?.call(household, registrationDate);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AddressModel model)? saveAddress,
    TResult Function(HouseholdModel household, bool isConsent)?
        saveHouseholdConsent,
    TResult Function(HouseholdModel household, DateTime registrationDate)?
        saveHouseholdDetails,
    TResult Function(IndividualModel model, bool isHeadOfHousehold)?
        saveIndividualDetails,
    TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)?
        addMember,
    TResult Function(HouseholdModel household, AddressModel? addressModel)?
        updateHouseholdDetails,
    TResult Function(IndividualModel model, AddressModel addressModel)?
        updateIndividualDetails,
    TResult Function(String userUuid, String projectId, BoundaryModel boundary)?
        create,
    required TResult orElse(),
  }) {
    if (saveHouseholdDetails != null) {
      return saveHouseholdDetails(household, registrationDate);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeneficiaryRegistrationSaveAddressEvent value)
        saveAddress,
    required TResult Function(
            BeneficiaryRegistrationSaveHouseholdConsentEvent value)
        saveHouseholdConsent,
    required TResult Function(
            BeneficiaryRegistrationSaveHouseholdDetailsEvent value)
        saveHouseholdDetails,
    required TResult Function(
            BeneficiaryRegistrationSaveIndividualDetailsEvent value)
        saveIndividualDetails,
    required TResult Function(BeneficiaryRegistrationAddMemberEvent value)
        addMember,
    required TResult Function(
            BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)
        updateHouseholdDetails,
    required TResult Function(
            BeneficiaryRegistrationUpdateIndividualDetailsEvent value)
        updateIndividualDetails,
    required TResult Function(BeneficiaryRegistrationCreateEvent value) create,
  }) {
    return saveHouseholdDetails(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BeneficiaryRegistrationSaveAddressEvent value)?
        saveAddress,
    TResult? Function(BeneficiaryRegistrationSaveHouseholdConsentEvent value)?
        saveHouseholdConsent,
    TResult? Function(BeneficiaryRegistrationSaveHouseholdDetailsEvent value)?
        saveHouseholdDetails,
    TResult? Function(BeneficiaryRegistrationSaveIndividualDetailsEvent value)?
        saveIndividualDetails,
    TResult? Function(BeneficiaryRegistrationAddMemberEvent value)? addMember,
    TResult? Function(BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)?
        updateHouseholdDetails,
    TResult? Function(
            BeneficiaryRegistrationUpdateIndividualDetailsEvent value)?
        updateIndividualDetails,
    TResult? Function(BeneficiaryRegistrationCreateEvent value)? create,
  }) {
    return saveHouseholdDetails?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeneficiaryRegistrationSaveAddressEvent value)?
        saveAddress,
    TResult Function(BeneficiaryRegistrationSaveHouseholdConsentEvent value)?
        saveHouseholdConsent,
    TResult Function(BeneficiaryRegistrationSaveHouseholdDetailsEvent value)?
        saveHouseholdDetails,
    TResult Function(BeneficiaryRegistrationSaveIndividualDetailsEvent value)?
        saveIndividualDetails,
    TResult Function(BeneficiaryRegistrationAddMemberEvent value)? addMember,
    TResult Function(BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)?
        updateHouseholdDetails,
    TResult Function(BeneficiaryRegistrationUpdateIndividualDetailsEvent value)?
        updateIndividualDetails,
    TResult Function(BeneficiaryRegistrationCreateEvent value)? create,
    required TResult orElse(),
  }) {
    if (saveHouseholdDetails != null) {
      return saveHouseholdDetails(this);
    }
    return orElse();
  }
}

abstract class BeneficiaryRegistrationSaveHouseholdDetailsEvent
    implements BeneficiaryRegistrationEvent {
  const factory BeneficiaryRegistrationSaveHouseholdDetailsEvent(
          {required final HouseholdModel household,
          required final DateTime registrationDate}) =
      _$BeneficiaryRegistrationSaveHouseholdDetailsEventImpl;

  HouseholdModel get household;
  DateTime get registrationDate;
  @JsonKey(ignore: true)
  _$$BeneficiaryRegistrationSaveHouseholdDetailsEventImplCopyWith<
          _$BeneficiaryRegistrationSaveHouseholdDetailsEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BeneficiaryRegistrationSaveIndividualDetailsEventImplCopyWith<
    $Res> {
  factory _$$BeneficiaryRegistrationSaveIndividualDetailsEventImplCopyWith(
          _$BeneficiaryRegistrationSaveIndividualDetailsEventImpl value,
          $Res Function(_$BeneficiaryRegistrationSaveIndividualDetailsEventImpl)
              then) =
      __$$BeneficiaryRegistrationSaveIndividualDetailsEventImplCopyWithImpl<
          $Res>;
  @useResult
  $Res call({IndividualModel model, bool isHeadOfHousehold});
}

/// @nodoc
class __$$BeneficiaryRegistrationSaveIndividualDetailsEventImplCopyWithImpl<
        $Res>
    extends _$BeneficiaryRegistrationEventCopyWithImpl<$Res,
        _$BeneficiaryRegistrationSaveIndividualDetailsEventImpl>
    implements
        _$$BeneficiaryRegistrationSaveIndividualDetailsEventImplCopyWith<$Res> {
  __$$BeneficiaryRegistrationSaveIndividualDetailsEventImplCopyWithImpl(
      _$BeneficiaryRegistrationSaveIndividualDetailsEventImpl _value,
      $Res Function(_$BeneficiaryRegistrationSaveIndividualDetailsEventImpl)
          _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? model = null,
    Object? isHeadOfHousehold = null,
  }) {
    return _then(_$BeneficiaryRegistrationSaveIndividualDetailsEventImpl(
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as IndividualModel,
      isHeadOfHousehold: null == isHeadOfHousehold
          ? _value.isHeadOfHousehold
          : isHeadOfHousehold // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BeneficiaryRegistrationSaveIndividualDetailsEventImpl
    implements BeneficiaryRegistrationSaveIndividualDetailsEvent {
  const _$BeneficiaryRegistrationSaveIndividualDetailsEventImpl(
      {required this.model, this.isHeadOfHousehold = false});

  @override
  final IndividualModel model;
  @override
  @JsonKey()
  final bool isHeadOfHousehold;

  @override
  String toString() {
    return 'BeneficiaryRegistrationEvent.saveIndividualDetails(model: $model, isHeadOfHousehold: $isHeadOfHousehold)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BeneficiaryRegistrationSaveIndividualDetailsEventImpl &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.isHeadOfHousehold, isHeadOfHousehold) ||
                other.isHeadOfHousehold == isHeadOfHousehold));
  }

  @override
  int get hashCode => Object.hash(runtimeType, model, isHeadOfHousehold);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BeneficiaryRegistrationSaveIndividualDetailsEventImplCopyWith<
          _$BeneficiaryRegistrationSaveIndividualDetailsEventImpl>
      get copyWith =>
          __$$BeneficiaryRegistrationSaveIndividualDetailsEventImplCopyWithImpl<
                  _$BeneficiaryRegistrationSaveIndividualDetailsEventImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AddressModel model) saveAddress,
    required TResult Function(HouseholdModel household, bool isConsent)
        saveHouseholdConsent,
    required TResult Function(
            HouseholdModel household, DateTime registrationDate)
        saveHouseholdDetails,
    required TResult Function(IndividualModel model, bool isHeadOfHousehold)
        saveIndividualDetails,
    required TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)
        addMember,
    required TResult Function(
            HouseholdModel household, AddressModel? addressModel)
        updateHouseholdDetails,
    required TResult Function(IndividualModel model, AddressModel addressModel)
        updateIndividualDetails,
    required TResult Function(
            String userUuid, String projectId, BoundaryModel boundary)
        create,
  }) {
    return saveIndividualDetails(model, isHeadOfHousehold);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AddressModel model)? saveAddress,
    TResult? Function(HouseholdModel household, bool isConsent)?
        saveHouseholdConsent,
    TResult? Function(HouseholdModel household, DateTime registrationDate)?
        saveHouseholdDetails,
    TResult? Function(IndividualModel model, bool isHeadOfHousehold)?
        saveIndividualDetails,
    TResult? Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)?
        addMember,
    TResult? Function(HouseholdModel household, AddressModel? addressModel)?
        updateHouseholdDetails,
    TResult? Function(IndividualModel model, AddressModel addressModel)?
        updateIndividualDetails,
    TResult? Function(
            String userUuid, String projectId, BoundaryModel boundary)?
        create,
  }) {
    return saveIndividualDetails?.call(model, isHeadOfHousehold);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AddressModel model)? saveAddress,
    TResult Function(HouseholdModel household, bool isConsent)?
        saveHouseholdConsent,
    TResult Function(HouseholdModel household, DateTime registrationDate)?
        saveHouseholdDetails,
    TResult Function(IndividualModel model, bool isHeadOfHousehold)?
        saveIndividualDetails,
    TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)?
        addMember,
    TResult Function(HouseholdModel household, AddressModel? addressModel)?
        updateHouseholdDetails,
    TResult Function(IndividualModel model, AddressModel addressModel)?
        updateIndividualDetails,
    TResult Function(String userUuid, String projectId, BoundaryModel boundary)?
        create,
    required TResult orElse(),
  }) {
    if (saveIndividualDetails != null) {
      return saveIndividualDetails(model, isHeadOfHousehold);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeneficiaryRegistrationSaveAddressEvent value)
        saveAddress,
    required TResult Function(
            BeneficiaryRegistrationSaveHouseholdConsentEvent value)
        saveHouseholdConsent,
    required TResult Function(
            BeneficiaryRegistrationSaveHouseholdDetailsEvent value)
        saveHouseholdDetails,
    required TResult Function(
            BeneficiaryRegistrationSaveIndividualDetailsEvent value)
        saveIndividualDetails,
    required TResult Function(BeneficiaryRegistrationAddMemberEvent value)
        addMember,
    required TResult Function(
            BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)
        updateHouseholdDetails,
    required TResult Function(
            BeneficiaryRegistrationUpdateIndividualDetailsEvent value)
        updateIndividualDetails,
    required TResult Function(BeneficiaryRegistrationCreateEvent value) create,
  }) {
    return saveIndividualDetails(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BeneficiaryRegistrationSaveAddressEvent value)?
        saveAddress,
    TResult? Function(BeneficiaryRegistrationSaveHouseholdConsentEvent value)?
        saveHouseholdConsent,
    TResult? Function(BeneficiaryRegistrationSaveHouseholdDetailsEvent value)?
        saveHouseholdDetails,
    TResult? Function(BeneficiaryRegistrationSaveIndividualDetailsEvent value)?
        saveIndividualDetails,
    TResult? Function(BeneficiaryRegistrationAddMemberEvent value)? addMember,
    TResult? Function(BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)?
        updateHouseholdDetails,
    TResult? Function(
            BeneficiaryRegistrationUpdateIndividualDetailsEvent value)?
        updateIndividualDetails,
    TResult? Function(BeneficiaryRegistrationCreateEvent value)? create,
  }) {
    return saveIndividualDetails?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeneficiaryRegistrationSaveAddressEvent value)?
        saveAddress,
    TResult Function(BeneficiaryRegistrationSaveHouseholdConsentEvent value)?
        saveHouseholdConsent,
    TResult Function(BeneficiaryRegistrationSaveHouseholdDetailsEvent value)?
        saveHouseholdDetails,
    TResult Function(BeneficiaryRegistrationSaveIndividualDetailsEvent value)?
        saveIndividualDetails,
    TResult Function(BeneficiaryRegistrationAddMemberEvent value)? addMember,
    TResult Function(BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)?
        updateHouseholdDetails,
    TResult Function(BeneficiaryRegistrationUpdateIndividualDetailsEvent value)?
        updateIndividualDetails,
    TResult Function(BeneficiaryRegistrationCreateEvent value)? create,
    required TResult orElse(),
  }) {
    if (saveIndividualDetails != null) {
      return saveIndividualDetails(this);
    }
    return orElse();
  }
}

abstract class BeneficiaryRegistrationSaveIndividualDetailsEvent
    implements BeneficiaryRegistrationEvent {
  const factory BeneficiaryRegistrationSaveIndividualDetailsEvent(
          {required final IndividualModel model,
          final bool isHeadOfHousehold}) =
      _$BeneficiaryRegistrationSaveIndividualDetailsEventImpl;

  IndividualModel get model;
  bool get isHeadOfHousehold;
  @JsonKey(ignore: true)
  _$$BeneficiaryRegistrationSaveIndividualDetailsEventImplCopyWith<
          _$BeneficiaryRegistrationSaveIndividualDetailsEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BeneficiaryRegistrationAddMemberEventImplCopyWith<$Res> {
  factory _$$BeneficiaryRegistrationAddMemberEventImplCopyWith(
          _$BeneficiaryRegistrationAddMemberEventImpl value,
          $Res Function(_$BeneficiaryRegistrationAddMemberEventImpl) then) =
      __$$BeneficiaryRegistrationAddMemberEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {HouseholdModel householdModel,
      IndividualModel individualModel,
      AddressModel addressModel,
      String userUuid,
      String projectId,
      BeneficiaryType beneficiaryType});
}

/// @nodoc
class __$$BeneficiaryRegistrationAddMemberEventImplCopyWithImpl<$Res>
    extends _$BeneficiaryRegistrationEventCopyWithImpl<$Res,
        _$BeneficiaryRegistrationAddMemberEventImpl>
    implements _$$BeneficiaryRegistrationAddMemberEventImplCopyWith<$Res> {
  __$$BeneficiaryRegistrationAddMemberEventImplCopyWithImpl(
      _$BeneficiaryRegistrationAddMemberEventImpl _value,
      $Res Function(_$BeneficiaryRegistrationAddMemberEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? householdModel = null,
    Object? individualModel = null,
    Object? addressModel = null,
    Object? userUuid = null,
    Object? projectId = null,
    Object? beneficiaryType = null,
  }) {
    return _then(_$BeneficiaryRegistrationAddMemberEventImpl(
      householdModel: null == householdModel
          ? _value.householdModel
          : householdModel // ignore: cast_nullable_to_non_nullable
              as HouseholdModel,
      individualModel: null == individualModel
          ? _value.individualModel
          : individualModel // ignore: cast_nullable_to_non_nullable
              as IndividualModel,
      addressModel: null == addressModel
          ? _value.addressModel
          : addressModel // ignore: cast_nullable_to_non_nullable
              as AddressModel,
      userUuid: null == userUuid
          ? _value.userUuid
          : userUuid // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      beneficiaryType: null == beneficiaryType
          ? _value.beneficiaryType
          : beneficiaryType // ignore: cast_nullable_to_non_nullable
              as BeneficiaryType,
    ));
  }
}

/// @nodoc

class _$BeneficiaryRegistrationAddMemberEventImpl
    implements BeneficiaryRegistrationAddMemberEvent {
  const _$BeneficiaryRegistrationAddMemberEventImpl(
      {required this.householdModel,
      required this.individualModel,
      required this.addressModel,
      required this.userUuid,
      required this.projectId,
      required this.beneficiaryType});

  @override
  final HouseholdModel householdModel;
  @override
  final IndividualModel individualModel;
  @override
  final AddressModel addressModel;
  @override
  final String userUuid;
  @override
  final String projectId;
  @override
  final BeneficiaryType beneficiaryType;

  @override
  String toString() {
    return 'BeneficiaryRegistrationEvent.addMember(householdModel: $householdModel, individualModel: $individualModel, addressModel: $addressModel, userUuid: $userUuid, projectId: $projectId, beneficiaryType: $beneficiaryType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BeneficiaryRegistrationAddMemberEventImpl &&
            (identical(other.householdModel, householdModel) ||
                other.householdModel == householdModel) &&
            (identical(other.individualModel, individualModel) ||
                other.individualModel == individualModel) &&
            (identical(other.addressModel, addressModel) ||
                other.addressModel == addressModel) &&
            (identical(other.userUuid, userUuid) ||
                other.userUuid == userUuid) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.beneficiaryType, beneficiaryType) ||
                other.beneficiaryType == beneficiaryType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, householdModel, individualModel,
      addressModel, userUuid, projectId, beneficiaryType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BeneficiaryRegistrationAddMemberEventImplCopyWith<
          _$BeneficiaryRegistrationAddMemberEventImpl>
      get copyWith => __$$BeneficiaryRegistrationAddMemberEventImplCopyWithImpl<
          _$BeneficiaryRegistrationAddMemberEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AddressModel model) saveAddress,
    required TResult Function(HouseholdModel household, bool isConsent)
        saveHouseholdConsent,
    required TResult Function(
            HouseholdModel household, DateTime registrationDate)
        saveHouseholdDetails,
    required TResult Function(IndividualModel model, bool isHeadOfHousehold)
        saveIndividualDetails,
    required TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)
        addMember,
    required TResult Function(
            HouseholdModel household, AddressModel? addressModel)
        updateHouseholdDetails,
    required TResult Function(IndividualModel model, AddressModel addressModel)
        updateIndividualDetails,
    required TResult Function(
            String userUuid, String projectId, BoundaryModel boundary)
        create,
  }) {
    return addMember(householdModel, individualModel, addressModel, userUuid,
        projectId, beneficiaryType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AddressModel model)? saveAddress,
    TResult? Function(HouseholdModel household, bool isConsent)?
        saveHouseholdConsent,
    TResult? Function(HouseholdModel household, DateTime registrationDate)?
        saveHouseholdDetails,
    TResult? Function(IndividualModel model, bool isHeadOfHousehold)?
        saveIndividualDetails,
    TResult? Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)?
        addMember,
    TResult? Function(HouseholdModel household, AddressModel? addressModel)?
        updateHouseholdDetails,
    TResult? Function(IndividualModel model, AddressModel addressModel)?
        updateIndividualDetails,
    TResult? Function(
            String userUuid, String projectId, BoundaryModel boundary)?
        create,
  }) {
    return addMember?.call(householdModel, individualModel, addressModel,
        userUuid, projectId, beneficiaryType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AddressModel model)? saveAddress,
    TResult Function(HouseholdModel household, bool isConsent)?
        saveHouseholdConsent,
    TResult Function(HouseholdModel household, DateTime registrationDate)?
        saveHouseholdDetails,
    TResult Function(IndividualModel model, bool isHeadOfHousehold)?
        saveIndividualDetails,
    TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)?
        addMember,
    TResult Function(HouseholdModel household, AddressModel? addressModel)?
        updateHouseholdDetails,
    TResult Function(IndividualModel model, AddressModel addressModel)?
        updateIndividualDetails,
    TResult Function(String userUuid, String projectId, BoundaryModel boundary)?
        create,
    required TResult orElse(),
  }) {
    if (addMember != null) {
      return addMember(householdModel, individualModel, addressModel, userUuid,
          projectId, beneficiaryType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeneficiaryRegistrationSaveAddressEvent value)
        saveAddress,
    required TResult Function(
            BeneficiaryRegistrationSaveHouseholdConsentEvent value)
        saveHouseholdConsent,
    required TResult Function(
            BeneficiaryRegistrationSaveHouseholdDetailsEvent value)
        saveHouseholdDetails,
    required TResult Function(
            BeneficiaryRegistrationSaveIndividualDetailsEvent value)
        saveIndividualDetails,
    required TResult Function(BeneficiaryRegistrationAddMemberEvent value)
        addMember,
    required TResult Function(
            BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)
        updateHouseholdDetails,
    required TResult Function(
            BeneficiaryRegistrationUpdateIndividualDetailsEvent value)
        updateIndividualDetails,
    required TResult Function(BeneficiaryRegistrationCreateEvent value) create,
  }) {
    return addMember(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BeneficiaryRegistrationSaveAddressEvent value)?
        saveAddress,
    TResult? Function(BeneficiaryRegistrationSaveHouseholdConsentEvent value)?
        saveHouseholdConsent,
    TResult? Function(BeneficiaryRegistrationSaveHouseholdDetailsEvent value)?
        saveHouseholdDetails,
    TResult? Function(BeneficiaryRegistrationSaveIndividualDetailsEvent value)?
        saveIndividualDetails,
    TResult? Function(BeneficiaryRegistrationAddMemberEvent value)? addMember,
    TResult? Function(BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)?
        updateHouseholdDetails,
    TResult? Function(
            BeneficiaryRegistrationUpdateIndividualDetailsEvent value)?
        updateIndividualDetails,
    TResult? Function(BeneficiaryRegistrationCreateEvent value)? create,
  }) {
    return addMember?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeneficiaryRegistrationSaveAddressEvent value)?
        saveAddress,
    TResult Function(BeneficiaryRegistrationSaveHouseholdConsentEvent value)?
        saveHouseholdConsent,
    TResult Function(BeneficiaryRegistrationSaveHouseholdDetailsEvent value)?
        saveHouseholdDetails,
    TResult Function(BeneficiaryRegistrationSaveIndividualDetailsEvent value)?
        saveIndividualDetails,
    TResult Function(BeneficiaryRegistrationAddMemberEvent value)? addMember,
    TResult Function(BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)?
        updateHouseholdDetails,
    TResult Function(BeneficiaryRegistrationUpdateIndividualDetailsEvent value)?
        updateIndividualDetails,
    TResult Function(BeneficiaryRegistrationCreateEvent value)? create,
    required TResult orElse(),
  }) {
    if (addMember != null) {
      return addMember(this);
    }
    return orElse();
  }
}

abstract class BeneficiaryRegistrationAddMemberEvent
    implements BeneficiaryRegistrationEvent {
  const factory BeneficiaryRegistrationAddMemberEvent(
          {required final HouseholdModel householdModel,
          required final IndividualModel individualModel,
          required final AddressModel addressModel,
          required final String userUuid,
          required final String projectId,
          required final BeneficiaryType beneficiaryType}) =
      _$BeneficiaryRegistrationAddMemberEventImpl;

  HouseholdModel get householdModel;
  IndividualModel get individualModel;
  AddressModel get addressModel;
  String get userUuid;
  String get projectId;
  BeneficiaryType get beneficiaryType;
  @JsonKey(ignore: true)
  _$$BeneficiaryRegistrationAddMemberEventImplCopyWith<
          _$BeneficiaryRegistrationAddMemberEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BeneficiaryRegistrationUpdateHouseholdDetailsEventImplCopyWith<
    $Res> {
  factory _$$BeneficiaryRegistrationUpdateHouseholdDetailsEventImplCopyWith(
          _$BeneficiaryRegistrationUpdateHouseholdDetailsEventImpl value,
          $Res Function(
                  _$BeneficiaryRegistrationUpdateHouseholdDetailsEventImpl)
              then) =
      __$$BeneficiaryRegistrationUpdateHouseholdDetailsEventImplCopyWithImpl<
          $Res>;
  @useResult
  $Res call({HouseholdModel household, AddressModel? addressModel});
}

/// @nodoc
class __$$BeneficiaryRegistrationUpdateHouseholdDetailsEventImplCopyWithImpl<
        $Res>
    extends _$BeneficiaryRegistrationEventCopyWithImpl<$Res,
        _$BeneficiaryRegistrationUpdateHouseholdDetailsEventImpl>
    implements
        _$$BeneficiaryRegistrationUpdateHouseholdDetailsEventImplCopyWith<
            $Res> {
  __$$BeneficiaryRegistrationUpdateHouseholdDetailsEventImplCopyWithImpl(
      _$BeneficiaryRegistrationUpdateHouseholdDetailsEventImpl _value,
      $Res Function(_$BeneficiaryRegistrationUpdateHouseholdDetailsEventImpl)
          _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? household = null,
    Object? addressModel = freezed,
  }) {
    return _then(_$BeneficiaryRegistrationUpdateHouseholdDetailsEventImpl(
      household: null == household
          ? _value.household
          : household // ignore: cast_nullable_to_non_nullable
              as HouseholdModel,
      addressModel: freezed == addressModel
          ? _value.addressModel
          : addressModel // ignore: cast_nullable_to_non_nullable
              as AddressModel?,
    ));
  }
}

/// @nodoc

class _$BeneficiaryRegistrationUpdateHouseholdDetailsEventImpl
    implements BeneficiaryRegistrationUpdateHouseholdDetailsEvent {
  const _$BeneficiaryRegistrationUpdateHouseholdDetailsEventImpl(
      {required this.household, this.addressModel});

  @override
  final HouseholdModel household;
  @override
  final AddressModel? addressModel;

  @override
  String toString() {
    return 'BeneficiaryRegistrationEvent.updateHouseholdDetails(household: $household, addressModel: $addressModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BeneficiaryRegistrationUpdateHouseholdDetailsEventImpl &&
            (identical(other.household, household) ||
                other.household == household) &&
            (identical(other.addressModel, addressModel) ||
                other.addressModel == addressModel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, household, addressModel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BeneficiaryRegistrationUpdateHouseholdDetailsEventImplCopyWith<
          _$BeneficiaryRegistrationUpdateHouseholdDetailsEventImpl>
      get copyWith =>
          __$$BeneficiaryRegistrationUpdateHouseholdDetailsEventImplCopyWithImpl<
                  _$BeneficiaryRegistrationUpdateHouseholdDetailsEventImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AddressModel model) saveAddress,
    required TResult Function(HouseholdModel household, bool isConsent)
        saveHouseholdConsent,
    required TResult Function(
            HouseholdModel household, DateTime registrationDate)
        saveHouseholdDetails,
    required TResult Function(IndividualModel model, bool isHeadOfHousehold)
        saveIndividualDetails,
    required TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)
        addMember,
    required TResult Function(
            HouseholdModel household, AddressModel? addressModel)
        updateHouseholdDetails,
    required TResult Function(IndividualModel model, AddressModel addressModel)
        updateIndividualDetails,
    required TResult Function(
            String userUuid, String projectId, BoundaryModel boundary)
        create,
  }) {
    return updateHouseholdDetails(household, addressModel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AddressModel model)? saveAddress,
    TResult? Function(HouseholdModel household, bool isConsent)?
        saveHouseholdConsent,
    TResult? Function(HouseholdModel household, DateTime registrationDate)?
        saveHouseholdDetails,
    TResult? Function(IndividualModel model, bool isHeadOfHousehold)?
        saveIndividualDetails,
    TResult? Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)?
        addMember,
    TResult? Function(HouseholdModel household, AddressModel? addressModel)?
        updateHouseholdDetails,
    TResult? Function(IndividualModel model, AddressModel addressModel)?
        updateIndividualDetails,
    TResult? Function(
            String userUuid, String projectId, BoundaryModel boundary)?
        create,
  }) {
    return updateHouseholdDetails?.call(household, addressModel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AddressModel model)? saveAddress,
    TResult Function(HouseholdModel household, bool isConsent)?
        saveHouseholdConsent,
    TResult Function(HouseholdModel household, DateTime registrationDate)?
        saveHouseholdDetails,
    TResult Function(IndividualModel model, bool isHeadOfHousehold)?
        saveIndividualDetails,
    TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)?
        addMember,
    TResult Function(HouseholdModel household, AddressModel? addressModel)?
        updateHouseholdDetails,
    TResult Function(IndividualModel model, AddressModel addressModel)?
        updateIndividualDetails,
    TResult Function(String userUuid, String projectId, BoundaryModel boundary)?
        create,
    required TResult orElse(),
  }) {
    if (updateHouseholdDetails != null) {
      return updateHouseholdDetails(household, addressModel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeneficiaryRegistrationSaveAddressEvent value)
        saveAddress,
    required TResult Function(
            BeneficiaryRegistrationSaveHouseholdConsentEvent value)
        saveHouseholdConsent,
    required TResult Function(
            BeneficiaryRegistrationSaveHouseholdDetailsEvent value)
        saveHouseholdDetails,
    required TResult Function(
            BeneficiaryRegistrationSaveIndividualDetailsEvent value)
        saveIndividualDetails,
    required TResult Function(BeneficiaryRegistrationAddMemberEvent value)
        addMember,
    required TResult Function(
            BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)
        updateHouseholdDetails,
    required TResult Function(
            BeneficiaryRegistrationUpdateIndividualDetailsEvent value)
        updateIndividualDetails,
    required TResult Function(BeneficiaryRegistrationCreateEvent value) create,
  }) {
    return updateHouseholdDetails(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BeneficiaryRegistrationSaveAddressEvent value)?
        saveAddress,
    TResult? Function(BeneficiaryRegistrationSaveHouseholdConsentEvent value)?
        saveHouseholdConsent,
    TResult? Function(BeneficiaryRegistrationSaveHouseholdDetailsEvent value)?
        saveHouseholdDetails,
    TResult? Function(BeneficiaryRegistrationSaveIndividualDetailsEvent value)?
        saveIndividualDetails,
    TResult? Function(BeneficiaryRegistrationAddMemberEvent value)? addMember,
    TResult? Function(BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)?
        updateHouseholdDetails,
    TResult? Function(
            BeneficiaryRegistrationUpdateIndividualDetailsEvent value)?
        updateIndividualDetails,
    TResult? Function(BeneficiaryRegistrationCreateEvent value)? create,
  }) {
    return updateHouseholdDetails?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeneficiaryRegistrationSaveAddressEvent value)?
        saveAddress,
    TResult Function(BeneficiaryRegistrationSaveHouseholdConsentEvent value)?
        saveHouseholdConsent,
    TResult Function(BeneficiaryRegistrationSaveHouseholdDetailsEvent value)?
        saveHouseholdDetails,
    TResult Function(BeneficiaryRegistrationSaveIndividualDetailsEvent value)?
        saveIndividualDetails,
    TResult Function(BeneficiaryRegistrationAddMemberEvent value)? addMember,
    TResult Function(BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)?
        updateHouseholdDetails,
    TResult Function(BeneficiaryRegistrationUpdateIndividualDetailsEvent value)?
        updateIndividualDetails,
    TResult Function(BeneficiaryRegistrationCreateEvent value)? create,
    required TResult orElse(),
  }) {
    if (updateHouseholdDetails != null) {
      return updateHouseholdDetails(this);
    }
    return orElse();
  }
}

abstract class BeneficiaryRegistrationUpdateHouseholdDetailsEvent
    implements BeneficiaryRegistrationEvent {
  const factory BeneficiaryRegistrationUpdateHouseholdDetailsEvent(
          {required final HouseholdModel household,
          final AddressModel? addressModel}) =
      _$BeneficiaryRegistrationUpdateHouseholdDetailsEventImpl;

  HouseholdModel get household;
  AddressModel? get addressModel;
  @JsonKey(ignore: true)
  _$$BeneficiaryRegistrationUpdateHouseholdDetailsEventImplCopyWith<
          _$BeneficiaryRegistrationUpdateHouseholdDetailsEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BeneficiaryRegistrationUpdateIndividualDetailsEventImplCopyWith<
    $Res> {
  factory _$$BeneficiaryRegistrationUpdateIndividualDetailsEventImplCopyWith(
          _$BeneficiaryRegistrationUpdateIndividualDetailsEventImpl value,
          $Res Function(
                  _$BeneficiaryRegistrationUpdateIndividualDetailsEventImpl)
              then) =
      __$$BeneficiaryRegistrationUpdateIndividualDetailsEventImplCopyWithImpl<
          $Res>;
  @useResult
  $Res call({IndividualModel model, AddressModel addressModel});
}

/// @nodoc
class __$$BeneficiaryRegistrationUpdateIndividualDetailsEventImplCopyWithImpl<
        $Res>
    extends _$BeneficiaryRegistrationEventCopyWithImpl<$Res,
        _$BeneficiaryRegistrationUpdateIndividualDetailsEventImpl>
    implements
        _$$BeneficiaryRegistrationUpdateIndividualDetailsEventImplCopyWith<
            $Res> {
  __$$BeneficiaryRegistrationUpdateIndividualDetailsEventImplCopyWithImpl(
      _$BeneficiaryRegistrationUpdateIndividualDetailsEventImpl _value,
      $Res Function(_$BeneficiaryRegistrationUpdateIndividualDetailsEventImpl)
          _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? model = null,
    Object? addressModel = null,
  }) {
    return _then(_$BeneficiaryRegistrationUpdateIndividualDetailsEventImpl(
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as IndividualModel,
      addressModel: null == addressModel
          ? _value.addressModel
          : addressModel // ignore: cast_nullable_to_non_nullable
              as AddressModel,
    ));
  }
}

/// @nodoc

class _$BeneficiaryRegistrationUpdateIndividualDetailsEventImpl
    implements BeneficiaryRegistrationUpdateIndividualDetailsEvent {
  const _$BeneficiaryRegistrationUpdateIndividualDetailsEventImpl(
      {required this.model, required this.addressModel});

  @override
  final IndividualModel model;
  @override
  final AddressModel addressModel;

  @override
  String toString() {
    return 'BeneficiaryRegistrationEvent.updateIndividualDetails(model: $model, addressModel: $addressModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other
                is _$BeneficiaryRegistrationUpdateIndividualDetailsEventImpl &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.addressModel, addressModel) ||
                other.addressModel == addressModel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, model, addressModel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BeneficiaryRegistrationUpdateIndividualDetailsEventImplCopyWith<
          _$BeneficiaryRegistrationUpdateIndividualDetailsEventImpl>
      get copyWith =>
          __$$BeneficiaryRegistrationUpdateIndividualDetailsEventImplCopyWithImpl<
                  _$BeneficiaryRegistrationUpdateIndividualDetailsEventImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AddressModel model) saveAddress,
    required TResult Function(HouseholdModel household, bool isConsent)
        saveHouseholdConsent,
    required TResult Function(
            HouseholdModel household, DateTime registrationDate)
        saveHouseholdDetails,
    required TResult Function(IndividualModel model, bool isHeadOfHousehold)
        saveIndividualDetails,
    required TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)
        addMember,
    required TResult Function(
            HouseholdModel household, AddressModel? addressModel)
        updateHouseholdDetails,
    required TResult Function(IndividualModel model, AddressModel addressModel)
        updateIndividualDetails,
    required TResult Function(
            String userUuid, String projectId, BoundaryModel boundary)
        create,
  }) {
    return updateIndividualDetails(model, addressModel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AddressModel model)? saveAddress,
    TResult? Function(HouseholdModel household, bool isConsent)?
        saveHouseholdConsent,
    TResult? Function(HouseholdModel household, DateTime registrationDate)?
        saveHouseholdDetails,
    TResult? Function(IndividualModel model, bool isHeadOfHousehold)?
        saveIndividualDetails,
    TResult? Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)?
        addMember,
    TResult? Function(HouseholdModel household, AddressModel? addressModel)?
        updateHouseholdDetails,
    TResult? Function(IndividualModel model, AddressModel addressModel)?
        updateIndividualDetails,
    TResult? Function(
            String userUuid, String projectId, BoundaryModel boundary)?
        create,
  }) {
    return updateIndividualDetails?.call(model, addressModel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AddressModel model)? saveAddress,
    TResult Function(HouseholdModel household, bool isConsent)?
        saveHouseholdConsent,
    TResult Function(HouseholdModel household, DateTime registrationDate)?
        saveHouseholdDetails,
    TResult Function(IndividualModel model, bool isHeadOfHousehold)?
        saveIndividualDetails,
    TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)?
        addMember,
    TResult Function(HouseholdModel household, AddressModel? addressModel)?
        updateHouseholdDetails,
    TResult Function(IndividualModel model, AddressModel addressModel)?
        updateIndividualDetails,
    TResult Function(String userUuid, String projectId, BoundaryModel boundary)?
        create,
    required TResult orElse(),
  }) {
    if (updateIndividualDetails != null) {
      return updateIndividualDetails(model, addressModel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeneficiaryRegistrationSaveAddressEvent value)
        saveAddress,
    required TResult Function(
            BeneficiaryRegistrationSaveHouseholdConsentEvent value)
        saveHouseholdConsent,
    required TResult Function(
            BeneficiaryRegistrationSaveHouseholdDetailsEvent value)
        saveHouseholdDetails,
    required TResult Function(
            BeneficiaryRegistrationSaveIndividualDetailsEvent value)
        saveIndividualDetails,
    required TResult Function(BeneficiaryRegistrationAddMemberEvent value)
        addMember,
    required TResult Function(
            BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)
        updateHouseholdDetails,
    required TResult Function(
            BeneficiaryRegistrationUpdateIndividualDetailsEvent value)
        updateIndividualDetails,
    required TResult Function(BeneficiaryRegistrationCreateEvent value) create,
  }) {
    return updateIndividualDetails(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BeneficiaryRegistrationSaveAddressEvent value)?
        saveAddress,
    TResult? Function(BeneficiaryRegistrationSaveHouseholdConsentEvent value)?
        saveHouseholdConsent,
    TResult? Function(BeneficiaryRegistrationSaveHouseholdDetailsEvent value)?
        saveHouseholdDetails,
    TResult? Function(BeneficiaryRegistrationSaveIndividualDetailsEvent value)?
        saveIndividualDetails,
    TResult? Function(BeneficiaryRegistrationAddMemberEvent value)? addMember,
    TResult? Function(BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)?
        updateHouseholdDetails,
    TResult? Function(
            BeneficiaryRegistrationUpdateIndividualDetailsEvent value)?
        updateIndividualDetails,
    TResult? Function(BeneficiaryRegistrationCreateEvent value)? create,
  }) {
    return updateIndividualDetails?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeneficiaryRegistrationSaveAddressEvent value)?
        saveAddress,
    TResult Function(BeneficiaryRegistrationSaveHouseholdConsentEvent value)?
        saveHouseholdConsent,
    TResult Function(BeneficiaryRegistrationSaveHouseholdDetailsEvent value)?
        saveHouseholdDetails,
    TResult Function(BeneficiaryRegistrationSaveIndividualDetailsEvent value)?
        saveIndividualDetails,
    TResult Function(BeneficiaryRegistrationAddMemberEvent value)? addMember,
    TResult Function(BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)?
        updateHouseholdDetails,
    TResult Function(BeneficiaryRegistrationUpdateIndividualDetailsEvent value)?
        updateIndividualDetails,
    TResult Function(BeneficiaryRegistrationCreateEvent value)? create,
    required TResult orElse(),
  }) {
    if (updateIndividualDetails != null) {
      return updateIndividualDetails(this);
    }
    return orElse();
  }
}

abstract class BeneficiaryRegistrationUpdateIndividualDetailsEvent
    implements BeneficiaryRegistrationEvent {
  const factory BeneficiaryRegistrationUpdateIndividualDetailsEvent(
          {required final IndividualModel model,
          required final AddressModel addressModel}) =
      _$BeneficiaryRegistrationUpdateIndividualDetailsEventImpl;

  IndividualModel get model;
  AddressModel get addressModel;
  @JsonKey(ignore: true)
  _$$BeneficiaryRegistrationUpdateIndividualDetailsEventImplCopyWith<
          _$BeneficiaryRegistrationUpdateIndividualDetailsEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BeneficiaryRegistrationCreateEventImplCopyWith<$Res> {
  factory _$$BeneficiaryRegistrationCreateEventImplCopyWith(
          _$BeneficiaryRegistrationCreateEventImpl value,
          $Res Function(_$BeneficiaryRegistrationCreateEventImpl) then) =
      __$$BeneficiaryRegistrationCreateEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userUuid, String projectId, BoundaryModel boundary});
}

/// @nodoc
class __$$BeneficiaryRegistrationCreateEventImplCopyWithImpl<$Res>
    extends _$BeneficiaryRegistrationEventCopyWithImpl<$Res,
        _$BeneficiaryRegistrationCreateEventImpl>
    implements _$$BeneficiaryRegistrationCreateEventImplCopyWith<$Res> {
  __$$BeneficiaryRegistrationCreateEventImplCopyWithImpl(
      _$BeneficiaryRegistrationCreateEventImpl _value,
      $Res Function(_$BeneficiaryRegistrationCreateEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userUuid = null,
    Object? projectId = null,
    Object? boundary = null,
  }) {
    return _then(_$BeneficiaryRegistrationCreateEventImpl(
      userUuid: null == userUuid
          ? _value.userUuid
          : userUuid // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      boundary: null == boundary
          ? _value.boundary
          : boundary // ignore: cast_nullable_to_non_nullable
              as BoundaryModel,
    ));
  }
}

/// @nodoc

class _$BeneficiaryRegistrationCreateEventImpl
    implements BeneficiaryRegistrationCreateEvent {
  const _$BeneficiaryRegistrationCreateEventImpl(
      {required this.userUuid,
      required this.projectId,
      required this.boundary});

  @override
  final String userUuid;
  @override
  final String projectId;
  @override
  final BoundaryModel boundary;

  @override
  String toString() {
    return 'BeneficiaryRegistrationEvent.create(userUuid: $userUuid, projectId: $projectId, boundary: $boundary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BeneficiaryRegistrationCreateEventImpl &&
            (identical(other.userUuid, userUuid) ||
                other.userUuid == userUuid) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.boundary, boundary) ||
                other.boundary == boundary));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userUuid, projectId, boundary);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BeneficiaryRegistrationCreateEventImplCopyWith<
          _$BeneficiaryRegistrationCreateEventImpl>
      get copyWith => __$$BeneficiaryRegistrationCreateEventImplCopyWithImpl<
          _$BeneficiaryRegistrationCreateEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AddressModel model) saveAddress,
    required TResult Function(HouseholdModel household, bool isConsent)
        saveHouseholdConsent,
    required TResult Function(
            HouseholdModel household, DateTime registrationDate)
        saveHouseholdDetails,
    required TResult Function(IndividualModel model, bool isHeadOfHousehold)
        saveIndividualDetails,
    required TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)
        addMember,
    required TResult Function(
            HouseholdModel household, AddressModel? addressModel)
        updateHouseholdDetails,
    required TResult Function(IndividualModel model, AddressModel addressModel)
        updateIndividualDetails,
    required TResult Function(
            String userUuid, String projectId, BoundaryModel boundary)
        create,
  }) {
    return create(userUuid, projectId, boundary);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AddressModel model)? saveAddress,
    TResult? Function(HouseholdModel household, bool isConsent)?
        saveHouseholdConsent,
    TResult? Function(HouseholdModel household, DateTime registrationDate)?
        saveHouseholdDetails,
    TResult? Function(IndividualModel model, bool isHeadOfHousehold)?
        saveIndividualDetails,
    TResult? Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)?
        addMember,
    TResult? Function(HouseholdModel household, AddressModel? addressModel)?
        updateHouseholdDetails,
    TResult? Function(IndividualModel model, AddressModel addressModel)?
        updateIndividualDetails,
    TResult? Function(
            String userUuid, String projectId, BoundaryModel boundary)?
        create,
  }) {
    return create?.call(userUuid, projectId, boundary);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AddressModel model)? saveAddress,
    TResult Function(HouseholdModel household, bool isConsent)?
        saveHouseholdConsent,
    TResult Function(HouseholdModel household, DateTime registrationDate)?
        saveHouseholdDetails,
    TResult Function(IndividualModel model, bool isHeadOfHousehold)?
        saveIndividualDetails,
    TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            String userUuid,
            String projectId,
            BeneficiaryType beneficiaryType)?
        addMember,
    TResult Function(HouseholdModel household, AddressModel? addressModel)?
        updateHouseholdDetails,
    TResult Function(IndividualModel model, AddressModel addressModel)?
        updateIndividualDetails,
    TResult Function(String userUuid, String projectId, BoundaryModel boundary)?
        create,
    required TResult orElse(),
  }) {
    if (create != null) {
      return create(userUuid, projectId, boundary);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeneficiaryRegistrationSaveAddressEvent value)
        saveAddress,
    required TResult Function(
            BeneficiaryRegistrationSaveHouseholdConsentEvent value)
        saveHouseholdConsent,
    required TResult Function(
            BeneficiaryRegistrationSaveHouseholdDetailsEvent value)
        saveHouseholdDetails,
    required TResult Function(
            BeneficiaryRegistrationSaveIndividualDetailsEvent value)
        saveIndividualDetails,
    required TResult Function(BeneficiaryRegistrationAddMemberEvent value)
        addMember,
    required TResult Function(
            BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)
        updateHouseholdDetails,
    required TResult Function(
            BeneficiaryRegistrationUpdateIndividualDetailsEvent value)
        updateIndividualDetails,
    required TResult Function(BeneficiaryRegistrationCreateEvent value) create,
  }) {
    return create(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BeneficiaryRegistrationSaveAddressEvent value)?
        saveAddress,
    TResult? Function(BeneficiaryRegistrationSaveHouseholdConsentEvent value)?
        saveHouseholdConsent,
    TResult? Function(BeneficiaryRegistrationSaveHouseholdDetailsEvent value)?
        saveHouseholdDetails,
    TResult? Function(BeneficiaryRegistrationSaveIndividualDetailsEvent value)?
        saveIndividualDetails,
    TResult? Function(BeneficiaryRegistrationAddMemberEvent value)? addMember,
    TResult? Function(BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)?
        updateHouseholdDetails,
    TResult? Function(
            BeneficiaryRegistrationUpdateIndividualDetailsEvent value)?
        updateIndividualDetails,
    TResult? Function(BeneficiaryRegistrationCreateEvent value)? create,
  }) {
    return create?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeneficiaryRegistrationSaveAddressEvent value)?
        saveAddress,
    TResult Function(BeneficiaryRegistrationSaveHouseholdConsentEvent value)?
        saveHouseholdConsent,
    TResult Function(BeneficiaryRegistrationSaveHouseholdDetailsEvent value)?
        saveHouseholdDetails,
    TResult Function(BeneficiaryRegistrationSaveIndividualDetailsEvent value)?
        saveIndividualDetails,
    TResult Function(BeneficiaryRegistrationAddMemberEvent value)? addMember,
    TResult Function(BeneficiaryRegistrationUpdateHouseholdDetailsEvent value)?
        updateHouseholdDetails,
    TResult Function(BeneficiaryRegistrationUpdateIndividualDetailsEvent value)?
        updateIndividualDetails,
    TResult Function(BeneficiaryRegistrationCreateEvent value)? create,
    required TResult orElse(),
  }) {
    if (create != null) {
      return create(this);
    }
    return orElse();
  }
}

abstract class BeneficiaryRegistrationCreateEvent
    implements BeneficiaryRegistrationEvent {
  const factory BeneficiaryRegistrationCreateEvent(
          {required final String userUuid,
          required final String projectId,
          required final BoundaryModel boundary}) =
      _$BeneficiaryRegistrationCreateEventImpl;

  String get userUuid;
  String get projectId;
  BoundaryModel get boundary;
  @JsonKey(ignore: true)
  _$$BeneficiaryRegistrationCreateEventImplCopyWith<
          _$BeneficiaryRegistrationCreateEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BeneficiaryRegistrationState {
  HouseholdModel? get householdModel => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AddressModel? addressModel,
            HouseholdModel? householdModel,
            IndividualModel? individualModel,
            DateTime? registrationDate,
            String? searchQuery,
            bool loading,
            bool isHeadOfHousehold)
        create,
    required TResult Function(
            AddressModel addressModel,
            HouseholdModel householdModel,
            List<IndividualModel> individualModel,
            DateTime registrationDate,
            bool loading)
        editHousehold,
    required TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            bool loading)
        editIndividual,
    required TResult Function(AddressModel addressModel,
            HouseholdModel householdModel, bool loading)
        addMember,
    required TResult Function(
            bool navigateToRoot, HouseholdModel householdModel)
        persisted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            AddressModel? addressModel,
            HouseholdModel? householdModel,
            IndividualModel? individualModel,
            DateTime? registrationDate,
            String? searchQuery,
            bool loading,
            bool isHeadOfHousehold)?
        create,
    TResult? Function(
            AddressModel addressModel,
            HouseholdModel householdModel,
            List<IndividualModel> individualModel,
            DateTime registrationDate,
            bool loading)?
        editHousehold,
    TResult? Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            bool loading)?
        editIndividual,
    TResult? Function(AddressModel addressModel, HouseholdModel householdModel,
            bool loading)?
        addMember,
    TResult? Function(bool navigateToRoot, HouseholdModel householdModel)?
        persisted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            AddressModel? addressModel,
            HouseholdModel? householdModel,
            IndividualModel? individualModel,
            DateTime? registrationDate,
            String? searchQuery,
            bool loading,
            bool isHeadOfHousehold)?
        create,
    TResult Function(
            AddressModel addressModel,
            HouseholdModel householdModel,
            List<IndividualModel> individualModel,
            DateTime registrationDate,
            bool loading)?
        editHousehold,
    TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            bool loading)?
        editIndividual,
    TResult Function(AddressModel addressModel, HouseholdModel householdModel,
            bool loading)?
        addMember,
    TResult Function(bool navigateToRoot, HouseholdModel householdModel)?
        persisted,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeneficiaryRegistrationCreateState value) create,
    required TResult Function(BeneficiaryRegistrationEditHouseholdState value)
        editHousehold,
    required TResult Function(BeneficiaryRegistrationEditIndividualState value)
        editIndividual,
    required TResult Function(BeneficiaryRegistrationAddMemberState value)
        addMember,
    required TResult Function(BeneficiaryRegistrationPersistedState value)
        persisted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BeneficiaryRegistrationCreateState value)? create,
    TResult? Function(BeneficiaryRegistrationEditHouseholdState value)?
        editHousehold,
    TResult? Function(BeneficiaryRegistrationEditIndividualState value)?
        editIndividual,
    TResult? Function(BeneficiaryRegistrationAddMemberState value)? addMember,
    TResult? Function(BeneficiaryRegistrationPersistedState value)? persisted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeneficiaryRegistrationCreateState value)? create,
    TResult Function(BeneficiaryRegistrationEditHouseholdState value)?
        editHousehold,
    TResult Function(BeneficiaryRegistrationEditIndividualState value)?
        editIndividual,
    TResult Function(BeneficiaryRegistrationAddMemberState value)? addMember,
    TResult Function(BeneficiaryRegistrationPersistedState value)? persisted,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BeneficiaryRegistrationStateCopyWith<BeneficiaryRegistrationState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BeneficiaryRegistrationStateCopyWith<$Res> {
  factory $BeneficiaryRegistrationStateCopyWith(
          BeneficiaryRegistrationState value,
          $Res Function(BeneficiaryRegistrationState) then) =
      _$BeneficiaryRegistrationStateCopyWithImpl<$Res,
          BeneficiaryRegistrationState>;
  @useResult
  $Res call({HouseholdModel householdModel});
}

/// @nodoc
class _$BeneficiaryRegistrationStateCopyWithImpl<$Res,
        $Val extends BeneficiaryRegistrationState>
    implements $BeneficiaryRegistrationStateCopyWith<$Res> {
  _$BeneficiaryRegistrationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? householdModel = null,
  }) {
    return _then(_value.copyWith(
      householdModel: null == householdModel
          ? _value.householdModel!
          : householdModel // ignore: cast_nullable_to_non_nullable
              as HouseholdModel,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BeneficiaryRegistrationCreateStateImplCopyWith<$Res>
    implements $BeneficiaryRegistrationStateCopyWith<$Res> {
  factory _$$BeneficiaryRegistrationCreateStateImplCopyWith(
          _$BeneficiaryRegistrationCreateStateImpl value,
          $Res Function(_$BeneficiaryRegistrationCreateStateImpl) then) =
      __$$BeneficiaryRegistrationCreateStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AddressModel? addressModel,
      HouseholdModel? householdModel,
      IndividualModel? individualModel,
      DateTime? registrationDate,
      String? searchQuery,
      bool loading,
      bool isHeadOfHousehold});
}

/// @nodoc
class __$$BeneficiaryRegistrationCreateStateImplCopyWithImpl<$Res>
    extends _$BeneficiaryRegistrationStateCopyWithImpl<$Res,
        _$BeneficiaryRegistrationCreateStateImpl>
    implements _$$BeneficiaryRegistrationCreateStateImplCopyWith<$Res> {
  __$$BeneficiaryRegistrationCreateStateImplCopyWithImpl(
      _$BeneficiaryRegistrationCreateStateImpl _value,
      $Res Function(_$BeneficiaryRegistrationCreateStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addressModel = freezed,
    Object? householdModel = freezed,
    Object? individualModel = freezed,
    Object? registrationDate = freezed,
    Object? searchQuery = freezed,
    Object? loading = null,
    Object? isHeadOfHousehold = null,
  }) {
    return _then(_$BeneficiaryRegistrationCreateStateImpl(
      addressModel: freezed == addressModel
          ? _value.addressModel
          : addressModel // ignore: cast_nullable_to_non_nullable
              as AddressModel?,
      householdModel: freezed == householdModel
          ? _value.householdModel
          : householdModel // ignore: cast_nullable_to_non_nullable
              as HouseholdModel?,
      individualModel: freezed == individualModel
          ? _value.individualModel
          : individualModel // ignore: cast_nullable_to_non_nullable
              as IndividualModel?,
      registrationDate: freezed == registrationDate
          ? _value.registrationDate
          : registrationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      isHeadOfHousehold: null == isHeadOfHousehold
          ? _value.isHeadOfHousehold
          : isHeadOfHousehold // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BeneficiaryRegistrationCreateStateImpl
    implements BeneficiaryRegistrationCreateState {
  const _$BeneficiaryRegistrationCreateStateImpl(
      {this.addressModel,
      this.householdModel,
      this.individualModel,
      this.registrationDate,
      this.searchQuery,
      this.loading = false,
      this.isHeadOfHousehold = false});

  @override
  final AddressModel? addressModel;
  @override
  final HouseholdModel? householdModel;
  @override
  final IndividualModel? individualModel;
  @override
  final DateTime? registrationDate;
  @override
  final String? searchQuery;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool isHeadOfHousehold;

  @override
  String toString() {
    return 'BeneficiaryRegistrationState.create(addressModel: $addressModel, householdModel: $householdModel, individualModel: $individualModel, registrationDate: $registrationDate, searchQuery: $searchQuery, loading: $loading, isHeadOfHousehold: $isHeadOfHousehold)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BeneficiaryRegistrationCreateStateImpl &&
            (identical(other.addressModel, addressModel) ||
                other.addressModel == addressModel) &&
            (identical(other.householdModel, householdModel) ||
                other.householdModel == householdModel) &&
            (identical(other.individualModel, individualModel) ||
                other.individualModel == individualModel) &&
            (identical(other.registrationDate, registrationDate) ||
                other.registrationDate == registrationDate) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.isHeadOfHousehold, isHeadOfHousehold) ||
                other.isHeadOfHousehold == isHeadOfHousehold));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      addressModel,
      householdModel,
      individualModel,
      registrationDate,
      searchQuery,
      loading,
      isHeadOfHousehold);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BeneficiaryRegistrationCreateStateImplCopyWith<
          _$BeneficiaryRegistrationCreateStateImpl>
      get copyWith => __$$BeneficiaryRegistrationCreateStateImplCopyWithImpl<
          _$BeneficiaryRegistrationCreateStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AddressModel? addressModel,
            HouseholdModel? householdModel,
            IndividualModel? individualModel,
            DateTime? registrationDate,
            String? searchQuery,
            bool loading,
            bool isHeadOfHousehold)
        create,
    required TResult Function(
            AddressModel addressModel,
            HouseholdModel householdModel,
            List<IndividualModel> individualModel,
            DateTime registrationDate,
            bool loading)
        editHousehold,
    required TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            bool loading)
        editIndividual,
    required TResult Function(AddressModel addressModel,
            HouseholdModel householdModel, bool loading)
        addMember,
    required TResult Function(
            bool navigateToRoot, HouseholdModel householdModel)
        persisted,
  }) {
    return create(addressModel, householdModel, individualModel,
        registrationDate, searchQuery, loading, isHeadOfHousehold);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            AddressModel? addressModel,
            HouseholdModel? householdModel,
            IndividualModel? individualModel,
            DateTime? registrationDate,
            String? searchQuery,
            bool loading,
            bool isHeadOfHousehold)?
        create,
    TResult? Function(
            AddressModel addressModel,
            HouseholdModel householdModel,
            List<IndividualModel> individualModel,
            DateTime registrationDate,
            bool loading)?
        editHousehold,
    TResult? Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            bool loading)?
        editIndividual,
    TResult? Function(AddressModel addressModel, HouseholdModel householdModel,
            bool loading)?
        addMember,
    TResult? Function(bool navigateToRoot, HouseholdModel householdModel)?
        persisted,
  }) {
    return create?.call(addressModel, householdModel, individualModel,
        registrationDate, searchQuery, loading, isHeadOfHousehold);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            AddressModel? addressModel,
            HouseholdModel? householdModel,
            IndividualModel? individualModel,
            DateTime? registrationDate,
            String? searchQuery,
            bool loading,
            bool isHeadOfHousehold)?
        create,
    TResult Function(
            AddressModel addressModel,
            HouseholdModel householdModel,
            List<IndividualModel> individualModel,
            DateTime registrationDate,
            bool loading)?
        editHousehold,
    TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            bool loading)?
        editIndividual,
    TResult Function(AddressModel addressModel, HouseholdModel householdModel,
            bool loading)?
        addMember,
    TResult Function(bool navigateToRoot, HouseholdModel householdModel)?
        persisted,
    required TResult orElse(),
  }) {
    if (create != null) {
      return create(addressModel, householdModel, individualModel,
          registrationDate, searchQuery, loading, isHeadOfHousehold);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeneficiaryRegistrationCreateState value) create,
    required TResult Function(BeneficiaryRegistrationEditHouseholdState value)
        editHousehold,
    required TResult Function(BeneficiaryRegistrationEditIndividualState value)
        editIndividual,
    required TResult Function(BeneficiaryRegistrationAddMemberState value)
        addMember,
    required TResult Function(BeneficiaryRegistrationPersistedState value)
        persisted,
  }) {
    return create(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BeneficiaryRegistrationCreateState value)? create,
    TResult? Function(BeneficiaryRegistrationEditHouseholdState value)?
        editHousehold,
    TResult? Function(BeneficiaryRegistrationEditIndividualState value)?
        editIndividual,
    TResult? Function(BeneficiaryRegistrationAddMemberState value)? addMember,
    TResult? Function(BeneficiaryRegistrationPersistedState value)? persisted,
  }) {
    return create?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeneficiaryRegistrationCreateState value)? create,
    TResult Function(BeneficiaryRegistrationEditHouseholdState value)?
        editHousehold,
    TResult Function(BeneficiaryRegistrationEditIndividualState value)?
        editIndividual,
    TResult Function(BeneficiaryRegistrationAddMemberState value)? addMember,
    TResult Function(BeneficiaryRegistrationPersistedState value)? persisted,
    required TResult orElse(),
  }) {
    if (create != null) {
      return create(this);
    }
    return orElse();
  }
}

abstract class BeneficiaryRegistrationCreateState
    implements BeneficiaryRegistrationState {
  const factory BeneficiaryRegistrationCreateState(
      {final AddressModel? addressModel,
      final HouseholdModel? householdModel,
      final IndividualModel? individualModel,
      final DateTime? registrationDate,
      final String? searchQuery,
      final bool loading,
      final bool isHeadOfHousehold}) = _$BeneficiaryRegistrationCreateStateImpl;

  AddressModel? get addressModel;
  @override
  HouseholdModel? get householdModel;
  IndividualModel? get individualModel;
  DateTime? get registrationDate;
  String? get searchQuery;
  bool get loading;
  bool get isHeadOfHousehold;
  @override
  @JsonKey(ignore: true)
  _$$BeneficiaryRegistrationCreateStateImplCopyWith<
          _$BeneficiaryRegistrationCreateStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BeneficiaryRegistrationEditHouseholdStateImplCopyWith<$Res>
    implements $BeneficiaryRegistrationStateCopyWith<$Res> {
  factory _$$BeneficiaryRegistrationEditHouseholdStateImplCopyWith(
          _$BeneficiaryRegistrationEditHouseholdStateImpl value,
          $Res Function(_$BeneficiaryRegistrationEditHouseholdStateImpl) then) =
      __$$BeneficiaryRegistrationEditHouseholdStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AddressModel addressModel,
      HouseholdModel householdModel,
      List<IndividualModel> individualModel,
      DateTime registrationDate,
      bool loading});
}

/// @nodoc
class __$$BeneficiaryRegistrationEditHouseholdStateImplCopyWithImpl<$Res>
    extends _$BeneficiaryRegistrationStateCopyWithImpl<$Res,
        _$BeneficiaryRegistrationEditHouseholdStateImpl>
    implements _$$BeneficiaryRegistrationEditHouseholdStateImplCopyWith<$Res> {
  __$$BeneficiaryRegistrationEditHouseholdStateImplCopyWithImpl(
      _$BeneficiaryRegistrationEditHouseholdStateImpl _value,
      $Res Function(_$BeneficiaryRegistrationEditHouseholdStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addressModel = null,
    Object? householdModel = null,
    Object? individualModel = null,
    Object? registrationDate = null,
    Object? loading = null,
  }) {
    return _then(_$BeneficiaryRegistrationEditHouseholdStateImpl(
      addressModel: null == addressModel
          ? _value.addressModel
          : addressModel // ignore: cast_nullable_to_non_nullable
              as AddressModel,
      householdModel: null == householdModel
          ? _value.householdModel
          : householdModel // ignore: cast_nullable_to_non_nullable
              as HouseholdModel,
      individualModel: null == individualModel
          ? _value._individualModel
          : individualModel // ignore: cast_nullable_to_non_nullable
              as List<IndividualModel>,
      registrationDate: null == registrationDate
          ? _value.registrationDate
          : registrationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BeneficiaryRegistrationEditHouseholdStateImpl
    implements BeneficiaryRegistrationEditHouseholdState {
  const _$BeneficiaryRegistrationEditHouseholdStateImpl(
      {required this.addressModel,
      required this.householdModel,
      required final List<IndividualModel> individualModel,
      required this.registrationDate,
      this.loading = false})
      : _individualModel = individualModel;

  @override
  final AddressModel addressModel;
  @override
  final HouseholdModel householdModel;
  final List<IndividualModel> _individualModel;
  @override
  List<IndividualModel> get individualModel {
    if (_individualModel is EqualUnmodifiableListView) return _individualModel;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_individualModel);
  }

  @override
  final DateTime registrationDate;
  @override
  @JsonKey()
  final bool loading;

  @override
  String toString() {
    return 'BeneficiaryRegistrationState.editHousehold(addressModel: $addressModel, householdModel: $householdModel, individualModel: $individualModel, registrationDate: $registrationDate, loading: $loading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BeneficiaryRegistrationEditHouseholdStateImpl &&
            (identical(other.addressModel, addressModel) ||
                other.addressModel == addressModel) &&
            (identical(other.householdModel, householdModel) ||
                other.householdModel == householdModel) &&
            const DeepCollectionEquality()
                .equals(other._individualModel, _individualModel) &&
            (identical(other.registrationDate, registrationDate) ||
                other.registrationDate == registrationDate) &&
            (identical(other.loading, loading) || other.loading == loading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      addressModel,
      householdModel,
      const DeepCollectionEquality().hash(_individualModel),
      registrationDate,
      loading);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BeneficiaryRegistrationEditHouseholdStateImplCopyWith<
          _$BeneficiaryRegistrationEditHouseholdStateImpl>
      get copyWith =>
          __$$BeneficiaryRegistrationEditHouseholdStateImplCopyWithImpl<
                  _$BeneficiaryRegistrationEditHouseholdStateImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AddressModel? addressModel,
            HouseholdModel? householdModel,
            IndividualModel? individualModel,
            DateTime? registrationDate,
            String? searchQuery,
            bool loading,
            bool isHeadOfHousehold)
        create,
    required TResult Function(
            AddressModel addressModel,
            HouseholdModel householdModel,
            List<IndividualModel> individualModel,
            DateTime registrationDate,
            bool loading)
        editHousehold,
    required TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            bool loading)
        editIndividual,
    required TResult Function(AddressModel addressModel,
            HouseholdModel householdModel, bool loading)
        addMember,
    required TResult Function(
            bool navigateToRoot, HouseholdModel householdModel)
        persisted,
  }) {
    return editHousehold(addressModel, householdModel, individualModel,
        registrationDate, loading);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            AddressModel? addressModel,
            HouseholdModel? householdModel,
            IndividualModel? individualModel,
            DateTime? registrationDate,
            String? searchQuery,
            bool loading,
            bool isHeadOfHousehold)?
        create,
    TResult? Function(
            AddressModel addressModel,
            HouseholdModel householdModel,
            List<IndividualModel> individualModel,
            DateTime registrationDate,
            bool loading)?
        editHousehold,
    TResult? Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            bool loading)?
        editIndividual,
    TResult? Function(AddressModel addressModel, HouseholdModel householdModel,
            bool loading)?
        addMember,
    TResult? Function(bool navigateToRoot, HouseholdModel householdModel)?
        persisted,
  }) {
    return editHousehold?.call(addressModel, householdModel, individualModel,
        registrationDate, loading);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            AddressModel? addressModel,
            HouseholdModel? householdModel,
            IndividualModel? individualModel,
            DateTime? registrationDate,
            String? searchQuery,
            bool loading,
            bool isHeadOfHousehold)?
        create,
    TResult Function(
            AddressModel addressModel,
            HouseholdModel householdModel,
            List<IndividualModel> individualModel,
            DateTime registrationDate,
            bool loading)?
        editHousehold,
    TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            bool loading)?
        editIndividual,
    TResult Function(AddressModel addressModel, HouseholdModel householdModel,
            bool loading)?
        addMember,
    TResult Function(bool navigateToRoot, HouseholdModel householdModel)?
        persisted,
    required TResult orElse(),
  }) {
    if (editHousehold != null) {
      return editHousehold(addressModel, householdModel, individualModel,
          registrationDate, loading);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeneficiaryRegistrationCreateState value) create,
    required TResult Function(BeneficiaryRegistrationEditHouseholdState value)
        editHousehold,
    required TResult Function(BeneficiaryRegistrationEditIndividualState value)
        editIndividual,
    required TResult Function(BeneficiaryRegistrationAddMemberState value)
        addMember,
    required TResult Function(BeneficiaryRegistrationPersistedState value)
        persisted,
  }) {
    return editHousehold(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BeneficiaryRegistrationCreateState value)? create,
    TResult? Function(BeneficiaryRegistrationEditHouseholdState value)?
        editHousehold,
    TResult? Function(BeneficiaryRegistrationEditIndividualState value)?
        editIndividual,
    TResult? Function(BeneficiaryRegistrationAddMemberState value)? addMember,
    TResult? Function(BeneficiaryRegistrationPersistedState value)? persisted,
  }) {
    return editHousehold?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeneficiaryRegistrationCreateState value)? create,
    TResult Function(BeneficiaryRegistrationEditHouseholdState value)?
        editHousehold,
    TResult Function(BeneficiaryRegistrationEditIndividualState value)?
        editIndividual,
    TResult Function(BeneficiaryRegistrationAddMemberState value)? addMember,
    TResult Function(BeneficiaryRegistrationPersistedState value)? persisted,
    required TResult orElse(),
  }) {
    if (editHousehold != null) {
      return editHousehold(this);
    }
    return orElse();
  }
}

abstract class BeneficiaryRegistrationEditHouseholdState
    implements BeneficiaryRegistrationState {
  const factory BeneficiaryRegistrationEditHouseholdState(
      {required final AddressModel addressModel,
      required final HouseholdModel householdModel,
      required final List<IndividualModel> individualModel,
      required final DateTime registrationDate,
      final bool loading}) = _$BeneficiaryRegistrationEditHouseholdStateImpl;

  AddressModel get addressModel;
  @override
  HouseholdModel get householdModel;
  List<IndividualModel> get individualModel;
  DateTime get registrationDate;
  bool get loading;
  @override
  @JsonKey(ignore: true)
  _$$BeneficiaryRegistrationEditHouseholdStateImplCopyWith<
          _$BeneficiaryRegistrationEditHouseholdStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BeneficiaryRegistrationEditIndividualStateImplCopyWith<$Res>
    implements $BeneficiaryRegistrationStateCopyWith<$Res> {
  factory _$$BeneficiaryRegistrationEditIndividualStateImplCopyWith(
          _$BeneficiaryRegistrationEditIndividualStateImpl value,
          $Res Function(_$BeneficiaryRegistrationEditIndividualStateImpl)
              then) =
      __$$BeneficiaryRegistrationEditIndividualStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {HouseholdModel householdModel,
      IndividualModel individualModel,
      AddressModel addressModel,
      bool loading});
}

/// @nodoc
class __$$BeneficiaryRegistrationEditIndividualStateImplCopyWithImpl<$Res>
    extends _$BeneficiaryRegistrationStateCopyWithImpl<$Res,
        _$BeneficiaryRegistrationEditIndividualStateImpl>
    implements _$$BeneficiaryRegistrationEditIndividualStateImplCopyWith<$Res> {
  __$$BeneficiaryRegistrationEditIndividualStateImplCopyWithImpl(
      _$BeneficiaryRegistrationEditIndividualStateImpl _value,
      $Res Function(_$BeneficiaryRegistrationEditIndividualStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? householdModel = null,
    Object? individualModel = null,
    Object? addressModel = null,
    Object? loading = null,
  }) {
    return _then(_$BeneficiaryRegistrationEditIndividualStateImpl(
      householdModel: null == householdModel
          ? _value.householdModel
          : householdModel // ignore: cast_nullable_to_non_nullable
              as HouseholdModel,
      individualModel: null == individualModel
          ? _value.individualModel
          : individualModel // ignore: cast_nullable_to_non_nullable
              as IndividualModel,
      addressModel: null == addressModel
          ? _value.addressModel
          : addressModel // ignore: cast_nullable_to_non_nullable
              as AddressModel,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BeneficiaryRegistrationEditIndividualStateImpl
    implements BeneficiaryRegistrationEditIndividualState {
  const _$BeneficiaryRegistrationEditIndividualStateImpl(
      {required this.householdModel,
      required this.individualModel,
      required this.addressModel,
      this.loading = false});

  @override
  final HouseholdModel householdModel;
  @override
  final IndividualModel individualModel;
  @override
  final AddressModel addressModel;
  @override
  @JsonKey()
  final bool loading;

  @override
  String toString() {
    return 'BeneficiaryRegistrationState.editIndividual(householdModel: $householdModel, individualModel: $individualModel, addressModel: $addressModel, loading: $loading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BeneficiaryRegistrationEditIndividualStateImpl &&
            (identical(other.householdModel, householdModel) ||
                other.householdModel == householdModel) &&
            (identical(other.individualModel, individualModel) ||
                other.individualModel == individualModel) &&
            (identical(other.addressModel, addressModel) ||
                other.addressModel == addressModel) &&
            (identical(other.loading, loading) || other.loading == loading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, householdModel, individualModel, addressModel, loading);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BeneficiaryRegistrationEditIndividualStateImplCopyWith<
          _$BeneficiaryRegistrationEditIndividualStateImpl>
      get copyWith =>
          __$$BeneficiaryRegistrationEditIndividualStateImplCopyWithImpl<
                  _$BeneficiaryRegistrationEditIndividualStateImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AddressModel? addressModel,
            HouseholdModel? householdModel,
            IndividualModel? individualModel,
            DateTime? registrationDate,
            String? searchQuery,
            bool loading,
            bool isHeadOfHousehold)
        create,
    required TResult Function(
            AddressModel addressModel,
            HouseholdModel householdModel,
            List<IndividualModel> individualModel,
            DateTime registrationDate,
            bool loading)
        editHousehold,
    required TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            bool loading)
        editIndividual,
    required TResult Function(AddressModel addressModel,
            HouseholdModel householdModel, bool loading)
        addMember,
    required TResult Function(
            bool navigateToRoot, HouseholdModel householdModel)
        persisted,
  }) {
    return editIndividual(
        householdModel, individualModel, addressModel, loading);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            AddressModel? addressModel,
            HouseholdModel? householdModel,
            IndividualModel? individualModel,
            DateTime? registrationDate,
            String? searchQuery,
            bool loading,
            bool isHeadOfHousehold)?
        create,
    TResult? Function(
            AddressModel addressModel,
            HouseholdModel householdModel,
            List<IndividualModel> individualModel,
            DateTime registrationDate,
            bool loading)?
        editHousehold,
    TResult? Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            bool loading)?
        editIndividual,
    TResult? Function(AddressModel addressModel, HouseholdModel householdModel,
            bool loading)?
        addMember,
    TResult? Function(bool navigateToRoot, HouseholdModel householdModel)?
        persisted,
  }) {
    return editIndividual?.call(
        householdModel, individualModel, addressModel, loading);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            AddressModel? addressModel,
            HouseholdModel? householdModel,
            IndividualModel? individualModel,
            DateTime? registrationDate,
            String? searchQuery,
            bool loading,
            bool isHeadOfHousehold)?
        create,
    TResult Function(
            AddressModel addressModel,
            HouseholdModel householdModel,
            List<IndividualModel> individualModel,
            DateTime registrationDate,
            bool loading)?
        editHousehold,
    TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            bool loading)?
        editIndividual,
    TResult Function(AddressModel addressModel, HouseholdModel householdModel,
            bool loading)?
        addMember,
    TResult Function(bool navigateToRoot, HouseholdModel householdModel)?
        persisted,
    required TResult orElse(),
  }) {
    if (editIndividual != null) {
      return editIndividual(
          householdModel, individualModel, addressModel, loading);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeneficiaryRegistrationCreateState value) create,
    required TResult Function(BeneficiaryRegistrationEditHouseholdState value)
        editHousehold,
    required TResult Function(BeneficiaryRegistrationEditIndividualState value)
        editIndividual,
    required TResult Function(BeneficiaryRegistrationAddMemberState value)
        addMember,
    required TResult Function(BeneficiaryRegistrationPersistedState value)
        persisted,
  }) {
    return editIndividual(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BeneficiaryRegistrationCreateState value)? create,
    TResult? Function(BeneficiaryRegistrationEditHouseholdState value)?
        editHousehold,
    TResult? Function(BeneficiaryRegistrationEditIndividualState value)?
        editIndividual,
    TResult? Function(BeneficiaryRegistrationAddMemberState value)? addMember,
    TResult? Function(BeneficiaryRegistrationPersistedState value)? persisted,
  }) {
    return editIndividual?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeneficiaryRegistrationCreateState value)? create,
    TResult Function(BeneficiaryRegistrationEditHouseholdState value)?
        editHousehold,
    TResult Function(BeneficiaryRegistrationEditIndividualState value)?
        editIndividual,
    TResult Function(BeneficiaryRegistrationAddMemberState value)? addMember,
    TResult Function(BeneficiaryRegistrationPersistedState value)? persisted,
    required TResult orElse(),
  }) {
    if (editIndividual != null) {
      return editIndividual(this);
    }
    return orElse();
  }
}

abstract class BeneficiaryRegistrationEditIndividualState
    implements BeneficiaryRegistrationState {
  const factory BeneficiaryRegistrationEditIndividualState(
      {required final HouseholdModel householdModel,
      required final IndividualModel individualModel,
      required final AddressModel addressModel,
      final bool loading}) = _$BeneficiaryRegistrationEditIndividualStateImpl;

  @override
  HouseholdModel get householdModel;
  IndividualModel get individualModel;
  AddressModel get addressModel;
  bool get loading;
  @override
  @JsonKey(ignore: true)
  _$$BeneficiaryRegistrationEditIndividualStateImplCopyWith<
          _$BeneficiaryRegistrationEditIndividualStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BeneficiaryRegistrationAddMemberStateImplCopyWith<$Res>
    implements $BeneficiaryRegistrationStateCopyWith<$Res> {
  factory _$$BeneficiaryRegistrationAddMemberStateImplCopyWith(
          _$BeneficiaryRegistrationAddMemberStateImpl value,
          $Res Function(_$BeneficiaryRegistrationAddMemberStateImpl) then) =
      __$$BeneficiaryRegistrationAddMemberStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AddressModel addressModel, HouseholdModel householdModel, bool loading});
}

/// @nodoc
class __$$BeneficiaryRegistrationAddMemberStateImplCopyWithImpl<$Res>
    extends _$BeneficiaryRegistrationStateCopyWithImpl<$Res,
        _$BeneficiaryRegistrationAddMemberStateImpl>
    implements _$$BeneficiaryRegistrationAddMemberStateImplCopyWith<$Res> {
  __$$BeneficiaryRegistrationAddMemberStateImplCopyWithImpl(
      _$BeneficiaryRegistrationAddMemberStateImpl _value,
      $Res Function(_$BeneficiaryRegistrationAddMemberStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addressModel = null,
    Object? householdModel = null,
    Object? loading = null,
  }) {
    return _then(_$BeneficiaryRegistrationAddMemberStateImpl(
      addressModel: null == addressModel
          ? _value.addressModel
          : addressModel // ignore: cast_nullable_to_non_nullable
              as AddressModel,
      householdModel: null == householdModel
          ? _value.householdModel
          : householdModel // ignore: cast_nullable_to_non_nullable
              as HouseholdModel,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BeneficiaryRegistrationAddMemberStateImpl
    implements BeneficiaryRegistrationAddMemberState {
  const _$BeneficiaryRegistrationAddMemberStateImpl(
      {required this.addressModel,
      required this.householdModel,
      this.loading = false});

  @override
  final AddressModel addressModel;
  @override
  final HouseholdModel householdModel;
  @override
  @JsonKey()
  final bool loading;

  @override
  String toString() {
    return 'BeneficiaryRegistrationState.addMember(addressModel: $addressModel, householdModel: $householdModel, loading: $loading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BeneficiaryRegistrationAddMemberStateImpl &&
            (identical(other.addressModel, addressModel) ||
                other.addressModel == addressModel) &&
            (identical(other.householdModel, householdModel) ||
                other.householdModel == householdModel) &&
            (identical(other.loading, loading) || other.loading == loading));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, addressModel, householdModel, loading);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BeneficiaryRegistrationAddMemberStateImplCopyWith<
          _$BeneficiaryRegistrationAddMemberStateImpl>
      get copyWith => __$$BeneficiaryRegistrationAddMemberStateImplCopyWithImpl<
          _$BeneficiaryRegistrationAddMemberStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AddressModel? addressModel,
            HouseholdModel? householdModel,
            IndividualModel? individualModel,
            DateTime? registrationDate,
            String? searchQuery,
            bool loading,
            bool isHeadOfHousehold)
        create,
    required TResult Function(
            AddressModel addressModel,
            HouseholdModel householdModel,
            List<IndividualModel> individualModel,
            DateTime registrationDate,
            bool loading)
        editHousehold,
    required TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            bool loading)
        editIndividual,
    required TResult Function(AddressModel addressModel,
            HouseholdModel householdModel, bool loading)
        addMember,
    required TResult Function(
            bool navigateToRoot, HouseholdModel householdModel)
        persisted,
  }) {
    return addMember(addressModel, householdModel, loading);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            AddressModel? addressModel,
            HouseholdModel? householdModel,
            IndividualModel? individualModel,
            DateTime? registrationDate,
            String? searchQuery,
            bool loading,
            bool isHeadOfHousehold)?
        create,
    TResult? Function(
            AddressModel addressModel,
            HouseholdModel householdModel,
            List<IndividualModel> individualModel,
            DateTime registrationDate,
            bool loading)?
        editHousehold,
    TResult? Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            bool loading)?
        editIndividual,
    TResult? Function(AddressModel addressModel, HouseholdModel householdModel,
            bool loading)?
        addMember,
    TResult? Function(bool navigateToRoot, HouseholdModel householdModel)?
        persisted,
  }) {
    return addMember?.call(addressModel, householdModel, loading);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            AddressModel? addressModel,
            HouseholdModel? householdModel,
            IndividualModel? individualModel,
            DateTime? registrationDate,
            String? searchQuery,
            bool loading,
            bool isHeadOfHousehold)?
        create,
    TResult Function(
            AddressModel addressModel,
            HouseholdModel householdModel,
            List<IndividualModel> individualModel,
            DateTime registrationDate,
            bool loading)?
        editHousehold,
    TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            bool loading)?
        editIndividual,
    TResult Function(AddressModel addressModel, HouseholdModel householdModel,
            bool loading)?
        addMember,
    TResult Function(bool navigateToRoot, HouseholdModel householdModel)?
        persisted,
    required TResult orElse(),
  }) {
    if (addMember != null) {
      return addMember(addressModel, householdModel, loading);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeneficiaryRegistrationCreateState value) create,
    required TResult Function(BeneficiaryRegistrationEditHouseholdState value)
        editHousehold,
    required TResult Function(BeneficiaryRegistrationEditIndividualState value)
        editIndividual,
    required TResult Function(BeneficiaryRegistrationAddMemberState value)
        addMember,
    required TResult Function(BeneficiaryRegistrationPersistedState value)
        persisted,
  }) {
    return addMember(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BeneficiaryRegistrationCreateState value)? create,
    TResult? Function(BeneficiaryRegistrationEditHouseholdState value)?
        editHousehold,
    TResult? Function(BeneficiaryRegistrationEditIndividualState value)?
        editIndividual,
    TResult? Function(BeneficiaryRegistrationAddMemberState value)? addMember,
    TResult? Function(BeneficiaryRegistrationPersistedState value)? persisted,
  }) {
    return addMember?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeneficiaryRegistrationCreateState value)? create,
    TResult Function(BeneficiaryRegistrationEditHouseholdState value)?
        editHousehold,
    TResult Function(BeneficiaryRegistrationEditIndividualState value)?
        editIndividual,
    TResult Function(BeneficiaryRegistrationAddMemberState value)? addMember,
    TResult Function(BeneficiaryRegistrationPersistedState value)? persisted,
    required TResult orElse(),
  }) {
    if (addMember != null) {
      return addMember(this);
    }
    return orElse();
  }
}

abstract class BeneficiaryRegistrationAddMemberState
    implements BeneficiaryRegistrationState {
  const factory BeneficiaryRegistrationAddMemberState(
      {required final AddressModel addressModel,
      required final HouseholdModel householdModel,
      final bool loading}) = _$BeneficiaryRegistrationAddMemberStateImpl;

  AddressModel get addressModel;
  @override
  HouseholdModel get householdModel;
  bool get loading;
  @override
  @JsonKey(ignore: true)
  _$$BeneficiaryRegistrationAddMemberStateImplCopyWith<
          _$BeneficiaryRegistrationAddMemberStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BeneficiaryRegistrationPersistedStateImplCopyWith<$Res>
    implements $BeneficiaryRegistrationStateCopyWith<$Res> {
  factory _$$BeneficiaryRegistrationPersistedStateImplCopyWith(
          _$BeneficiaryRegistrationPersistedStateImpl value,
          $Res Function(_$BeneficiaryRegistrationPersistedStateImpl) then) =
      __$$BeneficiaryRegistrationPersistedStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool navigateToRoot, HouseholdModel householdModel});
}

/// @nodoc
class __$$BeneficiaryRegistrationPersistedStateImplCopyWithImpl<$Res>
    extends _$BeneficiaryRegistrationStateCopyWithImpl<$Res,
        _$BeneficiaryRegistrationPersistedStateImpl>
    implements _$$BeneficiaryRegistrationPersistedStateImplCopyWith<$Res> {
  __$$BeneficiaryRegistrationPersistedStateImplCopyWithImpl(
      _$BeneficiaryRegistrationPersistedStateImpl _value,
      $Res Function(_$BeneficiaryRegistrationPersistedStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? navigateToRoot = null,
    Object? householdModel = null,
  }) {
    return _then(_$BeneficiaryRegistrationPersistedStateImpl(
      navigateToRoot: null == navigateToRoot
          ? _value.navigateToRoot
          : navigateToRoot // ignore: cast_nullable_to_non_nullable
              as bool,
      householdModel: null == householdModel
          ? _value.householdModel
          : householdModel // ignore: cast_nullable_to_non_nullable
              as HouseholdModel,
    ));
  }
}

/// @nodoc

class _$BeneficiaryRegistrationPersistedStateImpl
    implements BeneficiaryRegistrationPersistedState {
  const _$BeneficiaryRegistrationPersistedStateImpl(
      {this.navigateToRoot = true, required this.householdModel});

  @override
  @JsonKey()
  final bool navigateToRoot;
  @override
  final HouseholdModel householdModel;

  @override
  String toString() {
    return 'BeneficiaryRegistrationState.persisted(navigateToRoot: $navigateToRoot, householdModel: $householdModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BeneficiaryRegistrationPersistedStateImpl &&
            (identical(other.navigateToRoot, navigateToRoot) ||
                other.navigateToRoot == navigateToRoot) &&
            (identical(other.householdModel, householdModel) ||
                other.householdModel == householdModel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, navigateToRoot, householdModel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BeneficiaryRegistrationPersistedStateImplCopyWith<
          _$BeneficiaryRegistrationPersistedStateImpl>
      get copyWith => __$$BeneficiaryRegistrationPersistedStateImplCopyWithImpl<
          _$BeneficiaryRegistrationPersistedStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AddressModel? addressModel,
            HouseholdModel? householdModel,
            IndividualModel? individualModel,
            DateTime? registrationDate,
            String? searchQuery,
            bool loading,
            bool isHeadOfHousehold)
        create,
    required TResult Function(
            AddressModel addressModel,
            HouseholdModel householdModel,
            List<IndividualModel> individualModel,
            DateTime registrationDate,
            bool loading)
        editHousehold,
    required TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            bool loading)
        editIndividual,
    required TResult Function(AddressModel addressModel,
            HouseholdModel householdModel, bool loading)
        addMember,
    required TResult Function(
            bool navigateToRoot, HouseholdModel householdModel)
        persisted,
  }) {
    return persisted(navigateToRoot, householdModel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            AddressModel? addressModel,
            HouseholdModel? householdModel,
            IndividualModel? individualModel,
            DateTime? registrationDate,
            String? searchQuery,
            bool loading,
            bool isHeadOfHousehold)?
        create,
    TResult? Function(
            AddressModel addressModel,
            HouseholdModel householdModel,
            List<IndividualModel> individualModel,
            DateTime registrationDate,
            bool loading)?
        editHousehold,
    TResult? Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            bool loading)?
        editIndividual,
    TResult? Function(AddressModel addressModel, HouseholdModel householdModel,
            bool loading)?
        addMember,
    TResult? Function(bool navigateToRoot, HouseholdModel householdModel)?
        persisted,
  }) {
    return persisted?.call(navigateToRoot, householdModel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            AddressModel? addressModel,
            HouseholdModel? householdModel,
            IndividualModel? individualModel,
            DateTime? registrationDate,
            String? searchQuery,
            bool loading,
            bool isHeadOfHousehold)?
        create,
    TResult Function(
            AddressModel addressModel,
            HouseholdModel householdModel,
            List<IndividualModel> individualModel,
            DateTime registrationDate,
            bool loading)?
        editHousehold,
    TResult Function(
            HouseholdModel householdModel,
            IndividualModel individualModel,
            AddressModel addressModel,
            bool loading)?
        editIndividual,
    TResult Function(AddressModel addressModel, HouseholdModel householdModel,
            bool loading)?
        addMember,
    TResult Function(bool navigateToRoot, HouseholdModel householdModel)?
        persisted,
    required TResult orElse(),
  }) {
    if (persisted != null) {
      return persisted(navigateToRoot, householdModel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BeneficiaryRegistrationCreateState value) create,
    required TResult Function(BeneficiaryRegistrationEditHouseholdState value)
        editHousehold,
    required TResult Function(BeneficiaryRegistrationEditIndividualState value)
        editIndividual,
    required TResult Function(BeneficiaryRegistrationAddMemberState value)
        addMember,
    required TResult Function(BeneficiaryRegistrationPersistedState value)
        persisted,
  }) {
    return persisted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BeneficiaryRegistrationCreateState value)? create,
    TResult? Function(BeneficiaryRegistrationEditHouseholdState value)?
        editHousehold,
    TResult? Function(BeneficiaryRegistrationEditIndividualState value)?
        editIndividual,
    TResult? Function(BeneficiaryRegistrationAddMemberState value)? addMember,
    TResult? Function(BeneficiaryRegistrationPersistedState value)? persisted,
  }) {
    return persisted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BeneficiaryRegistrationCreateState value)? create,
    TResult Function(BeneficiaryRegistrationEditHouseholdState value)?
        editHousehold,
    TResult Function(BeneficiaryRegistrationEditIndividualState value)?
        editIndividual,
    TResult Function(BeneficiaryRegistrationAddMemberState value)? addMember,
    TResult Function(BeneficiaryRegistrationPersistedState value)? persisted,
    required TResult orElse(),
  }) {
    if (persisted != null) {
      return persisted(this);
    }
    return orElse();
  }
}

abstract class BeneficiaryRegistrationPersistedState
    implements BeneficiaryRegistrationState {
  const factory BeneficiaryRegistrationPersistedState(
          {final bool navigateToRoot,
          required final HouseholdModel householdModel}) =
      _$BeneficiaryRegistrationPersistedStateImpl;

  bool get navigateToRoot;
  @override
  HouseholdModel get householdModel;
  @override
  @JsonKey(ignore: true)
  _$$BeneficiaryRegistrationPersistedStateImplCopyWith<
          _$BeneficiaryRegistrationPersistedStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
