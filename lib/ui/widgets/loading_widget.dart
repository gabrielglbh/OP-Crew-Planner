import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String msg;
  const LoadingWidget({Key? key, this.msg = ""}) : super(key: key);

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
              padding: const EdgeInsets.all(8),
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
  const FullScreenLoadingWidget({Key? key, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isLoading,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color.fromARGB(100, 0, 0, 0),
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

