import 'package:playauge/features/chat/domain/models/chat_message_entity.dart';

abstract class ChatRepository {
  Future<List<ChatMessageEntity>> getMessages(String conversationId);
  Future<ChatMessageEntity> sendMessage(ChatMessageEntity message);
}

class ChatRepositoryImpl implements ChatRepository {
  final Map<String, List<ChatMessageEntity>> _messagesByConv = {
    'conv_pedro': [
      ChatMessageEntity(
        id: 'msg_1',
        conversationId: 'conv_pedro',
        senderId: 'user_pedro_santos',
        senderName: 'Pedro Santos',
        text: 'Fala João! Vi seu convite para o show na Villa Country. Já anotei o repertório!',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
      ),
      ChatMessageEntity(
        id: 'msg_2',
        conversationId: 'conv_pedro',
        senderId: 'user_joao_silva',
        senderName: 'João Silva',
        text: 'Show de bola Pedro! Passagem de som às 17h em ponto, beleza?',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      ChatMessageEntity(
        id: 'msg_3',
        conversationId: 'conv_pedro',
        senderId: 'user_pedro_santos',
        senderName: 'Pedro Santos',
        text: 'Combinado meu amigo, estarei lá!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 50)),
        isRead: false,
      ),
    ],
  };

  @override
  Future<List<ChatMessageEntity>> getMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _messagesByConv[conversationId] ?? [];
  }

  @override
  Future<ChatMessageEntity> sendMessage(ChatMessageEntity message) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final list = _messagesByConv.putIfAbsent(message.conversationId, () => []);
    list.add(message);
    return message;
  }
}
