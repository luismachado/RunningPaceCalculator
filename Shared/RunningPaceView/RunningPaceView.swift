//
//  RunningPaceView.swift
//  RunningPaceCalculator
//
//  Created by Luís Machado on 06/06/2022.
//

import SwiftUI
import Xcore
import GoogleMobileAds

struct RunningPaceView: View {
    typealias LA = Localized.Alert.MissingFields
    @ObservedObject private var viewModel: RunningPaceViewModel
    @State private var isOptionsShowing: Bool = false
    public init() {
        viewModel = RunningPaceViewModel()
    }

    var body: some View {
        VStack {
            NavigationLink(destination: OptionsView(), isActive: $isOptionsShowing) { }
            header
            content
            ad
        }
        .vAlign(.top)
        .padding()
        .alert(isPresented: $viewModel.showMissingFieldsAlert) {
            Alert(
                title: Text(LA.title),
                message: Text(viewModel.missingFieldsAlertMessage ?? "")
            )
        }
        .onAppear(perform: viewModel.onAppear)
        .navigationBarHidden(true)
    }

    private var header: some View {
        HStack {
            Text(Localized.RunningPaceView.title)
                .font(.title)

            Spacer()

            Button {
                isOptionsShowing = true
            } label: {
                Image(assetIdentifier: .cog)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(24)
                    .foregroundColor(AppConstants.accentColor)
            }
        }
    }

    @ViewBuilder
    private var ad: some View {
        Spacer()
        SwiftUIBannerAd(adUnitId: AdConstants.live.bannerAdId)
        Spacer()
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
