import 'package:flutter/material.dart';

import '../../core/constants/app_dimensions.dart';
import '../../core/utils/button_debouncer.dart';
import '../widgets/glass_container.dart';
import '../widgets/contact_form_dialog.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  late final ButtonDebouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _debouncer = ButtonDebouncer();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.sectionVerticalPadding,
        horizontal: AppDimensions.contentHorizontalPadding,
      ),
      child: Column(
        children: [
          Text('Contáctanos', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 48),
          GlassContainer(
            padding: const EdgeInsets.all(48),
            child: Column(
              children: [
                const Text(
                  '¿Listo para empezar tu próxima aventura?',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    _debouncer.run(() {
                      showGeneralDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierLabel: 'Cerrar',
                        barrierColor: Colors.black.withValues(alpha: 0.6),
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const ContactFormDialog();
                        },
                      );
                    });
                  },
                  child: const Text('Enviar Mensaje'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
