// Mock classes
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Core module imports
import 'package:core/src/enums/media_type.dart';
import 'package:core/src/errors/failures.dart';
import 'package:core/src/network/connection_checker.dart';
import 'package:core/src/services/media/data/datasources/media_local_data_source.dart';
import 'package:core/src/services/media/data/datasources/media_remote_data_source.dart';
import 'package:core/src/services/media/data/repository/media_repository_impl.dart';
import 'package:core/src/services/media/domain/entities/media.dart';

// Mock classes
class MockMediaRemoteDataSource extends Mock implements MediaRemoteDataSource {}

class MockMediaLocalDataSource extends Mock implements MediaLocalDataSource {}

class MockConnectionChecker extends Mock implements ConnectionChecker {}

void main() {
  late MediaRepositoryImpl repository;
  late MockMediaRemoteDataSource mockRemoteDataSource;
  late MockMediaLocalDataSource mockLocalDataSource;
  late MockConnectionChecker mockConnectionChecker;

  setUp(() {
    mockRemoteDataSource = MockMediaRemoteDataSource();
    mockLocalDataSource = MockMediaLocalDataSource();
    mockConnectionChecker = MockConnectionChecker();
    repository = MediaRepositoryImpl(
      mockRemoteDataSource,
      mockLocalDataSource,
      mockConnectionChecker,
    );
  });

  group('getMedia', () {
    final testDate = DateTime.now();

    test(
        'should return data from local data source when there is no internet connection',
        () async {
      // Arrange
      when(mockConnectionChecker.isConnected).thenAnswer((_) async => false);
      // when(mockLocalDataSource.getMedia(date: anyNamed('date'))).thenReturn([
      //   MediaModel(
      //     url: 'url',
      //     title: 'Test Media',
      //     explanation: 'Test Media explanation',
      //     date: testDate,
      //     mediaType: MediaType.image,
      //   )
      // ]);

      // Act
      final result = await repository.getMedia(date: testDate);

      // Assert
      expect(
          result,
          equals(right([
            Media(
              url: 'url',
              title: 'Test Media',
              explanation: 'Test Media explanation',
              date: testDate,
              mediaType: MediaType.image,
            )
          ])));
    });

    test(
        'should return data from remote data source when there is internet connection',
        () async {
      // Arrange
      when(mockConnectionChecker.isConnected).thenAnswer((_) async => true);
      // when(mockRemoteDataSource.getMedia(any, any)).thenAnswer((_) async => [
      //       MediaModel(
      //         url: 'url',
      //         title: 'Test Media',
      //         explanation: 'Test Media explanation',
      //         date: testDate,
      //         mediaType: MediaType.image,
      //       )
      //     ]);

      // Act
      final result = await repository.getMedia(date: testDate);

      // Assert
      expect(
          result,
          equals(right([
            Media(
              url: 'url',
              title: 'Test Media',
              explanation: 'Test Media explanation',
              date: testDate,
              mediaType: MediaType.image,
            )
          ])));
    });

    test(
        'should throw ServerException when there is an error from remote data source',
        () async {
      // Arrange
      when(mockConnectionChecker.isConnected).thenAnswer((_) async => true);
      // when(mockRemoteDataSource.getMedia(any, any))
      //     .thenThrow(const ServerException('Error'));

      // Act
      final result = await repository.getMedia(date: testDate);

      // Assert
      expect(result, equals(left(const Failure('Error'))));
    });
  });
}
