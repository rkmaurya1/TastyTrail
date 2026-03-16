import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_screen.dart';
import 'onboarding_page_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.78);
  int _currentPage = 0;

  late AnimationController _textAnim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  static const List<_PageContent> _pages = [
    _PageContent(
      title: 'Order Your\nFavorite Food',
      subtitle: 'Browse hundreds of dishes near you\nand order in just a few taps.',
    ),
    _PageContent(
      title: 'Fast &\nReliable Delivery',
      subtitle: 'Your food arrives fresh and hot,\ndelivered right to your doorstep.',
    ),
    _PageContent(
      title: 'Track Your\nOrder Live',
      subtitle: 'Know exactly where your order is\nwith real-time live tracking.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _textAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textAnim, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textAnim, curve: Curves.easeOut));
    _textAnim.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textAnim.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _textAnim.reset();
    _textAnim.forward();
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, anim, __) =>
            FadeTransition(opacity: anim, child: const LoginScreen()),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 60),
                  Text(
                    '${_currentPage + 1} / ${_pages.length}',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: !isLast
                        ? GestureDetector(
                            onTap: _finish,
                            child: Text(
                              'Skip',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),

            // ── Illustration PageView
            SizedBox(
              height: size.height * 0.50,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double scale = 0.85;
                      double blurSigma = 5.0;
                      if (_pageController.position.haveDimensions) {
                        final diff = (_pageController.page! - index).abs();
                        scale = (1 - diff * 0.15).clamp(0.82, 1.0);
                        blurSigma = (diff * 6).clamp(0.0, 6.0);
                      } else {
                        scale = index == 0 ? 1.0 : 0.85;
                        blurSigma = index == 0 ? 0.0 : 5.0;
                      }

                      Widget content = Center(
                        child: OnboardingIllustration(pageIndex: index),
                      );

                      if (blurSigma > 0.5) {
                        content = ImageFiltered(
                          imageFilter: ui.ImageFilter.blur(
                            sigmaX: blurSigma,
                            sigmaY: blurSigma,
                          ),
                          child: content,
                        );
                      }

                      return Transform.scale(scale: scale, child: content);
                    },
                  );
                },
              ),
            ),

            // ── Dots
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                final active = i == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFF1A1A2E) : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            // ── Title + subtitle
            const SizedBox(height: 28),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Text(
                          _pages[_currentPage].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _pages[_currentPage].subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade500,
                            height: 1.65,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 32),
              child: isLast ? _buildGetStarted() : _buildNextRow(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            if (_currentPage > 0) {
              _pageController.animateToPage(
                _currentPage - 1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
              );
            }
          },
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              color: _currentPage > 0
                  ? Colors.grey.shade600
                  : Colors.transparent,
            ),
          ),
        ),
        GestureDetector(
          onTap: _next,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A1A2E).withValues(alpha: 0.3),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGetStarted() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: _finish,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A1A2E),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Get Started',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}

class _PageContent {
  final String title;
  final String subtitle;
  const _PageContent({required this.title, required this.subtitle});
}
