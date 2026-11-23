import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../sales/presentation/screens/new_contract_screen.dart';
import '../widgets/home_top_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeTopSection(),
              const SizedBox(height: 24),

              // Encabezado de la sección de Ruta
              Text(
                'SIGUIENTE PARADA',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.primaryGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ruta optimizada del día',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.map_outlined,
                        size: 16,
                        color: AppColors.primaryGreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Ver mapa',
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
              const SizedBox(height: 16),

              // Espacio en blanco reservado para los clientes/pedidos futuros
              Container(
                width: double.infinity,
                height: 240,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.route_outlined,
                      size: 36,
                      color: AppColors.textMuted.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sin clientes asignados aún',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Botón central flotante "+ Venta" conectado
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
        ),
      ),

      // Barra de navegación inferior
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 12,
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const _NavItem(
              icon: Icons.home_outlined,
              label: 'Inicio',
              isActive: true,
            ),
            const _NavItem(
              icon: Icons.people_outline_rounded,
              label: 'Clientes',
              isActive: false,
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
