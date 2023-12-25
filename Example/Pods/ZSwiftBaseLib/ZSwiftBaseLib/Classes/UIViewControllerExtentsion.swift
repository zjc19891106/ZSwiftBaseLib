//
//  UIViewControllerExtentsion.swift
//  Pods
//
//  Created by 朱继超 on 2022/8/3.
//

import Foundation
import UIKit
import QuartzCore

public extension UIViewController {
    
    func presentViewControllerPush(_ controller: UIViewController, completion: (() -> Void)? = nil) {
        controller.modalTransitionStyle = .crossDissolve
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.superview?.layer.add(transition, forKey: "presentPush")
        if self.responds(to: #selector(self.present(_:animated:completion:))) {
            self.present(controller, animated: true, completion: completion)
        }
    }
    
    func dismissPopViewController(completion: (() -> Void)? = nil) {
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.superview?.layer.add(transition, forKey: "presentPush")
        if self.responds(to: #selector(self.dismiss(animated:completion:))) {
            self.dismiss(animated: true, completion: completion)
        }
    }
    
}
