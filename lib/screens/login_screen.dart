import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';
import '../widgets/widgets.dart';
import '../providers/providers.dart';
import '../models/models.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole? _selectedRole = UserRole.client;

  void _handleLogin() {
    if (_selectedRole != null) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      appProvider.setUser(User(
        id: '1',
        name: _selectedRole == UserRole.client ? 'Sarah' : 'Maria',
        email: '${_selectedRole == UserRole.client ? 'client' : 'cook'}@example.com',
        role: _selectedRole!,
        avatar: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCb8kHsUE3kAQu8XJMQqAmG-oB44JavZZX5teQTtgZWGV_L-PvPrpMjVaKWKxgvEIta8KJBfHouLBkfQKEfTdQFqgmaAw08HHXdGkFSea9L3TNnf4GQSyuBWfMjUw-sdvCpKz0w4id2Q8l1H9OATMXudBwJUGsqabNRfPl5QaS09mNOxRlVbAL_Z_HmIY6ffl0DcV6QzGxCHDSnp3zIgph97o-mKjNKXIfwAQmIZIKdWvqUbgixU9M9AmMLc2WJnu2SvzM68WF604I',
      ));
      
      if (_selectedRole == UserRole.client) {
        Navigator.of(context).pushReplacementNamed('/client');
      } else {
        Navigator.of(context).pushReplacementNamed('/cook');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDE5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text('🍳', style: TextStyle(fontSize: 32)),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Bienvenue !',
                      style: AppTypography.h2.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Quel est votre objectif aujourd'hui ?",
                      style: AppTypography.bodyMd.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Role Cards
              // Client Role
              GestureDetector(
                onTap: () => setState(() => _selectedRole = UserRole.client),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: colors.card,
                    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                    border: Border.all(
                      color: _selectedRole == UserRole.client 
                          ? AppColors.primary 
                          : colors.border,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: _selectedRole == UserRole.client 
                              ? AppColors.primary 
                              : colors.border,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('🍽️', style: TextStyle(fontSize: 24)),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Je cherche des plats',
                              style: AppTypography.bodyLg.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Commander des repas faits maison',
                              style: AppTypography.bodySm.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Cook Role
              GestureDetector(
                onTap: () => setState(() => _selectedRole = UserRole.cook),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: colors.card,
                    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                    border: Border.all(
                      color: _selectedRole == UserRole.cook 
                          ? AppColors.primary 
                          : colors.border,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: _selectedRole == UserRole.cook 
                              ? AppColors.primary 
                              : colors.border,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('👨‍🍳', style: TextStyle(fontSize: 24)),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Je veux vendre',
                              style: AppTypography.bodyLg.copyWith(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Proposer mes spécialités culinaires',
                              style: AppTypography.bodySm.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Buttons
              AppButton(
                label: 'Se connecter',
                onPressed: _handleLogin,
                variant: AppButtonVariant.primary,
                size: AppButtonSize.lg,
                fullWidth: true,
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: "S'inscrire",
                onPressed: () => Navigator.of(context).pushNamed('/register'),
                variant: AppButtonVariant.secondary,
                size: AppButtonSize.lg,
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
