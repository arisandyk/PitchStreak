import Foundation
import Combine
import RxSwift
import Core

public final class HomeViewModel: ObservableObject {
    @Published public var songs: [Song] = []
    @Published public var isLoading = false
    @Published public var errorMessage: String?

    private let getTopSongsUseCase: GetTopSongsUseCase
    private let disposeBag = DisposeBag()

    public init(getTopSongsUseCase: GetTopSongsUseCase) {
        self.getTopSongsUseCase = getTopSongsUseCase
    }

    public func loadTopSongs() {
        isLoading = true
        errorMessage = nil
        getTopSongsUseCase.execute()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] songs in
                self?.songs = songs
                self?.isLoading = false
            }, onError: { [weak self] _ in
                self?.isLoading = false
                self?.errorMessage = "Gagal memuat chart lagu. Coba lagi."
            })
            .disposed(by: disposeBag)
    }
}
