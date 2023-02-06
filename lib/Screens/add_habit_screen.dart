import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/Screens/Authentication_Screens/login_screen.dart';
import 'package:habit_tracker/UI_elements/color.dart';
import 'package:habit_tracker/UI_elements/text_styles.dart';
import 'package:intl/intl.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({Key? key}) : super(key: key);

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  TextEditingController _controller = TextEditingController();
  final _key = GlobalKey<FormState>();

  /// add habit to database
  addHabit(String habit) async {
    if (_key.currentState!.validate()) {
      final String id =
          FirebaseFirestore.instance.collection('habits').doc().id;

      /// to dismiss the keyboard
      FocusManager.instance.primaryFocus?.unfocus();

      try {
        ///adding habits to firebase
        await FirebaseFirestore.instance
            .collection('habits')
            .doc(currentUser!.uid)
            .collection('habit')
            .doc(id)
            .set({
          'userId': currentUser!.uid,
          "habitId": id,
          "habit": habit,
          "timeStamp": DateTime.now(),
        }).whenComplete(() async {
          await FirebaseFirestore.instance
              .collection('habits')
              .doc(currentUser!.uid)
              .set({"count": FieldValue.increment(1)}, SetOptions(merge: true));
        });

        _controller.clear();
      } catch (e) {
        print(e.toString());
      }
    }
  }

  /// delete habit from database
  delete(String habitId) async {
    /// deleting habit from habits collection
    await FirebaseFirestore.instance
        .collection('habits')
        .doc(currentUser!.uid)
        .collection('habit')
        .doc(habitId)
        .delete()
        .whenComplete(() async {
          /// decreaseing
      await FirebaseFirestore.instance
          .collection('habits')
          .doc(currentUser!.uid)
          .set({"count": FieldValue.increment(-1)}, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection('habitOnDate')
          .doc(currentUser!.uid)
          .collection('habitDate')
          .doc(DateFormat.yMMMd().format(DateTime.now()))
          .collection('habits')
          .doc(habitId)
          .delete()
          .whenComplete(() {
        FirebaseFirestore.instance
            .collection('habitOnDate')
            .doc(currentUser!.uid)
            .collection('habitDate')
            .doc(DateFormat.yMMMd().format(DateTime.now()))
            .set({"count": FieldValue.increment(-1)}, SetOptions(merge: true));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),

      /// making a form
      child: Form(
        key: _key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text16Medium(
                text: 'Write habit you want to build', color: primaryTextColor),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _controller,
              validator: (val) => val!.trim().isEmpty ? 'Please fill input' : null,
              decoration: InputDecoration(
                  hintText: '...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                addHabit(_controller.text.trim());
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text16Medium(
                  text: 'Add',
                  color: Colors.white,
                ),
              ),
            ),
            Divider(
              height: 40,
            ),
            Text16Medium(
                text: 'Previous Habits you Added', color: primaryTextColor),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('habits')
                    .doc(currentUser!.uid)
                    .collection('habit')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  return Expanded(
                      child: ListView(
                    children: snapshot.data!.docs.map((doc) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(doc['habit']),
                          IconButton(

                              /// delete function
                              onPressed: () {
                                delete(doc['habitId']);
                              },
                              icon: Icon(Icons.delete))
                        ],
                      );
                    }).toList(),
                  ));
                }),
          ],
        ),
      ),
    );
  }
}
