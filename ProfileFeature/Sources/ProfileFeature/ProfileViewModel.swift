import Foundation
import Combine
import RxSwift
import Core

public final class ProfileViewModel: ObservableObject {
    @Published public var longestStreak: Int = 0

    private let getSessionsUseCase: GetSessionsUseCase
    private let calculateStreakUseCase: CalculateStreakUseCase
    private let disposeBag = DisposeBag()

    public init(getSessionsUseCase: GetSessionsUseCase, calculateStreakUseCase: CalculateStreakUseCase) {
        self.getSessionsUseCase = getSessionsUseCase
        self.calculateStreakUseCase = calculateStreakUseCase
    }

    public func loadStats() {
        getSessionsUseCase.execute()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] sessions in
                guard let self = self else { return }
                self.longestStreak = self.calculateStreakUseCase.execute(sessions: sessions).longestStreak
            })
            .disposed(by: disposeBag)
    }
}
