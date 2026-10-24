/// Status de Proposta e Contratação Profissional
enum ContractStatus {
  pendente,
  aceito,
  recusado,
  emNegociacao,
  concluido,
  cancelado;

  String get label {
    switch (this) {
      case ContractStatus.pendente:
        return 'Pendente';
      case ContractStatus.aceito:
        return 'Confirmado / Aceito';
      case ContractStatus.recusado:
        return 'Recusado';
      case ContractStatus.emNegociacao:
        return 'Em Negociação';
      case ContractStatus.concluido:
        return 'Trabalho Concluído';
      case ContractStatus.cancelado:
        return 'Cancelado';
    }
  }
}

/// Entidade de Convite de Trabalho / Proposta de Contratação
class ContractInviteEntity {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderAvatarUrl;
  final String recipientId;
  final String recipientName;
  final String? recipientAvatarUrl;
  final String eventName;
  final DateTime eventDate;
  final String eventTime;
  final String eventLocation;
  final String city;
  final String state;
  final double cacheAmount;
  final String? notes;
  final ContractStatus status;
  final DateTime createdAt;
  final double? counterOfferAmount; // Proposta de negociação

  const ContractInviteEntity({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderAvatarUrl,
    required this.recipientId,
    required this.recipientName,
    this.recipientAvatarUrl,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.eventLocation,
    required this.city,
    required this.state,
    required this.cacheAmount,
    this.notes,
    this.status = ContractStatus.pendente,
    required this.createdAt,
    this.counterOfferAmount,
  });

  ContractInviteEntity copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? senderAvatarUrl,
    String? recipientId,
    String? recipientName,
    String? recipientAvatarUrl,
    String? eventName,
    DateTime? eventDate,
    String? eventTime,
    String? eventLocation,
    String? city,
    String? state,
    double? cacheAmount,
    String? notes,
    ContractStatus? status,
    DateTime? createdAt,
    double? counterOfferAmount,
  }) {
    return ContractInviteEntity(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatarUrl: senderAvatarUrl ?? this.senderAvatarUrl,
      recipientId: recipientId ?? this.recipientId,
      recipientName: recipientName ?? this.recipientName,
      recipientAvatarUrl: recipientAvatarUrl ?? this.recipientAvatarUrl,
      eventName: eventName ?? this.eventName,
      eventDate: eventDate ?? this.eventDate,
      eventTime: eventTime ?? this.eventTime,
      eventLocation: eventLocation ?? this.eventLocation,
      city: city ?? this.city,
      state: state ?? this.state,
      cacheAmount: cacheAmount ?? this.cacheAmount,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      counterOfferAmount: counterOfferAmount ?? this.counterOfferAmount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatarUrl': senderAvatarUrl,
      'recipientId': recipientId,
      'recipientName': recipientName,
      'recipientAvatarUrl': recipientAvatarUrl,
      'eventName': eventName,
      'eventDate': eventDate.toIso8601String(),
      'eventTime': eventTime,
      'eventLocation': eventLocation,
      'city': city,
      'state': state,
      'cacheAmount': cacheAmount,
      'notes': notes,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'counterOfferAmount': counterOfferAmount,
    };
  }

  factory ContractInviteEntity.fromJson(Map<String, dynamic> json) {
    return ContractInviteEntity(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderAvatarUrl: json['senderAvatarUrl'] as String?,
      recipientId: json['recipientId'] as String,
      recipientName: json['recipientName'] as String,
      recipientAvatarUrl: json['recipientAvatarUrl'] as String?,
      eventName: json['eventName'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      eventTime: json['eventTime'] as String,
      eventLocation: json['eventLocation'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      cacheAmount: (json['cacheAmount'] as num).toDouble(),
      notes: json['notes'] as String?,
      status: ContractStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => ContractStatus.pendente,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      counterOfferAmount: (json['counterOfferAmount'] as num?)?.toDouble(),
    );
  }
}
