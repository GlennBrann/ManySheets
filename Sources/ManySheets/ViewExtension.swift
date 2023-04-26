//
//  ViewExtension.swift
//  ManySheets
//
//  Created by Glenn Brannelly on 9/16/21.
//  Copyright © 2021 Glenn Brannelly. All rights reserved.
//

import Foundation
import SwiftUI

public extension View {
    
    /// A modifier to add a `DefaultBottomSheet `to your view.
    /// - Parameters:
    ///    - isOpen: A binding used to display the bottom sheet.
    ///    - style: A property containing all bottom sheet styling
    ///    - options: An array that contains the bottom sheet options
    ///    - maxWidth: The max width of the bottom sheet
    ///    - content: A ViewBuilder used to set the content of the bottom sheet.
    func defaultBottomSheet<Content: View>(
        isOpen: Binding<Bool>,
        style: DefaultBottomSheetStyle = .defaultStyle(),
        options: [DefaultBottomSheet<Content>.Options] = [],
        maxWidth: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
            DefaultBottomSheet(
                isOpen: isOpen,
                style: style,
                options: options,
                maxWidth: maxWidth,
                content: content
            )
        }
    }
    
    /// A modifier to add a `ScaffoldBottomSheet `to your view.
    /// - Parameters:
    ///    - isOpen: A binding used to display the scaffold bottom sheet.
    ///    - style: A property containing all scaffold bottom sheet styling
    ///    - options: An array that contains the bottom sheet options
    ///    - positions: A struct containing the top, middle and bottom heights as a decimal percentage
    ///    - defaultPosition: The default position the scaffold bottom sheet will be in when isOpen.
    ///    - headerContent: An optional header content view builder
    ///    - bodyContent: A ViewBuilder used to set the body content of the scaffold bottom sheet.
    func scaffoldBottomSheet<Header: View, Body: View>(
        isOpen: Binding<Bool>,
        style: ScaffoldBottomSheetStyle = .defaultStyle(),
        options: [ScaffoldBottomSheet<Header, Body>.Options] = [],
        positions: ScaffoldBottomSheetPositions = ScaffoldBottomSheetPositions(),
        defaultPosition: ScaffoldBottomSheet<Header, Body>.Position = .bottom,
        @ViewBuilder headerContent: @escaping () -> Header? = { nil },
        @ViewBuilder bodyContent: @escaping () -> Body
    ) -> some View {
        ZStack {
            self
            ScaffoldBottomSheet(
                isOpen: isOpen,
                style: style,
                options: options,
                positions: positions,
                defaultPosition: defaultPosition,
                headerContent: headerContent,
                bodyContent: bodyContent
            )
        }
    }
}


