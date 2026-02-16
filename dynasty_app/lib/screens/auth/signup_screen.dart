import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/animated_background.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscure1 = true;
  bool _obscure2 = true;

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
    _confirmController.dispose();
    _animController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showSnack('Please fill in all fields', Colors.red);
      return;
    }
    if (password != confirm) {
      _showSnack('Passwords do not match', Colors.red);
      return;
    }
    if (password.length < 6) {
      _showSnack('Password must be at least 6 characters', Colors.red);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.signUp(email: email, password: password);
      if (mounted) {
        _showSnack('Account created! Please sign in.', AppTheme.accentEmerald);
        Navigator.pop(context);
      }
    } on AuthException catch (e) {
      if (mounted) _showSnack(e.message, Colors.red);
    } catch (e) {
      if (mounted) _showSnack('Error: $e', Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark.withValues(alpha: 0.5),
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primary.withValues(alpha: 0.15)),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
          ),
        ),
      ),
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
                        border: Border.all(color: AppTheme.accentMagenta.withValues(alpha: 0.15)),
                        boxShadow: [
                          BoxShadow(color: AppTheme.accentMagenta.withValues(alpha: 0.06), blurRadius: 40),
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
                                gradient: const LinearGradient(colors: [AppTheme.accentMagenta, AppTheme.primary]),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(color: AppTheme.accentMagenta.withValues(alpha: _pulse.value * 0.4), blurRadius: 25),
                                ],
                              ),
                              child: const Icon(Icons.person_add_rounded, size: 32, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 28),
                          const Text('Create Account', style: TextStyle(fontFamily: 'Inter', fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                          const SizedBox(height: 6),
                          Text('Join DynastyX today', style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.white.withValues(alpha: 0.6))),
                          const SizedBox(height: 32),
                          _buildField(_emailController, 'Email', Icons.email_rounded, keyboard: TextInputType.emailAddress),
                          const SizedBox(height: 14),
                          _buildField(_passwordController, 'Password', Icons.lock_rounded, obscure: _obscure1, suffix: GestureDetector(
                            onTap: () => setState(() => _obscure1 = !_obscure1),
                            child: Icon(_obscure1 ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: AppTheme.textSlate500, size: 20),
                          )),
                          const SizedBox(height: 14),
                          _buildField(_confirmController, 'Confirm Password', Icons.lock_rounded, obscure: _obscure2, suffix: GestureDetector(
                            onTap: () => setState(() => _obscure2 = !_obscure2),
                            child: Icon(_obscure2 ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: AppTheme.textSlate500, size: 20),
                          )),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: _isLoading ? null : const LinearGradient(colors: [AppTheme.accentMagenta, AppTheme.primary]),
                                color: _isLoading ? AppTheme.accentMagenta.withValues(alpha: 0.4) : null,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: _isLoading ? null : [BoxShadow(color: AppTheme.accentMagenta.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 8))],
                              ),
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _signUp,
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, disabledBackgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                                child: _isLoading
                                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                    : const Text('Sign Up', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have an account? ', style: TextStyle(fontFamily: 'Inter', color: Colors.white.withValues(alpha: 0.6))),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: ShaderMask(
                                  shaderCallback: (bounds) => const LinearGradient(colors: [AppTheme.accentCyan, AppTheme.primary]).createShader(bounds),
                                  child: const Text('Sign In', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, color: Colors.white)),
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
        border: Border.all(color: AppTheme.accentMagenta.withValues(alpha: 0.1)),
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
