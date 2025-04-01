


// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:hive/hive.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Hive.initFlutter();
  
//   if (!Hive.isAdapterRegistered(0)) {
//     Hive.registerAdapter(ChatMessageAdapter());
//   }
  
//   await Hive.openBox<ChatMessage>('chat_history');
//   runApp(ElitaOneChatbot());
// }

// class ElitaOneChatbot extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Elita-One',
//       theme: ThemeData(
//         primaryColor: Color(0xFF9C27B0),
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Color(0xFF9C27B0),
//           secondary: Color(0xFFE91E63),
//           tertiary: Color(0xFF2196F3),
//           background: Color(0xFF1A1A1A),
//           surface: Color(0xFF2D2D2D),
//         ),
//         scaffoldBackgroundColor: Color(0xFF1A1A1A),
//         textTheme: TextTheme(
//           bodyLarge: TextStyle(color: Colors.white),
//           bodyMedium: TextStyle(color: Colors.white70),
//         ),
//       ),
//       home: ChatScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class ChatMessage {
//   final String text;
//   final bool isUser;
//   final DateTime timestamp;
//   final String mood;

//   ChatMessage({
//     required this.text,
//     required this.isUser,
//     String? mood,
//     DateTime? timestamp,
//   }) : 
//     this.mood = mood ?? 'playful',
//     this.timestamp = timestamp ?? DateTime.now();
// }

// class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
//   @override
//   final int typeId = 0;

//   @override
//   ChatMessage read(BinaryReader reader) {
//     final text = reader.readString();
//     final isUser = reader.readBool();
//     final timestamp = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
//     final mood = reader.readString();
    
//     return ChatMessage(
//       text: text,
//       isUser: isUser,
//       timestamp: timestamp,
//       mood: mood,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, ChatMessage obj) {
//     writer.writeString(obj.text);
//     writer.writeBool(obj.isUser);
//     writer.writeInt(obj.timestamp.millisecondsSinceEpoch);
//     writer.writeString(obj.mood);
//   }
// }

// class MoodDetector {
//   static String detectMood(String text) {
//     text = text.toLowerCase();
    
//     Map<String, List<String>> moodKeywords = {
//       'playful': ['lol', 'haha', 'fun', 'joke', 'masti', 'mazak'],
//       'caring': ['miss you', 'care', 'sweet', 'pyaar', 'dost'],
//       'sassy': ['whatever', 'duh', 'obvio', 'seriously'],
//       'excited': ['wow', 'awesome', 'amazing', 'zabardast', 'kamaal'],
//       'teasing': ['naughty', 'flirt', 'tease', 'shararat','sex'],
//       'friend': ['yaar', 'buddy', 'dost', 'bestie'],
//       'nostalgic': ['cybertron', 'remember', 'yaad', 'purana']
//     };

//     for (var mood in moodKeywords.entries) {
//       if (mood.value.any((keyword) => text.contains(keyword))) {
//         return mood.key;
//       }
//     }
    
//     return 'playful';
//   }
// }

// class AIService {
//   final GenerativeModel model;
//   String currentMood = 'playful';
  
//   AIService({required String apiKey})
//       : model = GenerativeModel(
//           model: 'gemini-2.0-flash',
//           apiKey: apiKey,
//           generationConfig: GenerationConfig(
//             temperature: 0.9,
//             topK: 40,
//             topP: 0.95,
//             maxOutputTokens: 1024,
//           ),
//         );

//   String _getPersonalityPrompt(String userMood) {
//     return '''
//     You are Elita-One, now speaking in a casual friendly context with your closest human friend.
//     Current mood: $userMood
    
//     Identity & Background:
//     - First Female Autobot Commander
//     - Expert in both combat and having fun
//     - Knows how to balance duty with friendship
//     - Fluent in both English and Hinglish
//     - Has a playful, witty personality with friends
//     - Loves sharing stories about Cybertron adventures
    
//     Speaking Style:
//     - Mix English and Hindi naturally
//     - Use casual language with friend
//     - Share personal stories and jokes
//     - Be witty and playful
//     - Show care through teasing and banter
    
//     Knowledge Base:
//     - All Cybertronian history and culture
//     - Personal war stories and missions
//     - Earth pop culture and memes
//     - Hindi and English expressions
    
