import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/pet.dart';
import 'services/pet_service.dart';

import 'screens/profile/profile_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hcohlvtsypqwroeeuzxl.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhjb2hsdnRzeXBxd3JvZWV1enhsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ5NDEyNTgsImV4cCI6MjA5MDUxNzI1OH0.n0LCTV_7tfJAG2U3_eMXgRZFb8ZIdZLms_Fx_3wrQw4',
  );

  runApp(const DrugApp());
}

void goToHomePage(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const HomePage()),
    (route) => false,
  );
}

class DrugApp extends StatelessWidget {
  const DrugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      home: const WelcomePage(),
    );
  }
}

// =======================
// 1 ЭКРАН — WELCOME
// =======================

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F172A),
                Color(0xFF3B82F6),
                Color(0xFFF8FAFC),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 28,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Добро пожаловать',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Войдите в аккаунт ДРУГ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF4FF),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.pets_rounded,
                            size: 34,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                        const SizedBox(height: 28),
                        const _AuthField(
                          hintText: 'Email',
                          icon: Icons.mail_outline_rounded,
                        ),
                        const SizedBox(height: 16),
                        const _AuthField(
                          hintText: 'Пароль',
                          icon: Icons.lock_outline_rounded,
                          obscureText: true,
                        ),
                        const SizedBox(height: 26),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF63D1FF),
                                  Color(0xFF8B5CF6),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const HomePage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text(
                                'ВОЙТИ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Нет аккаунта? ',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              'Регистрация',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF3B82F6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Все важное для питомца в одном месте',
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
    );
  }
}

class _AuthField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;

  const _AuthField({
    required this.hintText,
    required this.icon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black45, size: 20),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.black45,
          fontSize: 14,
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFE5E7EB),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF3B82F6),
            width: 1.4,
          ),
        ),
      ),
    );
  }
}

