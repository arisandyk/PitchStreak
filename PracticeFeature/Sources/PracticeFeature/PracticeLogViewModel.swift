import Foundation
import Combine
import RxSwift
import Core

public final class PracticeLogViewModel: ObservableObject {
    @Published public var sessions: [PracticeSession] = []
    @Published public var streak = Streak(
        currentStreak: 0,
        longestStreak: 0,
        totalSessionsThisWeek: 0,
        totalSessionsThisMonth: 0,
        totalDurationThisWeek: 0
    )
    @Published public var isLoading = false

    private let getSessionsUseCase: GetSessionsUseCase
    private let calculateStreakUseCase: CalculateStreakUseCase
    private let disposeBag = DisposeBag()

    public init(getSessionsUseCase: GetSessionsUseCase, calculateStreakUseCase: CalculateStreakUseCase) {
        self.getSessionsUseCase = getSessionsUseCase
        self.calculateStreakUseCase = calculateStreakUseCase
    }

    public func loadSessions() {
        isLoading = true
        getSessionsUseCase.execute()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] sessions in
                guard let self = self else { return }
                self.sessions = sessions
                self.streak = self.calculateStreakUseCase.execute(sessions: sessions)
                self.isLoading = false
            }, onError: { [weak self] _ in
                self?.isLoading = false
            })
            .disposed(by: disposeBag)
    }
}
