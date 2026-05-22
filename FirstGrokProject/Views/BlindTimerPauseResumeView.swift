import SwiftUI

struct BlindTimerPauseResumeView: View {
    @Bindable var timerModel: LiveTournamentTimerModel

    var body: some View {
        Button(buttonTitle) {
            timerModel.toggleRunning()
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .frame(maxWidth: .infinity)
    }

    private var buttonTitle: String {
        timerModel.isRunning ? "Pause" : "Resume"
    }
}