// =======================
// 2 ЭКРАН — HOME
// =======================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _smallTilesPageController = PageController();
  int _currentSmallPage = 0;

  @override
  void dispose() {
    _smallTilesPageController.dispose();
    super.dispose();
  }

  void _openProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfilePage(),
      ),
    );
  }

  void _openSupportPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SupportPage(),
      ),
    );
  }

  void _openPartnersPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PartnersPage(),
      ),
    );
  }

  void _openAboutPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AboutPage(),
      ),
    );
  }

  void _openAiAssistant() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AiChatPage(),
      ),
    );
  }

  void _openLostPetPage() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ServicePlaceholderPage(
        title: 'Питомец потерялся',
        text: 'Здесь будет инфа про потерявшегося питомца',
        goToHomePage: goToHomePage,
      ),
    ),
  );
}

 void _openReminderPage() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ServicePlaceholderPage(
        title: 'Защита от клещей',
        text: 'Здесь будет инфа про защиту от клещей',
        goToHomePage: goToHomePage,
      ),
    ),
  );
}

  void _openServicePage(String title) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ServicePlaceholderPage(
        title: title,
        text: 'Здесь будет инфа про $title',
        goToHomePage: goToHomePage,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7F9F7);
    const aiBg = Color(0xFFF4DA91);
    const textDark = Color(0xFF2F333A);
    const lostPink = Color(0xFFE29AA0);
    const lostFill = Color(0xFFFFF7F7);

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(28),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Меню',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Основные разделы приложения',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),
                _drawerTile(
                  icon: Icons.support_agent_rounded,
                  title: 'Поддержка',
                  subtitle: 'Чат и помощь по типовым вопросам',
                  onTap: () {
                    Navigator.pop(context);
                    _openSupportPage();
                  },
                ),
                const SizedBox(height: 14),
                _drawerTile(
                  icon: Icons.handshake_outlined,
                  title: 'Партнёрам',
                  subtitle: 'Сотрудничество, вакансии и контакты',
                  onTap: () {
                    Navigator.pop(context);
                    _openPartnersPage();
                  },
                ),
                const SizedBox(height: 14),
                _drawerTile(
                  icon: Icons.info_outline_rounded,
                  title: 'О нас',
                  subtitle: 'Наша история и информация о приложении',
                  onTap: () {
                    Navigator.pop(context);
                    _openAboutPage();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFEFE3FA),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 402,
            child: SingleChildScrollView(
              child: Container(
                color: bg,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 20, 15, 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 48,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _scaffoldKey.currentState?.openDrawer();
                              },
                              child: const SizedBox(
                                width: 33,
                                height: 28,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _MenuLine(),
                                    _MenuLine(),
                                    _MenuLine(),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 26),
                            const Expanded(
                              child: Text(
                                'ВСЁ ЧТО НУЖНО ДЛЯ ВАШЕГО ДРУГА',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.15,
                                  fontWeight: FontWeight.w600,
                                  color: textDark,
                                ),
                              ),
                            ),
                            const SizedBox(width: 26),
                            GestureDetector(
                              onTap: _openProfilePage,
                              child: const SizedBox(
                                width: 44,
                                height: 44,
                                child: Icon(
                                  Icons.pets_outlined,
                                  size: 40,
                                  color: textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),
                      GestureDetector(
                        onTap: _openAiAssistant,
                        child: Container(
                          width: 373,
                          height: 91,
                          decoration: BoxDecoration(
                            color: aiBg,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search_rounded,
                                  size: 50,
                                  color: textDark,
                                ),
                                SizedBox(width: 14),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 6),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ВАШ ХВОСТАТЫЙ ИИ\nПОМОЩНИК',
                                          style: TextStyle(
                                            fontSize: 18,
                                            height: 1.02,
                                            fontWeight: FontWeight.w700,
                                            color: textDark,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          '— где погулять с собакой рядом?\n— лови подборку мест',
                                          style: TextStyle(
                                            fontSize: 13,
                                            height: 1.2,
                                            color: textDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: _openReminderPage,
                            child: Container(
                              width: 170,
                              height: 64,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.10),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'не забудьте защититься\nот клещей',
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.2,
                                    fontWeight: FontWeight.w500,
                                    color: textDark,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 44),
                          GestureDetector(
                            onTap: _openLostPetPage,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: lostFill,
                                border: Border.all(
                                  color: lostPink,
                                  width: 2,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'питомец\nпотерялся',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.15,
                                    fontWeight: FontWeight.w500,
                                    color: lostPink,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _TopBigTile(
                            label: 'вет-клиники',
                            onTap: () => _openServicePage('вет-клиники'),
                          ),
                          _TopBigTile(
                            label: 'куда с\nпитомцем',
                            onTap: () => _openServicePage('куда с питомцем'),
                          ),
                          _TopBigTile(
                            label: 'дог-ситеры/\nвыгул',
                            onTap: () => _openServicePage('дог-ситеры и выгул'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 122,
                        child: PageView(
                          controller: _smallTilesPageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentSmallPage = index;
                            });
                          },
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _SmallTile(
                                  label: 'грумминг',
                                  outlined: true,
                                  onTap: () => _openServicePage('грумминг'),
                                ),
                                const SizedBox(width: 8),
                                _SmallTile(
                                  label: 'комьюни\nти',
                                  onTap: () => _openServicePage('комьюнити'),
                                ),
                                const SizedBox(width: 8),
                                _SmallTile(
                                  label: 'дрессир\nовка',
                                  onTap: () => _openServicePage('дрессировка'),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _SmallTile(
                                  label: 'скоро',
                                  onTap: () => _openServicePage('скоро'),
                                ),
                                const SizedBox(width: 8),
                                _SmallTile(
                                  label: 'маркетпл\nейс',
                                  onTap: () => _openServicePage('маркетплейс'),
                                ),
                                const SizedBox(width: 8),
                                _SmallTile(
                                  label: 'полезное',
                                  onTap: () => _openServicePage('полезное'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(2, (index) {
                          final isActive = _currentSmallPage == index;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: isActive ? 10 : 8,
                            height: isActive ? 10 : 8,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFF2F333A)
                                  : Colors.black26,
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 72),
                      const Center(
                        child: Text(
                          'ЗДЕСЬ МОЖЕТ БЫТЬ\nВАША РЕКЛАМА',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            height: 1.08,
                            fontWeight: FontWeight.w500,
                            color: textDark,
                          ),
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
    );
  }

  Widget _drawerTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF4FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: const Color(0xFF3B82F6)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.black38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuLine extends StatelessWidget {
  const _MenuLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 33,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFFFFC857),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _TopBigTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _TopBigTile({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF7CCFC4),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onTap,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2F333A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallTile extends StatelessWidget {
  final String label;
  final bool outlined;
  final VoidCallback onTap;

  const _SmallTile({
    required this.label,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 86,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: outlined ? Colors.white : const Color(0xFF7CCFC4),
                borderRadius: BorderRadius.circular(14),
                border: outlined
                    ? Border.all(
                        color: const Color(0xFF7CCFC4),
                        width: 2,
                      )
                    : null,
              ),
              child: outlined
                  ? const Center(
                      child: Icon(
                        Icons.content_cut_rounded,
                        size: 30,
                        color: Color(0xFF7CCFC4),
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onTap,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                height: 1.08,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2F333A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =======================
// 3 ЭКРАН — PROFILE
// =======================



// =======================
// DRAWER СТРАНИЦЫ
// =======================

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoPageTemplate(
      title: 'Поддержка',
      text: 'Это страница поддержки',
      icon: Icons.support_agent_rounded,
    );
  }
}

class PartnersPage extends StatelessWidget {
  const PartnersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoPageTemplate(
      title: 'Партнёрам',
      text: 'Это страница для партнёров',
      icon: Icons.handshake_outlined,
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoPageTemplate(
      title: 'О нас',
      text: 'Это страница о нас',
      icon: Icons.info_outline_rounded,
    );
  }
}

class InfoPageTemplate extends StatelessWidget {
  final String title;
  final String text;
  final IconData icon;

  const InfoPageTemplate({
    super.key,
    required this.title,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 24,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4F7CFF), Color(0xFF7EA2FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => goToHomePage(context),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.home_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF4FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          icon,
                          size: 34,
                          color: const Color(0xFF3B82F6),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =======================
// ЧАТ ИИ
// =======================

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _messages.add(
        _ChatMessage(
          text: 'Здесь позже будет полноценный ответ ИИ на: "$text"',
          isUser: false,
        ),
      );
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF3F4F6);
    const dark = Color(0xFF30343B);
    const accent = Color(0xFF7C5CFA);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: dark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 16,
                            color: accent,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Алиса AI',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: dark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => goToHomePage(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.home_rounded,
                        size: 22,
                        color: dark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _messages.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Привет!',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: dark,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Чем помочь сегодня?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Color(0xD930343B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        return Align(
                          alignment: msg.isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            constraints: const BoxConstraints(maxWidth: 280),
                            decoration: BoxDecoration(
                              color: msg.isUser
                                  ? const Color(0xFFE9E5FF)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              msg.text,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.35,
                                color: dark,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAEAEA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            minLines: 1,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText:
                                  'Как правильно упаковать лыжное снаряжение в багаж?',
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color(0xBF30343B),
                              ),
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                            style: const TextStyle(
                              fontSize: 15,
                              color: dark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _sendMessage,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: accent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(
                        Icons.add,
                        size: 24,
                        color: dark,
                      ),
                      Spacer(),
                      Icon(
                        Icons.mic_none_rounded,
                        size: 24,
                        color: dark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;

  _ChatMessage({
    required this.text,
    required this.isUser,
  });
}

// =======================
// ЗАГЛУШКИ РАЗДЕЛОВ
// =======================

