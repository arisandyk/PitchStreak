import SwiftUI
import Combine
import DesignSystem

public struct FavoriteView: View {
    @StateObject private var viewModel: FavoriteViewModel

    public init(viewModel: FavoriteViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.favorites) { favorite in
                    FavoriteRowView(favorite: favorite)
                }
                .onDelete { indexSet in
                    indexSet.map { viewModel.favorites[$0] }.forEach(viewModel.removeFavorite)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Lagu favorit")
        }
        .onAppear { viewModel.loadFavorites() }
    }
}
