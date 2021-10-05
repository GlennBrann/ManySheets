//
//  BottomSheetPresenterViewController.swift
//  ManySheets
//
//  Created by Glenn Brannelly on 10/05/21.
//  Copyright © 2021 Glenn Brannelly. All rights reserved.
//

import SwiftUI
import UIKit

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
