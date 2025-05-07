import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/utils/app_routes.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/core/utils/user_role.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Builds a sidebar for navigation with expandable menus and hover effects.
///
/// This widget is a sidebar that contains various items such as navigation links.
/// It supports expandable menus and a hover effect on items. When an item is hovered,
/// it changes the background color. The sidebar is typically used in the main layout
/// for navigating between different sections of the app.
Widget buildSidebar(BuildContext context, VoidCallback logoutCallback) {
  final prefs = locator<PreferenceHelper>();
  final role = prefs.getUserRole();
  return Container(
    width: 210,
    color: const Color(0xFF282B2C),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SidebarItem(
          icon: Icons.dashboard,
          title: "Dashboard",
          onTap: () {
            // Navigator.pushNamed(context, '/dashboard');
            context.pushReplacement(AppRoutes.dashboard);
          },
        ),
        role == UserRoles.superAdmin
            ? const _ExpandableMenu(
              icon: Icons.app_registration,
              title: "Registration",
              children: [
                _SidebarItem(
                  title: "Organization",
                  route: '/organization-registration',
                ),
                _SidebarItem(title: "Device", route: '/device-registration'),
                _SidebarItem(title: "Generate QR", route: '/generate-qr'),
              ],
            )
            : Container(),
        const _ExpandableMenu(
          icon: Icons.pie_chart,
          title: "MIS",
          children: [
            _SidebarItem(
              icon: Icons.business,
              title: "Organizations",
              route: '/mis-organizations',
            ),
            _SidebarItem(
              icon: Icons.tablet_mac,
              title: "Device",
              route: '/mis-devices',
            ),
            _SidebarItem(
              icon: Icons.medical_services,
              title: "Doctor",
              route: '/mis-doctors',
            ),
            _SidebarItem(
              icon: Icons.pregnant_woman,
              title: "Mother",
              route: '/mis-mothers',
            ),
          ],
        ),
        const _ExpandableMenu(
          icon: Icons.analytics,
          title: "Analytics",
          children: [
            _SidebarItem(
              icon: Icons.medical_services,
              title: "Doctors",
              route: '/analytics-doctors',
            ),
            _SidebarItem(
              icon: Icons.business,
              title: "Organizations",
              route: '/analytics-organizations',
            ),
          ],
        ),
        const _SidebarItem(icon: Icons.article, title: "Reports"),
        const _SidebarItem(icon: Icons.settings, title: "Operations"),
        role == UserRoles.superAdmin ? const _SidebarItem(icon: Icons.people, title: "Users") : Container(),
        const Spacer(),
      ],
    ),
  );
}

/// A Sidebar item with hover effect.
///
/// This widget represents an individual item in the sidebar. It can be a navigation link
/// or an action, and includes hover effects that change the background color and text color
/// when hovered over.
class _SidebarItem extends StatefulWidget {
  final IconData? icon;
  final String title;
  final String? route;
  final VoidCallback? onTap;

  const _SidebarItem({this.icon, required this.title, this.route, this.onTap});

  @override
  _SidebarItemState createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          if (widget.route != null) {
            context.go(widget.route!);
          } else if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.cyan[700] : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              if (widget.icon != null)
                Icon(
                  widget.icon,
                  size: 18,
                  color: _isHovered ? Colors.white : Colors.grey[600],
                ),
              if (widget.icon != null) const SizedBox(width: 10),
              Text(
                widget.title,
                style: TextStyle(
                  color: _isHovered ? Colors.white : Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// An expandable menu with hover effect.
///
/// This widget represents an expandable menu in the sidebar. When clicked, the menu
/// expands to show additional child items. It supports hover effects on the menu item
/// and expansion toggle with an icon.
class _ExpandableMenu extends StatefulWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const _ExpandableMenu({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  _ExpandableMenuState createState() => _ExpandableMenuState();
}

class _ExpandableMenuState extends State<_ExpandableMenu> {
  bool _isHovered = false;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color:
                    _isExpanded
                        ? Colors.grey[900] // Change to grey[900] when expanded
                        : (_isHovered ? Colors.cyan[700] : Colors.transparent),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    size: 18,
                    color:
                        _isHovered || _isExpanded
                            ? Colors.white
                            : Colors.grey[600],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color:
                            _isHovered || _isExpanded
                                ? Colors.white
                                : Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color:
                        _isHovered || _isExpanded ? Colors.white : Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          color:
              _isExpanded
                  ? Colors.grey[900]
                  : Colors.transparent, // Keep background grey when expanded
          child: Column(children: _isExpanded ? widget.children : []),
        ),
      ],
    );
  }
}
