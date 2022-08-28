import 'package:cshell/api.dart';
import 'package:cshell/app.dart';
import 'package:cshell/sdr/sdr_area.dart';
import 'package:cshell/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put(ApiService(), permanent: true);
  runApp(GetMaterialApp(
    title: 'aShell',
    home: AppWidget(),
    darkTheme: AppThemes.darkTheme,
    theme: AppThemes.lightTheme,
    themeMode: ThemeMode.dark,
  ));
}

openTestPage() {
  Get.to(
    () => Scaffold(
      body: Column(
        children: const [
          SdrArea(
            areaId: '1',
            data: {
              'type': 'padding',
              'padding': 20,
              'child': {
                'type': 'text',
                'text': 'Hello from SdrArea',
                'fontSize': 30,
              },
            },
          ),
          SdrArea(
            areaId: '2',
            data: {
              'type': 'container',
              'margin': 10.0,
              'padding': {
                'top': 10,
                'bottom': 10,
                'right': 20,
                'left': 20,
              },
              'border': {
                'all': {
                  'color': '#ff0000',
                  'width': 2,
                }
              },
              'child': {
                '\$': {
                  '4_line': 'Fourth line from variable',
                },
                '\$\$': {
                  'rv': 'Fifth line',
                },
                'type': '\$column',
                'children': [
                  {
                    'type': 'text',
                    'text': 'First Line',
                  },
                  {
                    'type': 'text',
                    'text': 'Second Line',
                  },
                  {
                    'type': 'text',
                    'text': 'Third Line',
                  },
                  {
                    'type': 'text',
                    'text': '\$4_line',
                  },
                  {
                    'type': 'text',
                    'text': '\$\$rv',
                  },
                  {
                    'type': 'button',
                    '@click': {
                      '_': 'set_variable',
                      'name': 'rv',
                      'value': 'Button clicked!',
                    },
                    '@longPress': {
                      '_': 'set_variable',
                      'name': 'rv',
                      'value': 'Button long-pressed!',
                    },
                    'child': {
                      'type': 'text',
                      'text': 'Click Me!',
                    },
                  },
                ],
              },
            },
          ),
          SdrArea(
            areaId: '3',
            data: {
              '\$\$': {
                'counter': 0,
              },
              'type': 'column',
              'padding': 20,
              'children': [
                {
                  'type': '\$text',
                  'text': '\$\$counter',
                },
                {
                  'type': 'button',
                  '@click': {
                    '_': 'increment_variable',
                    'name': 'counter',
                  },
                  'child': {
                    'type': 'text',
                    'text': 'Increment',
                  },
                },
                {
                  'type': 'button',
                  '@click': {
                    '_': 'decrement_variable',
                    'name': 'counter',
                  },
                  'child': {
                    'type': 'text',
                    'text': 'Decrement',
                  },
                },
              ],
            },
          ),
        ],
      ),
    ),
  );
}
