import 'package:call_log/call_log.dart';
import 'package:callanalisys/shared/app_text_styles.dart';
import 'package:callanalisys/widgets/call_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:callanalisys/services/excel_exporter.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Iterable <CallLogEntry>? _entries;
  final DateFormat formatter = DateFormat("dd/MM/yyyy HH:mm");
  final DateFormat filterformatter = DateFormat("dd/MM/yyyy");

  DateTime _startDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    0,0,0
  );
  DateTime _endDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    23,59,59
  );

  
  

  @override
  void initState(){
    super.initState();
    _loadCallLog();
  }

  _loadCallLog() async {
    try {
  var entries = await CallLog.query(
    dateFrom: _startDate.millisecondsSinceEpoch,
    dateTo: _endDate.millisecondsSinceEpoch,
  );
  setState(() {
    _entries = entries;
  });
} catch (e) {
  debugPrint("Erro ao acessar CallLog: $e");
}
  }

  //seleciona nova data/hora para início
  Future<void> _pickStartDate () async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now()
      );

      if (picked != null) {
            setState(() {
              _startDate = DateTime(
                picked.year,
                picked.month,
                picked.day,
                0, 0, 0
              );
            });
            _loadCallLog(); //Reload List
          }
      
  }

  //Nova data de final
  _pickEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now()
      );
      if (picked != null) {
            setState(() {
              _endDate = DateTime(
                picked.year,
                picked.month,
                picked.day,
                23, 59, 59
                );
            });
            _loadCallLog();
          }
      
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),


      body: Column(
        children: [
          //seletores de data
          Padding(padding: EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //seletor inicial
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.date_range),
                      SizedBox(width: 5,),
                      Text("Início:", style: AppTextStyles.body,),
                      SizedBox(width: 10,),
                    ],
                  ),
                  
                  ElevatedButton(
                  onPressed: _pickStartDate,
                  child:  Text(filterformatter.format(_startDate), style: AppTextStyles.body)),
                ],
 
              ),
              //seletor final
               Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Row(
                    children: [
                      const Icon(Icons.date_range),
                      SizedBox(width: 5,),
                      Text("Fim:", style: AppTextStyles.body,),
                    ],
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                  onPressed: _pickEndDate,
                  child:  Text(filterformatter.format(_endDate), style: AppTextStyles.body)),
                ],
 
              )
            ],
          ),
          ),


          Divider(), //Divisão

          if(_entries != null && _entries!.isNotEmpty) ...[CallPieChart(entries: _entries!)],
            

          //Lista
          Expanded(
            child: _entries == null
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
              itemCount: _entries!.length,
              itemBuilder: (context, index) {
                final entry = _entries!.elementAt(index);
            
                IconData icon;
                if (entry.callType == CallType.incoming) {
                  icon = Icons.call_received;
                } else if (entry.callType == CallType.outgoing){ 
                  icon = Icons.call_made;
                } else {
                  icon = Icons.call_missed;
                }
            
                Color iconColor = (entry.duration != null && entry.duration! > 0)
                ? Colors.green
                : Colors.red;
            
                String titlecallitem = entry.name ?? entry.number ?? "Desconhecido";
            
                return ListTile(
                  leading: Icon(icon,
                    color: iconColor
                  ),
                  title: Text(titlecallitem),
                  subtitle: Text(
                    "Duração: ${entry.duration} segundos\n"
                    "Data: ${formatter.format(DateTime.fromMillisecondsSinceEpoch(entry.timestamp!))}"
                  ),
                );
              }
              ),
          ),
        ],
      ),


      //Botões
      floatingActionButton: 
      FloatingActionButton(
        heroTag: "btnExport",
        onPressed: () async {
          try {
            await ExcelExporter.ExportAllHostory();
            if (!mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Exportado com sucesso"))
            );

          } catch (e) {

            if(!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erro ao exportar $e"))
            );
          }
        },
        tooltip: 'Exportar',
        child: const Icon(Icons.upload_file_rounded),
      ),
    );
  }
}
