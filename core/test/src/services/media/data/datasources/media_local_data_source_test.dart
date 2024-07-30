// Mock classes
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';

// Core module imports
import 'package:core/src/enums/media_type.dart';
import 'package:core/src/errors/server_exception.dart';
import 'package:core/src/services/http/i_http.dart';
import 'package:core/src/services/media/data/datasources/media_local_data_source.dart';
import 'package:core/src/services/media/data/models/media_model.dart';

class MockBox extends Mock implements Box {}

class MockHttpClient extends Mock implements IHttp {}

void main() {
  late MediaLocalDataSourceImpl dataSource;
  late MockBox mockBox;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockBox = MockBox();
    mockHttpClient = MockHttpClient();
    dataSource = MediaLocalDataSourceImpl(mockBox, mockHttpClient);
  });

  group('getMedia', () {
    test(
        'should return a list of MediaModel when there is media for the given date range',
        () {
      // Arrange
      final DateTime testDate = DateTime.now();
      final mediaData = {
        'id': '1',
        'url': 'url',
        'date': testDate.toIso8601String(),
        'title': 'Test Media',
        'mediaType': 'image',
      };
      when(mockBox.toMap()).thenReturn({'1': mediaData});

      // Act
      final result = dataSource.getMedia(date: testDate);

      // Assert
      expect(result, isA<List<MediaModel>>());
      expect(result.first.title, equals('Test Media'));
    });
  });

  group('uploadLocalMedia', () {
    test('should upload media and update local data', () async {
      // Arrange
      final media = MediaModel(
        url: 'url',
        date: DateTime.now(),
        title: 'Test Media',
        explanation: 'Test Media explanation',
        mediaType: MediaType.image,
      );
      final mediaList = [media];

      // // Use valid non-nullable strings in the mock response
      // when(mockHttpClient.download(any<String>(), any<String>()))
      //     .thenAnswer((_) async => HttpResponse(data: null, statusCode: 200));

      // Act
      await dataSource.uploadLocalMedia(mediaList: mediaList);

      // Assert
      verify(mockBox.clear()).called(1);
      verify(mockBox.add(any)).called(1);
    });

    test('should throw ServerException when upload fails', () async {
      // Arrange
      final media = MediaModel(
          url: 'url',
          date: DateTime.now(),
          title: 'Test Media',
          explanation: 'Test Media explanation',
          mediaType: MediaType.image);
      final mediaList = [media];

      // // Throw an exception when the method is called
      // when(mockHttpClient.download(any<String>(), any<String>()))
      //     .thenThrow(isA<ServerException>());

      // Act
      final call = dataSource.uploadLocalMedia(mediaList: mediaList);

      // Assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
