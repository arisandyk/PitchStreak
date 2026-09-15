import SwiftUI
import HomeFeature
import PracticeFeature
import FavoriteFeature
import ProfileFeature

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView(viewModel: AppDIContainer.shared.makeHomeViewModel())
                .tabItem { Label("Beranda", systemImage: "music.note.list") }

            PracticeLogView(viewModel: AppDIContainer.shared.makePracticeLogViewModel())
                .tabItem { Label("Latihan", systemImage: "figure.mixed.cardio") }

            FavoriteView(viewModel: AppDIContainer.shared.makeFavoriteViewModel())
                .tabItem { Label("Favorit", systemImage: "heart") }

            ProfileView(viewModel: AppDIContainer.shared.makeProfileViewModel())
                .tabItem { Label("Profil", systemImage: "person") }
        }
    }
}
