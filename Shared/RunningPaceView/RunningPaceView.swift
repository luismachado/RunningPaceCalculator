//
//  RunningPaceView.swift
//  RunningPaceCalculator
//
//  Created by Luís Machado on 06/06/2022.
//

import SwiftUI
import Xcore

struct RunningPaceView: View {
    @ObservedObject private var viewModel: RunningPaceViewModel

    public init() {
        viewModel = RunningPaceViewModel()
    }

    var body: some View {
        VStack {
            header
            content
        }
        .vAlign(.top)
        .padding()
    }

    private var header: some View {
        HStack {
            Text(Localized.RunningPaceView.title)
                .font(.title)

            Spacer()

            Button {
                print("Options")
            } label: {
                Image(assetIdentifier: .cog)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(24)
                    .foregroundColor(AppConstants.accentColor)
            }
        }
    }

    private var content: some View {
        VStack(spacing: 30) {
            RowView(viewModel: viewModel, kind: .time)
            RowView(viewModel: viewModel, kind: .distance)
            RowView(viewModel: viewModel, kind: .pace)
        }
        .padding(.top)
    }
}

#if DEBUG

// MARK: - Previews

struct RunningPaceView_Previews: PreviewProvider {
    static var previews: some View {
        RunningPaceView()
    }
}
#endif
