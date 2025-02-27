import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const PortfolioApp(),
    ),
  );
}

// Theme Provider for Dark/Light Mode
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

// Main App Widget with Customized Theme
class PortfolioApp extends StatelessWidget {
  const PortfolioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sangeerth B - Developer Portfolio',
      theme: ThemeData(
        brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
        // Custom color scheme
        primaryColor: themeProvider.isDarkMode ? const Color(0xFF5E35B1) : const Color(0xFF7E57C2), // Deep purple tones
        scaffoldBackgroundColor: themeProvider.isDarkMode ? const Color(0xFF212121) : const Color(0xFFF5F5F5),
        cardColor: themeProvider.isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: themeProvider.isDarkMode ? Colors.white : Colors.black87,
          displayColor: themeProvider.isDarkMode ? Colors.white : Colors.black87,
        ),
        iconTheme: IconThemeData(
          color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: themeProvider.isDarkMode ? const Color(0xFF5E35B1) : const Color(0xFF7E57C2),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

// Home Page with Navigation
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToSection(int index) {
    final screenHeight = MediaQuery.of(context).size.height;
    _scrollController.animateTo(
      index * screenHeight,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
            title: const Text('Sangeerth B'),
            actions: [
              TextButton(onPressed: () => _scrollToSection(0), child: const Text('Home')),
              TextButton(onPressed: () => _scrollToSection(1), child: const Text('About')),
              TextButton(onPressed: () => _scrollToSection(2), child: const Text('Projects')),
              TextButton(onPressed: () => _scrollToSection(3), child: const Text('Skills')),
              TextButton(onPressed: () => _scrollToSection(4), child: const Text('Experience')),
              TextButton(onPressed: () => _scrollToSection(5), child: const Text('Contact')),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  Provider.of<ThemeProvider>(context).isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
              ),
              const SizedBox(width: 16),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              HeroSection(onScrollToProjects: () => _scrollToSection(2)),
              const AboutSection(),
              const ProjectsSection(),
              const SkillsSection(),
              const ExperienceSection(),
              const ContactSection(),
            ]),
          ),
        ],
      ),
    );
  }
}

// Hero Section
class HeroSection extends StatelessWidget {
  final VoidCallback onScrollToProjects;

  const HeroSection({Key? key, required this.onScrollToProjects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [const Color(0xFF311B92), const Color(0xFF5E35B1)] // Deep purple gradient
              : [const Color(0xFFEDE7F6), const Color(0xFFD1C4E9)],
        ),
      ),
      child: Stack(
        children: [
          ...List.generate(20, (index) => Positioned(
                left: (index * 50) % size.width,
                top: (index * 80) % size.height,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.purple.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              )),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SANGEERTH B',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87
                  ),
                ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 16),
                Text(
                  'Software Developer & Backend Engineer',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 24),
                Text(
                  'Building scalable backend systems and cross-platform applications',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white60 : Colors.black54,
                  ),
                ).animate().fadeIn(duration: 800.ms, delay: 400.ms),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.work),
                      label: const Text('View My Work'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: onScrollToProjects,
                    ).animate().fadeIn(duration: 800.ms, delay: 600.ms),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.download),
                      label: const Text('Download CV'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () async {
                         const cvUrl = 'https://drive.google.com/file/d/1QPHngvo6w0qB1IjbMTPBymdcycI-p_wN/view?usp=drive_link'; 
                           if (await canLaunchUrl(Uri.parse(cvUrl))) {
                        await launchUrl(Uri.parse(cvUrl));
    } else {
      throw 'Could not launch $cvUrl';
    }
                      },
                    ).animate().fadeIn(duration: 800.ms, delay: 800.ms),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 32,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ).animate(onPlay: (controller) => controller.repeat())
                  .fadeIn(duration: 800.ms)
                  .then()
                  .moveY(begin: 0, end: 10, duration: 800.ms)
                  .then()
                  .moveY(begin: 0, end: -10, duration: 800.ms),
            ),
          ),
        ],
      ),
    );
  }
}

