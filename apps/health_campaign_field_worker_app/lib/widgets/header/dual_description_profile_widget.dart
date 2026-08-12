import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:digit_ui_components/widgets/helper_widget/digit_profile.dart';
import 'package:digit_ui_components/widgets/molecules/hamburger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// [ProfileWidget] only renders a single description line. This variant
/// renders two - used in the hamburger menu to show the user's name and
/// mobile number underneath their username.
class DualDescriptionProfileWidget extends ProfileWidget {
  final String? description2;

  const DualDescriptionProfileWidget({
    super.key,
    required super.title,
    super.leading,
    super.type = SidebarType.light,
    super.description,
    this.description2,
    super.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);
    final isDark = type == SidebarType.dark;

    return InkWell(
      highlightColor: const DigitColors().transparent,
      hoverColor: const DigitColors().transparent,
      splashColor: const DigitColors().transparent,
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(24),
        color: isDark
            ? theme.colorTheme.primary.primary2
            : theme.colorTheme.paper.primary,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading ??
                SvgPicture.asset(
                  Base.profileIconSvg,
                  width: 64,
                  height: 64,
                ),
            const SizedBox(height: 12.0),
            Text(
              title,
              style: textTheme.headingS.copyWith(
                color: isDark
                    ? theme.colorTheme.paper.primary
                    : theme.colorTheme.text.primary,
              ),
            ),
            if (description != null) ...[
              const SizedBox(height: 4),
              Text(
                description!,
                style: textTheme.bodyS.copyWith(
                  color: isDark
                      ? theme.colorTheme.paper.secondary
                      : theme.colorTheme.text.secondary,
                ),
              ),
            ],
            if (description2 != null) ...[
              const SizedBox(height: 4),
              Text(
                description2!,
                style: textTheme.bodyS.copyWith(
                  color: isDark
                      ? theme.colorTheme.paper.secondary
                      : theme.colorTheme.text.secondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
