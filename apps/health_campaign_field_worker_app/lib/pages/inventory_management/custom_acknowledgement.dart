import 'package:auto_route/auto_route.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/widgets/molecules/panel_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/blocs/record_stock.dart';
import 'package:inventory_management/models/entities/stock.dart';
import 'package:registration_delivery/registration_delivery.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';
import 'package:registration_delivery/utils/i18_key_constants.dart' as i18;
import 'package:registration_delivery/widgets/localized.dart';
import '../../../utils/app_enums.dart';
import '../../router/app_router.dart';
import '../../utils/i18_key_constants.dart' as i18_local;

@RoutePage()
class CustomAcknowledgementPage extends LocalizedStatefulWidget {
  final String mrnNumber;
  final List<StockModel> stockRecords;

  const CustomAcknowledgementPage({
    super.key,
    super.appLocalizations,
    required this.mrnNumber,
    required this.stockRecords,
  });

  @override
  State<CustomAcknowledgementPage> createState() =>
      CustomAcknowledgementPageState();
}

class CustomAcknowledgementPageState
    extends LocalizedState<CustomAcknowledgementPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(spacer2),
          child: PanelCard(
            type: PanelType.success,
            description: localizations.translate(
              i18_local.acknowledgementSuccess
                  .transactionAcknowledgementDescriptionText,
              // variables: {'mrnNumber': widget.mrnNumber},
            ),
            title: localizations.translate(
              i18_local.acknowledgementSuccess
                  .transactionAcknowledgementDescriptionText,
            ),
            actions: [
              DigitButton(
                label: localizations.translate(
                  i18_local.acknowledgementSuccess.viewtransactions,
                ),
                onPressed: () {
                  context.router.push(
                    ViewStockRecordsRoute(
                      mrnNumber: widget.mrnNumber,
                      stockRecords: widget.stockRecords,
                    ),
                  );
                },
                type: DigitButtonType.primary,
                size: DigitButtonSize.large,
              ),
              DigitButton(
                label: localizations.translate(
                  i18_local.acknowledgementSuccess.createNewTransactions,
                ),
                onPressed: () {
                  // context
                  //     .read<RecordStockBloc>()
                  //     .add(const RecordStockEvent.reset());
                  context.router.popUntilRoot();
                },
                type: DigitButtonType.secondary,
                size: DigitButtonSize.large,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