// About Section
class AboutSection extends StatelessWidget {
  const AboutSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    Widget buildProfilePart() {
      return Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          children: [
            Container(
              width: 250,
              height: 250,


              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(125),
                border: Border.all(color: Theme.of(context).primaryColor, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
               child: ClipRRect(
    borderRadius: BorderRadius.circular(125), // Ensures the image stays circular
    child: Image.asset(
      'assets/Sangeerth_B.jpg', // Relative path to the image in the assets folder
      fit: BoxFit.cover, // Ensures the image covers the container
    ),
  ),
            ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.8, 0.8)),
            const SizedBox(height: 32),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _buildSocialButton(FontAwesomeIcons.github, 'GitHub', 'https://github.com/sangan007', context),
                _buildSocialButton(FontAwesomeIcons.linkedin, 'LinkedIn', 'https://linkedin.com', context),
                _buildSocialButton(FontAwesomeIcons.envelope, 'Email', 'mailto:sangeerth.b@outlook.com', context),
              ],
            ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
          ],
        ),
      );
    }

    Widget buildTextPart() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hello! I\'m Sangeerth B, a software developer specializing in backend development and cross-platform applications. With expertise in Go, Flutter, and Python, I focus on building scalable solutions and user-friendly interfaces.',
            style: TextStyle(fontSize: 18, height: 1.6),
          ).animate().fadeIn(duration: 800.ms).slideX(begin: 0.2, end: 0),
          const SizedBox(height: 24),
          const Text(
            'I\'m currently pursuing my B. Tech in Information Technology at Cochin University of Science and Technology (CUSAT). My work experience includes optimizing backend systems at Orinson Technologies and creating content for sustainability initiatives at Earth 5R.',
            style: TextStyle(fontSize: 16, height: 1.6),
          ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideX(begin: 0.2, end: 0),
          const SizedBox(height: 32),
          const Text('Key Skills', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSkillChip('Go (Golang)', context),
              _buildSkillChip('Flutter', context),
              _buildSkillChip('Python', context),
              _buildSkillChip('GORM', context),
              _buildSkillChip('PostgreSQL', context),
              _buildSkillChip('JavaScript', context),
              _buildSkillChip('C++', context),
              _buildSkillChip('Machine Learning', context),
              _buildSkillChip('RESTful APIs', context),
            ],
          ).animate().fadeIn(duration: 800.ms, delay: 400.ms),
          const SizedBox(height: 32),
          const Text('Key Achievements', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          _buildAchievement('Increased backend system performance by 30% at Orinson Technologies.', context),
          _buildAchievement('Authored content that boosted online visibility by 25% at Earth 5R.', context),
          _buildAchievement('Developed a trading bot with real-time sentiment analysis.', context),
          _buildAchievement('Created a sign language detection app with 95% accuracy.', context),
        ],
      );
    }

    return Container(
      height: size.height,
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Me',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true)).shimmer(
              duration: 3000.ms,
              color: isDarkMode ? Colors.purple.shade200 : Colors.purple.shade700,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 32),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: buildProfilePart()),
                      Expanded(flex: 3, child: buildTextPart()),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      buildProfilePart(),
                      const SizedBox(height: 32),
                      buildTextPart(),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label, String url, BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, size: 16, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(String label, BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.3)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    );
  }

  Widget _buildAchievement(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.1, end: 0);
  }
}

