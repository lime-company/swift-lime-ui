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

open class CrossfadeViewsTransition: EmbeddedViewsBaseTransition {
    
    let duration: TimeInterval
    
    public init(duration: TimeInterval = 0.3) {
        self.duration = duration
    }
    
    open override func prepare(current: UIView?, next: UIView?) {
        super.prepare(current: current, next: next)
        current?.alpha = 1
        next?.alpha = 0
    }
    
    open override func execute(callback: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: self.duration, delay: 0, options: .curveEaseInOut, animations: {
            super.current?.alpha = 0
            super.next?.alpha = 1
            super.additionalExecuteBlock?()
        }) { (completed) in
            callback(!self.isCancel)
        }
    }
}
