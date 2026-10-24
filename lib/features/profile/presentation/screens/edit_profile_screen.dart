import 'package:flutter/material.dart';
import 'package:playauge/core/theme/app_colors.dart';
import 'package:playauge/core/theme/app_text_styles.dart';
import 'package:playauge/features/auth/presentation/state/auth_provider.dart';
import 'package:playauge/features/profile/domain/models/profile_entity.dart';
import 'package:playauge/features/profile/presentation/state/profile_provider.dart';
import 'package:playauge/shared/widgets/app_button.dart';
import 'package:playauge/shared/widgets/app_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileEntity profile;
  final ProfileProvider profileProvider;
  final AuthProvider? authProvider;

  const EditProfileScreen({
    super.key,
    required this.profile,
    required this.profileProvider,
    this.authProvider,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _stageNameController;
  late TextEditingController _bioController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _experienceController;
  late TextEditingController _instrumentsController;
  late TextEditingController _genresController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final u = widget.profile.user;
    _nameController = TextEditingController(text: u.name);
    _stageNameController = TextEditingController(text: u.stageName);
    _bioController = TextEditingController(text: u.bio);
    _cityController = TextEditingController(text: u.city);
    _stateController = TextEditingController(text: u.state);
    _experienceController = TextEditingController(text: widget.profile.yearsOfExperience.toString());
    _instrumentsController = TextEditingController(text: widget.profile.instruments.join(', '));
    _genresController = TextEditingController(text: widget.profile.genres.join(', '));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _stageNameController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _experienceController.dispose();
    _instrumentsController.dispose();
    _genresController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final rawInstruments = _instrumentsController.text
        .split(RegExp(r'[,•|]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final rawGenres = _genresController.text
        .split(RegExp(r'[,•|]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final years = int.tryParse(_experienceController.text.trim()) ?? widget.profile.yearsOfExperience;

    final updatedUser = widget.profile.user.copyWith(
      name: _nameController.text.trim(),
      stageName: _stageNameController.text.trim(),
      bio: _bioController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim().toUpperCase(),
    );

    final updatedProfile = widget.profile.copyWith(
      user: updatedUser,
      instruments: rawInstruments.isNotEmpty ? rawInstruments : widget.profile.instruments,
      genres: rawGenres.isNotEmpty ? rawGenres : widget.profile.genres,
      yearsOfExperience: years,
    );

    try {
      await widget.profileProvider.updateProfile(updatedProfile);
      if (widget.authProvider != null) {
        await widget.authProvider!.updateCurrentUser(updatedUser);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.success,
            content: Text('Perfil atualizado com sucesso!'),
          ),
        );
        Navigator.pop(context, updatedProfile);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: Text('Erro ao atualizar perfil: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Identificação Artística',
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Nome Completo',
                controller: _nameController,
                prefixIcon: Icons.person_outline_rounded,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe seu nome' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Nome Artístico / Banda',
                hint: 'Ex: Zé da Guitarra, Banda Alvorada',
                controller: _stageNameController,
                prefixIcon: Icons.badge_outlined,
              ),
              const SizedBox(height: 24),
              const Text(
                'Sobre Você & Biografia',
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Biografia / Experiência',
                hint: 'Fale sobre sua carreira musical, bandas que participou, etc.',
                controller: _bioController,
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              const Text(
                'Localização & Atuação',
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: AppTextField(
                      label: 'Cidade',
                      hint: 'Ex: Belo Horizonte',
                      controller: _cityController,
                      prefixIcon: Icons.location_city_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: AppTextField(
                      label: 'UF',
                      hint: 'MG',
                      controller: _stateController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Especialidades Musicais',
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Instrumentos / Habilidades (separados por vírgula)',
                hint: 'Ex: Guitarra Solo, Violão 7 Cordas, Vocal',
                controller: _instrumentsController,
                prefixIcon: Icons.music_note_rounded,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Gêneros Musicais (separados por vírgula)',
                hint: 'Ex: Sertanejo, Rock, MPB, Forró, Gospel',
                controller: _genresController,
                prefixIcon: Icons.library_music_rounded,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Anos de Experiência Musical',
                hint: 'Ex: 10',
                controller: _experienceController,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.timeline_rounded,
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'Salvar Alterações',
                icon: Icons.check_circle_rounded,
                isLoading: _isSaving,
                onPressed: _save,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
