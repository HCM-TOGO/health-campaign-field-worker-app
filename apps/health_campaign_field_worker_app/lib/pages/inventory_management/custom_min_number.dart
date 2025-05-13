import 'package:auto_route/auto_route.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:digit_ui_components/widgets/molecules/digit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_campaign_field_worker_app/data/repositories/local/inventory_management/custom_stock.dart';
import 'package:health_campaign_field_worker_app/widgets/action_card/min_number_card.dart';
import 'package:inventory_management/models/entities/stock.dart';

import 'package:inventory_management/utils/i18_key_constants.dart' as i18;
import 'package:inventory_management/widgets/localized.dart';
import 'package:inventory_management/widgets/back_navigation_help_header.dart';

import '../../router/app_router.dart';
import 'package:logger/logger.dart';

@RoutePage()
class CustomMinNumberPage extends LocalizedStatefulWidget {
  const CustomMinNumberPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<CustomMinNumberPage> createState() => CustomMinNumberPageState();
}

class CustomMinNumberPageState extends LocalizedState<CustomMinNumberPage> {
  @override
  void initState() {
    super.initState();
    loadLocalStockData();
  }

  List<StockModel> stockList = [];

  Future<void> loadLocalStockData() async {
    final repository =
        context.read<LocalRepository<StockModel, StockSearchModel>>()
            as CustomStockLocalRepository;

    final result = await repository.search(StockSearchModel());

    setState(() {
      stockList = result;
    });

    Logger().i("Stock List: $stockList");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    return Scaffold(
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ScrollableContent(
            header: const Column(children: [
              BackNavigationHelpHeaderWidget(
                showHelp: true,
              ),
            ]),
            footer: SizedBox(
              child: DigitCard(
                  margin: const EdgeInsets.fromLTRB(0, spacer2, 0, 0),
                  children: [
                    DigitButton(
                        type: DigitButtonType.primary,
                        mainAxisSize: MainAxisSize.max,
                        size: DigitButtonSize.large,
                        label: localizations.translate(
                          i18.householdDetails.actionLabel,
                        ),
                        onPressed: () {}),
                  ]),
            ),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(spacer2),
                ),
                margin: const EdgeInsets.all(spacer2),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16.0),
                      Text(
                        "Select the MRN number",
                        style: textTheme.headingL,
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: ListView.builder(
                          itemCount: stockList.length,
                          itemBuilder: (context, index) {
                            final item = stockList[index];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MinNumberCard(
                                data: {
                                  'minNumber':
                                      '${item.additionalFields?.fields.firstWhere((field) => field.key == 'materialNoteNumber', orElse: () => AdditionalField('materialNoteNumber', '')).value?.toString() ?? 'N/A'}',
                                  'cddCode': item.boundaryCode,
                                  'date': item.dateOfEntry,
                                  'items': item,
                                  'waybillNumber': item.wayBillNumber,
                                },
                                minNumber:
                                    '${item.additionalFields?.fields.firstWhere((field) => field.key == 'materialNoteNumber', orElse: () => AdditionalField('materialNoteNumber', '')).value?.toString() ?? 'N/A'}',
                                cddCode: item.boundaryCode ?? "",
                                date: "${item.dateOfEntry}",
                                items: [
                                  {
                                    'name':
                                        '${item.additionalFields?.fields.firstWhere((field) => field.key == 'productName', orElse: () => AdditionalField('productName', '')).value?.toString() ?? 'N/A'}',
                                    'quantity': '${item.quantity}'
                                  },
                                ],
                                waybillNumber: item.wayBillNumber ?? "",
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
