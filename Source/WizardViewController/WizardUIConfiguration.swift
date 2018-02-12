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
import LimeConfig

public protocol WizardUIConfig: ImmutableConfig {
    
    var wizardStoryboardName: String { get }
    var wizardStoryboardBundle: Bundle { get }
    
    var wizardBackgroundColor: UIColor { get }
    var wizardMessageColor: UIColor { get }
    var wizardTitleColor: UIColor { get }
    
    var messageLabelLineSpacing: CGFloat { get }
    var titleLabelLineSpacing: CGFloat { get }
    
    var nextPageButtonTitleColor: UIColor { get }
}

public class MutableWizardUIConfig: MutableConfig, WizardUIConfig {
    
    public var wizardStoryboardName = "Wizard"
    public var wizardStoryboardBundle = Bundle.main
    
    public var wizardBackgroundColor = UIColor.init(rgb: 0xF4F4F4)
    public var wizardTitleColor = UIColor.init(rgb: 0x323A44)
    public var wizardMessageColor = UIColor.gray
    
    public var messageLabelLineSpacing: CGFloat = 1.1
    public var titleLabelLineSpacing: CGFloat = 1.1
    
    public var nextPageButtonTitleColor = UIColor.gray
    
    public func makeImmutable() -> ImmutableConfig {
        return self as WizardUIConfig
    }
}


public extension LimeConfig {
    
    /// Returns configuration for `LocalizationProvider`.
    public var uiWizard: WizardUIConfig {
        if let cfg: MutableWizardUIConfig = self.config(for: LimeConfig.domainForUiWizard) {
            return cfg
        }
        return LimeConfig.fallbackUiWizardConfig
    }
    
    /// Registers `MutableLocalizationConfiguration` to `LimeConfig` facility. You can call this method only
    /// once per LimeConfig instance, during the config's domain registration phase.
    public var registerLocalization: MutableWizardUIConfig? {
        return self.register(MutableWizardUIConfig(), for: LimeConfig.domainForUiWizard)
    }
    
    /// Domain for config registration
    private static let domainForUiWizard = "lime.ui.wizard"
    
    /// Fallback object returned when localization domain has not been properly registered.
    private static let fallbackUiWizardConfig = MutableWizardUIConfig()
}
