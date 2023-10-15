import 'package:app1f/provider/test_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ProviderScreeen extends StatelessWidget {
  const ProviderScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<TestProvider>(context);

    return Scaffold(
      body: Center(
        child: Text(userProvider.user),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          userProvider.user = 'Omar';
        },
      ),
    );
  }
}
