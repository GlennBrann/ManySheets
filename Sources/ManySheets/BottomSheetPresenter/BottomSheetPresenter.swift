//
//  BottomSheetPresenter.swift
//  ManySheets
//
//  Created by Glenn Brannelly on 10/05/21.
//  Copyright © 2021 Glenn Brannelly. All rights reserved.
//

import SwiftUI

@available(iOS 15, *)
struct BottomSheetPresenter<T: Any, BodyContent: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    let detents: [UISheetPresentationController.Detent]
    let showHandleBar: Bool
    let scrollExapandEdges: Bool
    let edgeAttachedInCompactHeight: Bool
    let widthFollowsPreferredContentSizeWhenEdgeAttached: Bool
    let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    let isModalInPresentation: Bool
    let bodyContent: BodyContent
    
    @State private var bottomSheetPresenterVC: BottomSheetPresenterViewController<BodyContent>?
    
    private var topMostVC: UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
        
        if var topController = keyWindow?.rootViewController {
            while let presentedVC = topController.presentedViewController {
                topController = presentedVC
            }
            return topController
        }
        return nil
    }
    
    init(
        isPresented: Binding<Bool>,
        detents: [UISheetPresentationController.Detent] = [.medium(), .large()],
        showHandleBar: Bool = false,
        scrollExapandEdges: Bool = true,
        edgeAttachedInCompactHeight: Bool = false,
        widthFollowsPreferredContentSizeWhenEdgeAttached: Bool = false,
        largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
        isModalInPresentation: Bool = false,
        @ViewBuilder content: () -> BodyContent
    ) {
        self._isPresented = isPresented
        self.detents = detents
        self.showHandleBar = showHandleBar
        self.scrollExapandEdges = scrollExapandEdges
        self.edgeAttachedInCompactHeight = edgeAttachedInCompactHeight
        self.widthFollowsPreferredContentSizeWhenEdgeAttached = widthFollowsPreferredContentSizeWhenEdgeAttached
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.isModalInPresentation = isModalInPresentation
        self.bodyContent = content()
    }
    
    func body(content: Content) -> some View {
        bottomSheetContent(content)
    }
    
    private func bottomSheetContent(_ content: Content) -> some View {
        content
            .onChange(of: isPresented) { presented in
                if presented {
                    bottomSheetPresenterVC = BottomSheetPresenterViewController(
                        isPresented: $isPresented,
                        detents: detents,
                        showHandleBar: showHandleBar,
                        scrollExapandEdges: scrollExapandEdges,
                        edgeAttachedInCompactHeight: edgeAttachedInCompactHeight,
                        widthFollowsPreferredContentSizeWhenEdgeAttached: widthFollowsPreferredContentSizeWhenEdgeAttached,
                        largestUndimmedDetentIdentifier: largestUndimmedDetentIdentifier,
                        isModalInPresentation: isModalInPresentation,
                        content: bodyContent
                    )
                    bottomSheetPresenterVC?.modalPresentationStyle = .pageSheet
                    topMostVC?.present(bottomSheetPresenterVC!, animated: true)
                } else {
                    bottomSheetPresenterVC?.dismiss(animated: true)
                }
            }
    }
    
}

@available(iOS 15, *)
extension View {
    public func bottomSheetPresenter<Content: View>(
        isPresented: Binding<Bool>,
        detents: [UISheetPresentationController.Detent] = [.medium(), .large()],
        showHandleBar: Bool = false,
        scrollExapandEdges: Bool = true,
        edgeAttachedInCompactHeight: Bool = false,
        widthFollowsPreferredContentSizeWhenEdgeAttached: Bool = false,
        largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
        isModalInPresentation: Bool = false,
        @ViewBuilder content: () -> Content
    ) -> some View {
        self.modifier(
            BottomSheetPresenter<Any, Content>(
                isPresented: isPresented,
                detents: detents,
                showHandleBar: showHandleBar,
                scrollExapandEdges: scrollExapandEdges,
                edgeAttachedInCompactHeight: edgeAttachedInCompactHeight,
                widthFollowsPreferredContentSizeWhenEdgeAttached: widthFollowsPreferredContentSizeWhenEdgeAttached,
                largestUndimmedDetentIdentifier: largestUndimmedDetentIdentifier,
                isModalInPresentation: isModalInPresentation,
                content: content
            )
        )
    }
}
