import 'package:flutter_test/flutter_test.dart';

import 'package:drawingbook/core/network/api_client.dart';
import 'package:drawingbook/main.dart';

void main() {
  testWidgets('DrawingBook app starts with main tabs', (tester) async {
    await tester.pumpWidget(
      DrawingBookApp(
        apiClient: ApiClient.fake((path) async {
          if (path == '/category/getFcList') {
            return {
              'data': {
                'list': [
                  {},
                  {},
                  {'tag_list': []},
                ],
              },
            };
          }
          if (path == '/recommend/goodBookList') {
            return {
              'data': {'single_list': []},
            };
          }
          return {
            'data': {'list': []},
          };
        }),
      ),
    );
    await tester.pump();

    expect(find.text('找绘本'), findsOneWidget);
    expect(find.text('找书单'), findsOneWidget);
    expect(find.text('听故事'), findsOneWidget);
  });
}
