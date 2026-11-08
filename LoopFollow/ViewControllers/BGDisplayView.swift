// LoopFollow
// BGDisplayView.swift

import SwiftUI

struct BGDisplayView: View {
    @ObservedObject var serverText = Observable.shared.serverText
    @ObservedObject var bgText = Observable.shared.bgText
    @ObservedObject var bgTextColor = Observable.shared.bgTextColor
    @ObservedObject var bgStale = Observable.shared.bgStale
    @ObservedObject var directionText = Observable.shared.directionText
    @ObservedObject var deltaText = Observable.shared.deltaText
    @ObservedObject var minAgoText = Observable.shared.minAgoText
    @ObservedObject var loopStatusText = Observable.shared.loopStatusText
    @ObservedObject var loopStatusColor = Observable.shared.loopStatusColor
    @ObservedObject var predictionText = Observable.shared.predictionText
    @ObservedObject var isNotLooping = Observable.shared.isNotLooping
    @ObservedObject var cgmSensorState = Observable.shared.cgmSensorState
    @ObservedObject var retro = RetroSelection.shared

    var onRefresh: (() -> Void)?

    var body: some View {
        // While scrubbing the chart, the display shows the scrubbed time.
        let snapshot = retro.snapshot
        let isStale = snapshot == nil && bgStale.value

        ScrollView {
            VStack(spacing: 0) {
                Text(serverText.value)
                    .font(.system(size: 13))

                Text(snapshot?.bgText ?? bgText.value)
                    .font(.system(size: 85, weight: .black))
                    .foregroundColor(snapshot?.bgColor ?? bgTextColor.value)
                    .strikethrough(
                        isStale,
                        pattern: .solid,
                        color: isStale ? .red : .clear
                    )
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)

                HStack {
                    Text(snapshot?.directionText ?? directionText.value)
                        .font(.system(size: 60, weight: .black))
                    Text(snapshot?.deltaText ?? deltaText.value)
                        .font(.system(size: 32))
                }
                .foregroundColor(.babyPinkSoft)
                .lineLimit(1)
                .minimumScaleFactor(0.5)

                Text(minAgoText.value)
                    .font(.system(size: 17))
                    .foregroundColor(.babyPinkSoft)

                if isNotLooping.value {
                    Text(loopStatusText.value)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(loopStatusColor.value)
                        .frame(maxWidth: .infinity)
                } else {
                    Text(minAgoText.value)
                        .font(.system(size: 17))

                    if let state = cgmSensorState.value {
                        Text("CGM: \(state.summary)")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.orange)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }

                    if isNotLooping.value {
                        Text(loopStatusText.value)
                            .foregroundColor(.babyPinkSoft)
                        Text(predictionText.value)
                            .foregroundColor(.babyPinkSoft)
                        Spacer()
                    }
                }
            }
        }
        .background {
            if snapshot != nil {
                RetroCardBackground()
            }
        }
        .refreshable {
            onRefresh?()
        }
    }
}
