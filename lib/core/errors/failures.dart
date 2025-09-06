abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message, {super.code});
}

class AuthorizationFailure extends Failure {
  const AuthorizationFailure(super.message, {super.code});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.code});
}

class DuplicateEntryFailure extends Failure {
  const DuplicateEntryFailure(super.message, {super.code});
}

class OrganMatchingFailure extends Failure {
  const OrganMatchingFailure(super.message, {super.code});
}

class HospitalAccessFailure extends Failure {
  const HospitalAccessFailure(super.message, {super.code});
}
