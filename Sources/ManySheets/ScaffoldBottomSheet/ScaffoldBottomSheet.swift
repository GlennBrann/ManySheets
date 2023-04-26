//
//  ScaffoldBottomSheet.swift
//  ManySheets
//
//  Created by Glenn Brannelly on 9/16/21.
//  Copyright © 2021 Glenn Brannelly. All rights reserved.
//

import Foundation
import SwiftUI

public struct ScaffoldBottomSheetPositions {
    public let top: CGFloat
    public let middle: CGFloat
    public let bottom: CGFloat
    
    public init(
        top: CGFloat = 1.0,
        middle: CGFloat = 0.5,
        bottom: CGFloat = 0.125
    ) {
        self.top = top
        self.middle = middle
        self.bottom = bottom
    }
}

extension ScaffoldBottomSheet {
    public enum Position {
        case top
        case middle
        case bottom
    }
}

extension ScaffoldBottomSheet {
    public enum Options: Equatable {
        /// Adds a handle bar to our bottom sheet
        case enableHandleBar
        /// Blocks the user from interacting with view behind bottom sheet
        case tapAwayToDismiss
        /// Disables the shadow behind the bottom sheet. Shadows can be modified via ScaffoldBottomSheetStyle
        case disableShadow
        /// Disables the scroll view functionality when the sheet is fully open
        case disableScroll
        
        case swipeToDismiss
    }
}

// MARK: - ScaffoldBottomSheet.Option flags

extension ScaffoldBottomSheet {
    private var hasHandleBar: Bool {
        options.contains(.enableHandleBar)
    }
    
    private var tapAwayToDismiss: Bool {
        options.contains(.tapAwayToDismiss)
    }
    
    private var shadowDisabled: Bool {
        options.contains(.disableShadow)
    }
    
    private var scrollDisabled: Bool {
        options.contains(.disableScroll)
    }
    
    private var swipeToDismiss: Bool {
        options.contains(.swipeToDismiss)
    }
}


public struct ScaffoldBottomSheet<Header: View, Body: View>: View {
    
    @Binding var isOpen: Bool
    
    let style: ScaffoldBottomSheetStyle
    
    let options: [ScaffoldBottomSheet.Options]
    
    let positions: ScaffoldBottomSheetPositions
    
    let defaultPosition: Position
    
    let headerContent: Header?
    
    let bodyContent: Body
    
    var topSafeArea: CGFloat {
        (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
    }
    
    var bottomSafeArea: CGFloat {
        (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
    }
    
    @State var position: CGFloat = UIScreen.main.bounds.height
    
    @State private var shouldScroll: Bool = false
    
    @GestureState private var dragState = DragState.inactive
    
    enum DragState {
        case inactive
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
        
        var isDragging: Bool {
            switch self {
            case .inactive:
                return false
            case .dragging:
                return true
            }
        }
    }
    
    public init(
        isOpen: Binding<Bool>,
        style: ScaffoldBottomSheetStyle = .defaultStyle(),
        options: [ScaffoldBottomSheet.Options] = [],
        positions: ScaffoldBottomSheetPositions = ScaffoldBottomSheetPositions(),
        defaultPosition: ScaffoldBottomSheet.Position = .bottom,
        @ViewBuilder headerContent: @escaping () -> Header? = { nil },
        @ViewBuilder bodyContent: @escaping () -> Body
    ) {
        self._isOpen = isOpen
        self.style = style
        self.options = options
        self.positions = positions
        self.defaultPosition = defaultPosition
        self.headerContent = headerContent()
        self.bodyContent = bodyContent()
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                if isOpen, tapAwayToDismiss {
                    Rectangle()
                        .fill(Color.black.opacity(0.2))
                        .edgesIgnoringSafeArea(.all)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onTapGesture { isOpen = false }
                }
                VStack(spacing: 0) {
                    if hasHandleBar {
                        dragBar
                            .frame(width: proxy.size.width, height: style.handleBarHeight)
                            .background(style.backgroundColor)
                            .padding(.top, 4)
                    }
                    if let header = headerContent {
                        header
                    }
                    if !scrollDisabled {
                        ScrollView(.vertical, showsIndicators: false) {
                            bodyContent
                                .frame(
                                    width: proxy.size.width,
                                    height: max(proxy.size.height - (!dragState.isDragging ? position : 0.0), 0.0),
                                    alignment: .top
                                )
                        }
                    } else {
                        bodyContent
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .top)
                .background(style.backgroundColor)
                .cornerRadius(style.cornerRadius, corners: [.topLeft, .topRight])
                .offset(y: isOpen ? position + dragState.translation.height : proxy.size.height + proxy.safeAreaInsets.bottom)
                .animation(dragState.isDragging ? nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                .shadow(color: !shadowDisabled ? style.shadowColor : .clear,
                        radius: style.shadowRadius, x: style.shadowX, y: style.shadowY)
                .gesture(
                    DragGesture()
                        .updating($dragState) { drag, state, transaction in
                            let topEdge = position + state.translation.height
                            if topEdge > topSafeArea {
                                state = .dragging(translation: drag.translation)
                            }
                        }
                        .onEnded({ drag in
                            onDragEnded(drag: drag, height: proxy.size.height)
                        })
                )
            }
            .onChange(of: isOpen) { value in
                if isOpen {
                    switch defaultPosition {
                    case .top:
                        position = getSheetPosition(height: proxy.size.height, position: .top)
                    case .middle:
                        position = getSheetPosition(height: proxy.size.height, position: .middle)
                    case .bottom:
                        position = getSheetPosition(height: proxy.size.height, position: .bottom)
                    }
                } else {
                    position = UIScreen.main.bounds.height
                }
            }
        }
    }
    
    private func getSheetPosition(height: CGFloat, position: Position) -> CGFloat {
        switch position {
        case .top:
            return height - (height * positions.top) + topSafeArea
        case .middle:
            return height - (height * positions.middle)
        case .bottom:
            return height - (height * positions.bottom) - bottomSafeArea
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

// MARK: - DragGesture onDragEnded extension

extension ScaffoldBottomSheet {

    private func onDragEnded(drag: DragGesture.Value, height: CGFloat) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        let topEdge = position + drag.translation.height
        
        let topPosition = getSheetPosition(height: height, position: .top)
        let middlePosition = getSheetPosition(height: height, position: .middle)
        let bottomPosition = getSheetPosition(height: height, position: .bottom)
        
        var positionAbove: CGFloat = .zero
        var positionBelow: CGFloat = .zero
        var closestPosition: CGFloat = .zero
        shouldScroll = false

        if topEdge <= middlePosition {
            positionAbove = topPosition
            positionBelow = middlePosition
        } else {
            positionAbove = middlePosition
            positionBelow = bottomPosition
        }

        if (topEdge - positionAbove) < (positionBelow - topEdge) {
            closestPosition = positionAbove
        } else {
            closestPosition = positionBelow
        }

        if verticalDirection > 0 { // Downwards
            if topEdge > bottomPosition, swipeToDismiss {
                position = height
                isOpen = false
                return
            }
            position = positionBelow
        } else if verticalDirection < 0 { // Upwards
            if topEdge <= topPosition, !scrollDisabled {
                shouldScroll = true
            }
            position = positionAbove
        } else {
            if topEdge <= topPosition, !scrollDisabled {
                shouldScroll = true
            }
            position = closestPosition
        }
    }
    
}

// MARK: - SizePreferenceKey

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        _ = nextValue()
    }
}
