import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_store/core/utils/json_reader.dart';

void main() {
  test('reads typed values and converts numbers', () {
    final json = JsonReader({
      'name': 'Sofa',
      'price': 10.0,
      'rating': 4,
      'ok': true,
      'tags': ['a', 'b'],
    });
    expect(json.string('name'), 'Sofa');
    expect(json.integer('price'), 10);
    expect(json.number('rating'), 4.0);
    expect(json.boolean('ok'), isTrue);
    expect(json.list<String>('tags'), ['a', 'b']);
    expect(json.optionalInt('missing'), isNull);
    expect(JsonReader({'share': 0.25}).optionalNumber('share'), 0.25);
    expect(json.optionalNumber('missing'), isNull);
    expect(json.booleanOr('missing', orElse: true), isTrue);
  });

  test('names the field when a value is missing or has the wrong type', () {
    final json = JsonReader({'price': 'cheap'});
    expect(
      () => json.integer('price'),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains('price'),
        ),
      ),
    );
    expect(() => json.string('name'), throwsFormatException);
  });

  test('reports the path of a bad nested item', () {
    final json = JsonReader({
      'colors': [
        {'name': 'Red'},
        {'name': 5},
      ],
    });
    final colors = json.objects('colors');
    expect(colors.first.string('name'), 'Red');
    expect(
      () => colors[1].string('name'),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains('colors[1].name'),
        ),
      ),
    );
  });

  test('a list with a wrong item type is rejected', () {
    expect(
      () => JsonReader({
        'ids': ['a', 2],
      }).list<String>('ids'),
      throwsFormatException,
    );
  });
}