// Projects Section
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    final projects = [
      ProjectModel(
        title: 'Sign Language Detection App',
        description: 'A Flutter application that uses CNN to detect sign language gestures in real-time with 95% accuracy.',
        image: 'sign_language.jpg',
        techStack: ['Flutter', 'CNN', 'TensorFlow', 'Machine Learning'],
        demoUrl: 'https://github.com/sangan007',
        repoUrl: 'https://github.com/sangan007',
      ),
      ProjectModel(
        title: 'Sentiment Analysis Trading Bot',
        description: 'A trading bot analyzing market sentiment, built with Flutter and C++.',
        image: 'trading_bot.jpg',
        techStack: ['Flutter', 'C++', 'Sentiment Analysis', 'Data Visualization'],
        demoUrl: 'https://github.com/sangan007',
        repoUrl: 'https://github.com/sangan007',
      ),
      ProjectModel(
        title: 'Transferit',
        description: 'A secure file transfer app with end-to-end encryption.',
        image: 'transferit.jpg',
        techStack: ['Flutter', 'Dart', 'Firebase', 'Encryption'],
        demoUrl: 'https://github.com/sangan007',
        repoUrl: 'https://github.com/sangan007',
      ),
      ProjectModel(
        title: 'Transaction Analytics Dashboard',
        description: 'An analytics dashboard processing over 1M data points using Hive and SQL.',
        image: 'analytics.jpg',
        techStack: ['Flutter', 'Hive', 'SQL', 'Data Visualization'],
        demoUrl: 'https://github.com/sangan007',
        repoUrl: 'https://github.com/sangan007',
      ),
    ];

    return Container(
      height: size.height,
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode
              ? [const Color(0xFF311B92), const Color(0xFF5E35B1)]
              : [const Color(0xFFEDE7F6), const Color(0xFFD1C4E9)],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Projects',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true)).shimmer(
              duration: 3000.ms,
              color: isDarkMode ? Colors.purple.shade200 : Colors.purple.shade700,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 32),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 1200
                    ? 3
                    : (MediaQuery.of(context).size.width > 600 ? 2 : 1),
                childAspectRatio: 1.1,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
              ),
              itemCount: projects.length,
              itemBuilder: (context, index) => ProjectCard(project: projects[index], index: index),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectModel {
  final String title;
  final String description;
  final String image;
  final List<String> techStack;
  final String demoUrl;
  final String repoUrl;

  ProjectModel({
    required this.title,
    required this.description,
    required this.image,
    required this.techStack,
    required this.demoUrl,
    required this.repoUrl,
  });
}

class ProjectCard extends StatefulWidget {
  final ProjectModel project;
  final int index;

  const ProjectCard({Key? key, required this.project, required this.index}) : super(key: key);

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: _isHovered ? (Matrix4.identity()..translate(0, -8, 0)) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.2 : 0.1),
              blurRadius: _isHovered ? 20 : 10,
              spreadRadius: _isHovered ? 2 : 0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
                ),
                height: double.infinity,
                width: double.infinity,
                child: Icon(
                  _getProjectIcon(widget.project.title),
                  size: 80,
                  color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      border: Border(bottom: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.2))),
                    ),
                    child: Text(
                      widget.project.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.project.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16),
                          const Text('Tech Stack:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: widget.project.techStack.map((tech) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    tech,
                                    style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor),
                                  ),
                                )).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border(top: BorderSide(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.play_arrow),
                          tooltip: 'Live Demo',
                          onPressed: () => launchUrl(Uri.parse(widget.project.demoUrl)),
                        ),
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.github, size: 20),
                          tooltip: 'View Code',
                          onPressed: () => launchUrl(Uri.parse(widget.project.repoUrl)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 800.ms, delay: Duration(milliseconds: 100 * widget.index)),
    );
  }

  IconData _getProjectIcon(String title) {
    if (title.contains('Language')) return Icons.sign_language;
    if (title.contains('Trading')) return Icons.trending_up;
    if (title.contains('Transferit')) return Icons.send;
    if (title.contains('Analytics')) return Icons.analytics;
    if (title.contains('Sustainable')) return Icons.eco;
    if (title.contains('Microservices')) return Icons.device_hub;
    return Icons.code;
  }
}

// Skills Section
class SkillsSection extends StatelessWidget {
  const SkillsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    final programmingSkills = [
      SkillModel(name: 'Go (Golang)', level: 0.9, icon: FontAwesomeIcons.golang),
      SkillModel(name: 'Python', level: 0.85, icon: FontAwesomeIcons.python),
      SkillModel(name: 'Dart/Flutter', level: 0.8, icon: FontAwesomeIcons.mobile),
      SkillModel(name: 'JavaScript', level: 0.75, icon: FontAwesomeIcons.js),
      SkillModel(name: 'C/C++', level: 0.8, icon: FontAwesomeIcons.zap),
      SkillModel(name: 'PHP', level: 0.65, icon: FontAwesomeIcons.php),
    ];

    final frontendSkills = [
      SkillModel(name: 'Flutter', level: 0.85, icon: FontAwesomeIcons.mobile),
      SkillModel(name: 'HTML/CSS', level: 0.8, icon: FontAwesomeIcons.html5),
    ];

    final backendSkills = [
      SkillModel(name: 'GORM', level: 0.85, icon: FontAwesomeIcons.database),
      SkillModel(name: 'PostgreSQL', level: 0.9, icon: FontAwesomeIcons.database),
      SkillModel(name: 'Docker', level: 0.75, icon: FontAwesomeIcons.docker),
    ];

