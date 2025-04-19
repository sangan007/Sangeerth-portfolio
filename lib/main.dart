import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

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
    
    // Define color scheme based on theme
    final primaryColor = themeProvider.isDarkMode 
        ? const Color(0xFF6E56CF) // Deep purple for dark mode
        : const Color(0xFF7C4DFF); // Brighter purple for light mode
    
    final accentColor = themeProvider.isDarkMode
        ? const Color(0xFF9E86FF) // Lighter purple for dark mode
        : const Color(0xFF5E35B1); // Deeper purple for light mode
    
    final backgroundColor = themeProvider.isDarkMode
        ? const Color(0xFF121212) // Very dark for dark mode
        : const Color(0xFFF8F9FA); // Off-white for light mode
    
    final cardColor = themeProvider.isDarkMode
        ? const Color(0xFF1E1E1E) // Dark gray for dark mode
        : Colors.white; // White for light mode
    
    final textColor = themeProvider.isDarkMode
        ? Colors.white // White text for dark mode
        : const Color(0xFF2D3748); // Dark gray text for light mode

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sangeerth B - Developer Portfolio',
      theme: ThemeData(
        brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        cardColor: cardColor,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: textColor,
          displayColor: textColor,
        ),
        iconTheme: IconThemeData(
          color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, 
            backgroundColor: primaryColor,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryColor,
            side: BorderSide(color: primaryColor),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: themeProvider.isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: themeProvider.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: themeProvider.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor),
          ),
          labelStyle: TextStyle(
            color: themeProvider.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
          ),
        ),
        dividerTheme: DividerThemeData(
          color: themeProvider.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
          thickness: 1,
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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  bool _isScrolled = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _scrollController.addListener(_scrollListener);
  }
  
  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }
  
  void _scrollListener() {
    if (_scrollController.offset > 70 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 70 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
    
    // Update tab controller based on scroll position
    final screenHeight = MediaQuery.of(context).size.height;
    final currentIndex = (_scrollController.offset / screenHeight).round().clamp(0, 4);
    if (_tabController.index != currentIndex) {
      _tabController.animateTo(currentIndex);
    }
  }

  void _scrollToSection(int index) {
    final screenHeight = MediaQuery.of(context).size.height;
    _scrollController.animateTo(
      index * screenHeight,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isMobile ? 70 : 80),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          color: _isScrolled 
              ? (isDarkMode ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.8))
              : Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40, vertical: 8),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo/Name
                Text(
                  'Sangeerth B',
                  style: TextStyle(
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: _isScrolled 
                        ? Theme.of(context).primaryColor
                        : (isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
                
                // Navigation
                if (!isMobile) Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNavItem('Home', 0),
                      _buildNavItem('About', 1),
                      _buildNavItem('Projects', 2),
                      _buildNavItem('Skills', 3),
                      _buildNavItem('Contact', 4),
                    ],
                  ),
                ),
                
                // Theme Toggle & Mobile Menu
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Provider.of<ThemeProvider>(context).isDarkMode 
                            ? Icons.light_mode_rounded 
                            : Icons.dark_mode_rounded,
                        color: _isScrolled 
                            ? Theme.of(context).primaryColor
                            : (isDarkMode ? Colors.white : Colors.black),
                      ),
                      onPressed: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                    ),
                    if (isMobile) PopupMenuButton<int>(
                      icon: Icon(
                        Icons.menu,
                        color: _isScrolled 
                            ? Theme.of(context).primaryColor
                            : (isDarkMode ? Colors.white : Colors.black),
                      ),
                      onSelected: _scrollToSection,
                      itemBuilder: (context) => [
                        _buildPopupMenuItem('Home', 0, Icons.home),
                        _buildPopupMenuItem('About', 1, Icons.person),
                        _buildPopupMenuItem('Projects', 2, Icons.work),
                        _buildPopupMenuItem('Skills', 3, Icons.code),
                        _buildPopupMenuItem('Contact', 4, Icons.email),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(child: HeroSection(onScrollToProjects: () => _scrollToSection(2))),
          SliverToBoxAdapter(child: AboutSection()),
          SliverToBoxAdapter(child: ProjectsSection()),
          SliverToBoxAdapter(child: SkillsSection()),
          SliverToBoxAdapter(child: ContactSection()),
        ],
      ),
    );
  }
  
  Widget _buildNavItem(String title, int index) {
    final isActive = _tabController.index == index;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () => _scrollToSection(index),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isActive 
                ? Theme.of(context).primaryColor.withOpacity(0.1) 
                : Colors.transparent,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive 
                  ? Theme.of(context).primaryColor 
                  : (_isScrolled 
                      ? (Provider.of<ThemeProvider>(context).isDarkMode ? Colors.white70 : Colors.black87)
                      : (Provider.of<ThemeProvider>(context).isDarkMode ? Colors.white : Colors.black)),
            ),
          ),
        ),
      ),
    );
  }
  
  PopupMenuItem<int> _buildPopupMenuItem(String title, int index, IconData icon) {
    return PopupMenuItem<int>(
      value: index,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Text(title),
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
    final isMobile = size.width < 768;

    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)] // Deep blue-purple gradient for dark
              : [const Color(0xFFF8F9FA), const Color(0xFFE9ECEF)], // Light gray gradient for light
        ),
      ),
      child: Stack(
        children: [
          // Animated background elements
          ...List.generate(30, (index) {
            final random = math.Random(index);
            return AnimatedPositioned(
              duration: Duration(milliseconds: 10000 + random.nextInt(10000)),
              curve: Curves.easeInOut,
              left: random.nextDouble() * size.width,
              top: random.nextDouble() * size.height,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                opacity: isDarkMode ? 0.15 : 0.1,
                child: Container(
                  width: 4 + random.nextInt(8).toDouble(),
                  height: 4 + random.nextInt(8).toDouble(),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          
          // Decorative elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor.withOpacity(0.05),
              ),
            ),
          ),
          
          // Main content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting
                Text(
                  'Hello, I\'m',
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 24,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
                
                // Name
                Text(
                  'SANGEERTH B',
                  style: TextStyle(
                    fontSize: isMobile ? 40 : 72,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: isDarkMode ? Colors.white : Colors.black87,
                    height: 1.1,
                  ),
                ).animate().fadeIn(duration: 800.ms, delay: 200.ms).slideY(begin: 0.2, end: 0),
                
                // Title
                Container(
                  margin: const EdgeInsets.only(top: 16, bottom: 24),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Software Developer & Backend Engineer',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 20,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ).animate().fadeIn(duration: 800.ms, delay: 400.ms).slideY(begin: 0.2, end: 0),
                
                // Description
                SizedBox(
                  width: isMobile ? size.width : size.width * 0.5,
                  child: Text(
                    'Building scalable backend systems and cross-platform applications with a focus on performance and user experience.',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      height: 1.6,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ).animate().fadeIn(duration: 800.ms, delay: 600.ms),
                
                const SizedBox(height: 40),
                
                // Action buttons
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.work_outline_rounded),
                      label: const Text('View My Work'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 16 : 24, 
                          vertical: isMobile ? 12 : 16
                        ),
                        textStyle: TextStyle(fontSize: isMobile ? 14 : 16),
                      ),
                      onPressed: onScrollToProjects,
                    ).animate().fadeIn(duration: 800.ms, delay: 800.ms),
                    
                    const SizedBox(width: 16),
                    
                    OutlinedButton.icon(
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Download CV'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 16 : 24, 
                          vertical: isMobile ? 12 : 16
                        ),
                        textStyle: TextStyle(fontSize: isMobile ? 14 : 16),
                      ),
                      onPressed: () async {
                        const cvUrl = 'https://drive.google.com/file/d/1QPHngvo6w0qB1IjbMTPBymdcycI-p_wN/view?usp=drive_link'; 
                        if (await canLaunchUrl(Uri.parse(cvUrl))) {
                          await launchUrl(Uri.parse(cvUrl));
                        } else {
                          throw 'Could not launch $cvUrl';
                        }
                      },
                    ).animate().fadeIn(duration: 800.ms, delay: 1000.ms),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Social links
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildSocialLink(FontAwesomeIcons.github, 'GitHub', 'https://github.com/sangan007', context),
                    _buildSocialLink(FontAwesomeIcons.linkedin, 'LinkedIn', 'https://linkedin.com', context),
                    _buildSocialLink(FontAwesomeIcons.envelope, 'Email', 'mailto:sangeerth.b@outlook.com', context),
                  ],
                ).animate().fadeIn(duration: 800.ms, delay: 1200.ms),
              ],
            ),
          ),
          
          // Scroll indicator
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Scroll Down',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white60 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 32,
                    color: isDarkMode ? Colors.white60 : Colors.black54,
                  ).animate(onPlay: (controller) => controller.repeat())
                    .fadeIn(duration: 800.ms)
                    .then()
                    .moveY(begin: 0, end: 10, duration: 800.ms)
                    .then()
                    .moveY(begin: 0, end: -10, duration: 800.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSocialLink(IconData icon, String label, String url, BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, size: 16, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
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
    final isMobile = size.width < 768;

    return Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80, vertical: 64),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title with animated underline
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Me',
                  style: TextStyle(
                    fontSize: isMobile ? 28 : 36,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.1, end: 0),
            
            const SizedBox(height: 48),
            
            // Main content
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 900) {
                  // Desktop layout
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile image and social links
                      Expanded(
                        flex: 2,
                        child: _buildProfileSection(context, isDarkMode),
                      ),
                      const SizedBox(width: 64),
                      // Bio and skills
                      Expanded(
                        flex: 3,
                        child: _buildBioSection(context, isDarkMode, false),
                      ),
                    ],
                  );
                } else {
                  // Mobile layout
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileSection(context, isDarkMode),
                      const SizedBox(height: 48),
                      _buildBioSection(context, isDarkMode, true),
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

  Widget _buildProfileSection(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Profile image with animated border
        Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          padding: const EdgeInsets.all(4), // Border width
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDarkMode ? const Color(0xFF1A1A2E) : Colors.white,
            ),
            padding: const EdgeInsets.all(4), // Inner padding
            child: ClipRRect(
              borderRadius: BorderRadius.circular(140),
              child: Image.asset(
                'assets/Sangeerth_B.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if image is not found
                  return Container(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Center(
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.9, 0.9)),
        
        const SizedBox(height: 32),
        
        // Social links
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
    );
  }

  Widget _buildBioSection(BuildContext context, bool isDarkMode, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bio paragraphs
        Text(
          'Hello! I\'m Sangeerth B',
          style: TextStyle(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ).animate().fadeIn(duration: 800.ms).slideX(begin: 0.1, end: 0),
        
        const SizedBox(height: 16),
        
        Text(
          'A software developer specializing in backend development and cross-platform applications. With expertise in Go, Flutter, and Python, I focus on building scalable solutions and user-friendly interfaces.',
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            height: 1.6,
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
        
        const SizedBox(height: 16),
        
        Text(
          'I\'m currently pursuing my B. Tech in Information Technology at Cochin University of Science and Technology (CUSAT). My work experience includes optimizing backend systems at Orinson Technologies and creating content for sustainability initiatives at Earth 5R.',
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            height: 1.6,
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ).animate().fadeIn(duration: 800.ms, delay: 400.ms),
        
        const SizedBox(height: 32),
        
        // Key skills section
        Text(
          'Key Skills',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        
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
        ).animate().fadeIn(duration: 800.ms, delay: 600.ms),
        
        const SizedBox(height: 32),
        
        // Key achievements section
        Text(
          'Key Achievements',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        
        const SizedBox(height: 16),
        
        _buildAchievement('Increased backend system performance by 30% at Orinson Technologies.', context),
        _buildAchievement('Authored content that boosted online visibility by 25% at Earth 5R.', context),
        _buildAchievement('Developed a trading bot with real-time sentiment analysis.', context),
        _buildAchievement('Created a sign language detection app with 95% accuracy.', context),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String label, String url, BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, size: 16, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(String label, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildAchievement(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
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
    final isMobile = size.width < 768;

    final projects = [
      ProjectModel(
        title: 'Sign Language Detection App',
        description: 'A Flutter application that uses CNN to detect sign language gestures in real-time with 95% accuracy. The app helps bridge communication gaps for the hearing impaired.',
        image: 'sign_language.jpg',
        techStack: ['Flutter', 'CNN', 'TensorFlow', 'Machine Learning'],
        demoUrl: 'https://github.com/sangan007',
        repoUrl: 'https://github.com/sangan007',
        featured: true,
      ),
      ProjectModel(
        title: 'Sentiment Analysis Trading Bot',
        description: 'A sophisticated trading bot that analyzes market sentiment from social media and news sources to make informed trading decisions. Built with Flutter for the frontend and C++ for the backend processing.',
        image: 'trading_bot.jpg',
        techStack: ['Flutter', 'C++', 'Sentiment Analysis', 'Data Visualization'],
        demoUrl: 'https://github.com/sangan007',
        repoUrl: 'https://github.com/sangan007',
        featured: true,
      ),
      ProjectModel(
        title: 'Transferit',
        description: 'A secure file transfer application with end-to-end encryption. Allows users to share files across devices with military-grade security protocols.',
        image: 'transferit.jpg',
        techStack: ['Flutter', 'Dart', 'Firebase', 'Encryption'],
        demoUrl: 'https://github.com/sangan007',
        repoUrl: 'https://github.com/sangan007',
        featured: false,
      ),
      ProjectModel(
        title: 'Transaction Analytics Dashboard',
        description: 'An analytics dashboard processing over 1M data points using Hive and SQL. Provides real-time insights and visualizations for financial transactions.',
        image: 'analytics.jpg',
        techStack: ['Flutter', 'Hive', 'SQL', 'Data Visualization'],
        demoUrl: 'https://github.com/sangan007',
        repoUrl: 'https://github.com/sangan007',
        featured: false,
      ),
    ];

    return Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80, vertical: 64),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode
              ? [const Color(0xFF16213E), const Color(0xFF0F3460)]
              : [const Color(0xFFF8F9FA), const Color(0xFFE9ECEF)],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title with animated underline
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Projects',
                  style: TextStyle(
                    fontSize: isMobile ? 28 : 36,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.1, end: 0),
            
            const SizedBox(height: 16),
            
            Text(
              'Featured projects I\'ve built',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Projects grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size.width > 1200 ? 3 : (size.width > 700 ? 2 : 1),
                childAspectRatio: 0.8,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
              ),
              itemCount: projects.length,
              itemBuilder: (context, index) => ProjectCard(
                project: projects[index],
                index: index,
              ),
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
  final bool featured;

  ProjectModel({
    required this.title,
    required this.description,
    required this.image,
    required this.techStack,
    required this.demoUrl,
    required this.repoUrl,
    this.featured = false,
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
          color: isDarkMode ? const Color(0xFF1E1E2D) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.2 : 0.1),
              blurRadius: _isHovered ? 20 : 10,
              spreadRadius: _isHovered ? 2 : 0,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(
            color: _isHovered 
                ? Theme.of(context).primaryColor.withOpacity(0.5)
                : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project header with title and featured badge
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.project.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.project.featured)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Featured',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Project content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getProjectIcon(widget.project.title),
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Project description
                      Expanded(
                        child: Text(
                          widget.project.description,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Tech stack
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tech Stack:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
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
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            )).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Project actions
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _isHovered ? 60 : 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: _isHovered 
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : (isDarkMode ? const Color(0xFF1A1A2D) : Colors.grey.shade50),
                  border: Border(
                    top: BorderSide(
                      color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Live Demo'),
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
        ),
      ).animate().fadeIn(duration: 800.ms, delay: Duration(milliseconds: 100 * widget.index)),
    );
  }

  IconData _getProjectIcon(String title) {
    if (title.contains('Language')) return Icons.sign_language_rounded;
    if (title.contains('Trading')) return Icons.trending_up_rounded;
    if (title.contains('Transferit')) return Icons.send_rounded;
    if (title.contains('Analytics')) return Icons.analytics_rounded;
    if (title.contains('Sustainable')) return Icons.eco_rounded;
    if (title.contains('Microservices')) return Icons.device_hub_rounded;
    return Icons.code_rounded;
  }
}

// Skills Section
class SkillsSection extends StatelessWidget {
  const SkillsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final isMobile = size.width < 768;

    final programmingSkills = [
      SkillModel(name: 'Go (Golang)', level: 0.9, icon: FontAwesomeIcons.golang),
      SkillModel(name: 'Python', level: 0.85, icon: FontAwesomeIcons.python),
      SkillModel(name: 'Dart/Flutter', level: 0.8, icon: FontAwesomeIcons.mobile),
      SkillModel(name: 'JavaScript', level: 0.75, icon: FontAwesomeIcons.js),
      SkillModel(name: 'C/C++', level: 0.8, icon: FontAwesomeIcons.code),
      SkillModel(name: 'PHP', level: 0.65, icon: FontAwesomeIcons.php),
    ];

    final frontendSkills = [
      SkillModel(name: 'Flutter', level: 0.85, icon: FontAwesomeIcons.mobile),
      SkillModel(name: 'HTML/CSS', level: 0.8, icon: FontAwesomeIcons.html5),
      SkillModel(name: 'React', level: 0.7, icon: FontAwesomeIcons.react),
    ];

    final backendSkills = [
      SkillModel(name: 'GORM', level: 0.85, icon: FontAwesomeIcons.database),
      SkillModel(name: 'PostgreSQL', level: 0.9, icon: FontAwesomeIcons.database),
      SkillModel(name: 'Docker', level: 0.75, icon: FontAwesomeIcons.docker),
      SkillModel(name: 'RESTful APIs', level: 0.85, icon: FontAwesomeIcons.server),
    ];

    return Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80, vertical: 64),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title with animated underline
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Technical Skills',
                  style: TextStyle(
                    fontSize: isMobile ? 28 : 36,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.1, end: 0),
            
            const SizedBox(height: 16),
            
            Text(
              'My technical expertise and proficiency levels',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Skills categories
            _buildSkillCategory('Programming Languages', programmingSkills, context, 0),
            _buildSkillCategory('Frontend Development', frontendSkills, context, 1),
            _buildSkillCategory('Backend & DevOps', backendSkills, context, 2),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillCategory(String title, List<SkillModel> skills, BuildContext context, int categoryIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Provider.of<ThemeProvider>(context).isDarkMode ? Colors.white : Colors.black87,
          ),
        ).animate().fadeIn(duration: 800.ms, delay: Duration(milliseconds: 200 * categoryIndex)),
        
        const SizedBox(height: 24),
        
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: skills.asMap().entries.map((entry) {
            final index = entry.key;
            final skill = entry.value;
            return _buildSkillCard(skill, context)
                .animate()
                .fadeIn(duration: 800.ms, delay: Duration(milliseconds: 100 * index + 300 * categoryIndex));
          }).toList(),
        ),
        
        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildSkillCard(SkillModel skill, BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E2D) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Skill icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                skill.icon,
                size: 28,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Skill name
          Text(
            skill.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Skill progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Proficiency',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  Text(
                    '${(skill.level * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  // Background
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  // Progress
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1500),
                    height: 8,
                    width: 168 * skill.level, // 168 = width of parent - padding
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.7),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideX(begin: -1, end: 0, duration: 1500.ms),
                ],
              ),
            ],
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

