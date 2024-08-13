// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:needlinc/needlinc/shared-pages/auth-pages/authSuccess.dart';
// import 'package:needlinc/needlinc/widgets/login-background.dart';

// import '../../colors/colors.dart';
// import '../../widgets/TextFieldBorder.dart';
// import '../user-type.dart';

// class confirmNumber extends StatefulWidget {
//   final String verificationId;
//   final String phoneNumber;
//   const confirmNumber(this.verificationId,
//       {super.key, required this.phoneNumber});

//   @override
//   State<confirmNumber> createState() => _confirmNumberState();
// }

// class _confirmNumberState extends State<confirmNumber> {
//   int lastDigit = 765;
//   final TextEditingController _otpController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController pin1Controller = TextEditingController();
//   final TextEditingController pin2Controller = TextEditingController();
//   final TextEditingController pin3Controller = TextEditingController();
//   final TextEditingController pin4Controller = TextEditingController();
//   final TextEditingController pin5Controller = TextEditingController();
//   final TextEditingController pin6Controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _otpController.text = widget.verificationId;
//   }

//   void verifyOTP() async {
//     // Combine the OTP digits from the controllers
//     String otp = '';
//     otp += pin1Controller.text;
//     otp += pin2Controller.text;
//     otp += pin3Controller.text;
//     otp += pin4Controller.text;
//     otp += pin5Controller.text;
//     otp += pin6Controller.text;

//     print('This is the OTP: $otp');

//     // Check if the OTP is valid
//     if (otp.length != 6) {
//       print('Invalid OTP');
//       return;
//     }

//     final PhoneAuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: widget.verificationId,
//       smsCode: otp,
//     );

