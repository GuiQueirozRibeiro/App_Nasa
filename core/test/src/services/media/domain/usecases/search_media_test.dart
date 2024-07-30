// Mock classes
import 'package:core/src/services/media/domain/usecases/search_media.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Core module imports
import 'package:core/src/enums/media_type.dart';
import 'package:core/src/services/media/domain/entities/media.dart';
import 'package:core/src/services/media/domain/repository/media_repository.dart';

// Mock classes
class MockMediaRepository extends Mock implements MediaRepository {}

void main() {
  late SearchMedia useCase;
  late MockMediaRepository mockRepository;

  setUp(() {
    mockRepository = MockMediaRepository();
    useCase = SearchMedia(mockRepository);
  });

  const tQuery = 'test';
  final tMediaList = [
    Media(
      url: 'url',
      title: 'Test Media',
      explanation: 'Test Media explanation',
      date: DateTime.now(),
      mediaType: MediaType.image,
    ),
  ];

  final tParams = SearchMediaParams(query: tQuery, mediaList: tMediaList);

  test('should get media from the repository', () async {
    // Arrange
    // when(mockRepository.searchMedia(
    //         query: anyNamed('query'), mediaList: anyNamed('query')))
    //     .thenAnswer((_) async => const Right(<Media>[]));

    // Act
    final result = await useCase(tParams);

    // Assert
    expect(result, isA<List<Media>>());
    // verify(mockRepository.getMedia(date: anyNamed('date')));
    verifyNoMoreInteractions(mockRepository);
  });
}
