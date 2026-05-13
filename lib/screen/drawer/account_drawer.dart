import 'package:flutter/material.dart';
import 'package:geo_leaf/models/plant_model.dart';
import 'package:geo_leaf/provider/login_provider.dart';
import 'package:geo_leaf/screen/settings_screen.dart';
import 'package:geo_leaf/utils/http_request.dart';
import 'package:geo_leaf/widgets/plant_box.dart';
import 'package:geo_leaf/widgets/plants/plant_list.dart';
import 'package:provider/provider.dart';

class AccountDrawer extends StatefulWidget {
  final Function(Plant)? onTap;

  const AccountDrawer({super.key, this.onTap});
  @override
  State<AccountDrawer> createState() => _AccountDrawerState();

}

class _AccountDrawerState extends State<AccountDrawer> {
  List<Plant>? plant;
  String name = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final logPr = Provider.of<LoginProvider>(context, listen: false);
      name = logPr.logged!.username;
      _getPlants(logPr);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        Text(name, style: TextStyle(fontSize: 32)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PlantList(
                plants: plant,
                element: (build, index) {
                  return GestureDetector(
                    onTap: () {
                      widget.onTap?.call(plant![index]);
                    },
                    child: PlantBox(height: 64, child: Text(plant![index].name)));
                },
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
