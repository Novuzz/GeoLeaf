import 'package:flutter/material.dart';
import 'package:geo_leaf/models/location_model.dart';
import 'package:geo_leaf/models/plant_map_model.dart';
import 'package:geo_leaf/models/plant_model.dart';

class StatisticDrawer extends StatefulWidget {
  final List<Location> locations;
  final Function(Plant)? onClick;

  const StatisticDrawer({
    Key? key,
    required this.locations, this.onClick,
  }) : super(key: key);

  @override
  State<StatisticDrawer> createState() => _StatisticDrawerState();
}

class _StatisticDrawerState extends State<StatisticDrawer> {
  String? selectedPlant;

  int _getTotalPlants() {
    int total = 0;
    for (final location in widget.locations) {
      for (final plantMap in location.plant) {
        total += plantMap.registeredPlants?.length ?? 0;
      }
    }
    return total;
  }

  int _getUniqueParticipants() {
    final authors = <String>{};
    for (final location in widget.locations) {
      for (final plantMap in location.plant) {
        for (final plant in plantMap.registeredPlants ?? []) {
          if (plant.author != null) {
            authors.add(plant.author!.id ?? plant.author!.email);
          }
        }
      }
    }
    return authors.length;
  }

  List<Map<String, dynamic>> _getMostCommonPlants() {
    final plantStats = <String, int>{};
    for (final location in widget.locations) {
      for (final plantMap in location.plant) {
        final count = plantMap.registeredPlants?.length ?? 0;
        plantStats[plantMap.name] = count;
      }
    }
    final sorted = plantStats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted
        .map((e) => {'name': e.key, 'count': e.value})
        .toList();
  }

  List<Map<String, dynamic>> _getLeastCommonPlants() {
    final plantStats = <String, int>{};
    for (final location in widget.locations) {
      for (final plantMap in location.plant) {
        final count = plantMap.registeredPlants?.length ?? 0;
        plantStats[plantMap.name] = count;
      }
    }
    final sorted = plantStats.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    return sorted
        .map((e) => {'name': e.key, 'count': e.value})
        .toList();
  }

  List<Map<String, dynamic>> _getLocationStats() {
    return widget.locations
        .map((location) => {
              'name': location.name,
              'count': location.getTotalPlants(),
            })
        .toList();
  }

  List<Widget> _buildPlantSelectionButtons() {
    final uniquePlants = <Plant>{};
    for (final location in widget.locations) {
      for (final plantMap in location.plant) {
        for(final plant in plantMap.registeredPlants!)
        {
          uniquePlants.add(plant);
        }
      }
    }

    final plants = uniquePlants.toList()..sort();
    final widgets = <Widget>[];

    for (int i = 0; i < plants.length; i++) {
      final plantName = plants[i];
      widgets.add(
        _PlantButton(
          label: plantName.name,
          onPressed: () {
            widget.onClick?.call(plantName);
          },
        ),
      );

      if (i < plants.length - 1) {
        widgets.add(const SizedBox(height: 8));
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Estatísticas',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Statistics cards
              Row(
                children: [
                  Expanded(
                    child: _StatisticCard(
                      title: 'Quantidade de Plantas',
                      value: '${_getTotalPlants()}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatisticCard(
                      title: 'Total de Participantes',
                      value: '${_getUniqueParticipants()}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Plant selection with filter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtrar Plantas',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune, color: Colors.green),
                    onPressed: () {
                      // Filter action
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Plant selection buttons
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    ..._buildPlantSelectionButtons(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Most and least common plants
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plantas mais\ncomuns',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        ..._buildPlantBars(_getMostCommonPlants()),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plantas menos\ncomuns',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        ..._buildPlantBars(_getLeastCommonPlants()),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Locations section
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Locais',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    ..._buildLocationRows(_getLocationStats()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPlantBars(List<Map<String, dynamic>> plants) {
    final maxCount = plants.fold<int>(0, (max, plant) {
      return plant['count'] > max ? plant['count'] : max;
    });

    return plants.map((plant) {
      final percentage = (plant['count'] as int) / maxCount;
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${plant['count']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 20,
                      backgroundColor: Colors.grey[300],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              plant['name'],
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildLocationRows(List<Map<String, dynamic>> locations) {
    return locations.map((location) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                location['name'],
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                '${location['count']}',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class _StatisticCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatisticCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 3),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlantButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PlantButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.green,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
