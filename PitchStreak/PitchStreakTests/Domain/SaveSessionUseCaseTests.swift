import Testing
import Foundation
import RxSwift
import Core

struct SaveSessionUseCaseTests {
    @Test func saveSessionWithSong_savesSessionAndIncrementsUsageCount() {
        let sessionRepository = MockSessionRepository()
        let songRepository = MockSongRepository()
        let sut = SaveSessionUseCaseImpl(sessionRepository: sessionRepository, songRepository: songRepository)
        let disposeBag = DisposeBag()

        let song = Song(id: "123", title: "Test Song", artist: "Test Artist", artworkURL: nil)
        let session = PracticeSession(id: UUID(), date: Date(), durationSeconds: 120, practiceType: .songPractice, song: song, notes: nil)

        sut.execute(session)
            .subscribe()
            .disposed(by: disposeBag)

        #expect(sessionRepository.savedSessions.count == 1)
        #expect(sessionRepository.savedSessions.first?.id == session.id)
        #expect(songRepository.incrementedSongIds == ["123"])
    }

    @Test func saveSessionWithoutSong_savesSessionWithoutIncrementingUsage() {
        let sessionRepository = MockSessionRepository()
        let songRepository = MockSongRepository()
        let sut = SaveSessionUseCaseImpl(sessionRepository: sessionRepository, songRepository: songRepository)
        let disposeBag = DisposeBag()

        let session = PracticeSession(id: UUID(), date: Date(), durationSeconds: 60, practiceType: .vocalWarmUp, song: nil, notes: nil)

        sut.execute(session)
            .subscribe()
            .disposed(by: disposeBag)

        #expect(sessionRepository.savedSessions.count == 1)
        #expect(songRepository.incrementedSongIds.isEmpty)
    }
}

// MARK: - Mocks

private final class MockSessionRepository: SessionRepository {
    var savedSessions: [PracticeSession] = []

    func saveSession(_ session: PracticeSession) -> Observable<Void> {
        savedSessions.append(session)
        return .just(())
    }
    func getAllSessions() -> Observable<[PracticeSession]> { .just(savedSessions) }
    func getSessions(from startDate: Date, to endDate: Date) -> Observable<[PracticeSession]> { .just(savedSessions) }
    func deleteSession(id: UUID) -> Observable<Void> {
        savedSessions.removeAll { $0.id == id }
        return .just(())
    }
}

private final class MockSongRepository: SongRepository {
    var incrementedSongIds: [String] = []

    func searchSongs(query: String) -> Observable<[Song]> { .just([]) }
    func getTopSongs() -> Observable<[Song]> { .just([]) }
    func getFavoriteSongs() -> Observable<[FavoriteSong]> { .just([]) }
    func addFavorite(_ song: Song) -> Observable<Void> { .just(()) }
    func removeFavorite(id: String) -> Observable<Void> { .just(()) }
    func incrementUsageCount(songId: String) -> Observable<Void> {
        incrementedSongIds.append(songId)
        return .just(())
    }
    func isFavorite(songId: String) -> Observable<Bool> { .just(false) }
}
