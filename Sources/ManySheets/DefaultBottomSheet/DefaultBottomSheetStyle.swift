//
//  DefaultBottomSheet.swift
//  ManySheets
//
//  Created by Glenn Brannelly on 9/16/21.
//  Copyright © 2021 Glenn Brannelly. All rights reserved.
//

import SwiftUI

public struct DefaultBottomSheetStyle {
    public let backgroundColor: Color
    public let cornerRadius: CGFloat
    public let dimmingColor: Color
    public let handleBarColor: Color
    public let handleBarHeight: CGFloat
    public let shadowColor: Color
    public let shadowRadius: CGFloat
    public let shadowX: CGFloat
    public let shadowY: CGFloat
    public let openAnimation: Animation
    
    public init(
        backgroundColor: Color = Color.white,
        cornerRadius: CGFloat = 8.0,
        dimmingColor: Color = Color.black,
        handleBarColor: Color = Color.gray,
        handleBarHeight: CGFloat = 8.0,
        shadowColor: Color = Color.black.opacity(0.25),
        shadowRadius: CGFloat = 10.0,
        shadowX: CGFloat = 0.0,
        shadowY: CGFloat = -5.0,
        openAnimation: Animation = .spring(response: 0.5, dampingFraction: 0.9, blendDuration: 0.75)
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.dimmingColor = dimmingColor
        self.handleBarColor = handleBarColor
        self.handleBarHeight = handleBarHeight
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowX = shadowX
        self.shadowY = shadowY
        self.openAnimation = openAnimation
    }
}

// MARK: - Default BottomSheet style extension

extension DefaultBottomSheetStyle {
    public static func defaultStyle() -> DefaultBottomSheetStyle {
        DefaultBottomSheetStyle(
            backgroundColor: Color.white,
            cornerRadius: 8.0,
            dimmingColor: Color.black,
            handleBarColor: Color.gray,
            handleBarHeight: 8.0,
            shadowColor: Color.black.opacity(0.25),
            shadowRadius: 10.0,
            shadowX: 0.0,
            shadowY: -5.0,
            openAnimation: .spring(response: 0.5, dampingFraction: 0.9, blendDuration: 0.75)
        )
    }
}
