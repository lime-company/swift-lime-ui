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

/// Wizard page with call to action button
///   for example: "please activate the application. - button activation"
class CTAWizardPageConfiguration: WizardPageConfiguration {
	
	var buttonTitle: String?
	var buttonTapped: (()->Void)?
	
}

open class CTAWizardPageViewController: WizardPageViewController {
	
	@IBOutlet weak var callToActionButton: UIButton!
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		self.reloadUI()
	}
	
	open override func reloadUI() {
		super.reloadUI()
		if let builder = buildWizardConfiguration {
			guard let configuration = builder() as? CTAWizardPageConfiguration else {
				return
			}
			self.callToActionButton.setTitle(configuration.buttonTitle, for: .normal)
		}
	}
	
	@IBAction func doTapButton(_ sender: UIButton) {
		if let builder = buildWizardConfiguration {
			guard let configuration = builder() as? CTAWizardPageConfiguration else {
				return
			}
			if let callback = configuration.buttonTapped {
				DispatchQueue.main.async {
					callback()
				}
			}
		}
	}
	
}
