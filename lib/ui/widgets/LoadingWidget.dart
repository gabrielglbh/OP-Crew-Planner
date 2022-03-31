import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String msg;
  const LoadingWidget({this.msg = ""});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[400]!),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(msg),
            )
          ],
        ),
      ),
    );
  }
}

class FullScreenLoadingWidget extends StatelessWidget {
  final bool isLoading;
  const FullScreenLoadingWidget({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isLoading,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromARGB(100, 0, 0, 0),
        child: Center(
          child: CircularProgressIndicator(
            value: null,
            strokeWidth: 5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[400]!),
          ),
        ),
      ),
    );
  }
}

