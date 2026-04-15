import 'package:flutter/material.dart';

import '../profile/profile_screen.dart';
import '../../theme/app_text_styles.dart';
import '../grooming/grooming_start_screen.dart';
import '../dog_sitter/dog_sitter_screen.dart';
import '../ai/ai_screen.dart';
import '../places/where_with_pet_screen.dart';
import '../training/training_screen.dart';
import '../lost_pet/lost_pet_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfilePage(),
      ),
    );
  }

void _openGrooming() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const GroomingStartScreen(),
    ),
  );
}

void _openDogSitter() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const DogSitterScreen(),
    ),
  );
}

void _openWhereWithPet() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const WhereWithPetScreen(),
    ),
  );
}

void _openTraining() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const TrainingScreen(),
    ),
  );
}

  void _openSupportPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServicePlaceholderPage(
          title: 'Поддержка',
          text: 'Здесь будет раздел поддержки',
          goToHomePage: _goToHomePage,
        ),
      ),
    );
  }

  void _openPartnersPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServicePlaceholderPage(
          title: 'Партнёрам',
          text: 'Здесь будет информация для партнёров',
          goToHomePage: _goToHomePage,
        ),
      ),
    );
  }

  void _openAboutPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServicePlaceholderPage(
          title: 'О нас',
          text: 'Здесь будет информация о приложении',
          goToHomePage: _goToHomePage,
        ),
      ),
    );
  }

  void _openAiAssistant() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AiScreen(),
      ),
    );
  }

  void _openLostPetPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LostPetScreen(),
      ),
    );
  }

  void _openReminderPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServicePlaceholderPage(
          title: 'Защита от клещей',
          text: 'Здесь будет напоминание и информация про защиту от клещей',
          goToHomePage: _goToHomePage,
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
          goToHomePage: _goToHomePage,
        ),
      ),
    );
  }

  void _goToHomePage(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7F9F7);
    const textDark = Color(0xFF2F333A);
    const aiBg = Color(0xFFDDF3F2);
    const lostBorder = Color(0xFFE29AA0);
    const lostFill = Color(0xFFFFF7F7);
    const reminderBorder = Color(0xFFD7C8F4);
    const menuBlue = Color(0xFF283593);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bg,
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
                Text(
                  'Меню',
                  style: AppTextStyles.title.copyWith(
                    fontSize: 28,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Основные разделы приложения',
                  style: AppTextStyles.body.copyWith(
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final bigTileWidth = (screenWidth - 52) / 3;
            final smallTileWidth = (screenWidth - 68) / 3;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 30),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        child: const SizedBox(
                          width: 34,
                          height: 28,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _MenuLine(),
                              _MenuLine(),
                              _MenuLine(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'ВСЁ ЧТО НУЖНО ДЛЯ ВАШЕГО ДРУГА',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.title.copyWith(
                            color: menuBlue,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _openProfilePage,
                        child: const SizedBox(
                          width: 42,
                          height: 42,
                          child: Icon(
                            Icons.pets_outlined,
                            size: 36,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: _openAiAssistant,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: aiBg,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 64,
                            child: Center(
                              child: Icon(
                                Icons.search_rounded,
                                size: 50,
                                color: textDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ВАШ ХВОСТАТЫЙ ИИ ПОМОЩНИК',
                                  style: AppTextStyles.subtitle.copyWith(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: textDark,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '— где погулять с собакой рядом?\n— лови подборку мест',
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: 14,
                                    color: textDark,
                                    height: 1.25,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _openReminderPage,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  22,
                                  18,
                                  18,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: reminderBorder,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Text(
                                  'не забудьте защититься\nот клещей',
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: 16,
                                    height: 1.25,
                                    fontWeight: FontWeight.w500,
                                    color: textDark,
                                  ),
                                ),
                              ),
                              const Positioned(
                                left: 0,
                                top: 0,
                                child: Icon(
                                  Icons.notifications_none_rounded,
                                  size: 40,
                                  color: Colors.black,
                                ),
                              ),
                              Positioned(
                                left: 16,
                                bottom: -10,
                                child: Transform.rotate(
                                  angle: 0.15,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                        left: BorderSide(
                                          color: reminderBorder,
                                          width: 2,
                                        ),
                                        bottom: BorderSide(
                                          color: reminderBorder,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: _openLostPetPage,
                        child: Container(
                          width: 118,
                          height: 118,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: lostFill,
                            border: Border.all(
                              color: lostBorder,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'питомец\nпотерялся',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.subtitle.copyWith(
                                  fontSize: 16,
                                  height: 1.2,
                                  fontWeight: FontWeight.w600,
                                  color: lostBorder,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 34),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _BigTile(
                        width: bigTileWidth,
                        label: 'вет-клиники',
                        onTap: () => _openServicePage('вет-клиники'),
                      ),
                      _BigTile(
                        width: bigTileWidth,
                        label: 'куда с питомцем',
                        onTap: _openWhereWithPet,
                      ),
                      _BigTile(
                        width: bigTileWidth,
                        label: 'дог-ситеры/выгул',
                        onTap: _openDogSitter,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 16,
                    runSpacing: 18,
                    alignment: WrapAlignment.center,
                    children: [
                      _SmallTileNew(
                        width: smallTileWidth,
                        label: 'грумминг',
                        onTap: _openGrooming,
                      ),
                      _SmallTileNew(
                        width: smallTileWidth,
                        label: 'комьюнити',
                        onTap: () => _openServicePage('комьюнити'),
                      ),
                      _SmallTileNew(
                        width: smallTileWidth,
                        label: 'дрессировка',
                        onTap: _openTraining,
                      ),
                      _SmallTileNew(
                        width: smallTileWidth,
                        label: 'скоро',
                        onTap: () => _openServicePage('скоро'),
                      ),
                      _SmallTileNew(
                        width: smallTileWidth,
                        label: 'маркетплейс',
                        onTap: () => _openServicePage('маркетплейс'),
                      ),
                      _SmallTileNew(
                        width: smallTileWidth,
                        label: 'полезное',
                        onTap: () => _openServicePage('полезное'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  Center(
                    child: Text(
                      'ЗДЕСЬ МОЖЕТ БЫТЬ\nВАША РЕКЛАМА',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.title.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        height: 1.08,
                        color: textDark,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
                child: Icon(
                  icon,
                  color: const Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.subtitle.copyWith(
                        fontSize: 17,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.body.copyWith(
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
        color: const Color(0xFF283593),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _BigTile extends StatelessWidget {
  final double width;
  final String label;
  final VoidCallback onTap;

  const _BigTile({
    required this.width,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const peach = Color(0xFFF2B7AD);
    return SizedBox(
      width: width,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: width,
              height: 108,
              decoration: BoxDecoration(
                color: peach,
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallTileNew extends StatelessWidget {
  final double width;
  final String label;
  final VoidCallback onTap;

  const _SmallTileNew({
    required this.width,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const peach = Color(0xFFF2B7AD);

    return SizedBox(
      width: width,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: width * 0.78,
              height: width * 0.78,
              decoration: BoxDecoration(
                color: peach,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServicePlaceholderPage extends StatelessWidget {
  final String title;
  final String text;
  final void Function(BuildContext) goToHomePage;

  const ServicePlaceholderPage({
    super.key,
    required this.title,
    required this.text,
    required this.goToHomePage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
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
                    style: AppTextStyles.title.copyWith(
                      fontSize: 26,
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
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.subtitle.copyWith(
                      fontSize: 22,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2F333A),
                    ),
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
