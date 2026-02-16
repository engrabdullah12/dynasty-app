import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> with SingleTickerProviderStateMixin {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Web', 'Mobile', 'Branding', 'AI'];

  late AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _projects = [
    {'title': 'FinTech Dashboard', 'category': 'Web', 'accent': AppTheme.accentCyan, 'icon': Icons.dashboard_rounded},
    {'title': 'HealthSync App', 'category': 'Mobile', 'accent': AppTheme.accentEmerald, 'icon': Icons.favorite_rounded},
    {'title': 'NovaBrand Identity', 'category': 'Branding', 'accent': AppTheme.accentAmber, 'icon': Icons.brush_rounded},
    {'title': 'AI Analytics Suite', 'category': 'AI', 'accent': AppTheme.accentMagenta, 'icon': Icons.auto_awesome_rounded},
    {'title': 'E-Commerce Platform', 'category': 'Web', 'accent': AppTheme.primary, 'icon': Icons.shopping_bag_rounded},
    {'title': 'Travel Companion', 'category': 'Mobile', 'accent': AppTheme.accentRose, 'icon': Icons.flight_rounded},
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_selectedFilter == 0) return _projects;
    return _projects.where((p) => p['category'] == _filters[_selectedFilter]).toList();
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
                _buildGrid(),
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
        border: Border(bottom: BorderSide(color: AppTheme.primary.withValues(alpha: 0.08))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
                child: const Text(
                  'Portfolio',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primary.withValues(alpha: 0.15)),
                ),
                child: const Icon(Icons.filter_list_rounded, color: AppTheme.primary, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Showcasing our finest work',
            style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppTheme.textSlate400),
          ),
          const SizedBox(height: 16),
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
                          fontFamily: 'Inter', fontSize: 12,
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

  Widget _buildGrid() {
    final projects = _filtered;
    if (projects.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 64),
        child: Column(
          children: [
            Icon(Icons.work_off_rounded, size: 48, color: AppTheme.textSlate500.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            const Text('No projects in this category', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textSlate400)),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.82,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: projects.length,
      itemBuilder: (context, i) {
        final delay = i * 0.12;
        final fade = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: _staggerController, curve: Interval(delay.clamp(0.0, 0.7), (delay + 0.3).clamp(0.0, 1.0), curve: Curves.easeOut)),
        );
        final scale = Tween<double>(begin: 0.9, end: 1.0).animate(
          CurvedAnimation(parent: _staggerController, curve: Interval(delay.clamp(0.0, 0.7), (delay + 0.3).clamp(0.0, 1.0), curve: Curves.easeOutBack)),
        );

        return AnimatedBuilder(
          animation: _staggerController,
          builder: (context, _) => Transform.scale(
            scale: scale.value,
            child: Opacity(
              opacity: fade.value,
              child: _buildProjectCard(projects[i]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    final accent = project['accent'] as Color;
    return GestureDetector(
      onTap: () => _showProjectDetail(project),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.surfaceGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent.withValues(alpha: 0.12)),
          boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project visual area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [accent.withValues(alpha: 0.15), accent.withValues(alpha: 0.05)],
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circle
                    Positioned(
                      right: -15, top: -15,
                      child: Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: accent.withValues(alpha: 0.1)),
                      ),
                    ),
                    Center(
                      child: Icon(project['icon'] as IconData, size: 48, color: accent.withValues(alpha: 0.6)),
                    ),
                  ],
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project['title'] as String,
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      project['category'] as String,
                      style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600, color: accent),
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

  void _showProjectDetail(Map<String, dynamic> project) {
    final accent = project['accent'] as Color;
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
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.textSlate600, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            // Visual area
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(colors: [accent.withValues(alpha: 0.2), accent.withValues(alpha: 0.05)]),
              ),
              child: Center(child: Icon(project['icon'] as IconData, size: 72, color: accent.withValues(alpha: 0.5))),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(project['category'] as String, style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w700, color: accent, letterSpacing: 1)),
            ),
            const SizedBox(height: 12),
            Text(project['title'] as String, style: const TextStyle(fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
            const SizedBox(height: 12),
            const Text(
              'A comprehensive solution designed with meticulous attention to detail, delivering exceptional user experiences and measurable business results.',
              style: TextStyle(fontFamily: 'Inter', fontSize: 15, color: AppTheme.textSlate400, height: 1.7),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _statPill('Timeline', '12 weeks', accent),
                const SizedBox(width: 12),
                _statPill('Team', '5 experts', accent),
                const SizedBox(width: 12),
                _statPill('ROI', '+240%', accent),
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
                  child: const Text('View Case Study', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _statPill(String label, String value, Color accent) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: accent.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w800, color: accent)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 10, color: AppTheme.textSlate400)),
          ],
        ),
      ),
    );
  }
}
