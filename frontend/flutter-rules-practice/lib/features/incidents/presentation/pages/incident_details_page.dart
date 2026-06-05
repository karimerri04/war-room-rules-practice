import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../domain/incident.dart';
import '../../domain/incident_status.dart';
import '../state/incident_details_notifier.dart';
import '../widgets/severity_badge.dart';
import '../widgets/status_badge.dart';

/// Details screen for a single incident.
///
/// This screen uses a [StatefulWidget] only because it owns text controllers.
/// Backend state and mutation logic remain in [IncidentDetailsNotifier].
class IncidentDetailsPage extends StatefulWidget {
  const IncidentDetailsPage({super.key});

  @override
  State<IncidentDetailsPage> createState() => _IncidentDetailsPageState();
}

class _IncidentDetailsPageState extends State<IncidentDetailsPage> {
  final _noteAuthorController = TextEditingController();
  final _noteMessageController = TextEditingController();
  final _resolutionController = TextEditingController();

  @override
  void dispose() {
    _noteAuthorController.dispose();
    _noteMessageController.dispose();
    _resolutionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<IncidentDetailsNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Incident details'),
        leading: IconButton(
          tooltip: 'Back to dashboard',
          onPressed: () => context.go('/incidents'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: _DetailsBody(
          notifier: notifier,
          noteAuthorController: _noteAuthorController,
          noteMessageController: _noteMessageController,
          resolutionController: _resolutionController,
        ),
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  final IncidentDetailsNotifier notifier;
  final TextEditingController noteAuthorController;
  final TextEditingController noteMessageController;
  final TextEditingController resolutionController;

  const _DetailsBody({
    required this.notifier,
    required this.noteAuthorController,
    required this.noteMessageController,
    required this.resolutionController,
  });

  @override
  Widget build(BuildContext context) {
    if (notifier.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (notifier.errorMessage != null && notifier.incident == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(notifier.errorMessage!),
        ),
      );
    }

    final incident = notifier.incident;

    if (incident == null) {
      return const Center(
        child: Text('Incident not found.'),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _NotificationBanner(
          errorMessage: notifier.errorMessage,
          successMessage: notifier.successMessage,
        ),
        _IncidentHeader(incident: incident),
        const SizedBox(height: 16),
        _SymptomsCard(incident: incident),
        const SizedBox(height: 16),
        _RootCauseAndResolutionCard(incident: incident),
        const SizedBox(height: 16),
        _ActionsCard(
          incident: incident,
          saving: notifier.saving,
          onStartInvestigation: notifier.startInvestigation,
          onAddNote: () async {
            final author = noteAuthorController.text.trim();
            final message = noteMessageController.text.trim();

            if (author.isEmpty || message.isEmpty) {
              return;
            }

            await notifier.addNote(
              author: author,
              message: message,
            );

            noteAuthorController.clear();
            noteMessageController.clear();
          },
          onResolve: () async {
            final resolution = resolutionController.text.trim();

            if (resolution.isEmpty) {
              return;
            }

            await notifier.resolve(
              resolutionSummary: resolution,
            );

            resolutionController.clear();
          },
          noteAuthorController: noteAuthorController,
          noteMessageController: noteMessageController,
          resolutionController: resolutionController,
        ),
        const SizedBox(height: 16),
        _NotesCard(incident: incident),
      ],
    );
  }
}

class _NotificationBanner extends StatelessWidget {
  final String? errorMessage;
  final String? successMessage;

  const _NotificationBanner({
    required this.errorMessage,
    required this.successMessage,
  });

  @override
  Widget build(BuildContext context) {
    final message = errorMessage ?? successMessage;

    if (message == null) {
      return const SizedBox.shrink();
    }

    final isError = errorMessage != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            message,
            style: TextStyle(
              color: isError ? Colors.red : Colors.green,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _IncidentHeader extends StatelessWidget {
  final Incident incident;

  const _IncidentHeader({
    required this.incident,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatusBadge(status: incident.status),
                SeverityBadge(severity: incident.severity),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              incident.id,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Text(
              incident.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(incident.description),
            const SizedBox(height: 12),
            Text(
              'Created at: ${incident.createdAt}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (incident.resolvedAt != null)
              Text(
                'Resolved at: ${incident.resolvedAt}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}

class _SymptomsCard extends StatelessWidget {
  final Incident incident;

  const _SymptomsCard({
    required this.incident,
  });

  @override
  Widget build(BuildContext context) {
    if (incident.symptoms.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Symptoms',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            ...incident.symptoms.map(
                  (symptom) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('• $symptom'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RootCauseAndResolutionCard extends StatelessWidget {
  final Incident incident;

  const _RootCauseAndResolutionCard({
    required this.incident,
  });

  @override
  Widget build(BuildContext context) {
    final rootCause = incident.rootCause.isEmpty
        ? 'Not identified yet.'
        : incident.rootCause;

    final resolution = incident.resolution.isEmpty
        ? 'Not resolved yet.'
        : incident.resolution;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Root cause',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(rootCause),
            const SizedBox(height: 16),
            Text(
              'Resolution',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(resolution),
          ],
        ),
      ),
    );
  }
}

/// User actions available on an incident.
///
/// This widget only collects form input and forwards intent to callbacks.
/// It does not call the backend directly.
class _ActionsCard extends StatelessWidget {
  final Incident incident;
  final bool saving;
  final VoidCallback onStartInvestigation;
  final VoidCallback onAddNote;
  final VoidCallback onResolve;
  final TextEditingController noteAuthorController;
  final TextEditingController noteMessageController;
  final TextEditingController resolutionController;

  const _ActionsCard({
    required this.incident,
    required this.saving,
    required this.onStartInvestigation,
    required this.onAddNote,
    required this.onResolve,
    required this.noteAuthorController,
    required this.noteMessageController,
    required this.resolutionController,
  });

  @override
  Widget build(BuildContext context) {
    final canStartInvestigation = incident.status == IncidentStatus.open;
    final canResolve = incident.status != IncidentStatus.resolved;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Incident actions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: saving || !canStartInvestigation
                  ? null
                  : onStartInvestigation,
              icon: const Icon(Icons.search),
              label: const Text('Start investigation'),
            ),
            const SizedBox(height: 24),
            Text(
              'Add investigation note',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: noteAuthorController,
              decoration: const InputDecoration(
                labelText: 'Author',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: noteMessageController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: saving ? null : onAddNote,
              icon: const Icon(Icons.note_add),
              label: const Text('Add note'),
            ),
            const SizedBox(height: 24),
            Text(
              'Resolve incident',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: resolutionController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Resolution summary',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: saving || !canResolve ? null : onResolve,
              icon: const Icon(Icons.check_circle),
              label: saving
                  ? const Text('Saving...')
                  : const Text('Resolve incident'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  final Incident incident;

  const _NotesCard({
    required this.incident,
  });

  @override
  Widget build(BuildContext context) {
    if (incident.notes.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No investigation notes yet.'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Investigation notes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            ...incident.notes.map(
                  (note) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.author,
                          style:
                          Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(note.message),
                        const SizedBox(height: 4),
                        Text(
                          note.createdAt,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}