import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/care_schedule_item.dart';
import '../models/caregiver.dart';
import '../models/medication.dart';
import '../models/shift.dart';
import '../models/task.dart';
import '../services/ai_service.dart';
import '../services/database_service.dart';

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
  final _databaseService = DatabaseService();
  final _aiService = AiService();
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  static const _quickPrompts = [
    "What does Dad need today?",
    "Who's responsible tonight?",
    'What did we miss yesterday?',
  ];

  final List<_ChatMessage> _messages = [];
  bool _loadingContext = true;
  bool _isSending = false;
  String _dailySummary = 'Gathering today\'s care summary…';
  String _systemPrompt =
      'You are Sanad, a helpful family-care coordination assistant inside '
      'the CareCircle app. Answer briefly and warmly.';

  ColorScheme get _colors => Theme.of(context).colorScheme;

  @override
  void initState() {
    super.initState();
    _loadCareContext();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _aiService.dispose();
    super.dispose();
  }

  /// Fetches [request], returning an empty list if the table is missing or
  /// the request otherwise fails — one broken data source shouldn't stop
  /// Sanad from using the rest.
  Future<List<T>> _fetchOrEmpty<T>(Future<List<T>> Function() request) async {
    try {
      return await request();
    } catch (_) {
      return <T>[];
    }
  }

  Future<void> _loadCareContext() async {
    final results = await Future.wait([
      _fetchOrEmpty(_databaseService.getCareSchedule),
      _fetchOrEmpty(_databaseService.getShifts),
      _fetchOrEmpty(_databaseService.getCaregivers),
      _fetchOrEmpty(_databaseService.getMedications),
      _fetchOrEmpty(_databaseService.getTasks),
    ]);
    final todayCareScheduleData = results[0] as List<CareScheduleItem>;
    final weeklyScheduleData = results[1] as List<Shift>;
    final caregiversData = results[2] as List<Caregiver>;
    final medicationsData = results[3] as List<Medication>;
    final tasksData = results[4] as List<Task>;

    final summary = _buildDailySummary(
      careSchedule: todayCareScheduleData,
      shifts: weeklyScheduleData,
      caregivers: caregiversData,
      medications: medicationsData,
      tasks: tasksData,
    );

    final contextJson = jsonEncode({
      'today_care_schedule':
          todayCareScheduleData.map((e) => e.toJson()).toList(),
      'weekly_schedule': weeklyScheduleData.map((e) => e.toJson()).toList(),
      'caregivers': caregiversData.map((e) => e.toJson()).toList(),
      'medications': medicationsData.map((e) => e.toJson()).toList(),
      'tasks': tasksData.map((e) => e.toJson()).toList(),
    });

    if (!mounted) return;
    setState(() {
      _dailySummary = summary;
      _systemPrompt =
          'You are Sanad, a helpful family-care coordination assistant '
          'inside the CareCircle app. Answer briefly and warmly.\n\n'
          'The JSON below has already been fetched live from the app\'s '
          'database for you — it is the current, real data, not a sample. '
          'Always answer directly from it; never say you cannot access, '
          'fetch, or retrieve the data, since it is already provided here. '
          'If a list is empty, that means nothing is currently recorded '
          'for that category — say so plainly (e.g. "No medications are '
          'logged yet") instead of saying you lack access.\n\n'
          'Care data: $contextJson';
      _loadingContext = false;
    });
  }

  String _buildDailySummary({
    required List<CareScheduleItem> careSchedule,
    required List<Shift> shifts,
    required List<Caregiver> caregivers,
    required List<Medication> medications,
    required List<Task> tasks,
  }) {
    if (careSchedule.isEmpty &&
        shifts.isEmpty &&
        medications.isEmpty &&
        tasks.isEmpty) {
      return "No care activity has been logged yet today — add a "
          'medication, task, or shift to see a summary here.';
    }

    final caregiverNames = {for (final c in caregivers) c.id: c.name};

    final medsTaken =
        medications.where((m) => m.status == MedicationStatus.taken).length;
    final medsMissed = medications
        .where((m) => m.status == MedicationStatus.missedYesterday)
        .length;
    final medsRemaining = medications.length - medsTaken;

    final pendingTasks =
        tasks.where((t) => t.status == TaskStatus.pending).length;

    final pendingCare = careSchedule
        .where((c) => c.status != CareScheduleStatus.completed)
        .length;

    Shift? onDutyShift;
    Shift? nextShift;
    for (final shift in shifts) {
      if (shift.status == ShiftStatus.now) {
        onDutyShift = shift;
      } else if (nextShift == null && shift.status == ShiftStatus.upcoming) {
        nextShift = shift;
      }
    }

    final parts = <String>[];

    if (medications.isNotEmpty) {
      parts.add(medsMissed > 0
          ? 'Dad has $medsRemaining medication${medsRemaining == 1 ? '' : 's'} '
              'left today and missed $medsMissed yesterday.'
          : 'Dad has $medsRemaining of ${medications.length} '
              'medication${medications.length == 1 ? '' : 's'} left today.');
    }

    if (pendingCare > 0) {
      parts.add('$pendingCare care schedule item'
          '${pendingCare == 1 ? '' : 's'} still need attention.');
    }

    if (pendingTasks > 0) {
      parts.add(
          '$pendingTasks task${pendingTasks == 1 ? '' : 's'} still pending.');
    }

    if (onDutyShift != null) {
      final name = caregiverNames[onDutyShift.caregiverId] ?? 'Someone';
      parts.add('$name is on duty now (${onDutyShift.label}).');
    } else if (nextShift != null) {
      final name = caregiverNames[nextShift.caregiverId] ?? 'Someone';
      parts.add(
          '$name is up next for ${nextShift.label} at ${nextShift.startTime}.');
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
      bottomNavigationBar: _buildBottomNav(),
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
              child: _loadingContext
                  ? SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _colors.onPrimaryContainer,
                      ),
                    )
                  : Text(
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

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 4,
      type: BottomNavigationBarType.fixed,
      backgroundColor: _colors.surfaceContainerHighest,
      selectedItemColor: _colors.primary,
      unselectedItemColor: _colors.onSurfaceVariant,
      selectedLabelStyle:
          GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined), label: 'Schedule'),
        BottomNavigationBarItem(
            icon: Icon(Icons.medication_outlined), label: 'Medications'),
        BottomNavigationBarItem(
            icon: Icon(Icons.checklist_outlined), label: 'Tasks'),
        BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined), label: 'Assistant'),
      ],
    );
  }
}
