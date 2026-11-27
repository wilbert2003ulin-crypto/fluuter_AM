import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../clients/data/contracts_firestore_service.dart';
import '../../../clients/data/mock_clients_store.dart';
import '../../../clients/presentation/screens/clients_screen.dart';
import '../widgets/signature_pad_card.dart';

class NewContractScreen extends StatefulWidget {
  const NewContractScreen({super.key});

  @override
  State<NewContractScreen> createState() => _NewContractScreenState();
}

class _NewContractScreenState extends State<NewContractScreen> {
  // Controladores Paso 1
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _colonyController = TextEditingController();
  final _referenceController = TextEditingController();

  // Catálogo de pueblos/municipios con su ruta y días de cobro
  final Map<String, Map<String, String>> _townRoutes = {
    'Umán': {'ruta': 'Ruta 1', 'dias': 'Lunes y Sábado'},
    'Kanasín': {'ruta': 'Ruta 2', 'dias': 'Martes y Viernes'},
    'Caucel': {'ruta': 'Ruta 3', 'dias': 'Miércoles y Sábado'},
    'Hunucmá': {'ruta': 'Ruta 4', 'dias': 'Jueves y Domingo'},
    'Conkal': {'ruta': 'Ruta 5', 'dias': 'Lunes y Jueves'},
    'Otro pueblo / municipio': {
      'ruta': 'Ruta por asignar',
      'dias': 'Por definir',
    },
  };
  String _selectedTown = 'Umán';

