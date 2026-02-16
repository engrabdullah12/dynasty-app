import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/animated_background.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  late AnimationController _animController;
  late AnimationController _pulseController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);

    _fade = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _pulse = Tween<double>(begin: 0.6, end: 1.0)
        .animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack('Please enter email and password', Colors.red);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.signIn(email: email, password: password);
    } on AuthException catch (e) {
      if (mounted) {
        if (e.message.toLowerCase().contains('email not confirmed')) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Email not verified. ${e.message}'),
            backgroundColor: AppTheme.accentAmber,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            action: SnackBarAction(label: 'Resend', textColor: Colors.white, onPressed: _resendEmail),
            duration: const Duration(seconds: 10),
          ));
        } else {
          _showSnack(e.message, Colors.red);
        }
      }
    } catch (e) {
      if (mounted) _showSnack('Error: $e', Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendEmail() async {
    try {
      await _authService.resendVerificationEmail(_emailController.text.trim());
      if (mounted) _showSnack('Verification email sent!', AppTheme.accentEmerald);
    } catch (e) {
      if (mounted) _showSnack('Error: $e', Colors.red);
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color.withValues(alpha: 0.9),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceDark.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.15)),
                        boxShadow: [
                          BoxShadow(color: AppTheme.primary.withValues(alpha: 0.08), blurRadius: 40, spreadRadius: 0),
                          BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 30),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Pulsing icon
                          AnimatedBuilder(
                            animation: _pulse,
                            builder: (context, child) => Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                gradient: AppTheme.primaryGradient,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primary.withValues(alpha: _pulse.value * 0.4),
                                    blurRadius: 25,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.lock_rounded, size: 32, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 28),
                          const Text(
                            'Welcome Back',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Sign in to continue',
                            style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.white.withValues(alpha: 0.6)),
                          ),
                          const SizedBox(height: 32),
                          _buildField(_emailController, 'Email', Icons.email_rounded, keyboard: TextInputType.emailAddress),
                          const SizedBox(height: 16),
                          _buildField(
                            _passwordController, 'Password', Icons.lock_rounded,
                            obscure: _obscurePassword,
                            suffix: GestureDetector(
                              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                              child: Icon(_obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: AppTheme.textSlate500, size: 20),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Gradient sign in button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: _isLoading ? null : AppTheme.primaryGradient,
                                color: _isLoading ? AppTheme.primary.withValues(alpha: 0.4) : null,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: _isLoading
                                    ? null
                                    : [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 8))],
                              ),
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _signIn,
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, disabledBackgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                                child: _isLoading
                                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                    : const Text('Sign In', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account? ", style: TextStyle(fontFamily: 'Inter', color: Colors.white.withValues(alpha: 0.6))),
                              GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen())),
                                child: ShaderMask(
                                  shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
                                  child: const Text('Sign Up', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label, IconData icon, {bool obscure = false, TextInputType? keyboard, Widget? suffix}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: obscure,
        keyboardType: keyboard,
        style: const TextStyle(fontFamily: 'Inter', color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontFamily: 'Inter', color: Colors.white.withValues(alpha: 0.5)),
          prefixIcon: Icon(icon, color: AppTheme.textSlate500, size: 20),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
