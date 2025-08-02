import 'package:flutter_test/flutter_test.dart';

import 'package:bio_sphere/core/routing/path.dart';

void main() {
  group('Path', () {
    test('simple constructor returns normalized path and absolutePath', () {
      const p = Path.simple('/todos');
      expect(p.path, equals('/todos'));
      expect(p.absolutePath, equals('/todos'));
    });

    test('dynamic path returns correct relative and absolute paths', () {
      const p = Path('/todos', '/:id');
      expect(p.path, equals('/:id'));
      expect(p.absolutePath, equals('/todos/:id'));
    });

    test('paramsInjectedPath injects single id and query param', () {
      const p = Path('/todos', '/:id');
      final path = p.paramsInjectedPath({'id': '123'}, {'mode': 'edit'});
      expect(path, equals('/123?mode=edit'));
    });

    test('paramsInjectedAbsolutePath injects id and query', () {
      const p = Path('/todos', '/:id');
      final absPath = p.paramsInjectedAbsolutePath(
        {'id': '123'},
        {'mode': 'edit'},
      );
      expect(absPath, equals('/todos/123?mode=edit'));
    });

    test('paramsInjectedPath returns original path if no params provided', () {
      const p = Path('/plain', '/path');
      expect(p.paramsInjectedPath({}, {}), equals('/path'));
    });

    test('paramsInjectedAbsolutePath supports multiple ids', () {
      const p = Path('/projects', '/:projectId/tasks/:taskId');
      final absPath = p.paramsInjectedAbsolutePath({
        'projectId': '1',
        'taskId': '99',
      }, {});
      expect(absPath, equals('/projects/1/tasks/99'));
    });

    test('does not replace non-existent id keys', () {
      const p = Path('/users', '/:id/:detail');
      final absPath = p.paramsInjectedAbsolutePath({'id': 'user1'}, {});
      expect(absPath, equals('/users/user1/:detail'));
    });

    test('paramsInjectedPath appends list query params', () {
      const p = Path.simple('/items');
      final result = p.paramsInjectedPath({}, {
        'tag': ['a', 'b'],
      });
      expect(
        result == '/items?tag=a&tag=b' || result == '/items?tag=b&tag=a',
        isTrue,
      );
    });

    test('paramsInjectedPath encodes query params with spaces and symbols', () {
      const p = Path.simple('/search');
      final result = p.paramsInjectedPath({}, {
        'q': 'hello world & test/encode',
      });
      expect(result, equals('/search?q=hello+world+%26+test%2Fencode'));
    });

    test('paramsInjectedAbsolutePath ignores null ID values', () {
      const p = Path('/items', '/:id');
      final result = p.paramsInjectedAbsolutePath({'id': null}, {});
      expect(result, equals('/items/:id'));
    });

    test('paramsInjectedAbsolutePath ignores null query values', () {
      const p = Path.simple('/data');
      final result = p.paramsInjectedAbsolutePath({}, {'filter': null});
      expect(result, equals('/data'));
    });

    test('paramsInjectedPath works with empty maps', () {
      const p = Path('/abc', '/xyz');
      final result = p.paramsInjectedPath({}, {});
      expect(result, equals('/xyz'));
    });

    test('query parser extracts parameters correctly', () {
      final result = Path.parseQuery('/todos?id=123&mode=edit');
      expect(result, containsPair('id', '123'));
      expect(result, containsPair('mode', 'edit'));
    });

    test('query parser returns empty map if no query', () {
      final result = Path.parseQuery('/plain/path');
      expect(result, isEmpty);
    });

    test('query parser decodes percent-encoded values', () {
      final result = Path.parseQuery('/search?q=hello%20world');
      expect(result['q'], equals('hello world'));
    });

    test('paramsInjectedPath handles trailing slashes gracefully', () {
      const p = Path('/base/', '/:id/');
      final result = p.paramsInjectedAbsolutePath({'id': 'x'}, {});
      expect(result, equals('/base/x/'));
    });

    test('multiple query params are encoded properly', () {
      const p = Path.simple('/query');
      final result = p.paramsInjectedPath({}, {
        'a': '1',
        'b': 'value with space',
        'c': 'special&chars',
      });
      expect(result, contains('a=1'));
      expect(result, contains('b=value+with+space'));
      expect(result, contains('c=special%26chars'));
    });
  });
}
