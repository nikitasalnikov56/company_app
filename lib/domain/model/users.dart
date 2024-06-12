import 'package:freezed_annotation/freezed_annotation.dart';

// flutter pub run build_runner watch --delete-conflicting-outputs

part 'users.freezed.dart';
part 'users.g.dart';

@freezed
class Users with _$Users {
  const factory Users({
    // ignore: invalid_annotation_target
    @JsonKey(name: 'Id') int? id,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'AssociatedClient') String? associatedClient,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'AssociatedContract') String? associatedContract,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'Lawyer') String? lawyer,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'BeneficiaryName') String? beneficiaryName,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'Founders') String? founders,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'Director') String? director,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'PartiesOfDispute') String? partiesOfDispute,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'AssociatedCompanies') String? associatedCompanies,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'AssociatedCases') String? associatedCases,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'createdBy') String? createdBy,
  }) = _Users;

  factory Users.fromJson(Map<String, dynamic> json) => _$UsersFromJson(json);
}
