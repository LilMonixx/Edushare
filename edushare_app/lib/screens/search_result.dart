import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/question_provider.dart';
import '../models/Question.dart';

class SearchScreen extends StatefulWidget {
  final String keyword;

  const SearchScreen({super.key, required this.keyword});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int selectedTab = 0;
  int selectedChip = 0;

  final ScrollController _controller = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final tabs = ["All", "Documents", "Groups", "Questions"];
  final List<String> subjects = [
    "Math",
    "English",
    "Physics",
    "Chemistry",
    "Biology",
    "History",
    "Geography",
    "Literature",
    "Computer Science",
    "Economics",
    "Art",
    "Music",
    "Philosophy",
    "Psychology",
    "Sociology",
    "Political Science",
    "Law",
    "Statistics",
    "Engineering",
    "Business"
  ];
  String? selectedSubject;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuestionProvider>().search(widget.keyword);
    });

    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 100) {
        context.read<QuestionProvider>().loadMoreSearch();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _buildSearch(),
                  const SizedBox(height: 16),

                  _buildTabs(),
                  const SizedBox(height: 12),
                _buildSubjectFilter(),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            /// LIST
            Expanded(
              child: Consumer<QuestionProvider>(
                builder: (context, provider, child) {
                  final posts = provider.searchResults;

                  if (provider.searching && posts.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (posts.isEmpty) {
                    return const Center(
                      child: Text(
                        "No results found",
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _controller,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final Question post = posts[index];

                      return PostCard(
                        title: post.subject ?? "No title",
                        description: post.content ?? "",
                        authorName: post.userName ?? "Unknown",
                        authorAvatar: post.userAvatar, // 🔥 THÊM DÒNG NÀY
                        time: "",
                        downloads: "0",
                        likes: "0",
                        verified: false,
                      );
                    },
                  );
                },
              ),
            ),

            /// LOAD MORE
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () {
                  context.read<QuestionProvider>().loadMoreSearch();
                },
                child: const LoadMoreButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SEARCH BAR =================
  Widget _buildSearch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(30),
      ),
      child:  Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, size: 20, color: Colors.white),
          ),
          SizedBox(width: 8),
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              onSubmitted: (value) {
                context.read<QuestionProvider>().search(
                  value,
                  subject: selectedSubject,
                );
              },
              decoration: const InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _searchController.clear();
            },
            child: const Icon(Icons.close, color: Colors.grey),
          ),
          SizedBox(width: 8),
          Icon(Icons.tune, color: Colors.green),
        ],
      ),
    );
  }

  // ================= TABS =================
  Widget _buildTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          tabs.length,
              (index) => GestureDetector(
            onTap: () => setState(() => selectedTab = index),
            child: _tab(tabs[index], selectedTab == index),
          ),
        ),
      ),
    );
  }

  // ================= CHIPS =================
  Widget _buildSubjectFilter() {
    return GestureDetector(
      onTap: _openSubjectSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedSubject ?? "All Subjects",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_drop_down, color: Colors.green),
          ],
        ),
      ),
    );
  }

  void _openSubjectSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];

            return ListTile(
              title: Text(
                subject,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                setState(() {
                  selectedSubject = subject;
                });

                Navigator.pop(context);

                // 👉 gọi filter search
                context.read<QuestionProvider>().search(
                  widget.keyword,
                  subject: selectedSubject,
                );

                // nếu muốn filter backend:
                // truyền subject luôn
              },
            );
          },
        );
      },
    );
  }

  Widget _tab(String text, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? Colors.green : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  Widget _chip(String text, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: active ? Colors.green : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.black : Colors.white70,
        ),
      ),
    );
  }
}

// ================= POST CARD =================
class PostCard extends StatelessWidget {
  final String title;
  final String description;
  final String authorName;
  final String? authorAvatar;
  final String time;
  final String downloads;
  final String likes;
  final bool verified;

  const PostCard({
    super.key,
    required this.title,
    required this.description,
    required this.authorName,
    required this.authorAvatar,
    required this.time,
    required this.downloads,
    required this.likes,
    required this.verified,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description, color: Colors.green),
              const SizedBox(width: 8),
              const Text("Post"),
              const Spacer(),
              if (verified)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Verified",
                    style: TextStyle(fontSize: 10, color: Colors.black),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundImage: (authorAvatar?.isNotEmpty ?? false)
                    ? NetworkImage(authorAvatar!)
                    : null,
                backgroundColor: Colors.grey,
                child: (authorAvatar?.isEmpty ?? true)
                    ? Text(
                  authorName.isNotEmpty ? authorName[0] : "?",
                  style: const TextStyle(fontSize: 10),
                )
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "$authorName • $time",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              const Icon(Icons.download, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(downloads),
              const SizedBox(width: 12),
              const Icon(Icons.favorite_border,
                  size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(likes),
            ],
          ),
        ],
      ),
    );
  }
}

// ================= LOAD MORE =================
class LoadMoreButton extends StatelessWidget {
  const LoadMoreButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(25),
      ),
      alignment: Alignment.center,
      child: const Text(
        "Load more results",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}