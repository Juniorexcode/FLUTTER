import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Modal para el formulario de contacto con diseño especial y animaciones nativas
class ContactFormDialog extends StatefulWidget {
  const ContactFormDialog({super.key});

  @override
  State<ContactFormDialog> createState() => _ContactFormDialogState();
}

class _ContactFormDialogState extends State<ContactFormDialog> with TickerProviderStateMixin {
  late AnimationController _animController;
  late AnimationController _borderAnimController;
  late Animation<double> _scaleAnimation;
  
  // Estados para inputs y hover
  bool _isEmailFocused = false;
  bool _isMessageFocused = false;
  bool _isButtonHovered = false;
  bool _isButtonPressed = false;
  
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _messageFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() => setState(() => _isEmailFocused = _emailFocus.hasFocus));
    _messageFocus.addListener(() => setState(() => _isMessageFocused = _messageFocus.hasFocus));
    
    // Animación de entrada estilo "pop" o "spring"
    _animController = AnimationController(
       vsync: this, 
       duration: const Duration(milliseconds: 350),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack)
    );
    
    // Animación del borde giratorio continuo
    _borderAnimController = AnimationController(
       vsync: this, 
       duration: const Duration(seconds: 4),
    )..repeat();
    
    _animController.forward();
  }

  @override
  void dispose() {
    _borderAnimController.dispose();
    _emailFocus.dispose();
    _messageFocus.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _closeDialog() {
    // Al cerrar, invertimos animación
    _animController.reverse().then((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _animController,
          child: Material(
            color: Colors.transparent,
            child: _buildFormContainer(),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContainer() {
    final screenWidth = MediaQuery.of(context).size.width;
    final double containerWidth = screenWidth < 450 ? screenWidth * 0.9 : 400.0;

    return SizedBox(
      width: containerWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Capa de gradiente giratorio (borde)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _borderAnimController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _borderAnimController.value * 2 * math.pi,
                    // Escalamos la capa interna visualmente para que al girar cubra bien
                    // todas las esquinas, pero al usar Positioned.fill no forzamos 
                    // que el modal se haga gigante, solo recubre el espacio disponible.
                    child: Transform.scale(
                      scale: 2.0, 
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: SweepGradient(
                            colors: [
                              AppTheme.primary.withValues(alpha: 0.1),
                              AppTheme.primary,
                              AppTheme.secondary,
                              AppTheme.primary.withValues(alpha: 0.1),
                            ],
                            stops: const [0.0, 0.45, 0.55, 1.0],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Fondo oscuro interior (creando el efecto de borde 2px)
            Padding(
              padding: const EdgeInsets.all(2.0), // Grosor del borde
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundDark,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ajustado al contenido interior
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                     _buildFormGroup('Company Email', _emailFocus, _isEmailFocused, false),
                     const SizedBox(height: 20),
                     _buildFormGroup('How Can We Help You?', _messageFocus, _isMessageFocused, true),
                     const SizedBox(height: 28),
                     _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormGroup(String label, FocusNode focusNode, bool isFocused, bool isTextArea) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
           label,
           style: const TextStyle(
             color: AppTheme.textSecondary,
             fontWeight: FontWeight.w600,
             fontSize: 12,
             letterSpacing: 0.3,
           ),
         ),
         const SizedBox(height: 5),
         AnimatedContainer(
           duration: const Duration(milliseconds: 200),
           height: isTextArea ? 96 : null,
           decoration: BoxDecoration(
             color: Colors.transparent,
             borderRadius: BorderRadius.circular(8),
             border: Border.all(
               color: isFocused ? AppTheme.secondary : Colors.white.withValues(alpha: 0.2),
               width: 1,
             ),
           ),
           child: TextField(
             focusNode: focusNode,
             maxLines: isTextArea ? null : 1,
             expands: isTextArea,
             style: const TextStyle(
               color: AppTheme.textPrimary,
               fontSize: 14,
             ),
             decoration: const InputDecoration(
               border: InputBorder.none,
               contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
               isDense: true,
             ),
             cursorColor: AppTheme.secondary,
           ),
         ),
      ],
    );
  }

  Widget _buildSubmitButton() {
     return Align(
       alignment: Alignment.centerLeft,
       child: MouseRegion(
         onEnter: (_) => setState(() => _isButtonHovered = true),
         onExit: (_) => setState(() => _isButtonHovered = false),
         cursor: SystemMouseCursors.click,
         child: GestureDetector(
           onTapDown: (_) => setState(() => _isButtonPressed = true),
           onTapUp: (_) {
             setState(() => _isButtonPressed = false);
             // Efecto visual al enviar, luego cerramos el modal
             Future.delayed(const Duration(milliseconds: 150), _closeDialog);
           },
           onTapCancel: () => setState(() => _isButtonPressed = false),
           child: AnimatedScale(
             scale: _isButtonPressed ? 0.95 : 1.0,
             duration: const Duration(milliseconds: 100),
             child: AnimatedContainer(
               duration: const Duration(milliseconds: 200),
               width: 130, // Aproximadamente 40%
               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
               decoration: BoxDecoration(
                 color: _isButtonHovered ? AppTheme.primary : Colors.white.withValues(alpha: 0.05),
                 border: Border.all(
                   color: _isButtonHovered ? AppTheme.secondary : Colors.white.withValues(alpha: 0.1),
                 ),
                 borderRadius: BorderRadius.circular(6),
                 boxShadow: _isButtonHovered
                    ? [
                        BoxShadow(
                          color: AppTheme.secondary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
               ),
               alignment: Alignment.center,
               child: Text(
                 'Submit',
                 style: TextStyle(
                   color: _isButtonHovered ? AppTheme.textPrimary : AppTheme.textSecondary,
                   fontWeight: FontWeight.w600,
                   fontSize: 14,
                 ),
               ),
             ),
           ),
         ),
       ),
     );
  }
}
