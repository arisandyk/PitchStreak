import Foundation
import Swinject
import Core
import HomeFeature
import PracticeFeature
import FavoriteFeature
import ProfileFeature

final class AppDIContainer {
    static let shared = AppDIContainer()

    private let container = Container()

    private init() {
        registerViewModels()
    }

    private func registerViewModels() {
        container.register(HomeViewModel.self) { _ in HomeFeatureFactory.makeHomeViewModel() }
        container.register(PracticeLogViewModel.self) { _ in PracticeFeatureFactory.makePracticeLogViewModel() }
        container.register(FavoriteViewModel.self) { _ in FavoriteFeatureFactory.makeFavoriteViewModel() }
        container.register(ProfileViewModel.self) { _ in ProfileFeatureFactory.makeProfileViewModel() }
    }

    func makeHomeViewModel() -> HomeViewModel {
        container.resolve(HomeViewModel.self)!
    }

    func makePracticeLogViewModel() -> PracticeLogViewModel {
        container.resolve(PracticeLogViewModel.self)!
    }

    func makeFavoriteViewModel() -> FavoriteViewModel {
        container.resolve(FavoriteViewModel.self)!
    }

    func makeProfileViewModel() -> ProfileViewModel {
        container.resolve(ProfileViewModel.self)!
    }
}
