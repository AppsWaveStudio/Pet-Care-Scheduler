import 'package:flutter/material.dart';
import 'package:pet_care_scheduler/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Declare the list to hold pets
  List<Map<String, dynamic>> _petList = [];

  // Function to fetch the pet list from Supabase
  Future<void> _fetchPetList() async {
    final response = await Supabase.instance.client.from('pet_profiles')
        .select('*')
        .eq('user_id', Supabase.instance.client.auth.currentUser!.id)
        .execute();


    print(response.data);

    if (response.error == null) {
      setState(() {
        _petList = List<Map<String, dynamic>>.from(response.data);
      });
    } else {
      // Handle error here if necessary
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching pets: ${response.error?.message}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch pet data when the screen is first built
    _fetchPetList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        leading: Container(),
      ),
      body: _petList.isEmpty
          ? Center(child: CircularProgressIndicator())  // Show loading spinner if no pets
          : ListView.builder(
        itemCount: _petList.length,
        itemBuilder: (context, index) {
          final pet = _petList[index];
          String url = pet['photo_url'].toString().isNotEmpty ? pet['photo_url'] : 'https://via.placeholder.com/150';
          return ListTile(
            title: Text(pet['name'] ?? 'Unknown Pet'),
            subtitle: Text(pet['type'] ?? 'Unknown Type'),
            leading: SizedBox(
              width: 50,  // Set a fixed width for the image
              height: 50, // Set a fixed height for the image
              child: Image.network(
                url,
                scale: 1.0,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // If loading is complete, show the image
                  }
                  return Center(child: CircularProgressIndicator()); // Show a loading spinner while loading
                },
                errorBuilder: (context, error, stackTrace) {
                  // Show a default placeholder if there is an error loading the image
                  return Icon(Icons.error, size: 50);
                },
              ),
            ),
            onTap: () {
              // Handle pet click if necessary (e.g., navigate to pet details)
            },
          );

        },
      ),
      floatingActionButton: GestureDetector(
        onTap: (){
          Navigator.of(context).pushNamed(Routes.addPet);  // Use your route for the add pet page
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: Text('Add Pet', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
