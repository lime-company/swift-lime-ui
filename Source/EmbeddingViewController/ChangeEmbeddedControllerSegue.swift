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
import LimeCore

/// An universal segue for switching embedded controllers. You can adjust the presentation mode
/// in `prepare(for segue:sender:)` method.
public class ChangeEmbeddedControllerSegue: UIStoryboardSegue {
    
    /// The `TransitionMode` enumeration defines supported transition types
    public enum TransitionMode {
        /// The switch will be performed instantly
        case instant
        /// The crossfade effect will be used for transition
        case crossfade
    }
    
    /// The `Configuration` class affects how the embedded controllers transition will be performed.
    public class Configuration {
        
        /// Defines transition mode
        public let transitionMode: TransitionMode
        
        /// Duration for animation, applied only when transition mode is animated
        public let animationDuration: TimeInterval
        
        /// You can use this property for passing additional data between `performSegue()` and `prepare(for...)`
        /// methods.
        public let sender: Any?
        
        /// An optional block called before the animation is executed.
        public var prepareAdditionalAnimations: (()->Void)?
        
        /// An optional block called inside the animation block.
        public var executeAdditionalAnimations: (()->Void)?
        
        /// Designated initializer
        public init(_ transitionMode: TransitionMode = .instant, animationDuration: TimeInterval = 0.35, sender: Any? = nil) {
            self.transitionMode = transitionMode
            self.animationDuration = animationDuration
            self.sender = sender
        }
    }
    
    /// A configuration for segue execution.
    public var configuration: Configuration?
    
    /// Performs execution of the segue
    override public func perform() {
        guard let controller = self.source.embeddingViewController else {
            D.print("ChangeEmbeddedControllerSegue: Cannot perform segue due to missing EmbeddingViewController.")
            return
        }
        
        // Prepare views transition object
        let mode = self.configuration?.transitionMode ?? .instant
        let duration = self.configuration?.animationDuration ?? 0.35
        var viewsTransition: EmbeddedViewsBaseTransition
        switch mode {
        case .instant:
            viewsTransition = InstantSwitchViewsTransition()
        case .crossfade:
            viewsTransition = CrossfadeViewsTransition(duration: duration)
        }
        viewsTransition.additionalPrepareBlock = self.configuration?.prepareAdditionalAnimations
        viewsTransition.additionalExecuteBlock = self.configuration?.executeAdditionalAnimations
        
        // Execute that transition
        controller.embed(controller: self.destination, transition: viewsTransition)
    }
}
