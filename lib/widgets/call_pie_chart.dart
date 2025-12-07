import 'package:call_log/call_log.dart';
import 'package:callanalisys/shared/app_colors.dart';
import 'package:callanalisys/shared/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CallPieChart extends StatelessWidget {
  final Iterable<CallLogEntry> entries;


    //gets
  int get outgoingCalls => entries.where((e) => (e.callType == CallType.outgoing)).length;

  int get incomingCalls => entries.where((e) => e.callType == CallType.incoming).length;

  int get missedCalls => entries.where((e) => e.callType == CallType.missed || e.callType == CallType.rejected || e.callType == CallType.blocked).length;

  int get customerUnansweredCalls => entries.where((e) => e.callType == CallType.outgoing && (e.duration ?? 0) == 0).length ;

  

  const CallPieChart({super.key, required this.entries});



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
                            sections: [
                PieChartSectionData(
                  value: outgoingCalls.toDouble(),
                  color: AppColors.blue,
                  title: ""
                ),
                PieChartSectionData(
                  value: incomingCalls.toDouble(),
                  color: AppColors.primary,
                  title: ""
                ),
                PieChartSectionData(
                  value: missedCalls.toDouble(),
                  color: Colors.redAccent,
                  title: ""
                ),
                PieChartSectionData(
                  value: customerUnansweredCalls.toDouble(),
                  color: Colors.orangeAccent,
                  title: ""
                ),
              ] 
            )
          ),
        ),
        SizedBox(height: 14,),

   
        Text("Ligações efetuadas: $outgoingCalls", style: AppTextStyles.chartTextOutgoing, ),
        Text("Ligações recebidas: $incomingCalls", style: AppTextStyles.chartTextIncoming),
        Text("Ligações perdidas: $missedCalls", style: AppTextStyles.chartTextMissed),
        Text("Ligações não atendidas: $customerUnansweredCalls", style: AppTextStyles.chartTextUnansweredCalls),
    
      ],
    );
  }
}