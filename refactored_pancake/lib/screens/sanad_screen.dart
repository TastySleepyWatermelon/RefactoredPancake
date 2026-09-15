import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/pill_model.dart';
import '../models/visit_model.dart';
import '../services/ai_service.dart';
import '../services/pill_service.dart';
import '../services/visit_service.dart';

enum _Role { user, assistant, error }

class _ChatMessage {
  _ChatMessage({required this.role, required this.text});
  final _Role role;
  final String text;
}

class SanadScreen extends StatefulWidget {
  const SanadScreen({super.key});

  @override
  State<SanadScreen> createState() => _SanadScreenState();
}

class _SanadScreenState extends State<SanadScreen> {
  final _pillService = PillService();
  final _visitService = VisitService();
  final _aiService = AiService();
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  static const _quickPrompts = [
    "What does Dad need today?",
    "Who's responsible tonight?",
    'What did we miss yesterday?',
  ];

  final List<_ChatMessage> _messages = [];
  bool _isSending = false;
  late String _dailySummary;
  late String _systemPrompt;

  ColorScheme get _colors => Theme.of(context).colorScheme;

  @override
  void initState() {
    super.initState();
    final pills = _pillService.getPills();
    final visits = _visitService.getVisits();
    _dailySummary = _buildDailySummary(pills, visits);
    _systemPrompt = _buildSystemPrompt(pills, visits);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _aiService.dispose();
    super.dispose();
  }

  String _buildSystemPrompt(List<PillModel> pills, List<VisitModel> visits) {
    final pillsContext = pills.isEmpty
        ? 'No medications recorded.'
        : pills
            .map((p) =>
                '- ${p.medicationName} (${p.dosage}, ${p.tablets} tablet(s)) '
                'at ${p.time}. Status: ${p.isTaken ? "Taken" : "Not taken"}')
            .join('\n');

    final visitsContext = visits.isEmpty
        ? 'No visits scheduled.'
        : visits
            .map((v) =>
                '- ${v.visitName} with ${v.doctorName} on ${v.day} '
                '${v.month} at ${v.time}. '
                'Status: ${v.isHandled ? "Handled" : "Pending"}')
            .join('\n');

    return 'You are Sanad, a helpful family-care coordination assistant '
        'inside the CareCircle app. Answer briefly and warmly.\n\n'
        'The lists below have already been fetched for you — they are the '
        'current, real data, not a sample. Always answer directly from '
        'them; never say you cannot access, fetch, or retrieve the data, '
        'since it is already provided here.\n\n'
        'All Pills / Medications:\n$pillsContext\n\n'
        'All Scheduled Visits:\n$visitsContext';
  }

  String _buildDailySummary(List<PillModel> pills, List<VisitModel> visits) {
    if (pills.isEmpty && visits.isEmpty) {
      return "No medications or visits are logged yet — add one to see a "
          'summary here.';
    }

    final pillsRemaining = pills.where((p) => !p.isTaken).length;
    final visitsPending = visits.where((v) => !v.isHandled).length;

    final parts = <String>[];
    if (pills.isNotEmpty) {
      parts.add('Dad has $pillsRemaining of ${pills.length} '
          'medication${pills.length == 1 ? '' : 's'} left today.');
    }
    if (visitsPending > 0) {
      parts.add('$visitsPending visit${visitsPending == 1 ? '' : 's'} '
          'still need${visitsPending == 1 ? 's' : ''} scheduling attention.');
    }
    if (parts.isEmpty) {
      return 'Everything looks on track for today.';
    }
    return parts.join(' ');
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _isSending) return;

    final history = _messages
        .where((m) => m.role != _Role.error)
        .map((m) => {
              'role': m.role == _Role.user ? 'user' : 'assistant',
              'content': m.text,
            })
        .toList();

    setState(() {
      _messages.add(_ChatMessage(role: _Role.user, text: trimmed));
      _isSending = true;
    });
    _inputController.clear();
    _scrollToBottom();

    try {
      final reply = await _aiService.sendMessage(
        systemPrompt: _systemPrompt,
        history: history,
        message: trimmed,
      );
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage(role: _Role.assistant, text: reply));
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMessage(
          role: _Role.error,
          text: "Sanad couldn't respond, try again",
        ));
      });
    } finally {
      if (mounted) setState(() => _isSending = false);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSummaryCard(),
            Expanded(child: _buildChatList()),
            _buildQuickActions(),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _colors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.eco_outlined, color: _colors.onPrimary),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sanad',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _colors.onSurface,
                ),
              ),
              Text(
                'Care Assistant',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: _colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _colors.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🌿', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _dailySummary,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: _colors.onPrimaryContainer,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList() {
    final itemCount = _messages.length + (_isSending ? 1 : 0);
    if (itemCount == 0) {
      return Center(
        child: Text(
          'Ask Sanad anything about today\'s care plan.',
          style: GoogleFonts.inter(color: _colors.onSurfaceVariant),
        ),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index >= _messages.length) {
          return _buildTypingBubble();
        }
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  Widget _buildAssistantAvatar() {
    return Container(
      width: 28,
      height: 28,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: _colors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.smart_toy_outlined,
          size: 16, color: _colors.onPrimary),
    );
  }

  Widget _buildMessageBubble(_ChatMessage message) {
    final isUser = message.role == _Role.user;
    final isError = message.role == _Role.error;

    final bubbleColor = isUser
        ? _colors.primary
        : isError
            ? _colors.errorContainer
            : _colors.surfaceContainerHighest;
    final textColor = isUser
        ? _colors.onPrimary
        : isError
            ? _colors.onErrorContainer
            : _colors.onSurface;

    final bubble = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.72,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          message.text,
          style: GoogleFonts.inter(fontSize: 14, color: textColor),
        ),
      ),
    );

    if (isUser) {
      return Align(alignment: Alignment.centerRight, child: bubble);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAssistantAvatar(),
        Flexible(child: bubble),
      ],
    );
  }

  Widget _buildTypingBubble() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAssistantAvatar(),
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14),
          ),
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _colors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _quickPrompts.map((prompt) {
          return OutlinedButton(
            onPressed: _isSending ? null : () => _send(prompt),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: _colors.outlineVariant),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            child: Text(
              prompt,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: _colors.onSurfaceVariant,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: _colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _inputController,
                textInputAction: TextInputAction.send,
                onSubmitted: _send,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Ask Sanad…',
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: _colors.primary,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _isSending ? null : () => _send(_inputController.text),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(Icons.send_rounded,
                    size: 20, color: _colors.onPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
