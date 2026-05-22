import SwiftUI

struct BlindTimerDisplayView: View {
    @Bindable var timerModel: LiveTournamentTimerModel

    var body: some View {
        VStack(spacing: 16) {
            timerLabel
            BlindTimerAdjustButtonsView(timerModel: timerModel)
            BlindTimerPauseResumeView(timerModel: timerModel)
        }
    }

    private var timerLabel: some View {
        Text(BlindTimerFormatter.format(seconds: timerModel.timeRemainingSeconds))
            .font(.system(size: 72, weight: .bold, design: .monospaced))
            .foregroundStyle(timerModel.isRunning ? .green : .primary)
    }
}
