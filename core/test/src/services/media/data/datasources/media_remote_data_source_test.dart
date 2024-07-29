// Mock classes
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Core module imports
import 'package:core/src/errors/server_exception.dart';
import 'package:core/src/services/http/i_http.dart';
import 'package:core/src/services/http/http_response.dart';
import 'package:core/src/services/media/data/datasources/media_remote_data_source.dart';
import 'package:core/src/services/media/data/models/media_model.dart';

// Mock classes
class MockHttpClient extends Mock implements IHttp {}

void main() {
  late MediaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = MediaRemoteDataSourceImpl(mockHttpClient);
  });

  group('getMedia', () {
    const String startDate = '2021-01-01';
    const String endDate = '2021-01-08';

    test(
        'should return a list of MediaModel when the call to httpClient is successful',
        () async {
      // Arrange
      final mediaData = [
        {
          'id': '1',
          'url': 'url1',
          'date': '2021-01-02',
          'title': 'Test Media 1',
          'mediaType': 'image'
        },
        {
          'id': '2',
          'url': 'url2',
          'date': '2021-01-03',
          'title': 'Test Media 2',
          'mediaType': 'image'
        },
      ];
      when(mockHttpClient.get(query: anyNamed('query'))).thenAnswer(
          (_) async => HttpResponse(data: mediaData, statusCode: 200));

      // Act
      final result = await dataSource.getMedia(startDate, endDate);

      // Assert
      expect(result, isA<List<MediaModel>>());
      expect(result.length, equals(2));
      expect(result.first.title, equals('Test Media 2'));
    });

    test(
        'should throw a ServerException when the call to httpClient is unsuccessful',
        () async {
      // Arrange
      when(mockHttpClient.get(query: anyNamed('query')))
          .thenThrow(const ServerException('Failed to fetch data'));

      // Act
      final call = dataSource.getMedia(startDate, endDate);

      // Assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
