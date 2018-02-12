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

class WizardPageConfiguration {
	
	var illustrationImage: UIImage?
	var heading: String?
	var message: String?
	var additionalActionButtonTitle: String?
	var additionalActionButtonTapped: (()->Void)?
	
}

/// Wizard page with no action buttons. It's base class for wizard pages.
open class WizardPageViewController: BaseLocalizableViewController {

	@IBOutlet weak private var illustrationImageView: UIImageView!
	@IBOutlet weak private var topBackgroundView: UIView!
	@IBOutlet weak private var bottomBackgroundView: UIView!
	@IBOutlet weak private var titleLabel: UILabel!
	@IBOutlet weak private var messageLabel: UILabel!
	@IBOutlet weak private var additionalActionButton: UIButton!
	
	var buildWizardConfiguration: (()->WizardPageConfiguration)?
    
    override open func prepareUI() {
        self.reloadUI()
    }
	
	func reloadUI() {
		
        let uiConfig = LimeConfig.shared.uiWizard
        
		if let builder = buildWizardConfiguration {
			// Bind configuration variables
			let configuration = builder()
			self.illustrationImageView.image = configuration.illustrationImage
			self.titleLabel.text = configuration.heading
			self.messageLabel.text = configuration.message
			self.additionalActionButton.setTitle(configuration.additionalActionButtonTitle, for: .normal)
			
			// Update line spacing
			self.messageLabel.setLineSpacing(lineHeightMultiple: uiConfig.messageLabelLineSpacing)
			self.titleLabel.setLineSpacing(lineHeightMultiple: uiConfig.titleLabelLineSpacing)
		}
		
		// Apply common styles
		self.view.backgroundColor = uiConfig.wizardBackgroundColor
		self.topBackgroundView.backgroundColor = uiConfig.wizardBackgroundColor
		self.bottomBackgroundView.backgroundColor = uiConfig.wizardBackgroundColor
		self.messageLabel.textColor = uiConfig.wizardMessageColor
		self.titleLabel.textColor = uiConfig.wizardTitleColor
	}
	
	@IBAction open func doTapTopLeftButton(_ sender: UIButton) {
		if let builder = buildWizardConfiguration, let callback = builder().additionalActionButtonTapped {
			DispatchQueue.main.async {
				callback()
			}
		}
	}
	
	override open func didChangeLanguage() {
		reloadUI()
	}

}
