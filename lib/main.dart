import 'package:cshell/api.dart';
import 'package:cshell/app.dart';
import 'package:cshell/sdr/sdr.dart';
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

class TestAreaWidget extends StatefulWidget {
  const TestAreaWidget({Key? key}) : super(key: key);

  @override
  State<TestAreaWidget> createState() => _TestAreaWidgetState();
}

class _TestAreaWidgetState extends State<TestAreaWidget> {
  @override
  void initState() {
    super.initState();
  }

  makeUpdate() {
    sdrUpdate({
      'templates': {
        'item': {
          'type': 'padding',
          'padding': 10,
          'child': {
            'type': 'text',
            'text': {
              '_v': '\$text',
            },
          },
        }
      },
      'areas': {
        'updatable': {
          'type': 'column',
          'children': [
            {
              '\$': {
                'text': 'Item 1',
              },
              'type': 'item',
            },
            {
              '\$': {
                'text': 'Item 2',
              },
              'type': 'item',
            },
          ],
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Area'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () => makeUpdate(),
            child: const Text('Make Update'),
          ),
          const SdrArea(areaId: 'updatable'),
          const SdrArea(
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
          const SdrArea(
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
                    'text': {
                      '_v': '\$4_line',
                    },
                  },
                  {
                    'type': 'text',
                    'text': {
                      '_v': '\$\$rv',
                    },
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
          const SdrArea(
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
                  'text': {
                    '_v': '\$\$counter',
                  },
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
          const SdrArea(
            areaId: '4',
            data: {
              '\$': {
                'items': [
                  'Line 0',
                  'Line 1',
                  'Line 2',
                ],
                'index': 2,
              },
              'type': 'column',
              'children': [
                {
                  'type': 'text',
                  'text': {
                    '_v': '\$items.1',
                  },
                },
                {
                  'type': 'text',
                  'text': {
                    '_v': '\$items.\$index',
                  },
                },
              ],
            },
          ),
          const Expanded(
            child: SdrArea(
              areaId: '5',
              data: {
                'type': 'list_builder',
                'child': {
                  'type': 'padding',
                  'padding': 10,
                  'child': {
                    'type': 'text',
                    'text': {
                      '_v': '\$index',
                    },
                  },
                },
              },
            ),
          ),
          const Expanded(
            child: SdrArea(
              areaId: '6',
              data: {
                '\$': {
                  'articles': [
                    {'author': 'John Doe', 'title': 'Title 1'},
                    {'author': 'Mari Doe', 'title': 'Title 2'},
                    {'author': 'John Doe', 'title': 'Title 3'},
                  ],
                },
                'type': 'list_builder',
                'items': {
                  '_v': '\$articles',
                },
                'child': {
                  'type': 'padding',
                  'padding': 10,
                  'child': {
                    'type': 'column',
                    'children': [
                      {
                        'type': 'text',
                        'text': {
                          '_v': 'interpolate',
                          'value': 'Author name: \$item.author. Index: \$index',
                        },
                      },
                      {
                        'type': 'text',
                        'text': {
                          '_v': '\$item.title',
                        },
                      },
                    ],
                  },
                },
              },
            ),
          ),
        ],
      ),
    );
  }
}
