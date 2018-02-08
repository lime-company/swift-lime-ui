//
// Copyright 2018 Lime - HighTech Solutions s.r.o.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions
// and limitations under the License.
//

import UIKit

/// The `EmbeddedViewsTransition` protocol defines interface which allows implement
/// transition between two views, belonging to current and next embedded view controller.
public protocol EmbeddedViewsTransition : class {
    
    /// Called before the transaction begins. If the next view is valid, then it's
    /// already added into EmbeddingViewController's hierarchy.
    func prepare(current: UIView?, next: UIView?)
    
    /// Execute the transition. The implementation must call `callback` block after the
    /// transition is complete with "completed" boolean parameter.
    func execute(callback: @escaping (Bool)->Void)

    /// Cancels a pending trasition. The cancel might happen when another transition
    /// is scheduled while previous one did not finish yet.
    func cancel()
}


/// The `EmbeddingViewController` implements an easy way for embedding another controller
/// as a child-controller.
open class EmbeddingViewController: BaseLocalizableViewController {
    
    // MARK: - Controllers embedding
    
    /// Removes currently embedded controller from this controller.
    public func removeEmbeddedController(transition: EmbeddedViewsTransition? = nil, completion:(()->Void)? = nil) {
        let tr = transition ?? InstantSwitchViewsTransition()
        self.doSwitch(nil, transition: tr, completion: completion)
    }
    
    /// Embeds a new controller into this controller.
    public func embed(controller: UIViewController, transition: EmbeddedViewsTransition? = nil, completion:(()->Void)? = nil) {
        let tr = transition ?? InstantSwitchViewsTransition()
        self.doSwitch(controller, transition: tr, completion: completion)
    }
    
    // MARK: - Initial configuration
    
    /// An identifier for storyboard seque, which will be instantiated together with this instance of EmbeddingViewController.
    /// You can change this value in storyboard editor's inspector, or with using `User defined runtime attributes`.
    @IBInspectable @objc public var initialStoryboardSegueIdentifier: String?
    
    /// An identifier for storyboard scene, which will be instantiated together with this controller. You have to
    /// place the scene to the same storyboard as this instance of EmbeddingViewController.
    /// You can change this value in storyboard editor's inspector, or with using `User defined runtime attributes`.
    @IBInspectable @objc public var initialStoryboardControllerIdentifier: String?
    
    /// Private method will try to instantiate first scene, when this controller is created.
    private func instantiateFirstEmbeddedController() {
        // at first, we will try to perform an initial segue
        // then the controller may be instantiated by its storyboard identifier
        if let identifier = self.initialStoryboardSegueIdentifier {
            self.performSegue(withIdentifier: identifier, sender: nil)
        } else if let identifier = self.initialStoryboardControllerIdentifier {
            self.storyboard?.instantiateViewController(withIdentifier: identifier)
        }
        self.initialStoryboardControllerIdentifier = nil
        self.initialStoryboardSegueIdentifier = nil
    }
    
    // MARK: - View's lifecycle
    
    /// View for embedding the controllers. If the value is not set during the controller's initialization,
    /// then the self.view is assigned.
    @IBOutlet public weak var embeddingView: UIView!
    
    /// In `viewDidLoad` method, following operations are performed:
    ///  - If `self.embeddingView` is not set, then `self.view` is assigned to the property.
    ///  - Controller will try to embed a first controller, depending on `initialStoryboardSegueIdentifier`
    ///    or `initialStoryboardControllerIdentifier` properties.
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Attach embedding view to controller's view, if the value is not set
        if self.embeddingView == nil {
            self.embeddingView = self.view
        }
        // Instantiate first controller
        self.instantiateFirstEmbeddedController()
    }

    
    // MARK: - Private methods
    
    /// Currently embedded view controller.
    private weak var embeddedViewController: UIViewController?
    
    /// Transaction currently in progress
    private weak var pendingTransition: EmbeddedViewsTransition?
    
    
    private func doSwitch(_ nextController: UIViewController?, transition: EmbeddedViewsTransition, completion:(()->Void)?) {
        // Mark possible pending transition as cancelled and store the next one
        self.pendingTransition?.cancel()
        self.pendingTransition = transition
        
        let currentController = self.embeddedViewController
        self.insertNext(controller: nextController)
        transition.prepare(current: currentController?.view, next: nextController?.view)
        transition.execute { (completed) in
            self.commitNext(current: currentController, next: nextController, completed: completed)
            completion?()
        }
    }
    
    private func insertNext(controller: UIViewController?) {
        if let next = controller {
            // add as subcontroller
            next.willMove(toParentViewController: self)
            self.addChildViewController(next)
            if let parentView = self.embeddingView, let nextView = next.view {
                // add view as subview
                parentView.addSubview(nextView)
                // ...and make constraints
                let bindings = [ "nextView" : nextView ]
                nextView.translatesAutoresizingMaskIntoConstraints = false
                parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[nextView]|", options: [], metrics: nil, views: bindings))
                parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nextView]|", options: [], metrics: nil, views: bindings))
            }
        }
        if let current = self.embeddedViewController {
            current.willMove(toParentViewController: nil)
        }
    }
    
    private func commitNext(current: UIViewController?, next: UIViewController?, completed: Bool) {
        if let current = current {
            // remove current
            current.view.removeFromSuperview()
            current.removeFromParentViewController()
            current.didMove(toParentViewController: nil)
            self.embeddedViewController = nil
        }
        if let next = next {
            if completed {
                self.embeddedViewController = next
                next.didMove(toParentViewController: self)
            } else {
                // the operation did not finish
                next.didMove(toParentViewController: self)
                next.willMove(toParentViewController: nil)
                next.view .removeFromSuperview()
                next.removeFromParentViewController()
                next.didMove(toParentViewController: nil)
            }
        }
    }
}

public extension UIViewController {
    
    /// If this controller is managed by the `EmbeddingViewController` then returns its instance, or nil if there's no such
    /// controller in parent controllers hierarchy.
    public var embeddingViewController: EmbeddingViewController? {
        var controller: UIViewController? = self
        while controller != nil {
            if let embedding = controller as? EmbeddingViewController {
                return embedding
            }
            controller = controller?.parent
        }
        return nil
    }
}
