//
//  BottomSheetPresenter.swift
//  Newton2
//
//  Created by Brannelly, Glenn on 10/5/21.
//

import SwiftUI

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
class BottomSheetPresenterViewController<Content: View>: UIViewController {
    @Binding var isPresented: Bool

    private let detents: [UISheetPresentationController.Detent]
    private let prefersGrabberVisible: Bool
    private let prefersScrollingExpandsWhenScrolledToEdge: Bool
    private let prefersEdgeAttachedInCompactHeight: Bool
    private let widthFollowsPreferredContentSizeWhenEdgeAttached: Bool
    private let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    private let content: UIHostingController<Content>

    init(
        isPresented: Binding<Bool>,
        detents: [UISheetPresentationController.Detent] = [.medium(), .large()],
        showHandleBar: Bool = false,
        scrollExapandEdges: Bool = true,
        edgeAttachedInCompactHeight: Bool = false,
        widthFollowsPreferredContentSizeWhenEdgeAttached: Bool = false,
        largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
        isModalInPresentation: Bool = false,
        content: Content
    ) {
        self._isPresented = isPresented
        self.detents = detents
        self.prefersGrabberVisible = showHandleBar
        self.prefersScrollingExpandsWhenScrolledToEdge = scrollExapandEdges
        self.prefersEdgeAttachedInCompactHeight = edgeAttachedInCompactHeight
        self.widthFollowsPreferredContentSizeWhenEdgeAttached = widthFollowsPreferredContentSizeWhenEdgeAttached
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.content = UIHostingController(rootView: content)
        super.init(nibName: nil, bundle: nil)
        self.isModalInPresentation = isModalInPresentation
    }

    required init?(coder: NSCoder) {
        fatalError("No Storyboards")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(content)
        view.addSubview(content.view)
        content.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            content.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            content.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            content.view.topAnchor.constraint(equalTo: view.topAnchor),
            content.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        if let sheetController = self.presentationController as? UISheetPresentationController {
            sheetController.detents = detents
            sheetController.prefersGrabberVisible = prefersGrabberVisible
            sheetController.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
            sheetController.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
            sheetController.widthFollowsPreferredContentSizeWhenEdgeAttached = widthFollowsPreferredContentSizeWhenEdgeAttached
            sheetController.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isPresented = false
    }
}
