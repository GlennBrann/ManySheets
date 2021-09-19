//
//  DefaultBottomSheet.swift
//  ManySheets
//
//  Created by Glenn Brannelly on 9/16/21.
//  Copyright © 2021 Glenn Brannelly. All rights reserved.
//

import SwiftUI

extension DefaultBottomSheet {
    public enum Options: Equatable {
        /// Adds a handle bar to our bottom sheet
        case enableHandleBar
        /// Blocks the user from interacting with view behind bottom sheet
        case blockContent
        /// Tapping outside of the sheet will trigger a dismissal (blocks content by default)
        case tapAwayToDismiss
        /// Adds a shadow behind the bottom sheet. Can be modified via BottomSheetStyle
        case enableShadow
        /// Adds swipe gesture support - swiping the view down will trigger a dismissal
        case swipeToDismiss
    }
}

// MARK: - DefaultBottomSheet.Option flags

extension DefaultBottomSheet {
    private var hasHandleBar: Bool {
        options.contains(.enableHandleBar)
    }
    
    private var tapAwayToDismiss: Bool {
        options.contains(.tapAwayToDismiss)
    }
    
    private var blockContent: Bool {
        options.contains(.blockContent)
    }
    
    private var hasShadow: Bool {
        options.contains(.enableShadow)
    }
    
    private var swipeToDismiss: Bool {
        options.contains(.swipeToDismiss)
    }
}

// MARK: - DefaultBottomSheetView

public struct DefaultBottomSheet<Content: View>: View {

    @Binding var isOpen: Bool
    
    let style: BottomSheetStyle
    
    let options: [DefaultBottomSheet.Options]
    
    let content: Content

    @State var contentSize: CGSize = .zero
    
    @State private var previousDragValue: DragGesture.Value?
    
    public init(
        isOpen: Binding<Bool>,
        style: BottomSheetStyle = .defaultStyle(),
        options: [DefaultBottomSheet.Options] = [],
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isOpen = isOpen
        self.style = style
        self.options = options
        self.content = content()
    }
    
    public var body: some View {
        ZStack {
            GeometryReader { proxy in
                if isOpen, (tapAwayToDismiss || blockContent) {
                    dimmingView
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .onTapGesture { if tapAwayToDismiss { isOpen = false } }
                }
                VStack(spacing: 0) {
                    if hasHandleBar {
                        dragBar
                            .frame(width: proxy.size.width, height: style.handleBarHeight)
                            .background(style.backgroundColor)
                            .padding(.top, 4)
                    }
                    content
                }
                .background(
                    GeometryReader { proxy in
                        Color.clear.preference(key: SizePreferenceKey.self, value: proxy.size)
                    }
                )
                .onPreferenceChange(SizePreferenceKey.self) {
                    self.contentSize = $0
                }
                .frame(width: proxy.size.width,
                       height: contentSize.height + proxy.safeAreaInsets.bottom,
                       alignment: .bottom)
                .background(style.backgroundColor)
                .cornerRadius(style.cornerRadius, corners: [.topLeft, .topRight])
                .frame(height: proxy.size.height, alignment: .bottom)
                .animation(.interactiveSpring(), value: contentSize)
                .animation(style.openAnimation, value: isOpen)
                .offset(y: isOpen ? 0 : contentSize.height)
                .shadow(color: hasShadow ? style.shadowColor : .clear,
                        radius: style.shadowRadius, x: style.shadowX, y: style.shadowY)
                .gesture(dragGesture())
            }
            .edgesIgnoringSafeArea(.vertical)
        }
    }
    
    private var dragBar: some View {
        RoundedRectangle(cornerRadius: 5.0 / 2.0)
            .frame(width: 40, height: 5.0)
            .foregroundColor(style.handleBarColor)
    }
    
    private var dimmingView: some View {
        Rectangle()
            .fill(style.dimmingColor.opacity(0.25))
            .contentShape(Rectangle())
    }
}

// MARK: - DragGesture onDragChanged & onDragEnded extensions

extension DefaultBottomSheet {
    
    private func dragGesture() -> _EndedGesture<_ChangedGesture<DragGesture>> {
        DragGesture(minimumDistance: 0.1, coordinateSpace: .local)
            .onChanged(onDragChanged)
            .onEnded(onDragEnded)
    }
    
    private func onDragChanged(drag: DragGesture.Value) {
        guard isOpen, swipeToDismiss else { return }
        let yOffset = drag.translation.height
        
        guard let previousValue = previousDragValue else {
            previousDragValue = drag
            return
        }
        
        let previousOffsetY = previousValue.translation.height
        let timeDiff = Double(drag.time.timeIntervalSince(previousValue.time))
        let heightDiff = Double(yOffset - previousOffsetY)
        let yVelocity = heightDiff / timeDiff
        if yVelocity > 1200 {
            isOpen = false
            return
        }
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        guard isOpen, swipeToDismiss else { return }
        let yOffset = drag.translation.height
        if yOffset > contentSize.height * 0.2 {
            isOpen = false
        }
    }
}