  // Controladores y estado Paso 2 (Producto y pagos)
  final _products = [
    {
      'name': 'Crema Alivio Muscular',
      'detail': '250 g · Fórmula natural',
      'price': 720.0,
    },
    {
      'name': 'Gel Térmico Relajante',
      'detail': '300 g · Uso diario',
      'price': 580.0,
    },
    {
      'name': 'Kit Bienestar Integral',
      'detail': '3 piezas · Línea herbal',
      'price': 1150.0,
    },
  ];
  int _selectedProductIndex = 0;
  int _quantity = 1;
  bool _isWeekly = true; // true = Semanal (7 días), false = Quincenal (15 días)
  int _installmentsCount = 8;
  final _downPaymentController = TextEditingController(text: '144');
  bool _customDownPayment = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _colonyController.dispose();
    _referenceController.dispose();
    _downPaymentController.dispose();
    super.dispose();
  }

  void _updateSuggestedDownPayment(double total) {
    if (!_customDownPayment) {
      final suggested = (total * 0.20).round();
      _downPaymentController.text = suggested.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentProduct = _products[_selectedProductIndex];
    final double unitPrice = currentProduct['price'] as double;
    final String productDetail = currentProduct['detail'] as String;
    final double totalSale = unitPrice * _quantity;
    final double downPayment =
        double.tryParse(_downPaymentController.text) ?? 0.0;
    final double creditBalance = (totalSale - downPayment).clamp(
      0.0,
      double.infinity,
    );
    final double installmentAmount = _installmentsCount > 0
        ? creditBalance / _installmentsCount
        : 0.0;

    final routeInfo = _townRoutes[_selectedTown]!;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Encabezado centrado y limpio
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.chevron_left_rounded,
                            color: AppColors.textDark,
                            size: 24,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'Nuevo contrato',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textDark,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Venta a crédito · Entrega inmediata',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancelar',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.primaryGreen,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Badge "Cloud Firestore"
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F4EE),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primaryGreen.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cloud_done_outlined,
                            size: 13,
                            color: AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Cloud Firestore',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.primaryGreen,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Stepper visual de 3 pasos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const _StepDot(
                        number: '1',
                        label: 'Cliente',
                        isActive: true,
                      ),
                      Container(
                        width: 48,
                        height: 2,
                        margin: const EdgeInsets.only(bottom: 16),
                        color: AppColors.primaryGreen,
                      ),
                      const _StepDot(
                        number: '2',
                        label: 'Venta',
                        isActive: true,
                      ),
                      Container(
                        width: 48,
                        height: 2,
                        margin: const EdgeInsets.only(bottom: 16),
                        color: const Color(0xFFE5E7EB),
                      ),
                      const _StepDot(
                        number: '3',
                        label: 'Firma',
                        isActive: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Cuerpo desplazable con las 3 tarjetas
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // --- PASO 1: DATOS DEL CLIENTE ---
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFF3F4F6)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6F4EE),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.person_outline_rounded,
                                  color: AppColors.primaryGreen,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PASO 1',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.primaryGreen,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  Text(
                                    'Datos del cliente',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textDark,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // Nombre completo
                          const _FieldLabel('Nombre completo'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _nameController,
                            textCapitalization: TextCapitalization.words,
                            style: GoogleFonts.plusJakartaSans(fontSize: 14),
                            decoration: _inputDecoration(
                              'Ej. Juan Pérez Hernández',
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Pueblo / Municipio (Asigna ruta automáticamente)
                          const _FieldLabel('Pueblo / Municipio'),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedTown,
                            decoration:
                                _inputDecoration(
                                  'Selecciona pueblo o municipio',
                                ).copyWith(
                                  prefixIcon: const Icon(
                                    Icons.location_city_rounded,
                                    color: AppColors.primaryGreen,
                                    size: 19,
                                  ),
                                ),
                            items: _townRoutes.keys.map((town) {
                              return DropdownMenuItem<String>(
                                value: town,
                                child: Text(
                                  town,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedTown = value;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 10),

                          // Tarjeta informativa de Ruta y Días asignados automáticamente
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F4EE),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.primaryGreen.withValues(
                                  alpha: 0.25,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.alt_route_rounded,
                                  color: AppColors.primaryGreen,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Asignación automática: ${routeInfo['ruta']}',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.primaryGreen,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        'Días de cobro: ${routeInfo['dias']}',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.textDark,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Teléfono y Colonia / Comisaría
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const _FieldLabel('Teléfono'),
                                    const SizedBox(height: 6),
                                    TextField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                      ),
                                      decoration: _inputDecoration('10 dígitos')
                                          .copyWith(
                                            prefixIcon: const Icon(
                                              Icons.phone_outlined,
                                              color: AppColors.textMuted,
                                              size: 18,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const _FieldLabel('Colonia / Comisaría'),
                                    const SizedBox(height: 6),
                                    TextField(
                                      controller: _colonyController,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                      ),
                                      decoration: _inputDecoration(
                                        'Ej. Centro',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Referencia del domicilio
                          const _FieldLabel('Referencia del domicilio'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _referenceController,
                            style: GoogleFonts.plusJakartaSans(fontSize: 14),
                            decoration:
                                _inputDecoration('Color de casa, frente a...')
                                    .copyWith(
                                      prefixIcon: const Icon(
                                        Icons.map_outlined,
                                        color: AppColors.textMuted,
                                        size: 18,
                                      ),
                                    ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // --- PASO 2: PRODUCTO Y PAGOS ---
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFF3F4F6)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6F4EE),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.description_outlined,
                                  color: AppColors.primaryGreen,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PASO 2',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.primaryGreen,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  Text(
                                    'Producto y pagos',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textDark,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Tarjeta del producto seleccionado
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAFAFA),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 54,
                                      height: 54,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE6F4EE),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: const Icon(
                                        Icons.spa_rounded,
                                        color: AppColors.primaryGreen,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'PRODUCTO NATURA FLEULIN',
                                            style: GoogleFonts.plusJakartaSans(
                                              color: AppColors.primaryGreen,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                          DropdownButton<int>(
                                            value: _selectedProductIndex,
                                            isExpanded: true,
                                            underline: const SizedBox(),
                                            isDense: true,
                                            style: GoogleFonts.plusJakartaSans(
                                              color: AppColors.textDark,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            items: List.generate(
                                              _products.length,
                                              (i) {
                                                final itemName =
                                                    _products[i]['name']
                                                        as String;
                                                return DropdownMenuItem<int>(
                                                  value: i,
                                                  child: Text(itemName),
                                                );
                                              },
                                            ),
                                            onChanged: (val) {
                                              if (val != null) {
                                                setState(() {
                                                  _selectedProductIndex = val;
                                                  final newTotal =
                                                      (_products[val]['price']
                                                          as double) *
                                                      _quantity;
                                                  _updateSuggestedDownPayment(
                                                    newTotal,
                                                  );
                                                });
                                              }
                                            },
                                          ),
                                          Text(
                                            productDetail,
                                            style: GoogleFonts.plusJakartaSans(
                                              color: AppColors.textMuted,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${unitPrice.toStringAsFixed(0)} c/u',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.textDark,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    // Controles de cantidad (- 1 +)
                                    Row(
                                      children: [
                                        _QtyButton(
                                          icon: Icons.remove_rounded,
                                          onTap: () {
                                            if (_quantity > 1) {
                                              setState(() {
                                                _quantity--;
                                                _updateSuggestedDownPayment(
                                                  unitPrice * _quantity,
                                                );
                                              });
                                            }
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                          ),
                                          child: Text(
                                            '$_quantity',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                        ),
                                        _QtyButton(
                                          icon: Icons.add_rounded,
                                          onTap: () {
                                            setState(() {
                                              _quantity++;
                                              _updateSuggestedDownPayment(
                                                unitPrice * _quantity,
                                              );
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Frecuencia de pago
                          const _FieldLabel('Frecuencia de pago'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _FrequencyCard(
                                  subtitle: 'Cada 7 días',
                                  title: 'Semanal',
                                  isSelected: _isWeekly,
                                  onTap: () => setState(() => _isWeekly = true),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _FrequencyCard(
                                  subtitle: 'Cada 15 días',
                                  title: 'Quincenal',
                                  isSelected: !_isWeekly,
                                  onTap: () =>
                                      setState(() => _isWeekly = false),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Número de pagos (Plazo)
                          const _FieldLabel('Número de pagos'),
                          const SizedBox(height: 8),
                          Row(
                            children: [4, 6, 8, 12].map((count) {
                              final selected = _installmentsCount == count;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(
                                    () => _installmentsCount = count,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: count == 12 ? 0 : 8,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? const Color(0xFFE6F4EE)
                                          : const Color(0xFFF9FAFB),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: selected
                                            ? AppColors.primaryGreen
                                            : const Color(0xFFE5E7EB),
                                        width: selected ? 1.5 : 1,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '$count pagos',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: selected
                                            ? AppColors.primaryGreen
                                            : AppColors.textDark,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),

                          // Resumen financiero y enganche editable
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total de venta',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.textMuted,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      '\$${totalSale.toStringAsFixed(0)}',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.textDark,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Enganche recibido (\$)',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.textMuted,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 96,
                                      height: 36,
                                      child: TextField(
                                        controller: _downPaymentController,
                                        textAlign: TextAlign.right,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        onChanged: (_) {
                                          setState(() {
                                            _customDownPayment = true;
                                          });
                                        },
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.textDark,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        decoration: InputDecoration(
                                          prefixText: '\$ ',
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 6,
                                              ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFD1D5DB),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Divider(height: 1),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Saldo a crédito',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.textDark,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      '\$${creditBalance.toStringAsFixed(0)}',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.primaryGreen,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 14,
                                      color: AppColors.primaryGreen,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '$_installmentsCount pagos ${_isWeekly ? "semanales" : "quincenales"} de \$${installmentAmount.toStringAsFixed(0)}',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.primaryGreen,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // --- PASO 3: FIRMA DEL CLIENTE ---
                    const SignaturePadCard(),
                    const SizedBox(height: 24),

                    // Botón final Guardar contrato en Firestore
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _isSaving
                            ? null
                            : () async {
                                final clientName = _nameController.text.trim();
                                if (clientName.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Por favor ingresa el nombre completo del cliente.',
                                      ),
                                      backgroundColor: Color(0xFFB91C1C),
                                    ),
                                  );
                                  return;
                                }

                                setState(() => _isSaving = true);

                                final now = DateTime.now();
                                final nextPayment = now.add(
                                  Duration(days: _isWeekly ? 7 : 15),
                                );

                                final newContract = ClientContract(
                                  name: clientName,
                                  town: _selectedTown,
                                  colony: _colonyController.text.trim(),
                                  reference: _referenceController.text.trim(),
                                  routeName: routeInfo['ruta']!,
                                  collectionDays: routeInfo['dias']!,
                                  phone: _phoneController.text.trim(),
                                  productName: currentProduct['name'] as String,
                                  quantity: _quantity,
                                  totalSale: totalSale,
                                  downPayment: downPayment,
                                  creditBalance: creditBalance,
                                  installmentsCount: _installmentsCount,
                                  installmentAmount: installmentAmount,
                                  isWeekly: _isWeekly,
                                  createdAt: now,
                                  nextPaymentDate: nextPayment,
                                  avatarBg: const Color(0xFFE6F4EE),
                                  avatarText: AppColors.primaryGreen,
                                );

                                try {
                                  await ContractsFirestoreService.createContract(
                                    newContract,
                                  );

                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Contrato guardado en Firestore: $clientName (${routeInfo['ruta']})',
                                      ),
                                      backgroundColor: AppColors.primaryGreen,
                                    ),
                                  );

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ClientsScreen(),
                                    ),
                                    (route) => false,
                                  );
                                } catch (e) {
                                  if (!context.mounted) return;
                                  setState(() => _isSaving = false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Error al guardar en Firestore: $e',
                                      ),
                                      backgroundColor: const Color(0xFFB91C1C),
                                    ),
                                  );
                                }
                              },
                        icon: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.2,
                                ),
                              )
                            : const Icon(Icons.cloud_upload_rounded, size: 20),
                        label: Text(
                          _isSaving
                              ? 'Guardando contrato...'
                              : 'Guardar contrato',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(
        color: AppColors.textMuted.withValues(alpha: 0.6),
        fontSize: 13,
      ),
      filled: true,
      fillColor: AppColors.inputFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.plusJakartaSans(
        color: AppColors.textDark,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final String number;
  final String label;
  final bool isActive;

  const _StepDot({
    required this.number,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryGreen : const Color(0xFFE5E7EB),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: GoogleFonts.plusJakartaSans(
              color: isActive ? Colors.white : AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: isActive ? AppColors.primaryGreen : AppColors.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFE6F4EE),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: AppColors.primaryGreen),
      ),
    );
  }
}

class _FrequencyCard extends StatelessWidget {
  final String subtitle;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _FrequencyCard({
    required this.subtitle,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF2FBF7) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryGreen
                : const Color(0xFFE5E7EB),
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textDark,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
