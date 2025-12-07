import 'package:callanalisys/pages/home_page.dart';
import 'package:callanalisys/services/permission_services.dart';
import 'package:callanalisys/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:callanalisys/shared/app_text_styles.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {


  Future<void> _requestPermission() async {
    bool granted = await PermissionServices.requestCallPermissions();

    if(!mounted) return;

    if(granted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MyHomePage(title: "Página Inicial"))
        );
    } 
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("O aplicativo precisa de acesso ao histórico de chamadas para funcionar corretamente",
          textAlign: TextAlign.center,
          style: AppTextStyles.body),
          SizedBox(height: 10,),
          ElevatedButton(
            onPressed: _requestPermission,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.buttonColor1),
            child: Text("Conceder acesso", style: AppTextStyles.button,)),
        ],
      ),
    );
  }
}