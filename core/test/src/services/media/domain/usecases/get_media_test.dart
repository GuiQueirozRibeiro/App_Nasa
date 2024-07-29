// Mock classes
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Core module imports
import 'package:core/src/enums/media_type.dart';
import 'package:core/src/services/media/domain/entities/media.dart';
import 'package:core/src/services/media/domain/repository/media_repository.dart';
import 'package:core/src/services/media/domain/usecases/get_media.dart';
import 'package:core/src/usecase/no_params.dart';

// Mock classes
class MockMediaRepository extends Mock implements MediaRepository {}

void main() {
  late GetMedia useCase;
  late MockMediaRepository mockRepository;

  setUp(() {
    mockRepository = MockMediaRepository();
    useCase = GetMedia(mockRepository);
  });

  final mediaList = [
    Media(
      url: 'url',
      title: 'Test Media',
      explanation: 'Test Media explanation',
      date: DateTime.now(),
      mediaType: MediaType.image,
    ),
  ];

  test('should get media from the repository', () async {
    // Arrange
    // when(mockRepository.getMedia(date: anyNamed('date')))
    //     .thenAnswer((_) async => right(mediaList));

    // Act
    final result = await useCase(const NoParams());

    // Assert
    expect(result, right(mediaList));
    // verify(mockRepository.getMedia(date: anyNamed('date')));
    verifyNoMoreInteractions(mockRepository);
  });
}
