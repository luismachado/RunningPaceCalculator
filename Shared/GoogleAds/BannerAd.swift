//
//  BannerAd.swift
//  RunningPaceCalculator (iOS)
//
//  Created by Luís Machado on 09/06/2022.
//

import SwiftUI
import GoogleMobileAds

struct SwiftUIBannerAd: View {
    @State var height: CGFloat = 0 //Height of ad
    @State var width: CGFloat = 0 //Width of ad
    let adUnitId: String

    init(adUnitId: String) {
        self.adUnitId = adUnitId
    }

    enum AdPosition {
        case top
        case bottom
    }

    public var body: some View {
        //Ad
        BannerAd(adUnitId: adUnitId)
            .frame(width: width, height: height, alignment: .center)
            .onAppear {
                //Call this in .onAppear() b/c need to load the initial frame size
                //.onReceive() will not be called on initial load
                setFrame()
            }
            //Changes the frame of the ad whenever the device is rotated.
            //This is what creates the adaptive ad
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                setFrame()
            }
    }

    func setFrame() {
        //Get the frame of the safe area
        let safeAreaInsets = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero
        let frame = UIScreen.main.bounds.inset(by: safeAreaInsets)

        //Use the frame to determine the size of the ad
        let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(frame.width)

        //Set the ads frame
        self.width = adSize.size.width
        self.height = adSize.size.height
    }
}
