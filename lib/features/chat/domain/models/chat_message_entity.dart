/// Tipo de Mensagem no Chat
enum ChatMessageType {
  texto,
  audio,
  musicaCompartilhada,
  oportunidadeCompartilhada,
  perfilCompartilhado,
  arquivo,
}

/// Mensagem de Chat no PlayAuge
class ChatMessageEntity {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String text;
  final ChatMessageType type;
  final String? attachmentUrl;
  final String? attachmentTitle;
  final DateTime timestamp;
  final bool isRead;

  const ChatMessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.text,
    this.type = ChatMessageType.texto,
    this.attachmentUrl,
    this.attachmentTitle,
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'type': type.name,
      'attachmentUrl': attachmentUrl,
      'attachmentTitle': attachmentTitle,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory ChatMessageEntity.fromJson(Map<String, dynamic> json) {
    return ChatMessageEntity(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      text: json['text'] as String,
      type: ChatMessageType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => ChatMessageType.texto,
      ),
      attachmentUrl: json['attachmentUrl'] as String?,
      attachmentTitle: json['attachmentTitle'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }
}