    return Container(
      height: size.height,
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Technical Skills',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true)).shimmer(
              duration: 3000.ms,
              color: isDarkMode ? Colors.purple.shade200 : Colors.purple.shade700,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 32),
            _buildSkillCategory('Programming Languages', programmingSkills, context),
            _buildSkillCategory('Frontend Development', frontendSkills, context),
            _buildSkillCategory('Backend & DevOps', backendSkills, context),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillCategory(String title, List<SkillModel> skills, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(spacing: 24, runSpacing: 24, children: skills.map((skill) => _buildSkillCard(skill, context)).toList()),
        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildSkillCard(SkillModel skill, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600 ? 200 : 150,
      child: Column(
        children: [
          FaIcon(skill.icon, size: 48, color: Theme.of(context).primaryColor),
          const SizedBox(height: 8),
          Text(skill.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: skill.level,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
            color: Theme.of(context).primaryColor,
            minHeight: 8,
          ),
          const SizedBox(height: 4),
          Text(
            '${(skill.level * 100).toInt()}%',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class SkillModel {
  final String name;
  final double level;
  final IconData icon;

  SkillModel({required this.name, required this.level, required this.icon});
}

// Experience Section
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    final experiences = [
      ExperienceModel(
        company: 'Orinson Technologies',
        position: 'Backend Developer Intern',
        duration: 'August 2024 - October 2024',
        description: 'Optimized backend systems leading to 30% performance improvement. Developed RESTful APIs and implemented database optimizations using Go and PostgreSQL.',
      ),
      ExperienceModel(
        company: 'Earth 5R',
        position: 'Content Developer',
        duration: 'May 2024 - June 2024',
        description: 'Created technical content for sustainability initiatives that increased online engagement by 25%. Worked on UN SDG tracking applications.',
      ),
    ];

    return Container(
      height: size.height,
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode
              ? [const Color(0xFF311B92), const Color(0xFF5E35B1)]
              : [const Color(0xFFEDE7F6), const Color(0xFFD1C4E9)],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Professional Experience',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true)).shimmer(
              duration: 3000.ms,
              color: isDarkMode ? Colors.purple.shade200 : Colors.purple.shade700,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: experiences.map((exp) => _buildExperienceCard(exp, context)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceCard(ExperienceModel exp, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(exp.company, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
          const SizedBox(height: 8),
          Text(exp.position, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(
            exp.duration,
            style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7)),
          ),
          const SizedBox(height: 16),
          Text(exp.description, style: const TextStyle(fontSize: 15, height: 1.5)),
        ],
      ),
    );
  }
}

class ExperienceModel {
  final String company;
  final String position;
  final String duration;
  final String description;

  ExperienceModel({required this.company, required this.position, required this.duration, required this.description});
}

// Contact Section
class ContactSection extends StatelessWidget {
  const ContactSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Let\'s Connect',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true)).shimmer(
              duration: 3000.ms,
              color: isDarkMode ? Colors.purple.shade200 : Colors.purple.shade700,
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 24,
              children: [
                _buildContactCard(
                  Icon(Icons.email, size: 32, color: Theme.of(context).primaryColor),
                  'Email',
                  'sangeerth.b@outlook.com',
                  'mailto:sangeerth.b@outlook.com',
                  context,
                ),
                _buildContactCard(
                  FaIcon(FontAwesomeIcons.linkedin, size: 32, color: Theme.of(context).primaryColor),
                  'LinkedIn',
                  'linkedin.com/in/sangeerth',
                  'https://linkedin.com',
                  context,
                ),
                _buildContactCard(
                  FaIcon(FontAwesomeIcons.github, size: 32, color: Theme.of(context).primaryColor),
                  'GitHub',
                  'github.com/sangan007',
                  'https://github.com/sangan007',
                  context,
                ),
              ],
            ),
            const SizedBox(height: 48),
            Text(
              'Or send me a message:',
              style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7)),
            ),
            const SizedBox(height: 24),
            Container(
              width: MediaQuery.of(context).size.width > 600 ? 600 : MediaQuery.of(context).size.width - 64,
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Your Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Message',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Message sent!')));
                      },
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
                      child: const Text('Send Message'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(Widget iconWidget, String title, String subtitle, String url, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(url)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              iconWidget,
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}