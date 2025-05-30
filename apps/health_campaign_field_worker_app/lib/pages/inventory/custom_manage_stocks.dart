import 'package:auto_route/auto_route.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:digit_ui_components/widgets/atoms/menu_card.dart';
import 'package:digit_ui_components/widgets/scrollable_content.dart';
import 'package:flutter/material.dart';

import 'package:inventory_management/utils/i18_key_constants.dart' as i18;
import 'package:inventory_management/utils/utils.dart';
import 'package:inventory_management/widgets/localized.dart';
import 'package:inventory_management/blocs/record_stock.dart';
import 'package:inventory_management/widgets/back_navigation_help_header.dart';

import '../../router/app_router.dart';
import '../../utils/extensions/extensions.dart';

@RoutePage()
class CustomManageStocksPage extends LocalizedStatefulWidget {
  const CustomManageStocksPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<CustomManageStocksPage> createState() => CustomManageStocksPageState();
}

class CustomManageStocksPageState
    extends LocalizedState<CustomManageStocksPage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    return Scaffold(
      body: ScrollableContent(
        header: const BackNavigationHelpHeaderWidget(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: spacer2, right: spacer2, bottom: spacer4),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    localizations.translate(i18.manageStock.label),
                    style: textTheme.headingXl,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.only(left: spacer2, right: spacer2),
                  child: Stack(children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 0.94 * MediaQuery.of(context).size.width,
                        child: MenuCard(
                          heading: localizations.translate(
                              i18.manageStock.recordStockReceiptLabel),
                          description: insertNewlines(localizations.translate(
                              i18.manageStock.recordStockReceiptDescription)),
                          icon: Icons.file_download_outlined,
                          onTap: () {
                            context.router.push(
                              CustomRecordStockWrapperRoute(
                                type: StockRecordEntryType.receipt,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 16,
                      child: Center(
                          child: GestureDetector(
                        onTap: () {
                          context.router.push(
                            CustomRecordStockWrapperRoute(
                              type: StockRecordEntryType.receipt,
                            ),
                          );
                        },
                        child: Icon(
                          Icons.arrow_circle_right,
                          color: Colors.orange[800],
                          size: Base.height,
                        ),
                      )),
                    ),
                  ]),
                ),
                const SizedBox(
                  height: spacer4,
                ),
                if (!context.isCDD)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: spacer2, right: spacer2),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 0.94 * MediaQuery.of(context).size.width,
                            child: MenuCard(
                              heading: localizations.translate(
                                  i18.manageStock.recordStockIssuedLabel),
                              description: insertNewlines(
                                  localizations.translate(i18.manageStock
                                      .recordStockIssuedDescription)),
                              icon: Icons.file_upload_outlined,
                              onTap: () => context.router.push(
                                CustomRecordStockWrapperRoute(
                                  type: StockRecordEntryType.dispatch,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: 16,
                          child: Center(
                              child: GestureDetector(
                            onTap: () {
                              context.router.push(
                                CustomRecordStockWrapperRoute(
                                  type: StockRecordEntryType.dispatch,
                                ),
                              );
                            },
                            child: Icon(
                              Icons.arrow_circle_right,
                              color: Colors.orange[800],
                              size: Base.height,
                            ),
                          )),
                        ),
                      ],
                    ),
                  ),
                if (!context.isCDD)
                  const SizedBox(
                    height: spacer4,
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: spacer2, right: spacer2),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 0.94 * MediaQuery.of(context).size.width,
                          child: MenuCard(
                            heading: localizations.translate(
                                i18.manageStock.recordStockReturnedLabel),
                            description: insertNewlines(localizations.translate(
                              i18.manageStock.recordStockReturnedDescription,
                            )),
                            icon: Icons.settings_backup_restore,
                            onTap: () => context.router.push(
                              CustomRecordStockWrapperRoute(
                                type: StockRecordEntryType.returned,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 16,
                        child: Center(
                            child: GestureDetector(
                          onTap: () {
                            context.router.push(
                              CustomRecordStockWrapperRoute(
                                type: StockRecordEntryType.returned,
                              ),
                            );
                          },
                          child: Icon(
                            Icons.arrow_circle_right,
                            color: Colors.orange[800],
                            size: Base.height,
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: spacer4,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: spacer2, right: spacer2),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 0.94 * MediaQuery.of(context).size.width,
                          child: MenuCard(
                            heading: localizations.translate(
                                i18.manageStock.recordStockDamagedLabel),
                            description: insertNewlines(localizations.translate(
                              i18.manageStock.recordStockDamagedDescription,
                            )),
                            icon: Icons.store,
                            onTap: () => context.router.push(
                              CustomRecordStockWrapperRoute(
                                type: StockRecordEntryType.damaged,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 16,
                        child: Center(
                            child: GestureDetector(
                          onTap: () {
                            context.router.push(
                              CustomRecordStockWrapperRoute(
                                type: StockRecordEntryType.damaged,
                              ),
                            );
                          },
                          child: Icon(
                            Icons.arrow_circle_right,
                            color: Colors.orange[800],
                            size: Base.height,
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: spacer4,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: spacer2, right: spacer2),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 0.94 * MediaQuery.of(context).size.width,
                          child: MenuCard(
                            heading: localizations.translate(
                                i18.manageStock.recordStockLossLabel),
                            description: insertNewlines(localizations.translate(
                              i18.manageStock.recordStockDamagedDescription,
                            )),
                            icon: Icons.store,
                            onTap: () => context.router.push(
                              CustomRecordStockWrapperRoute(
                                type: StockRecordEntryType.loss,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 16,
                        child: Center(
                            child: GestureDetector(
                          onTap: () {
                            context.router.push(
                              CustomRecordStockWrapperRoute(
                                type: StockRecordEntryType.loss,
                              ),
                            );
                          },
                          child: Icon(
                            Icons.arrow_circle_right,
                            color: Colors.orange[800],
                            size: Base.height,
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: spacer4),
            ],
          ),
        ],
      ),
    );
  }

  String insertNewlines(String text) {
    int charLimit = 0.94 * MediaQuery.of(context).size.width ~/ 8;
    // 8 is the average character width

    final words = text.split(' ');
    final buffer = StringBuffer();

    int currentLineLength = 0;

    for (var word in words) {
      // +1 for the space that follows the word
      if (currentLineLength + word.length + 1 > charLimit) {
        buffer.write('\n');
        currentLineLength = 0;
      } else if (buffer.isNotEmpty) {
        buffer.write(' ');
        currentLineLength += 1;
      }

      buffer.write(word);
      currentLineLength += word.length;
    }

    return buffer.toString();
  }
}
