import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

class FormScreenState extends State<FormScreen> {
  String? _name;
  String? _message;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Feedback",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container(
              //   height: MediaQuery.of(context).size.height * 0.35,
              // ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(50), right: Radius.circular(50))),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  'इस ऐप को और अधिक उपयोगी बनाने के लिए, कृपया अपना फीडबैक/सुझाव साझा करें।',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                child: TextFormField(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Name is Required';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _name = value;
                  },
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    filled: true,
                    contentPadding: EdgeInsets.only(left: 15),
                    fillColor: Colors.white,
                    hintText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(8),
                      ),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: TextFormField(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Message is required';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _message = value;
                  },
                  maxLines: 15,
                  decoration: InputDecoration(
                    hintText: "Message",
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(8),
                      ),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  if (!_formKey.currentState!.validate()) {
                    showCustomSnackBar(
                        context: context,
                        color: Colors.red,
                        text: 'Please enter all required fields');
                    return;
                  }
                  _formKey.currentState!.save();
                  _formKey.currentState!.reset();
                  showCustomSnackBar(
                      context: context,
                      color: Colors.green,
                      text: 'Successfully Submitted!');
                  print(_name);
                  print(_message);
                  var response = await http.post(
                      Uri.parse('http://5.161.78.72/api/submit_feedback_form'),
                      body: {
                        'message': _message,
                        'name': _name,
                      });
                  if (response.statusCode == 200) {
                    showCustomSnackBar(
                        context: context,
                        color: Colors.green,
                        text: 'Successfully Submitted!');
                  }
                  //Send to API
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 45,
                  // onPressed: () {

                  // },
                  alignment: Alignment.center,
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showCustomSnackBar(
      {required BuildContext context,
      required Color color,
      required String text}) {
    final snackBar = SnackBar(
      duration: Duration(milliseconds: 1500),
      backgroundColor: color,
      content: Text(text),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
