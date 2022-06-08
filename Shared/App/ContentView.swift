//
//  ContentView.swift
//  Shared
//
//  Created by Luís Machado on 06/06/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            RunningPaceView()
            Spacer()
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        .backgroundColor(AppConstants.backgroundColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
