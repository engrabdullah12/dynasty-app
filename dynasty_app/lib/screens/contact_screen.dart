import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> with SingleTickerProviderStateMixin {
  int _selectedService = 0;
  final List<String> _services = ['Software Dev', 'Digital Marketing', 'Branding', 'SEO', 'Cloud'];

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _detailsController = TextEditingController();
  bool _isSubmitting = false;

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _detailsController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _submitInquiry() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final details = _detailsController.text.trim();
    final service = _services[_selectedService];

    if (name.isEmpty || email.isEmpty || details.isEmpty) {
      _showSnack('Please fill in all fields', Colors.red);
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      _showSnack('Please enter a valid email', Colors.red);
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await Supabase.instance.client.from('inquiries').insert({
        'full_name': name,
        'email': email,
        'service_interest': service,
        'project_details': details,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        _nameController.clear();
        _emailController.clear();
        _detailsController.clear();
        setState(() => _selectedService = 0);
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) _showSnack('Failed to send: $e', Colors.red);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color.withValues(alpha: 0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: AppTheme.accentEmerald.withValues(alpha: 0.2)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppTheme.accentEmerald.withValues(alpha: 0.15), AppTheme.accentCyan.withValues(alpha: 0.1)]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppTheme.accentEmerald, size: 52),
            ),
            const SizedBox(height: 20),
            const Text('Inquiry Sent!', style: TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: 8),
            const Text(
              'Our team will get back to you\nwithin 24 hours.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppTheme.textSlate400, height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.accentEmerald, AppTheme.accentCyan]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: const Text('Got it!', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
          decoration: BoxDecoration(
            color: AppTheme.backgroundDark.withValues(alpha: 0.9),
            border: Border(bottom: BorderSide(color: AppTheme.primary.withValues(alpha: 0.08))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
                child: const Text('Contact', style: TextStyle(fontFamily: 'Inter', fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.primary.withValues(alpha: 0.15))),
                child: const Icon(Icons.mail_rounded, color: AppTheme.primary, size: 18),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _animSection(0.0, 0.3, _buildHero()),
                const SizedBox(height: 28),
                _animSection(0.15, 0.45, _buildForm()),
                const SizedBox(height: 32),
                _animSection(0.3, 0.6, _buildDivider()),
                const SizedBox(height: 28),
                _animSection(0.4, 0.7, _buildDirectContact()),
                const SizedBox(height: 28),
                _animSection(0.5, 0.8, _buildLocation()),
                const SizedBox(height: 28),
                _animSection(0.6, 0.9, _buildFooter()),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _animSection(double start, double end, Widget child) {
    final fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Interval(start, end, curve: Curves.easeOut)),
    );
    final slide = Tween<Offset>(begin: const Offset(0, 24), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Interval(start, end, curve: Curves.easeOutCubic)),
    );
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, _) => Transform.translate(
        offset: slide.value,
        child: Opacity(opacity: fade.value, child: child),
      ),
    );
  }

  Widget _buildHero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
          child: const Text('Start a Project', style: TextStyle(fontFamily: 'Inter', fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
        ),
        const SizedBox(height: 10),
        const Text(
          "Let's build something extraordinary together. Our team will respond within 24 hours.",
          style: TextStyle(fontFamily: 'Inter', fontSize: 15, color: AppTheme.textSlate400, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('FULL NAME'),
        const SizedBox(height: 8),
        _buildInput(_nameController, 'John Doe', Icons.person_rounded),
        const SizedBox(height: 18),
        _buildLabel('WORK EMAIL'),
        const SizedBox(height: 8),
        _buildInput(_emailController, 'john@company.com', Icons.email_rounded, keyboard: TextInputType.emailAddress),
        const SizedBox(height: 18),
        _buildLabel('SERVICE INTEREST'),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_services.length, (i) {
              final sel = _selectedService == i;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedService = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: sel ? AppTheme.primaryGradient : null,
                      color: sel ? null : AppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(999),
                      border: sel ? null : Border.all(color: AppTheme.borderDark),
                      boxShadow: sel
                          ? [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]
                          : null,
                    ),
                    child: Text(_services[i], style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: sel ? FontWeight.w700 : FontWeight.w500, color: sel ? Colors.white : AppTheme.textSlate400)),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 18),
        _buildLabel('PROJECT DETAILS'),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.1)),
          ),
          child: TextField(
            controller: _detailsController,
            maxLines: 4,
            style: const TextStyle(fontFamily: 'Inter', fontSize: 15, color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Tell us about your goals, timeline, and budget...',
              hintStyle: TextStyle(color: AppTheme.textSlate500),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Submit button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: Container(
            decoration: BoxDecoration(
              gradient: _isSubmitting ? null : AppTheme.primaryGradient,
              color: _isSubmitting ? AppTheme.primary.withValues(alpha: 0.4) : null,
              borderRadius: BorderRadius.circular(16),
              boxShadow: _isSubmitting
                  ? null
                  : [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitInquiry,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, disabledBackgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: _isSubmitting
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Send Inquiry', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                        SizedBox(width: 8),
                        Icon(Icons.send_rounded, size: 18, color: Colors.white),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInput(TextEditingController ctrl, String hint, IconData icon, {TextInputType? keyboard}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboard,
        style: const TextStyle(fontFamily: 'Inter', fontSize: 15, color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppTheme.textSlate500),
          prefixIcon: Icon(icon, color: AppTheme.textSlate500, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textSlate400, letterSpacing: 1.5));
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, AppTheme.primary.withValues(alpha: 0.2)])))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ShaderMask(
            shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
            child: const Text('OR CONNECT DIRECTLY', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 2)),
          ),
        ),
        Expanded(child: Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(colors: [AppTheme.primary.withValues(alpha: 0.2), Colors.transparent])))),
      ],
    );
  }

  Widget _buildDirectContact() {
    return Row(
      children: [
        Expanded(child: _contactCard(Icons.call_rounded, 'Call Us', '+1 (555) 000-1234', AppTheme.accentCyan)),
        const SizedBox(width: 14),
        Expanded(child: _contactCard(Icons.email_rounded, 'Email Us', 'hello@dynastyx.com', AppTheme.accentMagenta)),
      ],
    );
  }

  Widget _contactCard(IconData icon, String title, String subtitle, Color accent) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.surfaceGradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: accent, size: 20),
          ),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppTheme.textSlate400)),
        ],
      ),
    );
  }

  Widget _buildLocation() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.surfaceGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              gradient: LinearGradient(colors: [AppTheme.accentCyan.withValues(alpha: 0.12), AppTheme.primary.withValues(alpha: 0.08)]),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 20)],
                        ),
                        child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 28),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 2, height: 20,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.primary, Colors.transparent]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Visit Office', style: TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                      SizedBox(height: 4),
                      Text('123 Tech Plaza, Innovation District\nSan Francisco, CA 94103', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppTheme.textSlate400, height: 1.5)),
                    ],
                  ),
                ),
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 16)],
                  ),
                  child: const Icon(Icons.directions_rounded, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
          child: const Text('AVAILABLE MON — FRI, 9AM — 6PM PST', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 2)),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialBtn(Icons.public_rounded, AppTheme.accentCyan),
            const SizedBox(width: 16),
            _socialBtn(Icons.groups_rounded, AppTheme.accentMagenta),
            const SizedBox(width: 16),
            _socialBtn(Icons.alternate_email_rounded, AppTheme.accentAmber),
          ],
        ),
      ],
    );
  }

  Widget _socialBtn(IconData icon, Color accent) {
    return GestureDetector(
      onTap: () => _showSnack('Opening social...', accent),
      child: Container(
        width: 42, height: 42,
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent.withValues(alpha: 0.15)),
        ),
        child: Icon(icon, size: 18, color: accent),
      ),
    );
  }
}
