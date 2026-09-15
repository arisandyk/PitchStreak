import Foundation
import Combine
import RxSwift
import Core

public final class TimerViewModel: ObservableObject {
    @Published public var selectedType: PracticeType = .vocalWarmUp
    @Published public var searchQuery: String = ""
    @Published public var searchResults: [Song] = []
    @Published public var selectedSong: Song?
    @Published public var elapsedSeconds: Int = 0
    @Published public var isRunning = false
    @Published public var notes: String = ""
    @Published public var didSave = false

    private let searchSongUseCase: SearchSongUseCase
    private let saveSessionUseCase: SaveSessionUseCase
    private let ensureSongFavoritedUseCase: EnsureSongFavoritedUseCase
    private let disposeBag = DisposeBag()
    private var timerDisposable: Disposable?
    private let searchQuerySubject = PublishSubject<String>()

    public init(
        searchSongUseCase: SearchSongUseCase,
        saveSessionUseCase: SaveSessionUseCase,
        ensureSongFavoritedUseCase: EnsureSongFavoritedUseCase,
        preselectedSong: Song? = nil
    ) {
        self.searchSongUseCase = searchSongUseCase
        self.saveSessionUseCase = saveSessionUseCase
        self.ensureSongFavoritedUseCase = ensureSongFavoritedUseCase
        self.selectedSong = preselectedSong
        bindSearch()
        if let song = preselectedSong {
            ensureSongFavoritedUseCase.execute(song: song).subscribe().disposed(by: disposeBag)
        }
    }

    private func bindSearch() {
        searchQuerySubject
            .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { [searchSongUseCase] query in
                searchSongUseCase.execute(query: query)
                    .catchAndReturn([])
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] results in
                self?.searchResults = results
            })
            .disposed(by: disposeBag)
    }

    public func onSearchQueryChanged(_ query: String) {
        searchQuery = query
        selectedSong = nil
        searchQuerySubject.onNext(query)
    }

    public func selectSong(_ song: Song) {
        selectedSong = song
        searchResults = []
        searchQuery = ""
        ensureSongFavoritedUseCase.execute(song: song)
            .subscribe()
            .disposed(by: disposeBag)
    }

    public func clearSelectedSong() {
        selectedSong = nil
        searchQuery = ""
    }

    public func toggleTimer() {
        isRunning ? pauseTimer() : startTimer()
    }

    private func startTimer() {
        isRunning = true
        timerDisposable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.elapsedSeconds += 1
            })
        timerDisposable?.disposed(by: disposeBag)
    }

    private func pauseTimer() {
        isRunning = false
        timerDisposable?.dispose()
    }

    public func saveSession() {
        pauseTimer()
        let session = PracticeSession(
            id: UUID(),
            date: Date(),
            durationSeconds: elapsedSeconds,
            practiceType: selectedType,
            song: selectedSong,
            notes: notes.isEmpty ? nil : notes
        )
        saveSessionUseCase.execute(session)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.didSave = true
            })
            .disposed(by: disposeBag)
    }
}
