import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:call_log/call_log.dart';

class ExcelExporter {
  static Future<void> ExportAllHostory () async {
    //consulta o histórico sem filtro de datas
    final entries = await CallLog.query();

    if (entries.isEmpty) {
      throw Exception("Nenhuma chamada encontrada");
    }

    var excel = Excel.createExcel();
    Sheet sheeObject = excel['Chamadas'];

    //Cabeçalho
    sheeObject.appendRow([
      TextCellValue('Nome/Contato'),
      TextCellValue('Número'),
      TextCellValue('Tipo'),
      TextCellValue('Duração (s)'),
      TextCellValue("Data/Hora"),
      
    ]);

    //Preenche Linhas
    for (var entry in entries) {
      sheeObject.appendRow([
        TextCellValue(entry.name ?? 'Desconhecido'),
        TextCellValue(entry.number ?? ''),
        TextCellValue(entry.callType.toString()),
        IntCellValue(entry.duration ?? 0),
        TextCellValue(DateTime.fromMillisecondsSinceEpoch(entry.timestamp ?? 0).toString()),
      ]);
    }

    //Salva temporariamente
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/chamadas.xlsx';
    final fileBytes = excel.save();
    if (fileBytes != null) {
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

        //Compartilha o arquivo usando o menu nativo
        await Share.shareXFiles([XFile(filePath)], text: "Histórico completo de chamadas");
    }

  }
}