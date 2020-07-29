// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// FirestoreDocumentGenerator
// **************************************************************************

User _$userFromSnapshot(DocumentSnapshot snapshot) {
  return User(
    selfRef: snapshot.reference, // ignoring attribute 'List<String> roles'
    firstName: snapshot.data["firstName"] is String
        ? snapshot.data["firstName"]
        : snapshot.data["firstName"].toString(),
    lastName: snapshot.data["lastName"] is String
        ? snapshot.data["lastName"]
        : snapshot.data["lastName"].toString(),
    email: snapshot.data["email"] is String
        ? snapshot.data["email"]
        : snapshot.data["email"].toString(),
    phone: snapshot.data["phone"] is String
        ? snapshot.data["phone"]
        : snapshot.data["phone"].toString(),
    label: snapshot.data["label"] is String
        ? snapshot.data["label"]
        : snapshot.data["label"].toString(),
  );
}

User _$userFromMap(Map<String, dynamic> data) {
  return User(
    // ignoring attribute 'List<String> roles'
    firstName: data["firstName"] is String
        ? data["firstName"]
        : data["firstName"].toString(),
    lastName: data["lastName"] is String
        ? data["lastName"]
        : data["lastName"].toString(),
    email: data["email"] is String ? data["email"] : data["email"].toString(),
    phone: data["phone"] is String ? data["phone"] : data["phone"].toString(),
    label: data["label"] is String ? data["label"] : data["label"].toString(),
  );
}

Map<String, dynamic> _$userToMap(User model) {
  return <String, dynamic>{
    // ignoring attribute 'List<String> roles'
    "firstName": model.firstName,
    "lastName": model.lastName,
    "email": model.email,
    "phone": model.phone,
    "label": model.label,
  };
}

UserRole _$userRoleFromSnapshot(DocumentSnapshot snapshot) {
  return UserRole(
    label: snapshot.data["label"] is String
        ? snapshot.data["label"]
        : snapshot.data["label"].toString(),
  );
}

UserRole _$userRoleFromMap(Map<String, dynamic> data) {
  return UserRole(
    label: data["label"] is String ? data["label"] : data["label"].toString(),
  );
}

Map<String, dynamic> _$userRoleToMap(UserRole model) {
  return <String, dynamic>{
    "label": model.label,
  };
}
