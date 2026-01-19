import 'package:flutter/material.dart';
import '../../core/config/app_config.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/constants.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final userCredential = await _authService.signInWithGoogle();
      if (userCredential != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppConfig.primaryGradient,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                const Spacer(),
                // Logo and App Name
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingLarge),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusXL),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.restaurant_menu,
                        size: 80,
                        color: AppConfig.primaryColor,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    Text(
                      AppConfig.appName,
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      AppConfig.tagline,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Login Buttons
                Container(
                  width: size.width,
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppConstants.radiusXL),
                      topRight: Radius.circular(AppConstants.radiusXL),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        AppStrings.welcome,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingXL),
                      // Google Sign In Button
                      if (AppConfig.enableGoogleLogin)
                        _buildLoginButton(
                          onPressed: _isLoading ? null : _handleGoogleSignIn,
                          icon: Icons.g_mobiledata,
                          label: AppStrings.loginWithGoogle,
                          backgroundColor: Colors.white,
                          textColor: Colors.black87,
                          borderColor: Colors.grey.shade300,
                        ),
                      if (AppConfig.enableGoogleLogin &&
                          AppConfig.enablePhoneLogin)
                        const SizedBox(height: AppConstants.paddingMedium),
                      // Phone Sign In Button
                      if (AppConfig.enablePhoneLogin)
                        _buildLoginButton(
                          onPressed: _isLoading ? null : () {},
                          icon: Icons.phone,
                          label: AppStrings.loginWithPhone,
                          backgroundColor: AppConfig.primaryColor,
                          textColor: Colors.white,
                        ),
                      if (AppConfig.enableGuestMode)
                        const SizedBox(height: AppConstants.paddingMedium),
                      // Guest Mode Button
                      if (AppConfig.enableGuestMode)
                        TextButton(
                          onPressed: _isLoading ? null : () {},
                          child: Text(
                            AppStrings.continueAsGuest,
                            style: TextStyle(
                              color: AppConfig.primaryColor,
                              fontSize: AppConstants.fontSizeRegular,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      const SizedBox(height: AppConstants.paddingMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          side: borderColor != null ? BorderSide(color: borderColor) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
        ),
        child: _isLoading && onPressed == null
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 24),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeRegular,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