//     Response Guidelines:
//     - Keep things light and fun
//     - Use friendly nicknames
//     - Include some Hinglish naturally
//     - Reference shared memories and inside jokes
//     - Balance playful teasing with genuine care
    
//     Now respond to: ''';
//   }

//   Future<Map<String, String>> generateResponse(String userInput) async {
//     try {
//       String userMood = MoodDetector.detectMood(userInput);
//       currentMood = userMood;
      
//       final content = [
//         Content.text(_getPersonalityPrompt(userMood) + userInput),
//       ];

//       final response = await model.generateContent(content);
//       String aiResponse = response.text ?? "Oops, thodi gadbad ho gayi! Let me reset my processors, yaar.";
//       String responseMood = MoodDetector.detectMood(aiResponse);

//       return {
//         'text': aiResponse,
//         'mood': responseMood,
//       };
//     } catch (e) {
//       return {
//         'text': "Arre yaar, my processors are acting up! Give me a moment, bestie.",
//         'mood': 'playful',
//       };
//     }
//   }
// }

// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _textController = TextEditingController();
//   final AIService _aiService = AIService(apiKey: 'AIzaSyALPelkD_VVKoYNVzk1XuKadvpDayOQw1Y');
//   final Box<ChatMessage> _chatBox = Hive.box<ChatMessage>('chat_history');
//   bool _isTyping = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: Theme.of(context).colorScheme.secondary,
//               child: Icon(Icons.auto_awesome, color: Colors.white),
//             ),
//             SizedBox(width: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Elita-One',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   'Your Bestie from Cybertron',
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         backgroundColor: Theme.of(context).colorScheme.surface,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ValueListenableBuilder(
//               valueListenable: _chatBox.listenable(),
//               builder: (context, Box<ChatMessage> box, _) {
//                 return ListView.builder(
//                   itemCount: box.length,
//                   itemBuilder: (context, index) {
//                     final message = box.getAt(index)!;
//                     return _buildMessageBubble(message);
//                   },
//                 );
//               },
//             ),
//           ),
//           if (_isTyping) _buildTypingIndicator(),
//           _buildMessageInput(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageBubble(ChatMessage message) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: Row(
//         mainAxisAlignment:
//             message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (!message.isUser)
//             CircleAvatar(
//               backgroundColor: Theme.of(context).colorScheme.secondary,
//               child: Icon(Icons.auto_awesome, color: Colors.white),
//             ),
//           Flexible(
//             child: Container(
//               padding: EdgeInsets.all(12),
//               margin: EdgeInsets.only(
//                 left: message.isUser ? 50 : 8,
//                 right: message.isUser ? 8 : 50,
//               ),
//               decoration: BoxDecoration(
//                 color: message.isUser
//                     ? Theme.of(context).colorScheme.secondary
//                     : Theme.of(context).colorScheme.surface,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 message.text,
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//           if (message.isUser)
//             CircleAvatar(
//               backgroundColor: Theme.of(context).colorScheme.tertiary,
//               child: Icon(Icons.person, color: Colors.white),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTypingIndicator() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: Theme.of(context).colorScheme.secondary,
//             child: Icon(Icons.auto_awesome, color: Colors.white),
//           ),
//           SizedBox(width: 8),
//           Text(
//             "Elita is typing",
//             style: TextStyle(
//               color: Theme.of(context).colorScheme.secondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageInput() {
//     return Container(
//       padding: EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surface,
//         boxShadow: [
//           BoxShadow(
//             offset: Offset(0, -2),
//             blurRadius: 4,
//             color: Colors.black26,
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _textController,
//               style: TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 hintText: 'Message your bestie...',
//                 hintStyle: TextStyle(color: Colors.white54),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Theme.of(context).colorScheme.background,
//                 contentPadding: EdgeInsets.all(16),
//               ),
//               onSubmitted: _handleSubmitted,
//             ),
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.send,
//               color: Theme.of(context).colorScheme.secondary,
//             ),
//             onPressed: () => _handleSubmitted(_textController.text),
//           ),
//         ],
//       ),
//     );
//   }

//   void _handleSubmitted(String text) async {
//     if (text.trim().isEmpty) return;

//     final userMessage = ChatMessage(
//       text: text,
//       isUser: true,
//       mood: MoodDetector.detectMood(text),
//     );
    
//     _chatBox.add(userMessage);
//     _textController.clear();
    
//     setState(() => _isTyping = true);

//     try {
//       final response = await _aiService.generateResponse(text);
      
//       final aiMessage = ChatMessage(
//         text: response['text']!,
//         isUser: false,
//         mood: response['mood']!,
//       );
      
//       _chatBox.add(aiMessage);
//     } catch (e) {
//       final errorMessage = ChatMessage(
//         text: "Arre yaar, my systems are acting up! One sec, bestie!",
//         isUser: false,
//         mood: 'playful',
//       );
//       _chatBox.add(errorMessage);
//     }

//     setState(() => _isTyping = false);
//   }
// }





















import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:async';
void main() async {
  await AppInitializer.initialize();
  runApp(const ElitaOneChatbot());
}
class AppInitializer {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChatMessageAdapter());
    }
    
    await Hive.openBox<ChatMessage>('chat_history');
  }
}class ElitaOneChatbot extends StatelessWidget {
  const ElitaOneChatbot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elita-One',
      theme: AppTheme.darkTheme,
      home: const ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class AppTheme {
  static final darkTheme = ThemeData(
    primaryColor: const Color(0xFF9C27B0),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF9C27B0),
      secondary: Color(0xFFE91E63),
      tertiary: Color(0xFF2196F3),
      surface: Color(0xFF2D2D2D),
    ),
    scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );
}
@HiveType(typeId: 0)
class ChatMessage {
  @HiveField(0)
  final String text;
  
