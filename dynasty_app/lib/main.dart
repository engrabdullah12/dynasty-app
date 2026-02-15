import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/services_screen.dart';
import 'screens/portfolio_screen.dart';
import 'screens/contact_screen.dart';
import 'widgets/bottom_nav_bar.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'widgets/auth_gate.dart';
import 'config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  } catch (e) {
    debugPrint('Supabase initialization failed: $e');
  }

  runApp(const DynastyXApp());
}

class DynastyXApp extends StatelessWidget {
  const DynastyXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DynastyX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AuthGate(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ServicesScreen(),
    PortfolioScreen(),
    ContactScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: _currentIndex == 0 ? _buildHomeAppBar() : null,
      body: SafeArea(
        top: _currentIndex != 0,
        bottom: false,
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  PreferredSizeWidget _buildHomeAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: const TextSpan(
                  text: 'Dynasty',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                    letterSpacing: -0.5,
                  ),
                  children: [
                    TextSpan(
                      text: 'X',
                      style: TextStyle(
                        color: AppTheme.accentCyan,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications,
                      color: AppTheme.primary,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 32,
                    height: 32,
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
                              size: 14, color: AppTheme.textSlate400),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
