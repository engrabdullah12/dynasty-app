import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All Projects', 'Web', 'Mobile', 'Design'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                _buildProjectGrid(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Our Work',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.search,
                      color: AppTheme.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAOE9QN0kC9VOToe5zlJ8WvCFZ1jNaEljtR-KH7PepfGceIRWQuMk--fKboz5U5qhb-7qD7RNCe3mybnjnwnsIIOUAdrQATVxa16fFG7poBKsuh-0XvcRifWJiDxdEzD-AeI2liJj7vmoNYwZgXWjvkIf-ZUt6td6f3ktKEQGGgzjYE8ukdntkWJyLHTnmFfT4eQjA9mS4gPZi5lB6V7sCWMz7xsLsJfU_-_2uNbvboBiyGoRiBjPbkXqeviT-Mr-juRQOKa-pe7WU',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                          color: AppTheme.surfaceDark,
                          child: const Icon(Icons.person,
                              size: 18, color: AppTheme.textSlate400),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_filters.length, (index) {
                final isSelected = _selectedFilter == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedFilter = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primary
                            : AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(999),
                        border: isSelected
                            ? null
                            : Border.all(
                                color: AppTheme.primary.withValues(alpha: 0.15),
                              ),
                      ),
                      child: Text(
                        _filters[index],
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : AppTheme.textSlate400,
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

  Widget _buildProjectGrid() {
    final projects = [
      _ProjectData(
        title: 'SwiftPay Global',
        category: 'FINTECH APP',
        color: const Color(0xFFD4C5A0),
        secondaryColor: const Color(0xFFE8DCC4),
      ),
      _ProjectData(
        title: 'DataPulse AI',
        category: 'AI ANALYSIS',
        color: const Color(0xFF2A5F5F),
        secondaryColor: const Color(0xFF3A7070),
      ),
      _ProjectData(
        title: 'Luxe Brand Identity',
        category: 'DESIGN',
        color: const Color(0xFFE8E0D0),
        secondaryColor: const Color(0xFFF0EAE0),
      ),
      _ProjectData(
        title: 'Zenith HR',
        category: 'SAAS PLATFORM',
        color: const Color(0xFF8FAFA0),
        secondaryColor: const Color(0xFFA0C0B0),
      ),
      _ProjectData(
        title: 'Nexus Market',
        category: 'WEB & MOBILE',
        color: const Color(0xFFE0D8CC),
        secondaryColor: const Color(0xFFF0EAE0),
      ),
      _ProjectData(
        title: 'VibeCheck Social',
        category: 'CREATIVE DESIGN',
        color: const Color(0xFFC0D0C0),
        secondaryColor: const Color(0xFFD0E0D0),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return _buildProjectCard(projects[index]);
      },
    );
  }

  Widget _buildProjectCard(_ProjectData project) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            project.color,
            project.secondaryColor,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Center decoration element
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'PROJECT',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.6),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),
          // Label at bottom
          Positioned(
            left: 16,
            bottom: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.category,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary.withValues(alpha: 0.9),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  project.title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectData {
  final String title;
  final String category;
  final Color color;
  final Color secondaryColor;

  _ProjectData({
    required this.title,
    required this.category,
    required this.color,
    required this.secondaryColor,
  });
}
