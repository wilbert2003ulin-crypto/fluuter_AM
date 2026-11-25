import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../sales/presentation/screens/new_contract_screen.dart';
import '../../data/mock_clients_store.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'all'; // 'all', 'due_today', 'overdue'

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    final intPart = amount.truncate().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(intPart[i]);
    }
    return '\$$buffer';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ClientContract>>(
      valueListenable: MockClientsStore.clientsNotifier,
      builder: (context, allClients, _) {
        final query = _searchController.text.toLowerCase().trim();
        final overdueCount = allClients
            .where((c) => c.statusType == 'overdue')
            .length;

        final filteredClients = allClients.where((client) {
          final matchesFilter =
              _selectedFilter == 'all' ||
              (_selectedFilter == 'due_today' &&
                  client.statusType == 'due_today') ||
              (_selectedFilter == 'overdue' && client.statusType == 'overdue');

          final matchesSearch =
              query.isEmpty ||
              client.name.toLowerCase().contains(query) ||
              client.town.toLowerCase().contains(query) ||
              client.colony.toLowerCase().contains(query) ||
              client.routeName.toLowerCase().contains(query);

          return matchesFilter && matchesSearch;
        }).toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          body: SafeArea(
            child: Column(
              children: [
                // 1. Encabezado superior centrado y limpio
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Logo NATURA FLEULIN
                          Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.eco_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'NATURA',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textDark,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    'FLEULIN',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.textMuted,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Título central visible
                          Column(
                            children: [
                              Text(
                                'Clientes',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textDark,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                '${allClients.length} contratos activos',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          // Avatar AR
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F4EE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'AR',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.primaryGreen,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Badge dinámico de contratos pendientes por sincronizar
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3E7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFFDE2C4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.cloud_off_rounded,
                                size: 14,
                                color: Color(0xFFD97706),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${allClients.length} por subir',
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFFB45309),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Buscador y filtros
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Barra de búsqueda
                      TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        style: GoogleFonts.plusJakartaSans(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Buscar nombre, pueblo o ruta...',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            color: AppColors.textMuted.withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: Color(0xFFE5E7EB),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: Color(0xFFE5E7EB),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Chips de filtro: Todos / Pendientes hoy / Atrasados
                      Row(
                        children: [
                          _FilterChip(
                            label: 'Todos',
                            isSelected: _selectedFilter == 'all',
                            onTap: () =>
                                setState(() => _selectedFilter = 'all'),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Pendientes hoy',
                            isSelected: _selectedFilter == 'due_today',
                            onTap: () =>
                                setState(() => _selectedFilter = 'due_today'),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Atrasados',
                            badgeCount: overdueCount,
                            isSelected: _selectedFilter == 'overdue',
                            onTap: () =>
                                setState(() => _selectedFilter = 'overdue'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Subtítulo contador y orden
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${filteredClients.length} CLIENTES',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Más cercanos',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.primaryGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right_rounded,
                                size: 16,
                                color: AppColors.primaryGreen,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                // 3. Lista de tarjetas de clientes o estado vacío
                Expanded(
                  child: Stack(
                    children: [
                      filteredClients.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE6F4EE),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        Icons.person_add_alt_1_rounded,
                                        size: 30,
                                        color: AppColors.primaryGreen,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      allClients.isEmpty
                                          ? 'Aún no hay contratos registrados'
                                          : 'Sin resultados para este filtro',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.textDark,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      allClients.isEmpty
                                          ? 'Presiona "+ Nuevo contrato" para registrar tu primera venta y generar la tarjeta del cliente.'
                                          : 'Intenta buscar por otro nombre, pueblo o cambia el filtro superior.',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.textMuted,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                4,
                                20,
                                120,
                              ),
                              itemCount: filteredClients.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final client = filteredClients[index];
                                return _ClientCard(
                                  client: client,
                                  formattedBalance: _formatCurrency(
                                    client.creditBalance,
                                  ),
                                );
                              },
                            ),

                      // Botón flotante "+ Nuevo contrato" en la esquina inferior derecha
                      Positioned(
                        right: 20,
                        bottom: 24,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NewContractScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_rounded, size: 22),
                          label: Text(
                            'Nuevo contrato',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                            elevation: 6,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Botón central "+"
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: SizedBox(
            width: 58,
            height: 58,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewContractScreen(),
                  ),
                );
              },
              backgroundColor: AppColors.primaryGreen,
              elevation: 4,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),

          // Barra inferior con "Clientes" activo
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            elevation: 12,
            height: 68,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  child: const _NavItem(
                    icon: Icons.home_outlined,
                    label: 'Inicio',
                    isActive: false,
                  ),
                ),
                const _NavItem(
                  icon: Icons.people_alt_rounded,
                  label: 'Clientes',
                  isActive: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28),
                  child: Text(
                    'Venta',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primaryGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const _NavItem(
                  icon: Icons.alt_route_rounded,
                  label: 'Ruta',
                  isActive: false,
                ),
                const _NavItem(
                  icon: Icons.menu_rounded,
                  label: 'Más',
                  isActive: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int? badgeCount;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    this.badgeCount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryGreen
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: isSelected ? Colors.white : AppColors.textDark,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (badgeCount != null && badgeCount! > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : const Color(0xFFEA580C),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badgeCount',
                  style: GoogleFonts.plusJakartaSans(
                    color: isSelected ? AppColors.primaryGreen : Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ClientCard extends StatelessWidget {
  final ClientContract client;
  final String formattedBalance;

  const _ClientCard({required this.client, required this.formattedBalance});

  @override
  Widget build(BuildContext context) {
    Color badgeBg;
    Color badgeText;

    if (client.statusType == 'overdue') {
      badgeBg = const Color(0xFFFEE2E2);
      badgeText = const Color(0xFFB91C1C);
    } else if (client.statusType == 'due_today') {
      badgeBg = const Color(0xFFFEF3C7);
      badgeText = const Color(0xFFB45309);
    } else {
      badgeBg = const Color(0xFFDCFCE7);
      badgeText = const Color(0xFF15803D);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar con iniciales
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: client.avatarBg,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              client.initials,
              style: GoogleFonts.plusJakartaSans(
                color: client.avatarText,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Nombre, localidad/ruta y etiqueta de estado
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client.name,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.map_outlined,
                      size: 13,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${client.colony.isNotEmpty ? "${client.colony}, " : ""}${client.town} · ${client.routeName}',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    client.statusLabel,
                    style: GoogleFonts.plusJakartaSans(
                      color: badgeText,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Saldo y flecha
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'SALDO',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textMuted,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                formattedBalance,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primaryGreen : AppColors.textMuted;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: color,
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
