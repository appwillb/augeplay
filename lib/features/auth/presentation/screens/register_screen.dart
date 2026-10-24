import 'package:flutter/material.dart';
import 'package:playauge/core/constants/app_constants.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/core/theme/app_text_styles.dart';
import 'package:playauge/core/utils/validators.dart';
import 'package:playauge/features/auth/domain/models/user_role.dart';
import 'package:playauge/features/auth/presentation/state/auth_provider.dart';
import 'package:playauge/shared/widgets/app_button.dart';
import 'package:playauge/shared/widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  final AuthProvider authProvider;
  final VoidCallback onRegisterSuccess;

  const RegisterScreen({
    super.key,
    required this.authProvider,
    required this.onRegisterSuccess,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _stageNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cityController = TextEditingController(text: 'São Paulo');
  String _selectedState = 'SP';
  final _bioController = TextEditingController();

  final Set<UserRole> _selectedRoles = {UserRole.musico};

  @override
  void dispose() {
    _nameController.dispose();
    _stageNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedRoles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione pelo menos um papel profissional')),
      );
      return;
    }

    final success = await widget.authProvider.register(
      name: _nameController.text.trim(),
      stageName: _stageNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      city: _cityController.text.trim(),
      state: _selectedState,
      bio: _bioController.text.trim(),
      roles: _selectedRoles.toList(),
    );

    if (success && mounted) {
      widget.onRegisterSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Criar Perfil Profissional'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Como você atua na música?',
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Você pode selecionar mais de uma opção (ex: Músico e Produtor)',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 12),

                // Seleção de Papéis / Funções
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: UserRole.values.map((role) {
                    final isSelected = _selectedRoles.contains(role);
                    return FilterChip(
                      label: Text(role.shortLabel),
                      selected: isSelected,
                      selectedColor: AppColors.primary.withOpacity(0.2),
                      checkmarkColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      backgroundColor: AppColors.surfaceElevated,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.surfaceBorder,
                        ),
                      ),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedRoles.add(role);
                          } else {
                            if (_selectedRoles.length > 1) {
                              _selectedRoles.remove(role);
                            }
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                AppTextField(
                  label: 'Nome Completo',
                  hint: 'Ex: Carlos da Silva',
                  controller: _nameController,
                  validator: (v) => Validators.validateRequired(v, 'Nome'),
                ),
                const SizedBox(height: 16),

                AppTextField(
                  label: 'Nome Artístico / Como prefere ser chamado',
                  hint: 'Ex: Carlinhos Batera',
                  controller: _stageNameController,
                ),
                const SizedBox(height: 16),

                AppTextField(
                  label: 'E-mail Profissional',
                  hint: 'contato@seunome.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 16),

                AppTextField(
                  label: 'Senha',
                  hint: 'Mínimo de 6 caracteres',
                  controller: _passwordController,
                  obscureText: true,
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 16),

                // Linha de Localização (Cidade + UF)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: AppTextField(
                        label: 'Cidade',
                        hint: 'Ex: São Paulo',
                        controller: _cityController,
                        validator: (v) => Validators.validateRequired(v, 'Cidade'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Estado (UF)', style: AppTextStyles.labelMedium),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _selectedState,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            ),
                            items: AppConstants.brazilianStates
                                .map((uf) => DropdownMenuItem(value: uf, child: Text(uf)))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedState = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                AppTextField(
                  label: 'Biografia Profissional',
                  hint: 'Fale sobre sua experiência, instrumentos, bandas que já tocou...',
                  controller: _bioController,
                  maxLines: 3,
                ),
                const SizedBox(height: 28),

                AnimatedBuilder(
                  animation: widget.authProvider,
                  builder: (context, _) => AppButton(
                    label: 'Concluir Cadastro',
                    isLoading: widget.authProvider.isLoading,
                    onPressed: _submit,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
