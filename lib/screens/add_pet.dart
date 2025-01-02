import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _breedController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _genderController = TextEditingController();
  final _photoUrlController = TextEditingController();
  final _weightController = TextEditingController();
  final _vaccinationRecordsController = TextEditingController();
  final _medicalHistoryController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _vetNameController = TextEditingController();
  final _vetContactController = TextEditingController();
  final _feedingScheduleController = TextEditingController();
  final _activityRequirementsController = TextEditingController();
  final _groomingScheduleController = TextEditingController();
  final _specialNotesController = TextEditingController();
  final _microchipIdController = TextEditingController();
  final _adoptionDateController = TextEditingController();
  final _insuranceDetailsController = TextEditingController();
  final _emergencyContactsController = TextEditingController();

  String? _photoUrl;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      final fileBytes = await pickedImage.readAsBytes();  // Get byte data
      final fileName = pickedImage.name;

      // Create a File object from byte data
      final file = File('${Directory.systemTemp.path}/$fileName')..writeAsBytesSync(fileBytes);

      // Upload the image to Supabase storage
      final response = await Supabase.instance.client.storage
          .from('pet-photos')
          .upload(fileName, file);

      if (response.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: ${response.error?.message}')),
        );
      } else {
        // Get the public URL of the uploaded image
        final publicUrlResponse = await Supabase.instance.client.storage
            .from('pet-photos')
            .getPublicUrl(fileName);

        if (publicUrlResponse.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error getting public URL: ${publicUrlResponse.error?.message}')),
          );
        } else {
          setState(() {
            _photoUrl = publicUrlResponse.data; // Access the URL from the response's 'data' property
            _photoUrlController.text = _photoUrl!;
          });
        }
      }
    }
  }

  Future<void> _addPet() async {
    final petName = _nameController.text;
    final petType = _typeController.text;
    final petBreed = _breedController.text;
    final dateOfBirth = _dateOfBirthController.text;
    final gender = _genderController.text;
    final photoUrl = _photoUrlController.text;
    final petWeight = _weightController.text;
    final vaccinationRecords = _vaccinationRecordsController.text;
    final medicalHistory = _medicalHistoryController.text;
    final medications = _medicationsController.text;
    final vetName = _vetNameController.text;
    final vetContact = _vetContactController.text;
    final feedingSchedule = _feedingScheduleController.text;
    final activityRequirements = _activityRequirementsController.text;
    final groomingSchedule = _groomingScheduleController.text;
    final specialNotes = _specialNotesController.text;
    final microchipId = _microchipIdController.text;
    final adoptionDate = _adoptionDateController.text;
    final insuranceDetails = _insuranceDetailsController.text;
    final emergencyContacts = _emergencyContactsController.text;
    final userId = Supabase.instance.client.auth.currentUser!.id;

    // Make sure the form is valid before submitting
    if (_formKey.currentState?.validate() ?? false) {
      final response = await Supabase.instance.client.from('pet_profiles').insert({
        'name': petName,
        'type': petType,
        'breed': petBreed,
        'user_id': userId,
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'photo_url': photoUrl,
        'weight': double.tryParse(petWeight),
        'vaccination_records': vaccinationRecords,
        'medical_history': medicalHistory,
        'medications': medications,
        'veterinarian_info': {'name': vetName, 'contact': vetContact},
        'feeding_schedule': feedingSchedule,
        'activity_requirements': activityRequirements,
        'grooming_schedule': groomingSchedule,
        'special_notes': specialNotes,
        'microchip_id': microchipId,
        'adoption_date': adoptionDate,
        'insurance_details': insuranceDetails,
        'emergency_contacts': emergencyContacts,
      }).execute();

      if (response.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding pet: ${response.error?.message}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pet added successfully!')),
        );
        Navigator.pop(context); // Go back to the Home page after adding
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Pet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Pet Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _typeController,
                  decoration: InputDecoration(labelText: 'Pet Type (e.g., Dog, Cat)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the pet type';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _breedController,
                  decoration: InputDecoration(labelText: 'Pet Breed'),
                ),
                TextFormField(
                  controller: _dateOfBirthController,
                  decoration: InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)'),
                  keyboardType: TextInputType.datetime,
                ),
                TextFormField(
                  controller: _genderController,
                  decoration: InputDecoration(labelText: 'Gender (Male/Female/Neutered/Spayed)'),
                ),
                TextFormField(
                  controller: _weightController,
                  decoration: InputDecoration(labelText: 'Pet Weight'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _vaccinationRecordsController,
                  decoration: InputDecoration(labelText: 'Vaccination Records'),
                ),
                TextFormField(
                  controller: _medicalHistoryController,
                  decoration: InputDecoration(labelText: 'Medical History'),
                ),
                TextFormField(
                  controller: _medicationsController,
                  decoration: InputDecoration(labelText: 'Medications'),
                ),
                TextFormField(
                  controller: _vetNameController,
                  decoration: InputDecoration(labelText: 'Veterinarian Name'),
                ),
                TextFormField(
                  controller: _vetContactController,
                  decoration: InputDecoration(labelText: 'Veterinarian Contact'),
                ),
                TextFormField(
                  controller: _feedingScheduleController,
                  decoration: InputDecoration(labelText: 'Feeding Schedule'),
                ),
                TextFormField(
                  controller: _activityRequirementsController,
                  decoration: InputDecoration(labelText: 'Activity Requirements'),
                ),
                TextFormField(
                  controller: _groomingScheduleController,
                  decoration: InputDecoration(labelText: 'Grooming Schedule'),
                ),
                TextFormField(
                  controller: _specialNotesController,
                  decoration: InputDecoration(labelText: 'Special Notes'),
                ),
                TextFormField(
                  controller: _microchipIdController,
                  decoration: InputDecoration(labelText: 'Microchip ID'),
                ),
                TextFormField(
                  controller: _adoptionDateController,
                  decoration: InputDecoration(labelText: 'Adoption Date'),
                ),
                TextFormField(
                  controller: _insuranceDetailsController,
                  decoration: InputDecoration(labelText: 'Insurance Details'),
                ),
                TextFormField(
                  controller: _emergencyContactsController,
                  decoration: InputDecoration(labelText: 'Emergency Contacts'),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.camera),
                      child: Text('Take a Photo'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      child: Text('Pick from Gallery'),
                    ),
                  ],
                ),
                if (_photoUrl != null) ...[
                  SizedBox(height: 20),
                  Image.network(_photoUrl!),
                ],
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addPet,
                  child: Text('Add Pet'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
