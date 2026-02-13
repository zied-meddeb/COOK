import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import '../providers/providers.dart';
import '../models/models.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  UserRole _selectedRole = UserRole.client;
  bool _acceptTerms = false;
  bool _showPassword = false;
  bool _isLoading = false;
  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate() && _acceptTerms) {
      setState(() => _isLoading = true);

      // Simulate registration
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      final appProvider = Provider.of<AppProvider>(context, listen: false);
      appProvider.setUser(User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        email: _emailController.text,
        role: _selectedRole,
      ));

      Navigator.of(context).pushReplacementNamed(
        _selectedRole == UserRole.client ? '/client' : '/cook',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back, color: colors.textPrimary),
        ),
        title: Text(
          'Créer un compte',
          style: AppTypography.h3.copyWith(color: colors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Indicator
                _buildProgressIndicator(colors),
                const SizedBox(height: AppSpacing.xl),

                // Step Content
                if (_currentStep == 0) _buildRoleSelection(colors),
                if (_currentStep == 1) _buildPersonalInfo(colors),
                if (_currentStep == 2) _buildAccountInfo(colors),

                const SizedBox(height: AppSpacing.xl),

                // Navigation Buttons
                Row(
                  children: [
                    if (_currentStep > 0) ...[
                      Expanded(
                        child: AppButton(
                          label: 'Retour',
                          onPressed: () => setState(() => _currentStep--),
                          variant: AppButtonVariant.secondary,
                          size: AppButtonSize.lg,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                    ],
                    Expanded(
                      flex: _currentStep > 0 ? 2 : 1,
                      child: AppButton(
                        label: _currentStep < 2 ? 'Continuer' : "S'inscrire",
                        onPressed: _isLoading
                            ? () {}
                            : () {
                                if (_currentStep < 2) {
                                  if (_currentStep == 1) {
                                    if (_nameController.text.isEmpty ||
                                        _phoneController.text.isEmpty) {
                                      return;
                                    }
                                  }
                                  setState(() => _currentStep++);
                                } else {
                                  _handleRegister();
                                }
                              },
                        variant: AppButtonVariant.primary,
                        size: AppButtonSize.lg,
                        fullWidth: true,
                        disabled: _currentStep == 2 && !_acceptTerms,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // Login Link
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacementNamed('/login'),
                    child: RichText(
                      text: TextSpan(
                        style: AppTypography.bodyMd.copyWith(
                          color: colors.textSecondary,
                        ),
                        children: [
                          const TextSpan(text: 'Déjà un compte ? '),
                          TextSpan(
                            text: 'Se connecter',
                            style: AppTypography.bodyMd.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(AppThemeColors colors) {
    return Row(
      children: List.generate(3, (index) {
        final isActive = index <= _currentStep;
        final isCompleted = index < _currentStep;
        return Expanded(
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : colors.card,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive ? AppColors.primary : colors.border,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Text(
                          '${index + 1}',
                          style: AppTypography.bodySm.copyWith(
                            color: isActive ? Colors.white : colors.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              if (index < 2)
                Expanded(
                  child: Container(
                    height: 2,
                    color: index < _currentStep ? AppColors.primary : colors.border,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRoleSelection(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Je souhaite...',
          style: AppTypography.h2.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Choisissez votre type de compte',
          style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Client Option
        _buildRoleCard(
          role: UserRole.client,
          icon: '🍽️',
          title: 'Commander des plats',
          description: 'Découvrez des plats faits maison près de chez vous',
          colors: colors,
        ),
        const SizedBox(height: AppSpacing.md),

        // Chef Option
        _buildRoleCard(
          role: UserRole.cook,
          icon: '👨‍🍳',
          title: 'Vendre mes plats',
          description: 'Partagez vos talents culinaires et générez des revenus',
          colors: colors,
        ),
      ],
    );
  }

  Widget _buildRoleCard({
    required UserRole role,
    required String icon,
    required String title,
    required String description,
    required AppThemeColors colors,
  }) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          border: Border.all(
            color: isSelected ? AppColors.primary : colors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryLight : colors.background,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyLg.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTypography.bodySm.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : colors.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfo(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vos informations',
          style: AppTypography.h2.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Parlez-nous un peu de vous',
          style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Name
        TextInputField(
          label: 'Nom complet',
          controller: _nameController,
          placeholder: 'Jean Dupont',
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: AppSpacing.lg),

        // Phone
        TextInputField(
          label: 'Téléphone',
          controller: _phoneController,
          placeholder: '+33 6 12 34 56 78',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: AppSpacing.lg),

        // Chef-specific fields
        if (_selectedRole == UserRole.cook) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 24)),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'En tant que chef, vous pourrez ensuite ajouter vos spécialités et photos.',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAccountInfo(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vos identifiants',
          style: AppTypography.h2.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Créez vos identifiants de connexion',
          style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Email
        TextInputField(
          label: 'Email',
          controller: _emailController,
          placeholder: 'jean@example.com',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.lg),

        // Password
        TextInputField(
          label: 'Mot de passe',
          controller: _passwordController,
          placeholder: '••••••••',
          prefixIcon: Icons.lock_outline,
          obscureText: !_showPassword,
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _showPassword = !_showPassword),
            child: Icon(
              _showPassword ? Icons.visibility_off : Icons.visibility,
              color: colors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Confirm Password
        TextInputField(
          label: 'Confirmer le mot de passe',
          controller: _confirmPasswordController,
          placeholder: '••••••••',
          prefixIcon: Icons.lock_outline,
          obscureText: !_showPassword,
        ),
        const SizedBox(height: AppSpacing.xl),

        // Terms
        GestureDetector(
          onTap: () => setState(() => _acceptTerms = !_acceptTerms),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _acceptTerms ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _acceptTerms ? AppColors.primary : colors.border,
                    width: 2,
                  ),
                ),
                child: _acceptTerms
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: AppTypography.bodySm.copyWith(
                      color: colors.textSecondary,
                    ),
                    children: [
                      const TextSpan(text: "J'accepte les "),
                      TextSpan(
                        text: 'conditions générales',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: ' et la '),
                      TextSpan(
                        text: 'politique de confidentialité',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

