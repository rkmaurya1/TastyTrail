import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/auth_service.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isGuestLoading = false;

  // Master fade-in
  late AnimationController _masterCtrl;
  late Animation<double> _masterFade;
  late Animation<Offset> _masterSlide;

  // Logo pulse
  late AnimationController _logoCtrl;
  late Animation<double> _logoScale;

  // Card floats (3 separate controllers for stagger)
  late List<AnimationController> _cardCtrls;
  late List<Animation<double>> _cardFloats;

  // Button press
  bool _googlePressed = false;
  bool _guestPressed = false;

  static const _bgColor = Color(0xFFF5EFE6);
  static const _primaryColor = Color(0xFFE8472A);
  static const _cardRadius = 24.0;

  static const List<_FoodCard> _cards = [
    _FoodCard(
      label: 'Pizza',
      emoji: '🍕',
      color: Color(0xFFFF6B35),
      bg: Color(0xFFFFF0EB),
      tag: 'Italian',
    ),
    _FoodCard(
      label: 'Burger',
      emoji: '🍔',
      color: Color(0xFFF7C948),
      bg: Color(0xFFFFFBED),
      tag: 'American',
    ),
    _FoodCard(
      label: 'Sushi',
      emoji: '🍱',
      color: Color(0xFF4ECDC4),
      bg: Color(0xFFEBFAF9),
      tag: 'Japanese',
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Master fade
    _masterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _masterFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _masterCtrl, curve: const Interval(0, 0.7, curve: Curves.easeOut)),
    );
    _masterSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _masterCtrl, curve: Curves.easeOut));

    // Logo pulse
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _logoScale = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.easeInOut),
    );

    // Card staggered float
    _cardCtrls = List.generate(3, (i) {
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 2000 + i * 200),
      )..repeat(reverse: true);
    });
    _cardFloats = _cardCtrls.map((c) {
      return Tween<double>(begin: -6, end: 6).animate(
        CurvedAnimation(parent: c, curve: Curves.easeInOut),
      );
    }).toList();

    // Start master with delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _masterCtrl.forward();
    });
  }

  @override
  void dispose() {
    _masterCtrl.dispose();
    _logoCtrl.dispose();
    for (final c in _cardCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final result = await _authService.signInWithGoogle();
      if (result != null && mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, anim, __) =>
                FadeTransition(opacity: anim, child: const HomeScreen()),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign in failed: ${e.toString()}'),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGuestLogin() async {
    setState(() => _isGuestLoading = true);
    try {
      await _authService.signInAnonymously();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, anim, __) =>
                FadeTransition(opacity: anim, child: const HomeScreen()),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      }
    } catch (_) {
      // Guest fallback — just navigate
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } finally {
      if (mounted) setState(() => _isGuestLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _masterFade,
          child: SlideTransition(
            position: _masterSlide,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 48),
                  _buildLogo(),
                  const SizedBox(height: 12),
                  _buildTitle(),
                  const SizedBox(height: 6),
                  _buildSubtitle(),
                  const SizedBox(height: 44),
                  _buildFoodCards(),
                  const SizedBox(height: 48),
                  _buildGoogleButton(),
                  const SizedBox(height: 14),
                  _buildGuestButton(),
                  const SizedBox(height: 28),
                  _buildTermsText(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Logo ───────────────────────────────────────────────
  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _logoScale,
      builder: (_, __) => Transform.scale(
        scale: _logoScale.value,
        child: Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE8472A), Color(0xFFFF7043)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Fork
              Positioned(
                left: 22,
                child: _buildUtensil(isFork: true),
              ),
              // Spoon
              Positioned(
                right: 22,
                child: _buildUtensil(isFork: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUtensil({required bool isFork}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top part
        if (isFork) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _tine(), const SizedBox(width: 3), _tine(), const SizedBox(width: 3), _tine(),
            ],
          ),
          const SizedBox(height: 3),
        ] else ...[
          Container(
            width: 16, height: 16,
            decoration: const BoxDecoration(
              color: Colors.white, shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 2),
        ],
        // Handle
        Container(
          width: isFork ? 4 : 5,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _tine() => Container(
    width: 3,
    height: 10,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(2),
    ),
  );

  // ─── Title & Subtitle ────────────────────────────────────
  Widget _buildTitle() {
    return Text(
      'TastyTrail',
      style: GoogleFonts.poppins(
        fontSize: 38,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF1A1A1A),
        letterSpacing: -0.5,
        height: 1.1,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Savor the Flavor, Find Your Path.',
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontSize: 15,
        color: const Color(0xFF8A8A8A),
        height: 1.5,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  // ─── Food Cards ──────────────────────────────────────────
  Widget _buildFoodCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(_cards.length, (i) {
        // Middle card is taller
        final isCenter = i == 1;
        return Padding(
          padding: EdgeInsets.only(
            left: i == 0 ? 0 : 10,
            bottom: isCenter ? 0 : 10,
          ),
          child: AnimatedBuilder(
            animation: _cardFloats[i],
            builder: (_, __) => Transform.translate(
              offset: Offset(0, _cardFloats[i].value),
              child: _buildFoodCard(_cards[i], isCenter: isCenter, index: i),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFoodCard(_FoodCard card, {required bool isCenter, required int index}) {
    return GestureDetector(
      onTapDown: (_) => setState(() {}),
      onTapUp: (_) => setState(() {}),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: 1.0),
        duration: const Duration(milliseconds: 100),
        builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
        child: Container(
          width: isCenter ? 115 : 100,
          height: isCenter ? 155 : 135,
          decoration: BoxDecoration(
            color: card.bg,
            borderRadius: BorderRadius.circular(_cardRadius),
            boxShadow: [
              BoxShadow(
                color: card.color.withValues(alpha: isCenter ? 0.22 : 0.14),
                blurRadius: isCenter ? 24 : 16,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.8),
                blurRadius: 0,
                offset: const Offset(-2, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Emoji in circle
              Container(
                width: isCenter ? 68 : 58,
                height: isCenter ? 68 : 58,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: card.color.withValues(alpha: 0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    card.emoji,
                    style: TextStyle(fontSize: isCenter ? 34 : 28),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                card.label,
                style: GoogleFonts.poppins(
                  fontSize: isCenter ? 15 : 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: card.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  card.tag,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: card.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Google Button ───────────────────────────────────────
  Widget _buildGoogleButton() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _googlePressed = true),
      onTapUp: (_) => setState(() => _googlePressed = false),
      onTapCancel: () => setState(() => _googlePressed = false),
      onTap: _isLoading ? null : _handleGoogleSignIn,
      child: AnimatedScale(
        scale: _googlePressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE8472A), Color(0xFFFF6B47)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: _googlePressed
                ? []
                : [
                    BoxShadow(
                      color: _primaryColor.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: _isLoading
              ? const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google G logo
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'G',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF4285F4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Sign in with Google',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // ─── Guest Button ────────────────────────────────────────
  Widget _buildGuestButton() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _guestPressed = true),
      onTapUp: (_) => setState(() => _guestPressed = false),
      onTapCancel: () => setState(() => _guestPressed = false),
      onTap: _isGuestLoading ? null : _handleGuestLogin,
      child: AnimatedScale(
        scale: _guestPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            color: _guestPressed
                ? const Color(0xFFEDE7DB)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFD4C4B0),
              width: 1.8,
            ),
          ),
          child: _isGuestLoading
              ? Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.grey.shade600,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      color: Colors.grey.shade600,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Continue as Guest',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // ─── Terms ───────────────────────────────────────────────
  Widget _buildTermsText() {
    return Text(
      'By continuing, you agree to our\nTerms of Service & Privacy Policy',
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontSize: 11.5,
        color: Colors.grey.shade400,
        height: 1.6,
      ),
    );
  }
}

// ─── Data model ─────────────────────────────────────────────
class _FoodCard {
  final String label;
  final String emoji;
  final Color color;
  final Color bg;
  final String tag;

  const _FoodCard({
    required this.label,
    required this.emoji,
    required this.color,
    required this.bg,
    required this.tag,
  });
}
