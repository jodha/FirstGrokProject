import SwiftUI

struct ChipInventorySectionView: View {
    @Bindable var viewModel: TournamentSetupViewModel

    var body: some View {
        Section("Your Available Chips") {
            ForEach(viewModel.chipDenominations.indices, id: \.self) { index in
                ChipQuantityRowView(
                    denomination: viewModel.chipDenominations[index].value,
                    count: $viewModel.chipDenominations[index].count,
                    onCountChange: { viewModel.calculateTournament() }
                )
            }
        }
    }
}
