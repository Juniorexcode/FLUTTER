import 'package:flutter/material.dart';

import '../../core/constants/app_breakpoints.dart';
import '../../core/constants/app_dimensions.dart';
import '../widgets/custom_nav_bar.dart';
import 'hero_section.dart';
import 'projects_section.dart';
import 'about_us_section.dart';
import 'contact_section.dart';
import '../widgets/mobile_side_menu.dart';
import '../widgets/app_footer.dart';
import '../widgets/animated_starry_background.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();

  final ValueNotifier<double> _scrollNotifier = ValueNotifier(0.0);
  final ValueNotifier<bool> _isMenuNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    // Only notify if the value actually changes meaningfully (avoid jitter).
    if ((offset - _scrollNotifier.value).abs() > 0.5) {
      _scrollNotifier.value = offset;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollNotifier.dispose();
    _isMenuNotifier.dispose();
    super.dispose();
  }

  void _scrollTo(double offset) {
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Si la pantalla se redimensiona a escritorio y el menú está abierto, se cierra
    if (screenWidth >= AppBreakpoints.mobile && _isMenuNotifier.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _isMenuNotifier.value) {
          _isMenuNotifier.value = false;
        }
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          // Fondo Espacial Estrellado y Gradiente Dreamy
          const Positioned.fill(
            child: AnimatedStarryBackground(),
          ),

          // Scrollable Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const HeroSection(),
                const ProjectsSection(),
                const AboutUsSection(),
                SizedBox(height: AppDimensions.sectionVerticalPadding),
                const ContactSection(),
                const AppFooter(),
              ],
            ),
          ),

          // Mobile Side Menu Layer
          Positioned.fill(
            child: ValueListenableBuilder<bool>(
              valueListenable: _isMenuNotifier,
              builder: (context, isOpen, _) {
                return Stack(
                  children: [
                    // Barrier
                    IgnorePointer(
                      ignoring: !isOpen,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 400),
                        opacity: isOpen ? 1.0 : 0.0,
                        child: GestureDetector(
                          onTap: () => _isMenuNotifier.value = false,
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                    // Menu
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      top: 0,
                      bottom: 0,
                      right: isOpen ? 0 : -(MediaQuery.of(context).size.width * 0.8),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: MobileSideMenu(
                        navItems: CustomNavBar.navItems,
                        onNavigate: (offset) {
                          _isMenuNotifier.value = false;
                          Future.delayed(const Duration(milliseconds: 300), () {
                            _scrollTo(offset);
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Navigation Bar — only this rebuilds on scroll
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<double>(
              valueListenable: _scrollNotifier,
              builder: (_, scrollOffset, _) => ValueListenableBuilder<bool>(
                valueListenable: _isMenuNotifier,
                builder: (_, isMenuOpen, _) => CustomNavBar(
                  scrollController: _scrollController,
                  scrollOffset: scrollOffset,
                  isMenuOpen: isMenuOpen,
                  onToggleMenu: () {
                    _isMenuNotifier.value = !_isMenuNotifier.value;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
