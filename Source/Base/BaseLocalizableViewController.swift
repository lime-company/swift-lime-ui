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
import LimeLocalization

open class BaseLocalizableViewController: UIViewController, Localizable {
	
	private let localizationHelper = LocalizationHelper()
	
	override open func viewDidLoad() {
		super.viewDidLoad()
		// Register for language changes (calls updateLocalizedStrings())
		localizationHelper.attach(target: self)
		// Update UI
		prepareUI()
	}
	
	deinit {
		// Unsubscribe all notifications
		NotificationCenter.default.removeObserver(self)
	}
	
	// MARK: - UI Customization
	
	open func prepareUI() {
		// You can override this method and put all UI customization code here
		// It is recommended to update colors for labels, buttons and other
		// components managed in your controller from this method.
	}
	
	// MARK: - Localization
	
	open func updateLocalizedStrings() {
		// You can override this method and put all localization code here
		// It is recommended to update labels, buttons and other components
		// managed in your controller from this method.
	}
	
	open func didChangeLanguage() {
		// You can override this method and catch only language change event.
		// You can for example reload your table view if reload guarantees
		// that all strings will be updated.
		//
		// This method is called before `updateLocalizedStrings` and only when
		// the language is actually changed.
	}
	
}
