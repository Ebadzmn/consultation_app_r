import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:intl/intl.dart';
import 'package:consultant_app/core/network/api_client.dart';
import 'package:consultant_app/injection_container.dart' as di;
import '../../domain/entities/project.dart';
import '../../domain/repositories/experts_repository.dart';

class ProjectDetailsSheet extends StatefulWidget {
  final Project project;

  const ProjectDetailsSheet({super.key, required this.project});

  @override
  State<ProjectDetailsSheet> createState() => _ProjectDetailsSheetState();
}

class _ProjectDetailsSheetState extends State<ProjectDetailsSheet> {
  late Future<Map<String, dynamic>> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = _loadDetails();
  }

  Future<Map<String, dynamic>> _loadDetails() async {
    final repository = di.sl<ExpertsRepository>();
    final result = await repository.getProjectDetails(widget.project.id);
    return result.fold(
      (_) => <String, dynamic>{},
      (data) => data,
    );
  }

  String _resolveMediaUrl(String? raw, String fallback) {
    final s = raw?.trim() ?? '';
    if (s.isEmpty) {
      return fallback;
    }
    if (s.startsWith('http://') || s.startsWith('https://')) {
      return s;
    }
    final uri = Uri.parse(ApiClient.baseUrl);
    final origin = '${uri.scheme}://${uri.host}';
    return '$origin$s';
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: FutureBuilder<Map<String, dynamic>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load project details'),
            );
          }

          final data = snapshot.data ?? <String, dynamic>{};

          final categories = data['categories'];
          String primaryCategory = '';
          if (categories is List && categories.isNotEmpty) {
            final first = categories.first;
            if (first is Map<String, dynamic>) {
              primaryCategory =
                  (first['name'] ?? '').toString().trim();
            }
          }
          if (primaryCategory.isEmpty &&
              widget.project.categories.isNotEmpty) {
            primaryCategory = widget.project.categories.first;
          }
          if (primaryCategory.isEmpty) {
            primaryCategory = 'ИИ / ML';
          }

          String dateLabel = '';
          final createdRaw =
              data['time_create'] ?? data['created_at'] ?? data['updated_at'];
          if (createdRaw != null) {
            final s = createdRaw.toString();
            final parsed = DateTime.tryParse(s);
            if (parsed != null) {
              dateLabel = DateFormat('yyyy-MM-dd').format(parsed.toLocal());
            } else if (s.length >= 10) {
              dateLabel = s.substring(0, 10);
            }
          }
          if (dateLabel.isEmpty) {
            int? year;
            final yearRaw = data['year'];
            if (yearRaw is num) {
              year = yearRaw.toInt();
            } else if (yearRaw is String) {
              year = int.tryParse(yearRaw);
            }
            dateLabel = (year ?? widget.project.date.year).toString();
          }

          final nameRaw = (data['name'] ?? '').toString().trim();
          final title =
              nameRaw.isNotEmpty ? nameRaw : widget.project.title;

          final companyRaw =
              (data['company'] ?? '').toString().trim();
          final company =
              companyRaw.isNotEmpty ? companyRaw : 'ООО';

          final goalsRaw = (data['goals'] ?? '').toString().trim();
          final description = goalsRaw.isNotEmpty
              ? goalsRaw
              : widget.project.description;

          final participants = <_ParticipantItem>[];
          final author = data['author_details'];
          if (author is Map<String, dynamic>) {
            final fullName =
                (author['full_name'] ?? '').toString().trim();
            final avatarRaw =
                (author['avatar'] ?? '').toString().trim();
            final avatarUrl = _resolveMediaUrl(
              avatarRaw,
              'https://i.pravatar.cc/100?u=author_${widget.project.id}',
            );
            if (fullName.isNotEmpty) {
              participants.add(
                _ParticipantItem(
                  name: fullName,
                  avatarUrl: avatarUrl,
                ),
              );
            }
          }

          final members = data['members_details'];
          if (members is List) {
            for (final m
                in members.whereType<Map<String, dynamic>>()) {
              final fullName =
                  (m['full_name'] ?? '').toString().trim();
              final avatarRaw =
                  (m['avatar'] ?? '').toString().trim();
              final avatarUrl = _resolveMediaUrl(
                avatarRaw,
                'https://i.pravatar.cc/100?u=member_${widget.project.id}',
              );
              if (fullName.isNotEmpty) {
                participants.add(
                  _ParticipantItem(
                    name: fullName,
                    avatarUrl: avatarUrl,
                  ),
                );
              }
            }
          }

          final files = <_FileItem>[];
          final rawFiles = data['files'];
          if (rawFiles is List) {
            for (final f
                in rawFiles.whereType<Map<String, dynamic>>()) {
              final name =
                  (f['name'] ?? '').toString().trim();
              var url = (f['url'] ?? '').toString().trim();
              url = url.replaceAll('`', '').trim();
              final resolvedUrl = _resolveMediaUrl(
                url,
                '',
              );
              if (name.isNotEmpty && resolvedUrl.isNotEmpty) {
                files.add(
                  _FileItem(
                    name: name,
                    url: resolvedUrl,
                  ),
                );
              }
            }
          }

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Детали проекта',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF33354E),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFFEEEEEE)),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD),
                                borderRadius:
                                    BorderRadius.circular(16),
                              ),
                              child: Text(
                                primaryCategory,
                                style: const TextStyle(
                                  color: Color(0xFF2196F3),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            _buildStatIcon(
                              Icons.calendar_today_outlined,
                              dateLabel,
                            ),
                            const SizedBox(width: 16),
                            _buildStatIcon(
                              Icons.visibility_outlined,
                              '${widget.project.viewsCount}',
                            ),
                            const SizedBox(width: 16),
                            _buildStatIcon(
                              Icons.thumb_up_outlined,
                              '${widget.project.likesCount}',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF33354E),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Participants',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFAFB2C5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ..._buildParticipantsList(participants),
                        const SizedBox(height: 8),
                        if (participants.isNotEmpty)
                          const Text(
                            'Показать всех',
                            style: TextStyle(
                              color: Color(0xFF66BB6A),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        const SizedBox(height: 24),
                        const Text(
                          'Company',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFAFB2C5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          company,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF33354E),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Описание',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFAFB2C5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF33354E),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Материалы проекта',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFAFB2C5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (files.isEmpty) ...[
                          _buildMaterialItem('Презентация.pdf'),
                          const SizedBox(height: 8),
                          _buildMaterialItem('Отчет_по_проекту.pdf'),
                        ] else ...[
                          for (final f in files) ...[
                            _buildMaterialItem(
                              f.name,
                              onTap: () => _openFile(f.url),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ],
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Понравился проект?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF33354E),
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.thumb_up,
                                color: Color(0xFFB0B3C7),
                                size: 28,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${widget.project.likesCount}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB0B3C7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openFile(String url) {
    if (url.isEmpty) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FileViewerPage(url: url),
      ),
    );
  }

  Widget _buildStatIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFFAFB2C5)),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFAFB2C5),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildParticipantsList(
    List<_ParticipantItem> participants,
  ) {
    if (participants.isEmpty) {
      return [];
    }
    return participants
        .map(
          (p) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundImage: NetworkImage(p.avatarUrl),
                ),
                const SizedBox(width: 12),
                Text(
                  p.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF33354E),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Widget _buildMaterialItem(String fileName, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFEEEEEE)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.insert_drive_file,
              color: Color(0xFFAFB2C5),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                fileName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF33354E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParticipantItem {
  final String name;
  final String avatarUrl;

  _ParticipantItem({
    required this.name,
    required this.avatarUrl,
  });
}

class _FileItem {
  final String name;
  final String url;

  _FileItem({
    required this.name,
    required this.url,
  });
}

class FileViewerPage extends StatelessWidget {
  final String url;

  const FileViewerPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Файл'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
