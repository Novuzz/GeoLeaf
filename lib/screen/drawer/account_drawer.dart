import 'package:flutter/material.dart';
import 'package:geo_leaf/models/plant_model.dart';
import 'package:geo_leaf/provider/login_provider.dart';
import 'package:geo_leaf/screen/settings_screen.dart';
import 'package:geo_leaf/utils/http_request.dart';
import 'package:geo_leaf/widgets/plant_box.dart';
import 'package:provider/provider.dart';

class AccountDrawer extends StatefulWidget {
  const AccountDrawer({super.key});

  @override
  State<AccountDrawer> createState() => _AccountDrawerState();
}

class _AccountDrawerState extends State<AccountDrawer> {
  List<Plant>? plant;
  @override
  Widget build(BuildContext context) {
    var logPr = Provider.of<LoginProvider>(context);
    _getPlants(logPr);
    return PlantBox(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentGeometry.topEnd,
                    child: IconButton(
                      onPressed: () {
                         Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingsScreen()),
                );
                      },
                      icon: Icon(Icons.settings),
                    ),
                  ),
                  Align(
                    alignment: AlignmentGeometry.topCenter,
                    child: Column(
                      children: [
                        Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.primary,
                          size: 64,
                        ),
                        Text(
                          logPr.logged!.username,
                          style: TextStyle(fontSize: 32),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getPlants(LoginProvider log) async {
    final result = await getUserPosts(log.logged!.id);
    setState(() {
      plant = result;
    });
  }
}
