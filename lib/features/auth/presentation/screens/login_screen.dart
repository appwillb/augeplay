import 'package:flutter/material.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/core/theme/app_text_styles.dart';
import 'package:playauge/core/utils/validators.dart';
import 'package:playauge/features/auth/presentation/state/auth_provider.dart';
import 'package:playauge/shared/widgets/app_button.dart';
import 'package:playauge/shared/widgets/app_text_field.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthProvider authProvider;
  final VoidCallback onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.authProvider,
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginAsDemoUser(String email, String label) {
    _emailController.text = email;
    _passwordController.text = '123456';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primary,
        duration: const Duration(milliseconds: 900),
        content: Text('Entrando como $label...'),
      ),
    );
    _submit();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await widget.authProvider.login(
      _emailController.text,
      _passwordController.text,
    );

    if (success && mounted) {
      widget.onLoginSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo / Ícone
                  Center(
                    child: Image.asset(
                      'assets/images/app_logo.png',
                      width: 80,
                      height: 80,
                      errorBuilder: (_, __, ___) => Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.location_on_rounded, color: AppColors.textInverse, size: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Título & Boas-vindas
                  const Text(
                    'GPSMusic',
                    style: AppTextStyles.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A rede social e profissional do mercado musical.',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),

                  if (widget.authProvider.errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.error.withOpacity(0.4)),
                      ),
                      child: Text(
                        widget.authProvider.errorMessage!,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Campo E-mail
                  AppTextField(
                    label: 'E-mail',
                    hint: 'seu.email@exemplo.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: 16),

                  // Campo Senha
                  AppTextField(
                    label: 'Senha',
                    hint: '••••••••',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock_outline_rounded,
                    validator: Validators.validatePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Acesso Rápido de Demonstração:',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.mic_external_on_rounded, size: 16, color: AppColors.primary),
                        label: const Text('João Silva (Cantor)', style: TextStyle(fontSize: 12)),
                        backgroundColor: AppColors.surfaceElevated,
                        side: const BorderSide(color: AppColors.surfaceBorder),
                        onPressed: () => _loginAsDemoUser('joao.silva@playauge.demo', 'João Silva (Cantor)'),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.music_note_rounded, size: 16, color: Color(0xFF10B981)),
                        label: const Text('Pedro Guitar (Guitarrista)', style: TextStyle(fontSize: 12)),
                        backgroundColor: AppColors.surfaceElevated,
                        side: const BorderSide(color: AppColors.surfaceBorder),
                        onPressed: () => _loginAsDemoUser('pedro.santos@playauge.demo', 'Pedro Guitar (Guitarrista)'),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.album_rounded, size: 16, color: Colors.orangeAccent),
                        label: const Text('Marcos Batera (Baterista)', style: TextStyle(fontSize: 12)),
                        backgroundColor: AppColors.surfaceElevated,
                        side: const BorderSide(color: AppColors.surfaceBorder),
                        onPressed: () => _loginAsDemoUser('marcos.batera@playauge.demo', 'Marcos Batera (Baterista)'),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.edit_note_rounded, size: 16, color: Colors.purpleAccent),
                        label: const Text('Ana Martins (Compositora)', style: TextStyle(fontSize: 12)),
                        backgroundColor: AppColors.surfaceElevated,
                        side: const BorderSide(color: AppColors.surfaceBorder),
                        onPressed: () => _loginAsDemoUser('ana.martins@playauge.demo', 'Ana Martins (Compositora)'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Botão Entrar
                  AnimatedBuilder(
                    animation: widget.authProvider,
                    builder: (context, _) => AppButton(
                      label: 'Entrar na Plataforma',
                      isLoading: widget.authProvider.isLoading,
                      onPressed: _submit,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Cadastro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ainda não possui conta? ',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RegisterScreen(
                                authProvider: widget.authProvider,
                                onRegisterSuccess: widget.onLoginSuccess,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Cadastre-se',
                          style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
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
    );
  }
}
