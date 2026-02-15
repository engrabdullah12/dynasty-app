import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroSection(context),
          _buildMissionSection(),
          _buildExpertiseSection(context),
          _buildStatsSection(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return SizedBox(
      height: 480,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2A1B5E),
                  Color(0xFF1A1040),
                  AppTheme.backgroundDark,
                ],
              ),
            ),
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBQIBJTww-C7ct_Q-Nu4PQc9jzb-89em_B8ifXzSR2JiYVwbTlQDD_wWF8yUjUxoS2mSVHX28_H3PpgBBAxSLUL9NZGwV8neFiihAr5_1CGBX4mt1wHISWLdeqwb7yG0P-UwNXclT_iyFEPKHeT_kmSmmfhv8WO8FSrjz8TEbEHE5qzs2w77KfymvWsEOS-p1PGgoxo9STZAihElR7Lzq1_LPMG-BFincR7y5BWwt8LoTIyED07L74IGjkq0dvuTePz-MOOM3B3st0',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0x99141121),
                  AppTheme.backgroundDark,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Content
          Positioned(
            left: 24,
            right: 24,
            bottom: 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Text(
                    'DIGITAL EXCELLENCE',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accentCyan,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Heading
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                    children: [
                      const TextSpan(text: 'Innovate.\n'),
                      const TextSpan(text: 'Integrate.\n'),
                      TextSpan(
                        text: 'Impact.',
                        style: TextStyle(
                          color: AppTheme.primary,
                          shadows: [
                            Shadow(
                              color: AppTheme.primary.withValues(alpha: 0.5),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Crafting future-ready digital solutions for ambitious brands worldwide.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppTheme.textSlate400,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                // Buttons
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                        shadowColor: AppTheme.primary.withValues(alpha: 0.25),
                      ),
                      child: const Text(
                        'Get a Quote',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                      ),
                      child: const Text(
                        'Our Services',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.backgroundDark.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'OUR MISSION',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pioneering Progress',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'At DynastyX, we blend creative vision with technical precision. Our team of expert architects and strategists are dedicated to transforming your business challenges into digital opportunities.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppTheme.textSlate400,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                // Team avatars stacked
                SizedBox(
                  width: 76,
                  height: 32,
                  child: Stack(
                    children: [
                      _buildAvatar(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuBtQY4wszCWTQJvYsW9521LkbJ07klQlL2JBVGdz-0og47eRCRjIojWW16LxkTqSXJ_iqZUTvrEy23XMpUk_RUINYHNmHlcK-Vmjvi2_zJcLkNjAb5CZreYynzyLJQMjcmGsrA8_tgRtB8gkFiIMh2Mo74ndotbdTv4JXrUCY_wQSFnMr2Ejb3T1EwYVyWExhN7vlGvrUuLsKsRYPCNy97L6DC1ZdrLoTOFWQqOSWgvokAOr6ctOUQU7WlzUFY2Q8uUmo55Tjmqse8',
                        0,
                      ),
                      _buildAvatar(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDFJoWp2iSi49uLVMAru1uOFlGZLhRGze2GNmxG2Oq4ldK33MDHUNAZ4jUtJnI_KHwiqIs_pMzBC2kp5-L73RQ5_YQhz2FeyUTDy_CmbsMXU3EHICbkmLJ353fv1rRxF0d9JhHDYhkS9HjUK-RZQ9YwjC1cWymAkc6PZJ_yPkXlmj5yPYJzh2j1cRrfOJy3GB1hWbVlF8LBDZ-avUE9ZNwJq-yv2pX4zjn2VaCt4Oz2JYmN8awOPh3eO_YPw5rfNLYNa7VnNpgBgTg',
                        22,
                      ),
                      _buildAvatar(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCzA85s3uZ4SCli-afVK7Ae-4F0ckUkQaPQ7SZnz9y_anxS_NSEb68YYCOiFZx0FBn_y-I2CHT9ecMxq40HRZcfIFA__rQb7lHtuSWI1RFCXDs138FYi7ieIwdFoKZkwZR6J5FcQJPv96CyHaPZLIbrRouYY16BAefz026O2k5TrmCDbxB-GS7WKILvG1qA9zIDRx-spwRv88Wr4UlXxsgjsT55b7sgjCeKuA7PLh8V3CgRUksXuwAUAAcxqm7I9tzbdF4eeZ6M_KU',
                        44,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '+20 digital experts',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: AppTheme.textSlate400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String url, double left) {
    return Positioned(
      left: left,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.backgroundDark, width: 2),
        ),
        child: ClipOval(
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: AppTheme.surfaceDark,
              child: const Icon(Icons.person, size: 16, color: AppTheme.textSlate400),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpertiseSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Our Expertise',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'VIEW ALL',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.95,
            children: const [
              _ExpertiseCard(
                icon: Icons.code,
                title: 'Web Development',
                description: 'Responsive & scalable architectures.',
              ),
              _ExpertiseCard(
                icon: Icons.smartphone,
                title: 'App Development',
                description: 'Native iOS and Android solutions.',
              ),
              _ExpertiseCard(
                icon: Icons.trending_up,
                title: 'SEO Strategy',
                description: 'Data-driven organic growth hacking.',
              ),
              _ExpertiseCard(
                icon: Icons.palette,
                title: 'UI/UX Design',
                description: 'User-centric digital experiences.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem('150+', 'CLIENTS'),
            Container(
              width: 1,
              height: 32,
              color: AppTheme.primary.withValues(alpha: 0.2),
            ),
            _buildStatItem('12k', 'COMMITS'),
            Container(
              width: 1,
              height: 32,
              color: AppTheme.primary.withValues(alpha: 0.2),
            ),
            _buildStatItem('99%', 'RATING'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppTheme.primary,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ExpertiseCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ExpertiseCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.primary,
              size: 22,
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: AppTheme.textSlate500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
