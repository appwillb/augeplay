/// Hierarquia de Falhas e Erros de Domínio
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Ocorreu um erro no servidor. Tente novamente mais tarde.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'E-mail ou senha incorretos.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Item não encontrado.']);
}
