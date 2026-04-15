import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_leaf/models/plant_map_model.dart';
import 'package:geo_leaf/screen/map_screen.dart';
import 'package:geo_leaf/utils/http_request.dart';
import 'package:geo_leaf/widgets/logo_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  List<PlantMap>? plants;
  Uint8List? image;

  @override
  void initState() {
    super.initState();
    _getPlants();
    _controller = AnimationController(vsync: this);

    //plants = await getPlants();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Builder(
          builder: (context) => Column(
            children: [
              SizedBox(height: 64),
/*
              Expanded(
                child: PlantList(plants: plants, reload: () => _getPlants()),
              ),
 */
            ],
          ),
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _getPlants();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
        title: LogoWidget(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 40,
              icon: Icon(Icons.map),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MapScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _getPlants() async {
    final result = await getPlantsByLocation("predio");
    setState(() {
      plants = result;
    });
  }
}
