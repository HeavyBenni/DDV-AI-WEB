import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:developer';

class ChatBackend {
  final String apiKey =
      '9980710519a0447099580de4d0dead6d'; // Replace with your API key

  Future<Map<String, dynamic>> sendMessage(String userMessage) async {
    // Define a default system message
    final String systemMessage =
        "Du er en AI assistant som hjelper folk å finne informasjon om Didaktisk Digitalt Verksted (DDV) ved Universitet i Stavanger (UiS).";

    final String endpoint =
        'https://ddv-openai.openai.azure.com/openai/deployments/DDV-Test/chat/completions?api-version=2023-07-01-preview';

    try {
      final Dio dio = Dio();
      final response = await dio.post(
        endpoint,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'api-key': apiKey,
          },
        ),
        data: jsonEncode(<String, dynamic>{
          'messages': [
            {'role': 'system', 'content': systemMessage}, // System message
            {'role': 'user', 'content': userMessage}, // User message
          ],
          'max_tokens': 800,
          'temperature': 0.7,
          'frequency_penalty': 0,
          'presence_penalty': 0,
          'top_p': 0.95,
          'stop': null,
        }),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data;
      } else {
        print('Failed to fetch response: ${response.data}');
        throw Exception('Failed to fetch response');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch response');
    }
  }
}
