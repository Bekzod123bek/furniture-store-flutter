import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_store/core/l10n/l10n.dart';
import 'package:furniture_store/core/utils/formatters.dart';
import 'package:furniture_store/features/cart/domain/entities/cart.dart';
import 'package:furniture_store/core/utils/unsplash.dart';
import 'package:furniture_store/core/widgets/app_image.dart';
import 'package:furniture_store/features/onboarding/presentation/cubit/onboarding_cubit.dart';

class _Slide {
  const _Slide(this.title, this.text, this.photoId);

  final String Function(AppLocalizations l10n) title;
  final String Function(AppLocalizations l10n) text;
  final String photoId;
}

final _slides = [
  _Slide(
    (l) => l.onboarding1Title,
    (l) => l.onboarding1Text,
    '1616486338812-3dadae4b4ace',
  ),
  _Slide(
    (l) => l.onboarding2Title,
    (l) => l.onboarding2Text,
    '1618220179428-22790b461013',
  ),
  _Slide(
    (l) => l.onboarding3Title,
    (l) => l.onboarding3Text(formatMoney(Cart.freeDeliveryFrom)),
    '1556228453-efd6c1ff04f6',
  ),
];

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page == _slides.length - 1) {
      context.read<OnboardingCubit>().finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final last = _page == _slides.length - 1;
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (_, i) => AppImage(unsplashPhoto(_slides[i].photoId)),
          ),
          const IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                  stops: [0.35, 0.85],
                ),
              ),
              child: SizedBox.expand(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () => context.read<OnboardingCubit>().finish(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      child: Text(l10n.onboardingSkip),
                    ),
                  ),
                  const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      key: ValueKey(_page),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _slides[_page].title(l10n),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _slides[_page].text(l10n),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      for (var i = 0; i < _slides.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(right: 6),
                          width: i == _page ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _page ? Colors.white : Colors.white38,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      const Spacer(),
                      ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 150),
                        child: FilledButton(
                          onPressed: _next,
                          child: Text(
                            last ? l10n.onboardingStart : l10n.onboardingNext,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
