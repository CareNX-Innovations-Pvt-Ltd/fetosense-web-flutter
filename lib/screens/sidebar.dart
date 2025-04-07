import 'package:flutter/material.dart';

Widget buildSidebar(BuildContext context, VoidCallback logoutCallback) {
  return Container(
    width: 210,
    color: Colors.grey[850],
    // padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 16),
        //   // child: Text(
        //   //   "fetosense",
        //   //   style: TextStyle(
        //   //     color: Colors.tealAccent,
        //   //     fontSize: 20,
        //   //     fontWeight: FontWeight.normal,
        //   //   ),
        //   // ),
        // ),
        // const SizedBox(height: 20),
        _SidebarItem(
          icon: Icons.dashboard,
          title: "Dashboard",
          onTap: () {
            Navigator.pushNamed(context, '/dashboard');
          },
        ),
        _ExpandableMenu(
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
        ),
        _ExpandableMenu(
          icon: Icons.pie_chart,
          title: "MIS",
          children: [
            _SidebarItem(title: "Organizations", route: '/mis-organizations'),
            _SidebarItem(title: "Device", route: '/mis-devices'),
            _SidebarItem(title: "Doctor", route: '/mis-doctors'),
            _SidebarItem(title: "Mother", route: '/mis-mothers'),
          ],
        ),
        _SidebarItem(icon: Icons.analytics, title: "Analytics"),
        _SidebarItem(icon: Icons.article, title: "Reports"),
        _SidebarItem(icon: Icons.settings, title: "Operations"),
        _SidebarItem(icon: Icons.people, title: "Users"),
        const Spacer(),
        // _SidebarItem(
        //   icon: Icons.logout,
        //   title: "Logout",
        //   onTap: logoutCallback,
        // ),
      ],
    ),
  );
}

// Sidebar item with hover effect
class _SidebarItem extends StatefulWidget {
  final IconData? icon;
  final String title;
  final String? route;
  final VoidCallback? onTap;

  const _SidebarItem({
    Key? key,
    this.icon,
    required this.title,
    this.route,
    this.onTap,
  }) : super(key: key);

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
            Navigator.pushNamed(context, widget.route!);
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

// Expandable menu with hover effect
class _ExpandableMenu extends StatefulWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const _ExpandableMenu({
    Key? key,
    required this.icon,
    required this.title,
    required this.children,
  }) : super(key: key);

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
