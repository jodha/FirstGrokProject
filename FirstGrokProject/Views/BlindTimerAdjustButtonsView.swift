import SwiftUI

struct BlindTimerAdjustButtonsView: View {
    @Bindable var timerModel: LiveTournamentTimerModel

    var body: some View {
        HStack(spacing: 16) {
            adjustButton(label: "−1m", delta: -60)
            adjustButton(label: "−30s", delta: -30)
            adjustButton(label: "+30s", delta: 30)
            adjustButton(label: "+1m", delta: 60)
        }
    }

    private func adjustButton(label: String, delta: Int) -> some View {
        Button(label) {
            timerModel.adjustTime(by: delta)
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
    }
}
