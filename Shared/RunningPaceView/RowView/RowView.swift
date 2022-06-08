//
//  RowView.swift
//  RunningPaceCalculator
//
//  Created by Luís Machado on 06/06/2022.
//

import SwiftUI
import Xcore

struct RowView: View {
    typealias LT = Localized.TimeUnits
    typealias L = Localized.Row
    @ObservedObject private var viewModel: RunningPaceViewModel
    private let kind: RowType
    @State private var isDistancePickerPresented: Bool = false
    @State private var selectedDistance: String = Distance.allDistances.first ?? ""

    public init(viewModel: RunningPaceViewModel, kind: RowType) {
        self.viewModel = viewModel
        self.kind = kind
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 4) {
                header
                content
                    .padding(.bottom)
            }
            .padding()
            .backgroundColor(AppConstants.backgroundColor)
            .tiled()

            calculateButton
        }
        .popup(isPresented: $isDistancePickerPresented, style: .sheet) {
            CustomPickerPopup(selection: $selectedDistance) {
                ForEach(Distance.allDistances, id: \.self) { distance in
                    Text(distance)
                }
            } done: {
                viewModel.setDistanceFromPicker(stringValue: selectedDistance)
                isDistancePickerPresented = false
            }
        }
    }

    private var calculateButton: some View {
        CustomButton(title: L.calculate) {
            viewModel.calculate(kind: kind)
        }
        .padding(.trailing)
        .offset(y: 16)
    }


    private var header: some View {
        HStack {
            Text(kind.title)
                .fontWeight(.semibold)
            Spacer()
            Button {
                viewModel.eraseFields(for: kind)
            } label: {
                Image(assetIdentifier: .erase)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(20)
                    .foregroundColor(AppConstants.accentColor)
            }
        }
        .padding(.top, -6)
        .padding(.horizontal, -6)
    }

    @ViewBuilder
    private var content: some View {
        switch kind {
            case .time:
                timeRowView
            case .distance:
                distanceRowView
            case .pace:
                paceRowView
        }
    }
}

extension RowView {
    @ViewBuilder
    private var timeRowView: some View {
        HStack {
            CustomTextField(
                LT.hour,
                text: $viewModel.timeHourValue,
                hightlightError: viewModel.missingFields.contains(.time)
            )

            CustomTextField(
                LT.minute,
                text: $viewModel.timeMinutesValue,
                hightlightError: viewModel.missingFields.contains(.time)
            )

            CustomTextField(
                LT.second,
                text: $viewModel.timeSecondsValue,
                hightlightError: viewModel.missingFields.contains(.time)
            )
        }
    }

    @ViewBuilder
    private var distanceRowView: some View {
        HStack {
            CustomTextField(
                viewModel.distanceUnit.shortened,
                text: $viewModel.distanceValue,
                keyboardType: .decimalPad,
                width: 80,
                hightlightError: viewModel.missingFields.contains(.distance)
            )

            Text(L.Distance.or)

            Button(L.Distance.choose) {
                isDistancePickerPresented = true
            }
            .foregroundColor(AppConstants.accentColor)
        }
    }

    @ViewBuilder
    private var paceRowView: some View {
        HStack {
            CustomTextField(
                LT.minute,
                text: $viewModel.paceMinuteValue,
                hightlightError: viewModel.missingFields.contains(.pace)
            )

            CustomTextField(LT.second,
                            text: $viewModel.paceSecondsValue,
                            hightlightError: viewModel.missingFields.contains(.pace)
            )

            Text("/ \(viewModel.distanceUnit.shortened)")
                .frame(width: 40)
                .multilineTextAlignment(.leading)
        }
    }
}
