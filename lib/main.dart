import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';

void main() {
  runApp(MyApp());
  initializeLogging();
}

void initializeLogging() async {
  await FlutterLogs.initLogs(
    logLevelsEnabled: [
      LogLevel.WARNING,
      LogLevel.ERROR,
      LogLevel.INFO,
    ],
    timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
    directoryStructure: DirectoryStructure.SINGLE_FILE_FOR_DAY,
    logTypesEnabled: ["KaamConnect"],
    logFileExtension: LogFileExtension.LOG,
    logsWriteDirectoryName: "KaamConnectLogs",
    debugFileOperations: true,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KaamConnect Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _logEvent(String eventDetails) {
    FlutterLogs.logInfo('KaamConnect', 'RegistrationPage', '[KaamConnect Assignment] : $eventDetails');
  }

  void _validateEmail(String value) {
    setState(() {
      _isEmailValid = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value);
      if (!_isEmailValid) {
        _logEvent('Invalid email entered: $value');
      } else {
        _logEvent('Valid email entered: $value');
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      _isPasswordValid = value.length >= 8 &&
          value.length <= 50 &&
          RegExp(r'^(?=.*[a-z])(?=.*[A-Z]{2,})(?=.*[!@#\$%^&+=])[^*]*$').hasMatch(value);
      if (!_isPasswordValid) {
        _logEvent('Invalid password entered: $value');
      } else {
        _logEvent('Valid password entered: $value');
      }
    });
  }

  void _attemptRegistration() {
    if (_isEmailValid && _isPasswordValid) {
      _logEvent('User registered with email: ${_emailController.text} and Password: ${_passwordController.text}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registered Successfully!')));
    } else {
      _logEvent('Registration attempt failed due to invalid input');
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color.fromRGBO(144, 202, 249, 1);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              Text(
                'KaamConnect',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/LoginImg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Enter your Email',
                        labelStyle: TextStyle(color: primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        prefixIcon: Icon(Icons.email, color: primaryColor),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: _validateEmail,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || !_isEmailValid) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Enter your Password',
                        labelStyle: TextStyle(color: primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: primaryColor),
                        ),
                        prefixIcon: Icon(Icons.lock, color: primaryColor),
                        errorMaxLines: 3,
                      ),
                      obscureText: true,
                      onChanged: _validatePassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || !_isPasswordValid) {
                          return 'Password must be 8-50 chars, 2 capital letters, 1 small letter, 1 special char (except *)';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _isEmailValid && _isPasswordValid ? _attemptRegistration : null,
                      child: Text('Register', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                        textStyle: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: Divider(color: primaryColor)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Or OneTap SignIn with',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(child: Divider(color: primaryColor)),
                      ],
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        // Handle Google Sign-In
                        _logEvent('Google Sign-In tapped');
                      },
                      child: Image.asset(
                        'assets/GoogleIcon.png',
                        width: 48,
                        height: 48,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
