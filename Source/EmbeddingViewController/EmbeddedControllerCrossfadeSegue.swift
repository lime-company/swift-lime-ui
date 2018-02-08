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

/// A crossfade between source and destination controller.
public class EmbeddedControllerCrossfadeSegue: UIStoryboardSegue {
    
    @IBInspectable public var crossfadeDuration: TimeInterval = 0.3
    
    override public func perform() {
        guard let controller = self.source.embeddingViewController else {
            D.print("EmbeddedControllerCrossfadeSegue: Cannot perform segue due to missing EmbeddingViewController.")
            return
        }
        let tr = CrossfadeViewsTransition(duration: crossfadeDuration)
        controller.embed(controller: self.destination, transition: tr)
    }
}
