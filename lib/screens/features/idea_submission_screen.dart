import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_dhaka_app/screens/features/idea_details.dart';
import 'package:smart_dhaka_app/services/idea_service.dart';
import 'package:smart_dhaka_app/services/voting_service.dart';

class IdeaSubmissionScreen extends StatefulWidget {
  const IdeaSubmissionScreen({Key? key}) : super(key: key);

  @override
  _IdeaSubmissionScreenState createState() => _IdeaSubmissionScreenState();
}

class _IdeaSubmissionScreenState extends State<IdeaSubmissionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final GlobalKey<_MyIdeasTabState> myIdeaKey = GlobalKey();
  final GlobalKey<_AllIdeasTabState> allIdeakey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.index == 1) {
        myIdeaKey.currentState?.refreshData();
      } else if (_tabController.index == 2) {
        allIdeakey.currentState?.refreshData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Idea Submission'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Submission'),
            Tab(text: 'My Ideas'),
            Tab(text: 'All Ideas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          IdeaSubmissionTab(),
          MyIdeasTab(key: myIdeaKey),
          AllIdeasTab(key: allIdeakey),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class IdeaSubmissionTab extends StatefulWidget {
  @override
  _IdeaSubmissionTabState createState() => _IdeaSubmissionTabState();
}

class _IdeaSubmissionTabState extends State<IdeaSubmissionTab> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _secureStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Idea Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the title of your idea';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Idea Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your idea description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitIdea,
                  child: const Text('Submit Idea'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitIdea() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Retrieve the token from secure storage
        final String? token = await _secureStorage.read(key: 'authToken');

        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('User not authenticated. Please log in again.')),
          );
          return;
        }

        final ideaService = IdeaService(); // Ensure ideaService uses the token

        // Call the idea service with the retrieved token
        await ideaService.submitIdea(
          _titleController.text,
          _descriptionController.text,
          token, // Pass the token to the service
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Idea submitted successfully!')),
        );

        // Clear the form fields after submission
        _titleController.clear();
        _descriptionController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit Idea: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

class MyIdeasTab extends StatefulWidget {
  const MyIdeasTab({Key? key}) : super(key: key);

  @override
  State<MyIdeasTab> createState() => _MyIdeasTabState();
}

class _MyIdeasTabState extends State<MyIdeasTab> {
  final IdeaService _ideaService = IdeaService();
  late Future<List<Map<String, dynamic>>> _ideasFuture;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    setState(() {
      _ideasFuture = _ideaService.getIdeas(
        getAllIdeas: false,
        getMyIdeas: true,
      );
    });
  }

  void refreshData() {
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _ideasFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No Ideas found.'));
        } else {
          final ideas = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: ideas.length,
            itemBuilder: (context, index) {
              final idea = ideas[index];
              return Card(
                child: ListTile(
                  title: Text(idea['title']),
                  subtitle: Text('Status: ${idea['status']}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${idea['votes']} votes'),
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
          );
        }
      },
    );
  }
}

class AllIdeasTab extends StatefulWidget {
  const AllIdeasTab({Key? key}) : super(key: key);

  @override
  State<AllIdeasTab> createState() => _AllIdeasTabState();
}

class _AllIdeasTabState extends State<AllIdeasTab> {
  final IdeaService _ideaService = IdeaService();
  final VoteService _voteService = VoteService();
  late Future<List<Map<String, dynamic>>> _ideasFuture;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    setState(() {
      _ideasFuture = _ideaService.getIdeas(
        getAllIdeas: true,
        getMyIdeas: false,
      );
    });
  }

  void refreshData() {
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _ideasFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No Ideas found.'));
        } else {
          final ideas = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: ideas.length,
            itemBuilder: (context, index) {
              final idea = ideas[index];
              final hasVoted = idea['hasVoted'] ?? false;
              return Card(
                child: ListTile(
                  title: Text(idea['title']),
                  subtitle: Text('Status: ${idea['status']}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${idea['votes']} votes'),
                      IconButton(
                        icon: Icon(
                          Icons.thumb_up,
                          color: hasVoted ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () {
                          if (!hasVoted) {
                            _voteForIdea(idea['_id']);
                          } else {
                            _removeVoteForIdea(idea['_id']);
                          }
                        },
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
          );
        }
      },
    );
  }

  Future<void> _voteForIdea(String ideaId) async {
    try {
      await _voteService.vote("Idea", ideaId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vote registered successfully!')),
      );
      refreshData(); // Refresh data after voting
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register vote: $error')),
      );
    }
  }

  Future<void> _removeVoteForIdea(String ideaId) async {
    try {
      await _voteService.removeVote("Idea", ideaId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vote deregistered successfully!')),
      );
      refreshData(); // Refresh data after voting
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to deregister vote: $error')),
      );
    }
  }
}
