
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:edushare_app/screens/AI_quiz.dart';
import 'package:edushare_app/screens/Documents.dart';
import 'package:edushare_app/screens/Image_scan_screen.dart';
import 'package:edushare_app/screens/UploadQuestion.dart';
import 'package:edushare_app/screens/search_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../models/Question.dart';
import '../providers/question_provider.dart';
import '../widgets/BottomBar.dart';
import '../widgets/QuestionCard.dart';
import '../widgets/Subject.dart';
import '../widgets/radialItem.dart';
import 'Question_Detail.dart';
import 'login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isMenuOpen = false;
  late AnimationController _controller;

  int currentIndex = 0;
  late final List<Widget> radialScreens;

  List<Question> displayQuestions = [];
  bool isOffline = false;
  bool loadingQuestions = true;

  final ScrollController _scrollController = ScrollController();

  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scrollController.addListener(_onScroll);

    radialScreens = [
      const QuizGeneratorScreen(),
      const CreatePostScreen(),
      const AIScanScreen(),
    ];

    _initLoad(); // 👈 BỎ COMMENT
  }


  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<QuestionProvider>();

      if (!provider.loading && provider.hasMore) {
        provider.loadMore();
      }
    }
  }

  Future<void> _initLoad() async {
    final online = await hasInternet();

    if (!mounted) return;

    await context.read<QuestionProvider>().loadInitial();
  }


  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose(); // 👈 THÊM
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      /// BODY NAVIGATION
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _getScreen(currentIndex),
          ),

          if (isMenuOpen) _buildOverlayMenu(),
        ],
      ),

      /// BOTTOM BAR
      bottomNavigationBar: BottomBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;

            // đóng menu khi chuyển tab
            isMenuOpen = false;
            _controller.reverse();
          });
        },
      ),

      /// FAB
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
    );
  }


  Widget _buildHome({Key? key}) {
    return Container(
      key: key,
      child: _buildMainContent(),
    );
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return _buildHome(key: const ValueKey(0));
      case 1:
        return const MyDocumentsScreen(key: ValueKey(1));
      default:
        return _buildHome(key: const ValueKey(0));
    }
  }

  Widget _buildFAB() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isMenuOpen = !isMenuOpen;
        });

        isMenuOpen ? _controller.forward() : _controller.reverse();
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.6),
              blurRadius: 25,
            )
          ],
        ),
        child: Icon(
          isMenuOpen ? Icons.close : Icons.add,
          color: Colors.black,
          size: 30,
        ),
      ),
    );
  }

  // ================= MAIN CONTENT =================
  Widget _buildMainContent() {
    final user = context.watch<AuthProvider>().user;

    final questionProvider = context.watch<QuestionProvider>();
    final questions = questionProvider.questions;
    final loading = questionProvider.loading;

    return SafeArea(
      child: RefreshIndicator(
        color: Colors.green,
        backgroundColor: Colors.black,
        onRefresh: () async {
          await context.read<QuestionProvider>().loadInitial();
        },
        child: ListView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 20),

            /// ================= USER HEADER =================
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -0.3),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: isSearching ? _buildSearchBar() : _buildNormalHeader(),
            ),

            const SizedBox(height: 20),

            /// ================= ASK CARD =================
            _buildAskCard(),

            const SizedBox(height: 26),

            /// ================= SUBJECTS =================
            _buildSubjects(),

            const SizedBox(height: 30),

            /// ================= HEADER =================
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Trending Questions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Text(
                //   "See all",
                //   style: TextStyle(color: Colors.green),
                // ),
              ],
            ),

            const SizedBox(height: 16),

            /// ================= CONTENT =================
            if (loading)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (questions.isEmpty)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Text(
                  "No data",
                  style: TextStyle(color: Colors.white54),
                ),
              )
            else
              ...questions.map(
                    (q) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: QuestionCard(
                    question: q,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              QuestionDetailScreen(question: q),
                        ),
                      );
                    },
                  ),
                ),
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildNormalHeader() {
    final user = context.watch<AuthProvider>().user;

    return Row(
      key: const ValueKey("normal"),
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: const Color(0xFF22C55E),
          backgroundImage: (user?.photoURL != null &&
              user!.photoURL!.isNotEmpty)
              ? NetworkImage(user.photoURL!)
              : null,
          child: (user?.photoURL == null || user!.photoURL!.isEmpty)
              ? Text(
            (user?.displayName != null &&
                user!.displayName!.isNotEmpty)
                ? user.displayName![0].toUpperCase()
                : "?",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          )
              : null,
        ),

        const SizedBox(width: 14),

        Expanded(
          child: GestureDetector(
            onTapDown: (details) {
              _showUserMenu(context, details.globalPosition);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Good morning",
                    style: TextStyle(color: Colors.white54)),
                const SizedBox(height: 4),
                Text(
                  user?.displayName ?? "User",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        IconButton(
          icon: const Icon(Icons.notifications_none,
              color: Colors.white70),
          onPressed: () {},
        ),

        IconButton(
          icon: const Icon(Icons.search, color: Colors.white70),
          onPressed: () {
            setState(() {
              isSearching = true;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      key: const ValueKey("search"),
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              controller: searchController,
              autofocus: true,
              textInputAction: TextInputAction.search,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search questions...",
                hintStyle: const TextStyle(color: Colors.white54),
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => searchController.clear(),
                ),
              ),

              onSubmitted: (value) {
                final keyword = value.trim();
                if (keyword.isEmpty) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SearchScreen(keyword: keyword),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(width: 10),

        GestureDetector(
          onTap: () {
            setState(() {
              isSearching = false;
              searchController.clear();
            });
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _showUserMenu(BuildContext context, Offset position) async {
    final selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy,
      ),
      items: [
        const PopupMenuItem(
          value: "logout",
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 10),
              Text("Đăng xuất"),
            ],
          ),
        ),
      ],
    );

    if (selected == "logout") {
      _logout(context);
    }
  }
  Future<void> _logout(BuildContext context) async {
    await context.read<AuthProvider>().logout();

    // 🔥 clear navigation stack → về login sạch
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const StudyShareScreen()),
          (route) => false,
    );
  }

  // ================= ASK CARD =================
  Widget _buildAskCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF052E16), Color(0xFF022C22)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child:
            const Icon(Icons.auto_awesome, color: Colors.green),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Need help with homework?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 6),
                Text("Ask a question and get instant help",
                    style: TextStyle(color: Colors.white60)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= SUBJECTS =================
  Widget _buildSubjects() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Subjects",
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("See all", style: TextStyle(color: Colors.green)),
          ],



        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            Subject("Math", Icons.calculate, Colors.blue),
            Subject("English", Icons.menu_book, Colors.green),
            Subject("Science", Icons.science, Colors.orange),
            Subject("Geography", Icons.public, Colors.cyan),
            Subject("History", Icons.history, Colors.amber),
            Subject("Coding", Icons.code, Colors.pink),
            Subject("Art", Icons.brush, Colors.red),
            Subject("Music", Icons.music_note, Colors.indigo),
          ],
        ),
      ],
    );
  }

  // ================= RADIAL MENU =================
  Widget _buildOverlayMenu() {
    return GestureDetector(
      onTap: () => setState(() => isMenuOpen = false),
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
          Positioned.fill(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [

                RadialItem(
                  index: 0,
                  icon: Icons.psychology,
                  label: "AI Quiz",
                  color: Colors.green,
                  angle: -140,
                  radius: 120,
                  isMenuOpen: isMenuOpen,
                  controller: _controller,
                  onTap: () {
                    _openRadialScreen(0);
                  },
                ),
                RadialItem(
                  index: 1,
                  icon: Icons.upload,
                  label: "Upload",
                  color: Colors.blue,
                  angle: -90,
                  radius: 10,
                  isMenuOpen: isMenuOpen,
                  controller: _controller,
                  onTap: () {
                    _openRadialScreen(1);
                  },
                ),


                RadialItem(
                  index: 2,
                  icon: Icons.camera_alt,
                  label: "Image",
                  color: Colors.orange,
                  angle: -40,
                  radius: 120,
                  isMenuOpen: isMenuOpen,
                  controller: _controller,
                  onTap: () {
                    _openRadialScreen(2);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openRadialScreen(int index) {
    if (index >= radialScreens.length) {
      // chưa có screen thì không làm gì cả
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => radialScreens[index],
      ),
    );
  }


  Future<bool> hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

}

// ================= PLACEHOLDER SCREENS =================
class DocsScreen extends StatelessWidget {
  const DocsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text("Docs", style: TextStyle(color: Colors.white)));
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text("Chat", style: TextStyle(color: Colors.white)));
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text("Profile", style: TextStyle(color: Colors.white)));
  }
}