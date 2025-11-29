import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MenuDrawer extends StatelessWidget {
  final Color primaryColor;
  final VoidCallback onSettingsTap;

  const MenuDrawer({
    Key? key,
    required this.primaryColor,
    required this.onSettingsTap,
  }) : super(key: key);
  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff2d2438),
        title: const Text(
          'Salir de la aplicación',
          style: TextStyle(
              color: Colors.white,
              fontFamily: "DMSerif",
              fontWeight: FontWeight.bold
          ),
        ),
        content: const Text(
          '¿Está seguro de que quiere salir?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              if (Platform.isAndroid || Platform.isIOS) {
                SystemNavigator.pop();
              } else {
                exit(0);
              }
            },
            child: Text(
              'Salir',
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/unknown.jpg'),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Spooky :)",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "DMSerif",
                  ),
                ),
                const Text(
                  "Menú Principal",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildMenuItem(Icons.home, "Inicio", () {
            Navigator.pop(context);
          }),
          _buildMenuItem(Icons.settings, "Configuración", () {
            Navigator.pop(context);
            onSettingsTap();
          }),
          _buildMenuItem(Icons.info_outline, "Acerca de", () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Acerca de Spooky :)"),
                content: const Text(
                  "Reproductor de audio para la unidad de desarrollo de aplicaciones móviles, por Ángel Martínez y Ares Chávez",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cerrar", style: TextStyle(color: primaryColor)),
                  )
                ],
              ),
            );
          }),

          const Spacer(),
          const Divider(),

          _buildMenuItem(Icons.exit_to_app, "Salir de Spooky :)", () {
            Navigator.pop(context);
            _showExitDialog(context);
          }),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(
            fontFamily: "DMSerif", fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
    );
  }
}