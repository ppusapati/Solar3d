import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/providers/service_providers.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/metric_card.dart';

class FinancialScreen extends ConsumerStatefulWidget {
  final String projectId;

  const FinancialScreen({super.key, required this.projectId});

  @override
  ConsumerState<FinancialScreen> createState() => _FinancialScreenState();
}

class _FinancialScreenState extends ConsumerState<FinancialScreen> {
  bool _isLoading = true;
  String? _error;

  // Financial parameters (editable)
  double _systemCostPerWatt = 1.20;
  double _electricityRate = 0.12; // $/kWh
  double _annualDegradation = 0.5; // %
  double _discountRate = 5.0; // %
  double _inflationRate = 2.5; // %
  int _projectLifeYears = 25;

  // Computed from simulation
  double _systemCapacityKw = 0;
  double _annualEnergyKwh = 0;

  @override
  void initState() {
    super.initState();
    _loadProjectData();
  }

  Future<void> _loadProjectData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final projectService = ref.read(projectServiceProvider);
      final project = await projectService.getProject(widget.projectId);
      setState(() {
        _systemCapacityKw = project.capacityKw ?? 100.0;
        _annualEnergyKwh = _systemCapacityKw * 1500; // Estimate ~1500 kWh/kWp
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // Financial calculations
  double get _totalSystemCost => _systemCapacityKw * 1000 * _systemCostPerWatt;
  double get _annualRevenue => _annualEnergyKwh * _electricityRate;
  double get _simplePayback =>
      _annualRevenue > 0 ? _totalSystemCost / _annualRevenue : 0;

  double get _lcoe {
    if (_annualEnergyKwh <= 0) return 0;
    double totalDiscountedEnergy = 0;
    double totalDiscountedCost = _totalSystemCost;
    for (int year = 1; year <= _projectLifeYears; year++) {
      final degradationFactor =
          (1 - _annualDegradation / 100) * (year - 1).toDouble();
      final degradedEnergy =
          _annualEnergyKwh * (1 - degradationFactor / 100);
      final discountFactor = 1 / (1 + _discountRate / 100);
      final discounted =
          degradedEnergy * _pow(discountFactor, year.toDouble());
      totalDiscountedEnergy += discounted;
    }
    return totalDiscountedEnergy > 0
        ? totalDiscountedCost / totalDiscountedEnergy
        : 0;
  }

  double get _npv {
    double npv = -_totalSystemCost;
    for (int year = 1; year <= _projectLifeYears; year++) {
      final degradationFactor = _annualDegradation / 100 * (year - 1);
      final yearRevenue = _annualRevenue * (1 - degradationFactor) *
          _pow(1 + _inflationRate / 100, year.toDouble());
      npv += yearRevenue / _pow(1 + _discountRate / 100, year.toDouble());
    }
    return npv;
  }

  double get _irr {
    // Simplified IRR using Newton's method
    double guess = 0.10;
    for (int i = 0; i < 100; i++) {
      double npvAtGuess = -_totalSystemCost;
      double dnpv = 0;
      for (int year = 1; year <= _projectLifeYears; year++) {
        final degradationFactor = _annualDegradation / 100 * (year - 1);
        final cf = _annualRevenue * (1 - degradationFactor);
        final discount = _pow(1 + guess, year.toDouble());
        npvAtGuess += cf / discount;
        dnpv -= year * cf / (discount * (1 + guess));
      }
      if (dnpv.abs() < 1e-10) break;
      guess -= npvAtGuess / dnpv;
    }
    return guess * 100;
  }

  double _pow(double base, double exp) {
    double result = 1;
    for (int i = 0; i < exp.toInt(); i++) {
      result *= base;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: LoadingWidget(message: 'Loading financial data...'),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Financial Analysis')),
        body: AppErrorWidget(
          message: _error!,
          onRetry: _loadProjectData,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Financial Analysis')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Key Metrics
          Text('Key Metrics', style: AppTextStyles.heading3),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  label: 'LCOE',
                  value: '\$${_lcoe.toStringAsFixed(3)}/kWh',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: MetricCard(
                  label: 'Payback',
                  value: '${_simplePayback.toStringAsFixed(1)} yrs',
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  label: 'NPV',
                  value:
                      '\$${(_npv / 1000).toStringAsFixed(0)}k',
                  color: _npv >= 0 ? AppColors.success : AppColors.error,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: MetricCard(
                  label: 'IRR',
                  value: '${_irr.toStringAsFixed(1)}%',
                  color: _irr > _discountRate
                      ? AppColors.success
                      : AppColors.warning,
                ),
              ),
            ],
          ),

          // System Overview
          const SizedBox(height: 24),
          Text('System Overview', style: AppTextStyles.heading3),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _InfoRow('System Capacity',
                      '${_systemCapacityKw.toStringAsFixed(0)} kW'),
                  _InfoRow('Annual Energy',
                      '${_annualEnergyKwh.toStringAsFixed(0)} kWh'),
                  _InfoRow('Total System Cost',
                      '\$${_totalSystemCost.toStringAsFixed(0)}'),
                  _InfoRow('Annual Revenue',
                      '\$${_annualRevenue.toStringAsFixed(0)}'),
                ],
              ),
            ),
          ),

          // Assumptions
          const SizedBox(height: 24),
          Text('Assumptions', style: AppTextStyles.heading3),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _SliderRow(
                    label: 'Cost per Watt',
                    value: _systemCostPerWatt,
                    min: 0.50,
                    max: 3.00,
                    suffix: '\$/W',
                    onChanged: (v) =>
                        setState(() => _systemCostPerWatt = v),
                  ),
                  _SliderRow(
                    label: 'Electricity Rate',
                    value: _electricityRate,
                    min: 0.05,
                    max: 0.50,
                    suffix: '\$/kWh',
                    onChanged: (v) =>
                        setState(() => _electricityRate = v),
                  ),
                  _SliderRow(
                    label: 'Annual Degradation',
                    value: _annualDegradation,
                    min: 0.0,
                    max: 2.0,
                    suffix: '%',
                    onChanged: (v) =>
                        setState(() => _annualDegradation = v),
                  ),
                  _SliderRow(
                    label: 'Discount Rate',
                    value: _discountRate,
                    min: 1.0,
                    max: 15.0,
                    suffix: '%',
                    onChanged: (v) =>
                        setState(() => _discountRate = v),
                  ),
                  _SliderRow(
                    label: 'Inflation Rate',
                    value: _inflationRate,
                    min: 0.0,
                    max: 10.0,
                    suffix: '%',
                    onChanged: (v) =>
                        setState(() => _inflationRate = v),
                  ),
                  _SliderRow(
                    label: 'Project Life',
                    value: _projectLifeYears.toDouble(),
                    min: 10,
                    max: 40,
                    suffix: 'yrs',
                    divisions: 30,
                    onChanged: (v) =>
                        setState(() => _projectLifeYears = v.round()),
                  ),
                ],
              ),
            ),
          ),

          // Cash Flow Summary
          const SizedBox(height: 24),
          Text('Cash Flow Summary', style: AppTextStyles.heading3),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _InfoRow('Year 1 Revenue',
                      '\$${_annualRevenue.toStringAsFixed(0)}'),
                  _InfoRow(
                      'Year 10 Revenue',
                      '\$${(_annualRevenue * (1 - _annualDegradation / 100 * 9)).toStringAsFixed(0)}'),
                  _InfoRow(
                      'Year 25 Revenue',
                      '\$${(_annualRevenue * (1 - _annualDegradation / 100 * 24)).toStringAsFixed(0)}'),
                  const Divider(),
                  _InfoRow(
                    'Total Lifetime Revenue',
                    '\$${_totalLifetimeRevenue.toStringAsFixed(0)}',
                    valueColor: AppColors.success,
                  ),
                  _InfoRow(
                    'Net Profit',
                    '\$${(_totalLifetimeRevenue - _totalSystemCost).toStringAsFixed(0)}',
                    valueColor: (_totalLifetimeRevenue - _totalSystemCost) >= 0
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  double get _totalLifetimeRevenue {
    double total = 0;
    for (int year = 0; year < _projectLifeYears; year++) {
      total += _annualRevenue * (1 - _annualDegradation / 100 * year);
    }
    return total;
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body),
          Text(
            value,
            style: AppTextStyles.subtitle.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String suffix;
  final int? divisions;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    this.divisions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.bodySmall),
              Text(
                '${value.toStringAsFixed(2)} $suffix',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions ?? ((max - min) * 20).round(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
