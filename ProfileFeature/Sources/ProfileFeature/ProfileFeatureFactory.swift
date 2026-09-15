import Foundation
import Core

public enum ProfileFeatureFactory {
    public static func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(
            getSessionsUseCase: GetSessionsUseCaseImpl(repository: CoreDependencies.sessionRepository),
            calculateStreakUseCase: CalculateStreakUseCaseImpl()
        )
    }
}
