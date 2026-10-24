/// Papéis/Funções Profissionais na Plataforma Musical PlayAuge
enum UserRole {
  artista,
  musico,
  compositor,
  produtor,
  profissional;

  String get label {
    switch (this) {
      case UserRole.artista:
        return 'Artista / Cantor / Banda';
      case UserRole.musico:
        return 'Músico Instrumentista';
      case UserRole.compositor:
        return 'Compositor';
      case UserRole.produtor:
        return 'Produtor Musical';
      case UserRole.profissional:
        return 'Profissional Técnico';
    }
  }

  String get shortLabel {
    switch (this) {
      case UserRole.artista:
        return 'Artista';
      case UserRole.musico:
        return 'Músico';
      case UserRole.compositor:
        return 'Compositor';
      case UserRole.produtor:
        return 'Produtor';
      case UserRole.profissional:
        return 'Profissional';
    }
  }

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.name.toLowerCase() == value.toLowerCase() || role.shortLabel.toLowerCase() == value.toLowerCase(),
      orElse: () => UserRole.musico,
    );
  }
}