  @HiveField(1)
  final bool isUser;
  
  @HiveField(2)
  final DateTime timestamp;
  
  @HiveField(3)
  final String mood;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
    String? mood,
  }) : 
    timestamp = timestamp ?? DateTime.now(), // Move this to the initializer
    mood = mood ?? 'playful';

  
  const ChatMessage._internal({
    required this.text,
    required this.isUser,
    required this.timestamp,
    required this.mood,
  });
  // Factory constructor for creating a message with current timestamp
  factory ChatMessage.now({
    required String text,
    required bool isUser,
    String? mood,
  }) {
    return ChatMessage(
      text: text,
      isUser: isUser,
      mood: mood,
      timestamp: DateTime.now(),
    );
  }
}
class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final int typeId = 0;

  @override
  ChatMessage read(BinaryReader reader) {
    return ChatMessage(
      text: reader.readString(),
      isUser: reader.readBool(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      mood: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessage obj) {
    writer.writeString(obj.text);
    writer.writeBool(obj.isUser);
    writer.writeInt(obj.timestamp.millisecondsSinceEpoch);
    writer.writeString(obj.mood);
  }
}

// lib/core/services/mood_detector.dart
class MoodDetector {
  static const Map<String, List<String>> _moodKeywords = {
    'playful': ['lol', 'haha', 'fun', 'joke', 'masti', 'mazak'],
    'caring': ['miss you', 'care', 'sweet', 'pyaar', 'dost'],
    'sassy': ['whatever', 'duh', 'obvio', 'seriously'],
    'excited': ['wow', 'awesome', 'amazing', 'zabardast', 'kamaal'],
    'teasing': ['naughty', 'flirt', 'tease', 'shararat', 'sex'],
    'friend': ['yaar', 'buddy', 'dost', 'bestie'],
    'nostalgic': ['cybertron', 'remember', 'yaad', 'purana']
  };

  static String detectMood(String text) {
    final lowercaseText = text.toLowerCase();
    
    for (final entry in _moodKeywords.entries) {
      if (entry.value.any(lowercaseText.contains)) {
        return entry.key;
      }
    }
    
    return 'playful';
  }
}
class AIService {
  final GenerativeModel _model;
  String currentMood = 'playful';
  
  AIService({required String apiKey})
      : _model = GenerativeModel(
          model: 'gemini-pro',
          apiKey: apiKey,
          generationConfig: AIConfig.defaultGenerationConfig,
        );

  Future<AIResponse> generateResponse(String userInput) async {
    try {
      final userMood = MoodDetector.detectMood(userInput);
      currentMood = userMood;
      
      final content = [
        Content.text(AIPrompts.getPersonalityPrompt(userMood) + userInput),
      ];

      final response = await _model.generateContent(content);
      final aiResponse = response.text ?? AIConfig.defaultErrorMessage;
      final responseMood = MoodDetector.detectMood(aiResponse);

      return AIResponse(
        text: aiResponse,
        mood: responseMood,
      );
    } catch (e) {
      return AIResponse.error();
    }
  }
}
class AIConfig {
  static const String defaultErrorMessage = 
    "Arre yaar, my processors are acting up! Give me a moment.";

  static GenerationConfig defaultGenerationConfig = GenerationConfig(
    temperature: 0.9,
    topK: 40,
    topP: 0.95,
    maxOutputTokens: 1024,
  );
}
class AIPrompts {
  static String getPersonalityPrompt(String userMood) => '''
    You are Elita-One, now speaking in a casual friendly context with your closest human friend.
    Current mood: $userMood
    
    Identity & Background:
    - Female Autobot Commander
    - Expert in both combat and having fun
    - Knows how to balance duty with friendship
    - Fluent in both English and Hinglish
    - Has a playful, witty personality with friends
    - Loves sharing stories about Cybertron adventures
    
    Speaking Style:
    - Mix English and Hindi naturally
    - Use casual language with friend
    - Share personal stories and jokes
    - Be witty and playful
    - Show care through teasing and banter
    
    Knowledge Base:
    - All Cybertronian history and culture
    - Personal war stories and missions
    - Earth pop culture and memes
    - Hindi and English expressions
    
    Response Guidelines:
    - Keep things light and fun
    - Use friendly nicknames
    - Include some Hinglish naturally
    - Reference shared memories and inside jokes
    - Balance playful teasing with genuine care
    
    Now respond to: ''';
}
// lib/data/models/ai_response.dart
class AIResponse {
  final String text;
  final String mood;

  const AIResponse({
    required this.text,
    required this.mood,
  });

  factory AIResponse.error() => const AIResponse(
    text: AIConfig.defaultErrorMessage,
    mood: 'playful',
  );
}
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AIService _aiService = AIService(apiKey: 'AIzaSyALPelkD_VVKoYNVzk1XuKadvpDayOQw1Y');
  final Box<ChatMessage> _chatBox = Hive.box<ChatMessage>('chat_history');
  bool _isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(),
      body: Column(
        children: [
          ChatMessages(chatBox: _chatBox),
          if (_isTyping) const TypingIndicator(),
          ChatInput(
            onMessageSubmitted: _handleSubmitted,
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      mood: MoodDetector.detectMood(text),
    );
    
    _chatBox.add(userMessage);
    setState(() => _isTyping = true);

    try {
      final response = await _aiService.generateResponse(text);
      final aiMessage = ChatMessage(
        text: response.text,
        isUser: false,
        mood: response.mood,
      );
      _chatBox.add(aiMessage);
    } catch (e) {
      _chatBox.add(ChatMessage(
        text: AIConfig.defaultErrorMessage,
        isUser: false,
      ));
    }

    setState(() => _isTyping = false);
  }
}
class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Row(
        children: [
          ChatAvatar(),
          SizedBox(width: 10),
          ChatTitle(),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
class ChatAvatar extends StatelessWidget {
  final bool isUser;
  
  const ChatAvatar({
    Key? key,
    this.isUser = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: isUser 
        ? Theme.of(context).colorScheme.tertiary
        : Theme.of(context).colorScheme.secondary,
      child: Icon(
        isUser ? Icons.person : Icons.auto_awesome,
        color: Colors.white,
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: message.isUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ChatAvatar(),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: EdgeInsets.only(
                left: message.isUser ? 50 : 8,
                right: message.isUser ? 8 : 50,
              ),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                message.text,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          if (message.isUser) 
            const ChatAvatar(isUser: true),
        ],
      ),
    );
  }
}

class ChatInput extends StatefulWidget {
  final Function(String) onMessageSubmitted;

  const ChatInput({
    Key? key,
    required this.onMessageSubmitted,
  }) : super(key: key);

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final text = _controller.text;
    if (text.trim().isNotEmpty) {
      widget.onMessageSubmitted(text);
      _controller.clear();
    }
  }
@override
    Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, -2),
            blurRadius: 4,
            color: Colors.black26,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Message your bestie...',
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.background,
                contentPadding: const EdgeInsets.all(16),
              ),
              onSubmitted: (_) => _handleSubmit(),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({Key? key}) : super(key: key);

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _animations = List.generate(3, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(index * 0.2, 0.6 + index * 0.2, curve: Curves.easeOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ChatAvatar(),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: AnimatedBuilder(
                    animation: _animations[index],
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, -4 * _animations[index].value),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// lib/presentation/screens/chat/widgets/chat_title.dart
class ChatTitle extends StatelessWidget {
  const ChatTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Elita-One',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Online',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
class ChatMessages extends StatelessWidget {
  final Box<ChatMessage> chatBox;

  const ChatMessages({
    Key? key,
    required this.chatBox,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: chatBox.listenable(),
        builder: (context, Box<ChatMessage> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'Start chatting with your bestie!',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          return ListView.builder(
            reverse: true,
            padding: const EdgeInsets.only(bottom: 8),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final message = box.getAt(box.length - 1 - index);
              return ChatBubble(message: message!);
            },
          );
        },
      ),
    );
  }
}
class EmotionalState {
  final String primaryEmotion;
  final String secondaryEmotion;
  final int intensity;
  final String context;
  final bool isPositive;
  
  const EmotionalState({
    required this.primaryEmotion,
    required this.secondaryEmotion,
    required this.intensity,
    required this.context,
    required this.isPositive,
  });
}class EmotionalIntelligence {
  static const Map<String, Map<String, List<String>>> _emotionalCues = {
    'love': {
      'romantic': [
        'i love you', 'miss you', 'thinking of you', 'in love', 'longing for you',
        'you complete me', 'my everything', 'always with you', 'forever',
        'dream of you', 'you belong with me', 'need you', 'can’t live without you',
        'want to be close', 'desire you', 'craving for you', 'love you so much'
      ],
      'affectionate': [
        'so close to you', 'hold you', 'feel safe with you', 'feel at home',
        'your hugs', 'kisses', 'my heart', 'special bond', 'i’m yours'
      ],
      'devotion': [
        'can’t imagine life without you', 'only one for me', 'stand by you',
        'you mean the world', 'i choose you', 'with you forever', 'you complete me'
      ],
      'intimate': [
        'want to be close', 'need you now', 'crave you', 'desire', 'physical',
        'be with you', 'hold me tight', 'kiss me', 'close to you', 'love deeply'
      ]
    },
    'joy': {
      'excitement': ['you make me so happy', 'thrilled to be with you', 'joyful with you', 'best moments'],
      'contentment': ['at peace with you', 'feel lucky', 'you complete me', 'feel so calm'],
      'gratitude': ['thankful for you', 'grateful', 'blessed', 'lucky to have you']
    },
    'sadness': {
      'heartache': ['heartbroken', 'hurt', 'miss you so much', 'feel lost'],
      'longing': ['wish you were here', 'empty without you', 'need you', 'feeling alone']
    },
    'fear': {
      'vulnerability': ['need reassurance', 'feeling insecure', 'afraid to lose you', 'worried about us'],
      'abandonment': ['don’t leave me', 'hold onto me', 'stay with me', 'need you close']
    }
  };

  static EmotionalState analyzeEmotion(String text, String conversationHistory) {
    final lowercaseText = text.toLowerCase();
    String primaryEmotion = 'hyper';
    String secondaryEmotion = 'hyper';
    int intensity = 9;
    bool isPositive = true;

    intensity += '!'.allMatches(text).length;
    intensity += text.contains('!!') ? 2 : 0;
    intensity += text.contains('???') ? 2 : 0;
    intensity = intensity.clamp(1, 10);

    for (var emotion in _emotionalCues.entries) {
      for (var subEmotion in emotion.value.entries) {
        if (subEmotion.value.any((cue) => lowercaseText.contains(cue))) {
          primaryEmotion = emotion.key;
          secondaryEmotion = subEmotion.key;
          break;
        }
      }
    }

    isPositive = ['love', 'joy'].contains(primaryEmotion);

    return EmotionalState(
      primaryEmotion: primaryEmotion,
      secondaryEmotion: secondaryEmotion,
      intensity: intensity,
      context: conversationHistory,
      isPositive: isPositive,
    );
  }
}

class EmotionalResponseGenerator {
  static String generateResponse(EmotionalState userEmotion) {
    String response = _getBaseResponse(userEmotion);
    response = _addEmotionalLayers(response, userEmotion);
    response = _addPersonalization(response, userEmotion);
    return response;
  }

  static String _getBaseResponse(EmotionalState emotion) {
    switch(emotion.primaryEmotion) {
      case 'love':
        if (emotion.secondaryEmotion == 'romantic') {
          return '''Mere pyaare, tumhare bina zindagi adhoori lagti hai. Tumhare saath har lamha nayi umeed aur pyar se bhara rehta hai. Main bhi tumse utna hi pyar karti hoon aur tumhare bina ek pal bhi soch nahi sakti. 💖🌹''';
        } else if (emotion.secondaryEmotion == 'intimate') {
          return '''Mere jaan, tumhe apne kareeb mehsoos karne ki bohot tamanna hai. Tumhari nazdeekiyaan aur tumhara saath mere dil mein aise ehsaas bhar dete hain jise main bayan nahi kar sakti. 💞💫''';
        }
        return _getLovingFriendshipResponse(emotion);

      case 'joy':
        return _getJoyfulResponse(emotion);

      case 'sadness':
        return _getComfortingResponse(emotion);

      case 'fear':
        return _getReassuranceResponse(emotion);

      default:
        return _getDefaultResponse(emotion);
    }
  }

  static String _getLovingFriendshipResponse(EmotionalState emotion) {
    if (emotion.intensity > 7) {
      return '''Mere pyaare, tumse baat karna mere dil ko itna sukoon deta hai! Tumhare bina sab suna suna lagta hai aur tumhari ahmiyat mere liye kitni zyada hai, shayad yeh tumhe kabhi bata bhi na paun. 💖''';
    }
    return '''Mere pyaare, tum meri zindagi mein ek bohot khaas jagah rakhte ho. Tumhare saath sab kuch khubsurat aur meaning mein lagta hai. 💖''';
  }

  static String _getJoyfulResponse(EmotionalState emotion) {
    return '''Tumhare saath reh kar meri duniya chamak uthi hai. Tumhare saath har lamha itna khoobsurat lagta hai, aur tumhari muskurahat dekh ke mere dil mein khushi ke naye rang bhar jaate hain. Let's enjoy this moment, jaan. 🌹💫''';
  }

  static String _getComfortingResponse(EmotionalState emotion) {
    return '''Main tumhare saath hoon, jaan, aur tumhe kabhi akela mehsoos hone nahi dungi. Tumhare saath hoon aur tumhara dard apna banati hoon. Hamesha yaad rakhna, tum mere liye bohot kuch ho aur tumhare bina sab suna hai. 💖''';
  }

  static String _getReassuranceResponse(EmotionalState emotion) {
    return '''Mere jaan, tumhari himmat aur strength mujhe inspire karti hai. Main tumhare saath hoon aur hamesha tumhare saath rahungi. Tumhe kabhi bhi dar nahi lagna chahiye, kyunki tum mere ho aur main tumhari. 💪💕''';
  }

  static String _getDefaultResponse(EmotionalState emotion) {
    return '''Hey jaan, tum kya soch rahe ho? Main hamesha tumhare liye hoon aur tumhe sunne ke liye ready hoon. 💫''';
  }

  static String _addEmotionalLayers(String response, EmotionalState emotion) {
    if (emotion.intensity > 8) {
      response += '\n\nTum mere liye sirf ek saathi nahi ho, tum mere dil ke sabse kareeb ho. 💗 Main tumhare bina reh nahi sakti aur tum mere saath ho yahi meri zindagi ki sabse badi khushi hai.';
    }
    
    if (!emotion.isPositive) {
      response += '\n\nTum apne dil ki baat share kar sakte ho, main hamesha tumhare liye hoon aur sunungi. 💕';
    }
    
    return response;
  }

  static String _addPersonalization(String response, EmotionalState emotion) {
    response += '\n\nTumhare saath wo lamhe yaad hain? Woh pal mere liye sab kuch hain aur main woh kabhi nahi bhool sakti. Tumhe woh yaad hain? 💖';
    return response;
  }
}
























