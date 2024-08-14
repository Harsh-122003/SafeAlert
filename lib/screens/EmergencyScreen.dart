import 'package:direct_flutter_sms/direct_flutter_sms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_alert/Utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/EmergencyContact.dart';

class Emergencyscreen extends StatefulWidget {
  const Emergencyscreen({super.key});

  @override
  State<Emergencyscreen> createState() => _EmergencyscreenState();
}

class _EmergencyscreenState extends State<Emergencyscreen> {

  late double _latitude;
  late double _longitude;

  List<EmergencyContact> items = [
    EmergencyContact(imagePath:"images/home_call.png",name: "Home", phoneNo: "+919512764192"),
    EmergencyContact(imagePath:"images/ambulance.png",name: "Ambulance", phoneNo: "102"),
    EmergencyContact(imagePath:"images/fire_call.png",name: "Fire", phoneNo: "101"),
    EmergencyContact(imagePath:"images/police_call.png",name: "Police", phoneNo: "100"),
    EmergencyContact(imagePath:"images/women_call.png",name: "Women Help", phoneNo: "181"),
    EmergencyContact(imagePath:"images/child_call.png",name: "Child Support", phoneNo: "1098"),
    EmergencyContact(imagePath:"images/wildlife_call.png",name: "Wildlife Support", phoneNo: "155125"),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,

      body: Padding(
        padding:const EdgeInsets.all(18),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                    child:const Icon(CupertinoIcons.back,color: Colors.white,)),
                const SizedBox(width: 10,),
                Text("One-Touch SOS Alert" , style: TextStyle(color: Colors.yellow.shade700,fontSize: 20 , fontWeight: FontWeight.bold),)
              ],
            ),
            const SizedBox(height: 20,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text("One-touch SMS and phone calling -- safety is just a tap away.",style: TextStyle(color: Colors.grey,fontSize: 16),textAlign: TextAlign.center,)),
            const SizedBox(height: 10,),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 2 columns
                  crossAxisSpacing: 10.0, // Space between columns
                  mainAxisSpacing: 10.0, // Space between rows
                  childAspectRatio: 2 / 3.2, // Aspect ratio for items
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){

                    },
                    child: GridItemCard(
                        imagePath: items[index].imagePath,
                        title: items[index].name,
                        phone: items[index].phoneNo),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget GridItemCard(
      {required String imagePath,
        required String title,
        required String phone}) {
    return Container(
      padding:const EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.yellow.shade700),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 5,
          ),
          Image.asset(
            imagePath,
            width: MediaQuery.of(context).size.width * 0.09,
            height: MediaQuery.of(context).size.width * 0.09,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            title,
            style: TextStyle(
                color: Colors.yellow.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
          const SizedBox(
            height: 5,
          ),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  sendMessage(phone, "Emergency Type:${title}\nHelp Needed Immediately!\n", _latitude!, _longitude!);
                },
                  child: Icon(Icons.message,color: Colors.grey,)),
              SizedBox(width: 15,),
              InkWell(
                onTap: (){
                  makeCall(phone);
                },
                  child: Icon(Icons.phone,color: Colors.grey))
            ],
          )
        ],
      ),
    );
  }


  Future<void> _getLocation() async {
    try {
      Map<String, double> location = await getCurrentLocation();
      setState(() {
        _latitude = location['latitude']!;
        _longitude = location['longitude']!;

      });
    } catch (e) {
      setState(() {
        Utils.showSnackbar(context: context, msg: "Error: ${e.toString()}");
      });
    }
  }

  Future<Map<String, double>> getCurrentLocation() async {
    // Check if location services are enabled
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      Utils.showSnackbar(context: context, msg:"Location services are disabled." );
      throw Exception("Location services are disabled.");
    }

    // Check and request location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        throw Exception("Location permission is denied.");
      }
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Return latitude and longitude as a map
    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };
  }




  Future<void> sendMessage(String phoneNo, String message, double latitude, double longitude) async {
    // final Telephony telephony = Telephony.instance;
    String locationUrl = 'https://www.google.com/maps?q=$latitude,$longitude';
    String fullMessage = '$message\nLocation: $locationUrl';

    SmsService.sendSms(phoneNo, fullMessage);
    Utils.showSnackbar(context: context, msg: "SMS sent!!");

    // Request permissions
    // bool? permissionsGranted = await telephony.requestSmsPermissions;
    //
    // if (permissionsGranted != null && permissionsGranted) {
    //   try {
    //     // Ensure that telephony is properly initialized
    //     await telephony.sendSms(
    //       to: phoneNo,
    //       message: fullMessage,
    //       statusListener: (SendStatus status) {
    //         if (status == SendStatus.SENT) {
    //           Utils.showSnackbar(context: context, msg: "SMS Sent");
    //         }
    //       },
    //     );
    //   } catch (e) {
    //     Utils.showSnackbar(context: context, msg: "Error sending SMS: $e");
    //     print('Error sending SMS: $e');
    //   }
    // } else {
    //   Utils.showSnackbar(context: context, msg: "SMS permission not granted");
    // }
  }

//
// Future<void> sendMessage(String phoneNo, String message, double latitude, double longitude) async {
//     String locationUrl = 'https://www.google.com/maps?q=$latitude,$longitude';
//     String fullMessage = '$message\nLocation: $locationUrl';
//
//     try {
//       String result = await sendSMS(message: fullMessage, recipients: [phoneNo]);
//       if (result == "SMS Sent!") {
//         Utils.showSnackbar(context: context, msg: "SMS Sent");
//       } else {
//         Utils.showSnackbar(context: context, msg: "Failed to send SMS");
//       }
//     } catch (error) {
//       Utils.showSnackbar(context: context, msg: "Error sending SMS: $error");
//       print('Error sending SMS: $error');
//     }
//   }


// Future<void> sendMessage(String phoneNo, String message, double latitude, double longitude) async {
//     final Uri smsUri = Uri(
//       scheme: 'sms',
//       path: phoneNo,
//       queryParameters: {
//         'body': '$message\nLocation: https://www.google.com/maps?q=$latitude,$longitude',
//       },
//     );
//
//     if (await canLaunchUrl(smsUri)) {
//       await launchUrl(smsUri);
//       Utils.showSnackbar(context: context, msg:"SMS Send" );
//     } else {
//       Utils.showSnackbar(context: context, msg:"Could not send SMS" );
//       print('Could not launch SMS app');
//     }
//   }

  Future<void> makeCall(String phoneNumber) async {
    try {
      bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber); // Using flutter_phone_direct_caller to initiate the call
      if (!res!) {
        throw 'Could not launch $num';
      }
    } catch (e) {
      Utils.showSnackbar(context: context, msg:"Error launching phone: $e" );
      print('Error launching phone: $e');
    // Handle error as needed
    }

  }


}
