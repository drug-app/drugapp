import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/auth_service.dart';
import '../../theme/app_text_styles.dart';
import '../home/home_screen.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoginMode = true;
  bool _isLoading = false;
  bool _showIntro = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _show('Заполни email и пароль');
      return;
    }

    if (password.length < 6) {
      _show('Пароль должен быть не короче 6 символов');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isLoginMode) {
        await _authService.signIn(
          email: email,
          password: password,
        );
      } else {
        await _authService.signUp(
          email: email,
          password: password,
        );
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
    } on AuthException catch (e) {
      _show(e.message);
    } catch (e) {
      _show('Ошибка: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _continueAsGuest() async {
    setState(() => _isLoading = true);

    try {
      await _authService.signInAnonymously();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
    } on AuthException catch (e) {
      _show(e.message);
    } catch (e) {
      _show('Ошибка гостевого входа: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _show(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  void _toggle() {
    setState(() => _isLoginMode = !_isLoginMode);
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF3558D6);
    const darkText = Color(0xFF1F2937);
    const softText = Color(0xFF6B7280);

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0D1B43),
                Color(0xFF4379FF),
                Color(0xFFF4F7FF),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: _showIntro
                      ? ConstrainedBox(
                          key: const ValueKey('welcome_intro'),
                          constraints: const BoxConstraints(maxWidth: 380),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.94),
                              borderRadius: BorderRadius.circular(34),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.10),
                                  blurRadius: 28,
                                  offset: const Offset(0, 14),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(28),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 300,
                                    child: Image.asset(
                                      'assets/images/welcome_dog.png',
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 26),
                                Text(
                                  'добро пожаловать\nв место, где есть всё\nдля твоего любимого\nдруга',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.caveat(
                                    fontSize: 34,
                                    fontWeight: FontWeight.w700,
                                    color: darkText,
                                    height: 1.02,
                                  ),
                                ),
                                const SizedBox(height: 28),
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF67C7FF),
                                          Color(0xFF6A73FF),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _showIntro = false;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Text(
                                        'АВТОРИЗОВАТЬСЯ',
                                        style: AppTextStyles.button.copyWith(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          key: const ValueKey('welcome_auth'),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 390),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(
                                22,
                                22,
                                22,
                                24,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.94),
                                borderRadius: BorderRadius.circular(34),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.10),
                                    blurRadius: 28,
                                    offset: const Offset(0, 14),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: _isLoading
                                            ? null
                                            : () {
                                                setState(() {
                                                  _showIntro = true;
                                                });
                                              },
                                        child: Container(
                                          width: 42,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF1F5FF),
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: const Icon(
                                            Icons.arrow_back_rounded,
                                            color: accent,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        _isLoginMode
                                            ? 'Авторизация'
                                            : 'Регистрация',
                                        style: AppTextStyles.subtitle.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: darkText,
                                        ),
                                      ),
                                      const Spacer(),
                                      const SizedBox(width: 42),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFE8F8F7),
                                          Color(0xFFF1F5FF),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(26),
                                    ),
                                    child: Column(
                                      children: [
                                        const _WelcomeDogBadge(),
                                        const SizedBox(height: 14),
                                        Text(
                                          _isLoginMode
                                              ? 'С возвращением в ДРУГ'
                                              : 'Создай аккаунт в ДРУГ',
                                          textAlign: TextAlign.center,
                                          style:
                                              AppTextStyles.title.copyWith(
                                            fontSize: 26,
                                            color: darkText,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _isLoginMode
                                              ? 'Войди в аккаунт и продолжай пользоваться сервисами для питомца.'
                                              : 'Зарегистрируйся, чтобы сохранять питомцев, записи и историю в одном месте.',
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.body.copyWith(
                                            fontSize: 14,
                                            color: softText,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 22),
                                  _AuthField(
                                    controller: _emailController,
                                    hintText: 'Email',
                                    icon: Icons.mail_outline_rounded,
                                  ),
                                  const SizedBox(height: 14),
                                  _AuthField(
                                    controller: _passwordController,
                                    hintText: 'Пароль',
                                    icon: Icons.lock_outline_rounded,
                                    obscureText: true,
                                  ),
                                  const SizedBox(height: 22),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF67C7FF),
                                            Color(0xFF7C67FF),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: _isLoading ? null : _submit,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          foregroundColor: Colors.white,
                                          disabledBackgroundColor:
                                              Colors.transparent,
                                          disabledForegroundColor:
                                              Colors.white70,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: _isLoading
                                            ? const SizedBox(
                                                width: 22,
                                                height: 22,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Text(
                                                _isLoginMode
                                                    ? 'ВОЙТИ'
                                                    : 'ЗАРЕГИСТРИРОВАТЬСЯ',
                                                style:
                                                    AppTextStyles.button.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: OutlinedButton(
                                      onPressed: _isLoading
                                          ? null
                                          : _continueAsGuest,
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: darkText,
                                        side: const BorderSide(
                                          color: Color(0xFFD9E1F2),
                                          width: 1.2,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        backgroundColor:
                                            Colors.white.withValues(alpha: 0.82),
                                      ),
                                      child: Text(
                                        'ВОЙТИ КАК ГОСТЬ',
                                        style: AppTextStyles.button.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: darkText,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  GestureDetector(
                                    onTap: _isLoading ? null : _toggle,
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: AppTextStyles.caption.copyWith(
                                          fontSize: 13,
                                          color: softText,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: _isLoginMode
                                                ? 'Нет аккаунта? '
                                                : 'Уже есть аккаунт? ',
                                          ),
                                          TextSpan(
                                            text: _isLoginMode
                                                ? 'Регистрация'
                                                : 'Войти',
                                            style:
                                                AppTextStyles.caption.copyWith(
                                              fontSize: 13,
                                              color: accent,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    'Все важное для питомца в одном месте',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.caption.copyWith(
                                      fontSize: 12,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeDogBadge extends StatelessWidget {
  const _WelcomeDogBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(
        Icons.pets_rounded,
        size: 38,
        color: Color(0xFF3558D6),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;

  const _AuthField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF6B7280),
          size: 20,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF9CA3AF),
          fontSize: 14,
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFFDCE4F4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFF4F7CFF),
            width: 1.4,
          ),
        ),
      ),
    );
  }
}
