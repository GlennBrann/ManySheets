//
//  ContentView.swift
//  ManySheetsExample
//
//  Created by Glenn Brannelly on 2/2/22.
//

import SwiftUI
import ManySheets

struct ContentView: View {
    @State var showSheet: Bool = false
    
    let bottomSheetStyle = DefaultBottomSheetStyle(backgroundColor: .white)
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: { showSheet.toggle() },
                       label: { Text("Show Default Sheet") })
            }
        }
        .defaultBottomSheet(
            isOpen: $showSheet,
            style: bottomSheetStyle,
            options: [.enableHandleBar, .tapAwayToDismiss, .swipeToDismiss]
        ) {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Image(systemName: "info.circle")
                    Text("Photos attached must be of cats and cats only")
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.bottom, 4)
                Button(
                    action: { },
                    label: {
                        HStack {
                            Image(systemName: "camera")
                                .foregroundColor(Color.blue)
                            Text("Take a photo")
                        }
                    }
                )
                    .frame(height: 44)
                Button(
                    action: { },
                    label: {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                                .foregroundColor(Color.blue)
                            Text("Choose a photo")
                        }
                    }
                )
                    .frame(height: 44)
            }
            .padding()
            .padding(.bottom, 16)
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
