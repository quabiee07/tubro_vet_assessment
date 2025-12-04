import 'dart:math';
import 'package:turbo_vets_assessment/features/messaging/domain/entities/message.dart';

class SupportAgentService {
  static const String agentName = 'Support Agent';
  
  // Preset responses
  static final List<String> _greetings = [
    'Hello! How can I assist you today?',
    'Hi there! What can I help you with?',
    'Welcome! I\'m here to help.',
    'Good day! How may I be of service?',
  ];

  static final List<String> _generalResponses = [
    'Thank you for your message. Let me help you with that.',
    'I understand. Let me look into this for you.',
    'That\'s a great question! Here\'s what I can tell you...',
    'I appreciate you reaching out. Here\'s some information that might help.',
  ];

  static final List<String> _helpResponses = [
    'I\'m here to help! Could you please provide more details?',
    'Sure, I can assist with that. What specifically do you need help with?',
    'I\'d be happy to help! Can you elaborate on your question?',
  ];

  static final List<String> _thankYouResponses = [
    'You\'re welcome! Is there anything else I can help you with?',
    'Happy to help! Let me know if you need anything else.',
    'Glad I could assist! Feel free to ask if you have more questions.',
    'My pleasure! Don\'t hesitate to reach out if you need more help.',
  ];

  static final List<String> _farewellResponses = [
    'Have a great day! Feel free to message anytime.',
    'Take care! I\'m here if you need anything else.',
    'Goodbye! Don\'t hesitate to reach out again.',
    'See you later! Happy to help anytime.',
  ];

  // Keywords for intelligent responses
  static final Map<String, List<String>> _keywordResponses = {
    // Greetings
    'hello|hi|hey|greetings': [
      'Hello! How can I help you today?',
      'Hi there! What brings you here?',
      'Hey! How may I assist you?',
    ],
    
    // Help keywords
    'help|assist|support|issue|problem': [
      'I\'m here to help! What seems to be the problem?',
      'I\'d be happy to assist. Can you describe the issue?',
      'Let me help you with that. What\'s going on?',
    ],
    
    // Thank you
    'thank|thanks|appreciate': [
      'You\'re very welcome!',
      'Happy to help!',
      'Anytime! That\'s what I\'m here for.',
    ],
    
    // Goodbye
    'bye|goodbye|see you|later': [
      'Goodbye! Have a wonderful day!',
      'Take care! Message me anytime.',
      'See you later! I\'m always here to help.',
    ],
    
    // Questions
    'how|what|when|where|why': [
      'That\'s a great question! Let me explain...',
      'Good question! Here\'s what you need to know...',
      'I can help clarify that for you.',
    ],
    
    // Appointment/Schedule
    'appointment|schedule|booking|visit': [
      'I can help you schedule an appointment. What date works best for you?',
      'Let me assist you with booking. When would you like to come in?',
      'I\'d be happy to help schedule a visit. What time frame are you looking at?',
    ],
    
    // Pricing
    'price|cost|fee|payment|charge': [
      'For pricing information, our services start at \$50. Would you like a detailed breakdown?',
      'Our pricing varies by service. Can you tell me which service you\'re interested in?',
      'I can provide cost estimates. What service are you inquiring about?',
    ],
    
    // Location
    'location|address|where are you|directions': [
      'We\'re located at 123 Main Street, Suite 100. Would you like directions?',
      'Our office is at 123 Main Street. We\'re open Monday-Friday, 9 AM - 5 PM.',
      'You can find us at 123 Main Street. Need help getting here?',
    ],
  };

  final Random _random = Random();

  /// Get a response based on user message
  Message getResponse(String userMessage) {
    final response = _generateSmartResponse(userMessage.toLowerCase());
    
    return Message(
      text: response,
      sender: agentName,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );
  }

  /// Get a delayed response (simulates typing delay)
  Future<Message> getDelayedResponse(String userMessage, {int minSeconds = 1, int maxSeconds = 3}) async {
    final delay = minSeconds + _random.nextInt(maxSeconds - minSeconds + 1);
    await Future.delayed(Duration(seconds: delay));
    return getResponse(userMessage);
  }

  /// Generate smart response based on keywords
  String _generateSmartResponse(String message) {
    // Check for keyword matches
    for (var entry in _keywordResponses.entries) {
      final keywords = entry.key.split('|');
      for (var keyword in keywords) {
        if (message.contains(keyword)) {
          final responses = entry.value;
          return responses[_random.nextInt(responses.length)];
        }
      }
    }

    // If no keyword match, return general response
    return _generalResponses[_random.nextInt(_generalResponses.length)];
  }

  /// Get a random greeting
  String getGreeting() {
    return _greetings[_random.nextInt(_greetings.length)];
  }

  String getFarewell() {
    return _farewellResponses[_random.nextInt(_farewellResponses.length)];
  }

  String getThankYouResponse() {
    return _thankYouResponses[_random.nextInt(_thankYouResponses.length)];
  }

  String getHelpResponse() {
    return _helpResponses[_random.nextInt(_helpResponses.length)];
  }

  /// Check if message is from agent
  bool isAgentMessage(String sender) {
    return sender == agentName;
  }
}

class ConversationContext {
  List<String> messageHistory = [];
  String? currentTopic;
  DateTime? lastMessageTime;
  
  void addMessage(String message) {
    messageHistory.add(message);
    if (messageHistory.length > 10) {
      messageHistory.removeAt(0); // Keep only last 10 messages
    }
    lastMessageTime = DateTime.now();
  }
  
  bool isRecentlyActive() {
    if (lastMessageTime == null) return false;
    return DateTime.now().difference(lastMessageTime!) < Duration(minutes: 5);
  }
}
