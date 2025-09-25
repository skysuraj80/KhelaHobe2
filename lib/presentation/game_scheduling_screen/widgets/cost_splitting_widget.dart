import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';
import '../../../localization/app_localizations.dart';

class CostSplittingWidget extends StatefulWidget {
  final double venueCost;
  final String splitMethod;
  final ValueChanged<double> onCostChanged;
  final ValueChanged<String> onSplitMethodChanged;

  const CostSplittingWidget({
    Key? key,
    required this.venueCost,
    required this.splitMethod,
    required this.onCostChanged,
    required this.onSplitMethodChanged,
  }) : super(key: key);

  @override
  State<CostSplittingWidget> createState() => _CostSplittingWidgetState();
}

class _CostSplittingWidgetState extends State<CostSplittingWidget> {
  final TextEditingController _costController = TextEditingController();
  final List<Map<String, dynamic>> splitMethods = [
    {
      "method": AppLocalizations.equalSplit,
      "icon": "balance",
      "description": AppLocalizations.splitCostEqually
    },
    {
      "method": AppLocalizations.hostPays,
      "icon": "person",
      "description": AppLocalizations.gameOrganizerCoversCost
    },
    {
      "method": AppLocalizations.guestPays,
      "icon": "person_outline",
      "description": AppLocalizations.invitedPlayerCoversCost
    },
  ];

  @override
  void initState() {
    super.initState();
    _costController.text =
        widget.venueCost > 0 ? widget.venueCost.toStringAsFixed(2) : "";
  }

  @override
  void dispose() {
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha((255 * 0.2).round()),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'attach_money',
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                AppLocalizations.costSharing,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildCostInput(),
          if (widget.venueCost > 0) ...[
            SizedBox(height: 2.h),
            _buildSplitMethodSelector(),
            SizedBox(height: 2.h),
            _buildCostBreakdown(),
          ],
        ],
      ),
    );
  }

  Widget _buildCostInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.venueCostOptional,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _costController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: AppLocalizations.enterVenueCost,
            prefixText: "$ ",
            prefixStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            suffixIcon: _costController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _costController.clear();
                      widget.onCostChanged(0);
                    },
                    icon: CustomIconWidget(
                      iconName: 'clear',
                      color: Theme.of(context).colorScheme.onSurface
                          .withAlpha((255 * 0.5).round()),
                      size: 20,
                    ),
                  )
                : null,
          ),
          onChanged: (value) {
            final cost = double.tryParse(value) ?? 0;
            widget.onCostChanged(cost);
          },
        ),
      ],
    );
  }

  Widget _buildSplitMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.paymentMethod,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Column(
          children: splitMethods.map((method) {
            final isSelected = widget.splitMethod == method["method"];
            return Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: GestureDetector(
                onTap: () => widget.onSplitMethodChanged(method["method"]),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                            .withAlpha((255 * 0.1).round())
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(2.w),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline
                              .withAlpha((255 * 0.3).round()),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline
                                  .withAlpha((255 * 0.2).round()),
                          borderRadius: BorderRadius.circular(1.w),
                        ),
                        child: CustomIconWidget(
                          iconName: method["icon"],
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface
                                  .withAlpha((255 * 0.7).round()),
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method["method"],
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              method["description"],
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface
                                    .withAlpha((255 * 0.7).round()),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCostBreakdown() {
    final costPerPlayer = widget.splitMethod == AppLocalizations.equalSplit
        ? widget.venueCost / 2
        : widget.venueCost;
    final yourCost = widget.splitMethod == AppLocalizations.hostPays
        ? widget.venueCost
        : widget.splitMethod == AppLocalizations.guestPays
            ? 0
            : costPerPlayer;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withAlpha((255 * 0.1).round()),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withAlpha((255 * 0.3).round()),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'receipt',
                color: Theme.of(context).colorScheme.secondary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                AppLocalizations.costBreakdown,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          _buildCostRow(
              AppLocalizations.totalVenueCost, "\$${widget.venueCost.toStringAsFixed(2)}"),
          _buildCostRow(AppLocalizations.yourShare, "\$${yourCost.toStringAsFixed(2)}"),
          if (widget.splitMethod == AppLocalizations.equalSplit)
            _buildCostRow(
                AppLocalizations.partnersShare, "\$${costPerPlayer.toStringAsFixed(2)}"),
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, String amount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface
                  .withAlpha((255 * 0.7).round()),
            ),
          ),
          Text(
            amount,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}