//     try {
//       await _auth.signInWithCredential(credential);
//       // User is now authenticated, navigate to the next page
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const Success()),
//       );
//     } catch (e) {
//       // Handle verification failure, e.g., invalid OTP.
//       print('Verification failed: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           const backGround(),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
//             child: Column(
//               children: [
//                 // Top arrow
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Back arrow
//                     IconButton(
//                       onPressed: () => Navigator.pop(context),
//                       icon: const Icon(
//                         Icons
//                             .arrow_back_ios_new, // Specify the icon you want to use
//                         size: 30, // Adjust the icon size as needed
//                         color: NeedlincColors.white, // Customize the icon color
//                       ),
//                     ),
//                     // Page title
//                     const Text(
//                       'NEEDLINC',
//                       style:
//                           TextStyle(color: NeedlincColors.white, fontSize: 12),
//                     ),
//                     // Skip button
//                     InkWell(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const UserType()));
//                       },
//                       child: const Text(
//                         '',
//                         style: TextStyle(
//                             color: NeedlincColors.blue1, fontSize: 21),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 70),
//                 // main Card
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Card title
//                     const Text(
//                       'Confirm code',
//                       style: TextStyle(
//                         fontSize: 30,
//                         fontWeight: FontWeight.w400,
//                         color: NeedlincColors.white,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(20, 8, 20, 15),
//                       child: Text(
//                         'You were sent a 4 digit code to your phone number ~ ********$lastDigit ',
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: NeedlincColors.white,
//                         ),
//                       ),
//                     ),
//                     // body
//                     Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: NeedlincColors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: NeedlincColors.grey,
//                             offset: Offset(0, 3),
//                             blurRadius: 3.0,
//                             spreadRadius: 1.0,
//                           )
//                         ],
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(35, 50, 35, 50),
//                         child: Form(
//                             child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             SizedBox(
//                               height: 54,
//                               width: 50,
//                               child: TextFormField(
//                                 onChanged: (value) {
//                                   if (value.length == 1) {
//                                     FocusScope.of(context).nextFocus();
//                                   }
//                                 },
//                                 controller: pin1Controller,
//                                 onSaved: (pin1) {},
//                                 decoration: const InputDecoration(
//                                   focusedBorder: Borders.FocusedBorder,
//                                   enabledBorder: Borders.EnabledBorder,
//                                 ),
//                                 keyboardType: TextInputType.number,
//                                 textAlign: TextAlign.center,
//                                 inputFormatters: [
//                                   LengthLimitingTextInputFormatter(1),
//                                   FilteringTextInputFormatter.digitsOnly,
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: 54,
//                               width: 50,
//                               child: TextFormField(
//                                 decoration: const InputDecoration(
//                                   focusedBorder: Borders.FocusedBorder,
//                                   enabledBorder: Borders.EnabledBorder,
//                                 ),
//                                 onChanged: (value) {
//                                   if (value.length == 1) {
//                                     FocusScope.of(context).nextFocus();
//                                   }
//                                 },
//                                 controller: pin2Controller,
//                                 onSaved: (pin2) {},
//                                 keyboardType: TextInputType.number,
//                                 textAlign: TextAlign.center,
//                                 inputFormatters: [
//                                   LengthLimitingTextInputFormatter(1),
//                                   FilteringTextInputFormatter.digitsOnly,
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: 54,
//                               width: 50,
//                               child: TextFormField(
//                                 onChanged: (value) {
//                                   if (value.length == 1) {
//                                     FocusScope.of(context).nextFocus();
//                                   }
//                                 },
//                                 controller: pin3Controller,
//                                 onSaved: (pin3) {},
//                                 decoration: const InputDecoration(
//                                   focusedBorder: Borders.FocusedBorder,
//                                   enabledBorder: Borders.EnabledBorder,
//                                 ),
//                                 keyboardType: TextInputType.number,
//                                 textAlign: TextAlign.center,
//                                 inputFormatters: [
//                                   LengthLimitingTextInputFormatter(1),
//                                   FilteringTextInputFormatter.digitsOnly,
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: 54,
//                               width: 50,
//                               child: TextFormField(
//                                 onChanged: (value) {
//                                   if (value.length == 1) {
//                                     FocusScope.of(context).nextFocus();
//                                   }
//                                 },
//                                 controller: pin4Controller,
//                                 onSaved: (pin4) {},
//                                 decoration: const InputDecoration(
//                                   focusedBorder: Borders.FocusedBorder,
//                                   enabledBorder: Borders.EnabledBorder,
//                                 ),
//                                 keyboardType: TextInputType.number,
//                                 textAlign: TextAlign.center,
//                                 inputFormatters: [
//                                   LengthLimitingTextInputFormatter(1),
//                                   FilteringTextInputFormatter.digitsOnly,
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: 54,
//                               width: 50,
//                               child: TextFormField(
//                                 onChanged: (value) {
//                                   if (value.length == 1) {
//                                     FocusScope.of(context).nextFocus();
//                                   }
//                                 },
//                                 controller: pin5Controller,
//                                 onSaved: (pin5) {},
//                                 decoration: const InputDecoration(
//                                   focusedBorder: Borders.FocusedBorder,
//                                   enabledBorder: Borders.EnabledBorder,
//                                 ),
//                                 keyboardType: TextInputType.number,
//                                 textAlign: TextAlign.center,
//                                 inputFormatters: [
//                                   LengthLimitingTextInputFormatter(1),
//                                   FilteringTextInputFormatter.digitsOnly,
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: 54,
//                               width: 50,
//                               child: TextFormField(
//                                 onChanged: (value) {
//                                   if (value.length == 1) {
//                                     FocusScope.of(context).nextFocus();
//                                   }
//                                 },
//                                 controller: pin6Controller,
//                                 onSaved: (pin6) {},
//                                 decoration: const InputDecoration(
//                                   focusedBorder: Borders.FocusedBorder,
//                                   enabledBorder: Borders.EnabledBorder,
//                                 ),
//                                 keyboardType: TextInputType.number,
//                                 textAlign: TextAlign.center,
//                                 inputFormatters: [
//                                   LengthLimitingTextInputFormatter(1),
//                                   FilteringTextInputFormatter.digitsOnly,
//                                 ],
//                               ),
//                             ),
//                           ],
//                         )),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Expanded(
//                   child: Container(
//                     alignment: Alignment.bottomRight,
//                     padding: const EdgeInsets.only(right: 15, bottom: 55),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         //TODO
//                         verifyOTP();
//                         Navigator.push(context,
//                             MaterialPageRoute(builder: (context) => Success()));
//                       },
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         backgroundColor: NeedlincColors.blue1,
//                         padding: const EdgeInsets.all(16),
//                       ),
//                       child: const Text(
//                         'NEXT',
//                         style: TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
