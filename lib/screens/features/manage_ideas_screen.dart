import 'package:flutter/material.dart';
import 'package:smart_dhaka_app/screens/features/idea_details.dart';
import 'package:smart_dhaka_app/screens/features/idea_status_update.dart';
import 'package:smart_dhaka_app/services/idea_service.dart';

class ManageIdeasScreen extends StatefulWidget {
  const ManageIdeasScreen({Key? key}) : super(key: key);

  @override
  _ManageIdeasScreenState createState() => _ManageIdeasScreenState();
}

class _ManageIdeasScreenState extends State<ManageIdeasScreen> {
  late IdeaService _ideaService;
  List<Map<String, dynamic>> _ideas = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _ideaService = IdeaService();
    _fetchIdeas();
  }

  Future<void> _fetchIdeas() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final ideas = await _ideaService.fetchIdeasForAuthority();
      setState(() {
        _ideas = ideas;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching ideas: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Ideas'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _ideas.isEmpty
              ? const Center(child: Text('No ideas available'))
              : ListView.builder(
                  itemCount: _ideas.length,
                  itemBuilder: (context, index) {
                    final idea = _ideas[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(idea['title']),
                        subtitle: Text(
                          'Status: ${idea['status']} | Priority: ${idea['priority']}',
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (String result) {
                            _handleIdeaAction(result, idea);
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'view',
                              child: Text('View Details'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'update',
                              child: Text('Update Status'),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IdeaDetailScreen(
                                idea: idea,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }

  void _handleIdeaAction(String action, dynamic idea) {
    switch (action) {
      case 'view':
        _viewIdeaDetails(idea);
        break;
      case 'update':
        _updateIdeaStatus(idea);
        break;
    }
  }

  void _viewIdeaDetails(dynamic idea) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IdeaDetailScreen(
          idea: idea,
        ),
      ),
    );
  }

  void _updateIdeaStatus(Map<String, dynamic> idea) async {
    final updatedIdea = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IdeaStatusUpdateScreen(idea: idea),
      ),
    );

    if (updatedIdea != null) {
      setState(() {
        final index =
            _ideas.indexWhere((c) => c['id'] == updatedIdea['id']);
        if (index != -1) {
          _ideas[index] = updatedIdea;
        }
      });
    }
  }
}
