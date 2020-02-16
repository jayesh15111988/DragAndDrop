//
//  ViewController.swift
//  DrapAndDrop
//
//  Created by Jayesh Kawli on 1/29/20.
//  Copyright © 2020 Jayesh Kawli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private struct Constants {
        static let padding: CGFloat = 10
        static let blockDimension: CGFloat = 50
    }

    var trashView: UIView?
    var beginningPosition: CGPoint = .zero
    var initialMovableViewPosition: CGPoint = .zero

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addMovableViews(count: 4)
        addTrashView()
    }

    private func addMovableViews(count: Int) {
        var xOffset = Constants.padding
        for _ in 0..<count {
            let movableView = UIView(frame: CGRect(x: xOffset, y: 64, width: Constants.blockDimension, height: Constants.blockDimension))
            movableView.backgroundColor = .green
            view.addSubview(movableView)
            let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(touched(_:)))
            movableView.addGestureRecognizer(gestureRecognizer)
            xOffset += Constants.blockDimension + Constants.padding
        }
    }

    private func addTrashView() {
        trashView = UIView(frame: CGRect(x: view.frame.width - Constants.padding - Constants.blockDimension, y: view.frame.height - Constants.padding - Constants.blockDimension, width: Constants.blockDimension, height: Constants.blockDimension))
        trashView?.backgroundColor = .red
        view.addSubview(trashView!)
    }

    @objc private func touched(_ gestureRecognizer: UIGestureRecognizer) {
        if let touchedView = gestureRecognizer.view {
            if gestureRecognizer.state == .began {
                beginningPosition = gestureRecognizer.location(in: touchedView)
                initialMovableViewPosition = touchedView.frame.origin
            } else if gestureRecognizer.state == .ended {
                touchedView.frame.origin = initialMovableViewPosition
            } else if gestureRecognizer.state == .changed {
                let locationInView = gestureRecognizer.location(in: touchedView)
                touchedView.frame.origin = CGPoint(x: touchedView.frame.origin.x + locationInView.x - beginningPosition.x, y: touchedView.frame.origin.y + locationInView.y - beginningPosition.y)
                if touchedView.frame.intersects(trashView!.frame) {
                    touchedView.removeFromSuperview()
                    initialMovableViewPosition = .zero
                }
            }
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