// Contact Section
class ContactSection extends StatelessWidget {
  const ContactSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final isMobile = size.width < 768;

    return Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80, vertical: 64),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode
              ? [const Color(0xFF16213E), const Color(0xFF0F3460)]
              : [const Color(0xFFF8F9FA), const Color(0xFFE9ECEF)],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title with animated underline
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Let\'s Connect',
                  style: TextStyle(
                    fontSize: isMobile ? 28 : 36,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.1, end: 0),
            
            const SizedBox(height: 16),
            
            Text(
              'Have a project in mind or just want to say hello?',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Contact layout
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 900) {
                  // Desktop layout
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Contact info
                      Expanded(
                        flex: 2,
                        child: _buildContactInfo(context, isDarkMode),
                      ),
                      const SizedBox(width: 64),
                      // Contact form
                      Expanded(
                        flex: 3,
                        child: _buildContactForm(context, isDarkMode),
                      ),
                    ],
                  );
                } else {
                  // Mobile layout
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContactInfo(context, isDarkMode),
                      const SizedBox(height: 48),
                      _buildContactForm(context, isDarkMode),
                    ],
                  );
                }
              },
            ),
            
            // Footer
            const SizedBox(height: 64),
            Center(
              child: Column(
                children: [
                  Text(
                    '© ${DateTime.now().year} Sangeerth B. All rights reserved.',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white60 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Made with Flutter ❤️',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white60 : Colors.black54,
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

  Widget _buildContactInfo(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ).animate().fadeIn(duration: 800.ms),
        
        const SizedBox(height: 24),
        
        _buildContactCard(
          icon: Icons.email_rounded,
          title: 'Email',
          content: 'sangeerth.b@outlook.com',
          url: 'mailto:sangeerth.b@outlook.com',
          context: context,
          delay: 0,
        ),
        
        _buildContactCard(
          icon: FontAwesomeIcons.linkedin,
          title: 'LinkedIn',
          content: 'linkedin.com/in/sangeerth',
          url: 'https://linkedin.com',
          context: context,
          delay: 1,
        ),
        
        _buildContactCard(
          icon: FontAwesomeIcons.github,
          title: 'GitHub',
          content: 'github.com/sangan007',
          url: 'https://github.com/sangan007',
          context: context,
          delay: 2,
        ),
        
        const SizedBox(height: 32),
        
        Text(
          'Available for freelance projects and full-time positions.',
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ).animate().fadeIn(duration: 800.ms, delay: 600.ms),
      ],
    );
  }

  Widget _buildContactForm(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E2D) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send Me a Message',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ).animate().fadeIn(duration: 800.ms),
          
          const SizedBox(height: 24),
          
          // Name field
          TextField(
            decoration: InputDecoration(
              labelText: 'Your Name',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
          ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
          
          const SizedBox(height: 16),
          
          // Email field
          TextField(
            decoration: InputDecoration(
              labelText: 'Email Address',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ).animate().fadeIn(duration: 800.ms, delay: 400.ms),
          
          const SizedBox(height: 16),
          
          // Message field
          TextField(
            decoration: InputDecoration(
              labelText: 'Message',
              prefixIcon: Icon(Icons.message_outlined),
              alignLabelWithHint: true,
            ),
            maxLines: 5,
          ).animate().fadeIn(duration: 800.ms, delay: 600.ms),
          
          const SizedBox(height: 24),
          
          // Submit button
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Message sent successfully!'),
                    backgroundColor: Theme.of(context).primaryColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: Icon(Icons.send_rounded),
              label: Text('Send Message'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ).animate().fadeIn(duration: 800.ms, delay: 800.ms),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String content,
    required String url,
    required BuildContext context,
    required int delay,
  }) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E2D) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms, delay: Duration(milliseconds: 200 * delay));
  }
}