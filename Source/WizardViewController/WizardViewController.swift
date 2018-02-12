//
// Copyright 2017 Lime - HighTech Solutions s.r.o.
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
import LimeLocalization
import LimeConfig

public protocol WizardViewControllerDataSource {
	func wizardStoryboard() -> UIStoryboard?
	func wizardViewControllers() -> [UIViewController]?
}

open class WizardViewController: UIPageViewController, WizardViewControllerDataSource, Localizable {
	
	fileprivate var nextButton: UIButton?
	
	var localizationHelper = LocalizationHelper()
	
	private(set) lazy var orderedViewControllers: [UIViewController] = {
		if let viewControllers = self.wizardViewControllers() {
			return viewControllers
		} else {
			return []
		}
	}()
	
	func buildWizardScreenPlain(configuration: @escaping (()->WizardPageConfiguration)) -> WizardPageViewController {
		let controller = newViewController(identifier: "BasicWizardPage") as! WizardPageViewController
		controller.buildWizardConfiguration = configuration
		return controller
	}
	
	func buildWizardScreenButton(configuration: @escaping (()->CTAWizardPageConfiguration)) -> CTAWizardPageViewController {
		let controller = newViewController(identifier: "CTAWizardPage") as! CTAWizardPageViewController
		controller.buildWizardConfiguration = configuration
		return controller
	}
	
	func buildWizardScreenTwoButtons(configuration: @escaping (()->CTAAlternativeWizardPageConfiguration)) -> CTAAlternativePageViewController {
		let controller = newViewController(identifier: "CTAAlternativeWizardPage") as! CTAAlternativePageViewController
		controller.buildWizardConfiguration = configuration
		return controller
	}

	private func newViewController(identifier: String) -> UIViewController {
		if let wizardStoryboard = self.wizardStoryboard() {
			return wizardStoryboard.instantiateViewController(withIdentifier: identifier)
		} else {
			return UIViewController()
		}
	}
	
	func wizardName() -> String? {
		return nil
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		localizationHelper.attach(target: self)
		self.addNextPageButton()
	}
	
    open override func viewDidLoad() {
        super.viewDidLoad()
		self.dataSource = self
		self.delegate = self
		self.view.backgroundColor = LimeConfig.shared.uiWizard.wizardBackgroundColor
		self.reset()
    }
	
	public func reset() {
		if let firstViewController = self.orderedViewControllers.first {
			self.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
		}
	}
	
	public func goToScreen(index: NSInteger, animated: Bool) {
		if (index >= 0 && index < orderedViewControllers.count) {
			DispatchQueue.main.async {
				self.setViewControllers([self.orderedViewControllers[index]], direction: .forward, animated: true, completion: nil)
			}
		}
	}
	
	public func goToScreen(index: NSInteger) {
		goToScreen(index: index, animated: true)
	}
	
	public func wizardStoryboard() -> UIStoryboard? {
        let config = LimeConfig.shared.uiWizard
		return UIStoryboard(name: config.wizardStoryboardName, bundle: config.wizardStoryboardBundle)
	}
	
	public func wizardViewControllers() -> [UIViewController]? {
		return nil
	}
	
	private func addNextPageButton() {
		nextButton = UIButton(type: .roundedRect)
		if let button = nextButton {
			let size = self.view.bounds.size
			button.center = CGPoint(x: self.view.center.x, y: self.view.frame.size.height - 80)
			button.contentHorizontalAlignment = .right
            // TODO: layout defined in code... that's wrong!
			button.setTitleColor(LimeConfig.shared.uiWizard.nextPageButtonTitleColor, for: .normal)
			button.frame = CGRect(x: size.width - 100, y: size.height - 40, width: 80, height: 40)
			self.view.addSubview(button)
		}
	}
	
	public func didChangeLanguage() {
		self.title = wizardName()
		nextButton?.setTitle("common.next".localized, for: .normal)
	}
	
	public func updateLocalizedStrings() {
		self.title = wizardName()
		nextButton?.setTitle("common.next".localized, for: .normal)
	}

}

extension WizardViewController: UIPageViewControllerDataSource,UIPageViewControllerDelegate {
	
	public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		
		guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
			return nil
		}
		
		let previousIndex = viewControllerIndex - 1
		
		guard previousIndex >= 0 else {
			return nil
		}
		
		guard orderedViewControllers.count > previousIndex else {
			return nil
		}
		
		return orderedViewControllers[previousIndex]
		
	}
	
	public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		
		guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
			return nil
		}
		
		let nextIndex = viewControllerIndex + 1
		let orderedViewControllersCount = orderedViewControllers.count
		
		guard orderedViewControllersCount != nextIndex else {
			return nil
		}
		
		guard orderedViewControllersCount > nextIndex else {
			return nil
		}
		
		return orderedViewControllers[nextIndex]
	}
	
	public func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return orderedViewControllers.count
	}
	
	
	public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		
		guard let firstViewController = viewControllers?.first,
			let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
				return 0
		}
		return firstViewControllerIndex
	}
	
	public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
		if let lastViewController = orderedViewControllers.last {
			if (pendingViewControllers.contains(lastViewController)) {
				UIView.animate(withDuration: 0.25, animations: {
					self.nextButton?.alpha = 0.0
				})
			}
		}
	}
	
	public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		if let lastViewController = orderedViewControllers.last {
			if (completed && (previousViewControllers.contains(lastViewController))) {
				UIView.animate(withDuration: 0.25, animations: {
					self.nextButton?.alpha = 1.0
				})
			}
		}
	}
	
}
