// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UsersImpl _$$UsersImplFromJson(Map<String, dynamic> json) => _$UsersImpl(
      id: (json['Id'] as num?)?.toInt(),
      associatedClient: json['AssociatedClient'] as String?,
      associatedContract: json['AssociatedContract'] as String?,
      lawyer: json['Lawyer'] as String?,
      beneficiaryName: json['BeneficiaryName'] as String?,
      founders: json['Founders'] as String?,
      director: json['Director'] as String?,
      partiesOfDispute: json['PartiesOfDispute'] as String?,
      associatedCompanies: json['AssociatedCompanies'] as String?,
      associatedCases: json['AssociatedCases'] as String?,
      createdBy: json['createdBy'] as String?,
    );

Map<String, dynamic> _$$UsersImplToJson(_$UsersImpl instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'AssociatedClient': instance.associatedClient,
      'AssociatedContract': instance.associatedContract,
      'Lawyer': instance.lawyer,
      'BeneficiaryName': instance.beneficiaryName,
      'Founders': instance.founders,
      'Director': instance.director,
      'PartiesOfDispute': instance.partiesOfDispute,
      'AssociatedCompanies': instance.associatedCompanies,
      'AssociatedCases': instance.associatedCases,
      'createdBy': instance.createdBy,
    };
