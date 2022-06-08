//
//  RowView.swift
//  RunningPaceCalculator
//
//  Created by Luís Machado on 06/06/2022.
//

import SwiftUI
import Xcore
import Combine

struct RowView: View {
    typealias LT = Localized.TimeUnits
    @ObservedObject private var viewModel: RunningPaceViewModel
    private let kind: RowType
    @State private var isDistancePickerPresented: Bool = false
    @State private var selectedDistance: String = ""

    private let distances: [String] = ["5K", "10K", "Half-Marathon", "Marathon"]

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
        CustomButton(title: "Calculate") {
            viewModel.calculate(kind: kind)
        }
        .padding(.trailing)
        .offset(y: 16)
    }


    private var header: some View {
        HStack {
            Text(kind.title)
            Spacer()
            Button {
                viewModel.eraseFields(for: kind)
            } label: {
                Image(assetIdentifier: .erase)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(24)
                    .foregroundColor(AppConstants.accentColor)
            }
        }
        .padding(.top, -6)
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

    @ViewBuilder
    private var timeRowView: some View {
        HStack {
            CustomTextField(LT.hour, text: $viewModel.timeHourValue, hightlightError: viewModel.missingFields.contains(.time))
            CustomTextField(LT.minute, text: $viewModel.timeMinutesValue, hightlightError: viewModel.missingFields.contains(.time))
            CustomTextField(LT.second, text: $viewModel.timeSecondsValue, hightlightError: viewModel.missingFields.contains(.time))
        }
    }

    @ViewBuilder
    private var distanceRowView: some View {
        HStack {
            CustomTextField(viewModel.distanceUnit.shortened, text: $viewModel.distanceValue, keyboardType: .decimalPad, width: 80, hightlightError: viewModel.missingFields.contains(.distance))
            Text("or")
            Button("Choose Event") {
                print("CHOSE EVENT")
                if selectedDistance == "" {
                    selectedDistance = Distance.allCases.first?.title ?? ""
                }
                isDistancePickerPresented = true
            }
            .foregroundColor(AppConstants.accentColor)
        }

    }

    @ViewBuilder
    private var paceRowView: some View {
        HStack {
            CustomTextField(LT.minute, text: $viewModel.paceMinuteValue, hightlightError: viewModel.missingFields.contains(.pace))
            CustomTextField(LT.second, text: $viewModel.paceSecondsValue, hightlightError: viewModel.missingFields.contains(.pace))
            Text("/ \(viewModel.distanceUnit.shortened)")
                .frame(width: 40)
                .multilineTextAlignment(.leading)
        }
    }
}

private struct CustomPickerPopup<Content: View>: View {
    private let selection: Binding<String>
    private let done: () -> Void
    private let pickerContent: () -> Content

    init(
        selection: Binding<String>,
        @ViewBuilder pickerContent: @escaping () -> Content,
        done: @escaping () -> Void
    ) {
        self.selection = selection
        self.pickerContent = pickerContent
        self.done = done
    }

    var body: some View {
        PopupSheet {
            Picker("", selection: selection, content: pickerContent)
                .pickerStyle(.wheel)
                .padding(.horizontal, .defaultSpacing)

            Button {
                print(selection.wrappedValue)
                done()
            } label: {
                Text("DONE")
            }
            .padding(.horizontal, 20)
            .deviceSpecificBottomPadding()


//            Button(action: done) {
//                Text("Done")
//            }

        }
    }
}

public struct CustomTextField: View {
    private let placeholder: String
    private let text: Binding<String>
    private let keyboardType: UIKeyboardType
    private let width: CGFloat
    private let hightlightError: Bool

    public init(
        _ placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .numberPad,
        width: CGFloat = 50,
        hightlightError: Bool = false
    ) {
        self.placeholder = placeholder
        self.text = text
        self.keyboardType = keyboardType
        self.width = width
        self.hightlightError = hightlightError
    }

    public var body: some View {
        TextField(placeholder, text: text)
            .applyIf(hightlightError) {
                $0.textFieldStyle(ErrorTextFieldStyle())
            }
            .applyIf(!hightlightError) {
                $0.textFieldStyle(CustomTextFieldStyle())
            }
            .keyboardType(keyboardType)
            .frame(width: width)
            .onReceive(Just(text.wrappedValue)) { newValue in
                let filtered = newValue.filter { "0123456789.".contains($0) }
                if filtered != newValue {
                    text.wrappedValue = filtered
                }
            }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
            .backgroundColor(.white)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(UIColor.lightGray), lineWidth: 0.2)
            )
    }
}

struct ErrorTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 10)
            .padding(.vertical, 2)
            .backgroundColor(.red.opacity(0.3))
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(.red, lineWidth: 0.2)
            )
    }
}
