import 'dart:async';
import 'package:flutter/material.dart';

// App created by Esther and Phi
void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  double _energyLevel = 1;
  String activity = 'Play';
  
  int points = 0;
  bool lose = false;
  bool win = false;

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
    _startWinConditionTimer();
  }

  void _startHungerTimer() {
    Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
      });
    });
  }
  void _startWinConditionTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (happinessLevel > 80) {
        points += 1;
      } else {
        points = 0;
      }

      if (happinessLevel <= 10 && hungerLevel == 100) {
        setState(() {
          lose = true;
        });
        timer.cancel();
      } 
      if (points == 80) {
        setState(() {
          win = true;
        });
        timer.cancel();
      }
    });
  }
// Function to increase happiness and update hunger when playing withthe pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _energyLevel = (_energyLevel - 0.2).clamp(0, 1);
      _updateHunger();
    });
  }

// Function to decrease hunger and update happiness when feeding thepet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
    });
  }

// Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

// Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  String _getMood() {
    if (happinessLevel < 30) {
      return 'Unhappy';
    } else if (happinessLevel > 70) {
      return 'Happy';
    } else {
      return 'Neutral';
    }
  }

  String _displayMood() {
    if (happinessLevel < 30) {
      return '😢';
    } else if (happinessLevel > 70) {
      return '🙂';
    } else {
      return '😐';
    }
  }

  void doActivity() {
    if (lose) return;
    if (activity == 'Play') {
      _playWithPet();
    } else if (activity == 'Feed') {
      _feedPet();
    } else if (activity == 'Rest') {
      setState(() {
        _energyLevel = (_energyLevel + 0.1).clamp(0, 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            win ? Text("You Win!", style: TextStyle(fontSize: 30)) : SizedBox.shrink(),
            lose ? Text("You Lose!", style: TextStyle(fontSize: 30)) : SizedBox.shrink(),
            Text(
              _displayMood(),
              style: TextStyle(fontSize: 30.0),
            ),
            SizedBox(height: 20),
            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: LinearProgressIndicator(
                value: _energyLevel,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Mood: ${_getMood()}',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            DropdownButton<String>(
                padding: EdgeInsets.symmetric(horizontal: 10),
                value: activity,
                borderRadius: BorderRadius.all(Radius.circular(5)),
                items: <String>['Play', 'Feed', 'Rest'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) => activity = newValue!),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: doActivity, child: Text('Confirm Activity')),
          ],
        ),
      ),
    );
  }
}
