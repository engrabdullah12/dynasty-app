import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> with TickerProviderStateMixin {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Design', 'Development', 'Marketing', 'Cloud'];
  final _searchController = TextEditingController();
  String _searchQuery = '';

  late AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _allServices = [
    {
      'icon': Icons.palette_rounded,
      'title': 'UI/UX Design',
      'description': 'Creating intuitive, user-centric interfaces that drive engagement and satisfaction through data-driven design.',
      'category': 'Design',
      'accent': AppTheme.accentAmber,
      'projects': '80+',
    },
    {
      'icon': Icons.code_rounded,
      'title': 'Custom Software',
      'description': 'High-performance web and mobile applications built with cutting-edge technology stacks.',
      'category': 'Development',
      'accent': AppTheme.accentCyan,
      'projects': '120+',
    },
    {
      'icon': Icons.campaign_rounded,
      'title': 'Digital Marketing',
      'description': 'Strategic SEO, SEM, and social media campaigns designed to maximize ROI.',
      'category': 'Marketing',
      'accent': AppTheme.accentMagenta,
      'projects': '95+',
    },
    {
      'icon': Icons.smart_toy_rounded,
      'title': 'AI & Automation',
      'description': 'Integrating artificial intelligence to streamline workflows and unlock insights.',
      'category': 'Development',
      'accent': AppTheme.accentEmerald,
      'projects': '45+',
    },
    {
      'icon': Icons.cloud_rounded,
      'title': 'Cloud Solutions',
      'description': 'Scalable cloud architecture and migration services for enterprise applications.',
      'category': 'Cloud',
      'accent': AppTheme.primary,
      'projects': '60+',
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    var services = _allServices;
    if (_selectedFilter > 0) {
      services = services.where((s) => s['category'] == _filters[_selectedFilter]).toList();
    }
    if (_searchQuery.isNotEmpty) {
      services = services.where((s) {
        final t = (s['title'] as String).toLowerCase();
        final d = (s['description'] as String).toLowerCase();
        return t.contains(_searchQuery.toLowerCase()) || d.contains(_searchQuery.toLowerCase());
      }).toList();
    }
    return services;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                ..._buildCards(),
                if (_filtered.isEmpty) _buildEmptyState(),
                if (_filtered.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildCTA(),
                ],
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(color: AppTheme.primary.withValues(alpha: 0.08)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
            child: const Text(
              'Our Services',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Search bar
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.primary.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Icon(Icons.search_rounded, color: AppTheme.textSlate500, size: 20),
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search services...',
                      hintStyle: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppTheme.textSlate500),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      suffixIcon: _searchQuery.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              child: const Icon(Icons.close_rounded, color: AppTheme.textSlate500, size: 18),
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_filters.length, (i) {
                final sel = _selectedFilter == i;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedFilter = i);
                      _staggerController.reset();
                      _staggerController.forward();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                      decoration: BoxDecoration(
                        gradient: sel ? AppTheme.primaryGradient : null,
                        color: sel ? null : AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(999),
                        border: sel ? null : Border.all(color: AppTheme.borderDark),
                        boxShadow: sel
                            ? [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]
                            : null,
                      ),
                      child: Text(
                        _filters[i],
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                          color: sel ? Colors.white : AppTheme.textSlate400,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCards() {
    final services = _filtered;
    return List.generate(services.length, (i) {
      final delay = i * 0.15;
      final fade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(delay.clamp(0.0, 0.7), (delay + 0.3).clamp(0.0, 1.0), curve: Curves.easeOut),
        ),
      );
      final slide = Tween<Offset>(begin: const Offset(0, 24), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(delay.clamp(0.0, 0.7), (delay + 0.3).clamp(0.0, 1.0), curve: Curves.easeOutCubic),
        ),
      );
      return AnimatedBuilder(
        animation: _staggerController,
        builder: (context, _) => Transform.translate(
          offset: slide.value,
          child: Opacity(
            opacity: fade.value,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildServiceCard(services[i]),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    final accent = service['accent'] as Color;
    return GestureDetector(
      onTap: () => _showDetail(service),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppTheme.surfaceGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(color: accent.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(service['icon'] as IconData, color: accent, size: 24),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${service['projects']} projects',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: accent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              service['title'] as String,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.3),
            ),
            const SizedBox(height: 8),
            Text(
              service['description'] as String,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppTheme.textSlate400, height: 1.6),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(colors: [accent, AppTheme.primary]).createShader(bounds),
                  child: const Text(
                    'Learn More',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.arrow_forward_rounded, color: accent, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(Map<String, dynamic> service) {
    final accent = service['accent'] as Color;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: accent.withValues(alpha: 0.15)),
          boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.1), blurRadius: 40)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.textSlate600, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 24),
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(color: accent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16)),
              child: Icon(service['icon'] as IconData, color: accent, size: 30),
            ),
            const SizedBox(height: 16),
            Text(
              service['title'] as String,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5),
            ),
            const SizedBox(height: 12),
            Text(
              service['description'] as String,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 15, color: AppTheme.textSlate400, height: 1.7),
            ),
            const SizedBox(height: 8),
            const Text(
              'Our team of experts will work closely with you to deliver tailored solutions that exceed expectations.',
              style: TextStyle(fontFamily: 'Inter', fontSize: 15, color: AppTheme.textSlate400, height: 1.7),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _detailStat(service['projects'] as String, 'Completed', accent)),
                const SizedBox(width: 12),
                Expanded(child: _detailStat('98%', 'Satisfaction', accent)),
                const SizedBox(width: 12),
                Expanded(child: _detailStat('24/7', 'Support', accent)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, height: 52,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [accent, AppTheme.primary]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: const Text('Get Started', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _detailStat(String value, String label, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w900, color: accent)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: AppTheme.textSlate400)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: 64),
        Icon(Icons.search_off_rounded, size: 48, color: AppTheme.textSlate500.withValues(alpha: 0.5)),
        const SizedBox(height: 16),
        const Text('No services found', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textSlate400)),
        const SizedBox(height: 8),
        const Text('Try adjusting your search or filter', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppTheme.textSlate500)),
      ],
    );
  }

  Widget _buildCTA() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [AppTheme.primary.withValues(alpha: 0.2), AppTheme.accentMagenta.withValues(alpha: 0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.15)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20, top: -20,
            child: Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primary.withValues(alpha: 0.1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
                  child: const Text('CUSTOM SOLUTIONS', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 2)),
                ),
                const SizedBox(height: 8),
                const Text("Need something unique?", style: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 4),
                const Text("Let's build your custom solution.", style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: AppTheme.textSlate400)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
