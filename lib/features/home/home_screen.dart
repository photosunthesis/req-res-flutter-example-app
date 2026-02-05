import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:req_res_flutter/app/theme.dart';
import 'package:req_res_flutter/constants/icons.dart';
import 'package:req_res_flutter/constants/images.dart';
import 'package:req_res_flutter/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final _l10n = AppLocalizations.of(context)!;
  late final _theme = Theme.of(context);

  final _featuredNewsPageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  @override
  void dispose() {
    _featuredNewsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildFeaturedNews()),
          SliverToBoxAdapter(child: _buildNewsSection()),
          SliverToBoxAdapter(child: _buildCommunitySection()),
          SliverToBoxAdapter(child: _buildNewsArticle()),
          SliverToBoxAdapter(child: _buildPublicServiceSection()),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.background,
      surfaceTintColor: AppColors.background,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.searchBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.search,
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppColors.textSecondary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _l10n.searchHint,
                      style: _theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Stack(
              alignment: Alignment.topRight,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(AppIcons.bell, width: 28, height: 28),
                ),
                Positioned(
                  right: 4,
                  top: 2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withAlpha(12),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTabItem(
                  icon: AppIcons.forYou,
                  label: _l10n.tabForYou,
                  isSelected: true,
                ),
                _buildTabItem(
                  icon: AppIcons.news,
                  label: _l10n.tabNews,
                  isSelected: false,
                ),
                _buildTabItem(
                  icon: AppIcons.publicService,
                  label: _l10n.tabPublicService,
                  isSelected: false,
                ),
                _buildTabItem(
                  icon: AppIcons.community,
                  label: _l10n.tabCommunity,
                  isSelected: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required String icon,
    required String label,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      decoration: isSelected
          ? const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.primaryDark, width: 2),
              ),
            )
          : null,
      child: Row(
        children: [
          SvgPicture.asset(icon, width: 24, height: 24),
          const SizedBox(width: 8),
          Text(
            label,
            style: _theme.textTheme.bodyLarge?.copyWith(
              color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
              fontWeight: .w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedNews() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _l10n.featuredNewsTitle,
                style: _theme.textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: .w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                _l10n.seeMore,
                style: _theme.textTheme.labelLarge?.copyWith(
                  fontWeight: .normal,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 265,
          child: PageView(
            clipBehavior: Clip.none,
            controller: _featuredNewsPageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildNewsCard(
                image: AppImages.featuredImage1,
                title:
                    'Breaking News: Massive Fire Erupts in Downtown District',
                source: 'Acme News',
                time: '1h ago',
                isBreaking: true,
              ),
              _buildNewsCard(
                image: AppImages.featuredImage2,
                title: 'Kindness Project Sparks Global Movement',
                source: 'Acme News',
                time: '1h ago',
              ),
              _buildNewsCard(
                image: AppImages.featuredImage2,
                title: 'Community Garden Project Launches in City Center',
                source: 'Acme News',
                time: '3h ago',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildNewsCard({
    required String image,
    required String title,
    required String source,
    required String time,
    bool isBreaking = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isBreaking
            ? AppColors.breakingNewsBackground
            : AppColors.background,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  image,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (isBreaking)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.breakingNews,
                          width: 16,
                          height: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _l10n.breakingNewsBadge,
                          style: _theme.textTheme.labelSmall?.copyWith(
                            fontSize: 12,
                            fontWeight: .w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (isBreaking)
            Row(
              children: [
                SvgPicture.asset(AppIcons.breakingNews, width: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: .w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            )
          else
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _theme.textTheme.bodyLarge?.copyWith(
                fontWeight: .w700,
                color: AppColors.textPrimary,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            '$source · $time',
            style: _theme.textTheme.bodyMedium?.copyWith(
              fontWeight: .normal,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildNewsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withAlpha(12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSectionHeader(AppIcons.news, _l10n.tabNews),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'News Celebrating Prosperity: Chinese New Year 2025 Kicks Off with Joy and Tradition',
                        style: _theme.textTheme.titleMedium?.copyWith(
                          fontWeight: .w700,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        AppImages.article1,
                        width: 140,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'newspost',
                      style: _theme.textTheme.labelLarge?.copyWith(
                        fontWeight: .w500,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '·',
                      style: _theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Just now',
                      style: _theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.more_horiz,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunitySection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withAlpha(12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(AppIcons.community, _l10n.tabCommunity),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(AppImages.alonso, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alfonso George',
                            style: _theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: .w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '4h ago',
                            style: _theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.add,
                            size: 16,
                            color: AppColors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _l10n.follow,
                            style: _theme.textTheme.labelLarge?.copyWith(
                              color: AppColors.white,
                              fontWeight: .normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    style: _theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: .w500,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(
                        text:
                            'Our small business just reached a huge milestone: 5,000 happy customer... ',
                      ),
                      TextSpan(
                        text: 'See more',
                        style: _theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary.withAlpha(128),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    AppImages.article2,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInteractionButton(
                      AppIcons.likes,
                      '7 904',
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 24),
                    _buildInteractionButton(AppIcons.comments, '7 904'),
                    const SizedBox(width: 24),
                    _buildInteractionButton(AppIcons.saves, '7 904'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsArticle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        children: [
          _buildVideoArticleCard(
            sectionIcon: AppIcons.news,
            sectionTitle: _l10n.tabNews,
            image: AppImages.article3,
            title:
                '2025 Industry Outlook: Key Trends Shaping the Future of Business',
            source: 'newspost',
            time: 'Just now',
          ),
        ],
      ),
    );
  }

  Widget _buildPublicServiceSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        children: [
          _buildVideoArticleCard(
            sectionIcon: AppIcons.publicService,
            sectionTitle: _l10n.tabPublicService,
            image: AppImages.article4,
            title:
                'Stay Safe: Classes Canceled in Cavite Due to Heavy Rainfall',
            source: 'Bacoor, Cavite',
            time: 'Just now',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String icon, String title) {
    return Row(
      children: [
        SvgPicture.asset(icon, width: 24, height: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: _theme.textTheme.bodyLarge?.copyWith(
            fontWeight: .w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoArticleCard({
    required String image,
    required String title,
    required String source,
    required String time,
    required String sectionIcon,
    required String sectionTitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(sectionIcon, sectionTitle),
          const SizedBox(height: 16),
          Text(
            title,
            style: _theme.textTheme.bodyLarge?.copyWith(
              fontWeight: .w700,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  image,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                child: SvgPicture.asset(AppIcons.play, width: 48, height: 48),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                source,
                style: _theme.textTheme.labelLarge?.copyWith(
                  fontWeight: .w500,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '·',
                style: _theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                time,
                style: _theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.more_horiz,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionButton(String icon, String count, {Color? color}) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(
            color ?? AppColors.textSecondary,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          count,
          style: _theme.textTheme.labelLarge?.copyWith(
            fontWeight: .w500,
            color: color ?? AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
