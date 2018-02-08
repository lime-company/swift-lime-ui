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

open class EmbeddedViewsBaseTransition: EmbeddedViewsTransition {
    
    weak var current: UIView?
    weak var next: UIView?
    
    var additionalPrepareBlock: (()->Void)?
    var additionalExecuteBlock: (()->Void)?
    var isCancel = false
    
    open func prepare(current: UIView?, next: UIView?) {
        self.current = current
        self.next = next
        self.additionalPrepareBlock?()
    }
    
    open func execute(callback: @escaping (Bool) -> Void) {
        self.additionalExecuteBlock?()
        callback(true)
    }
    
    open func cancel() {
        self.isCancel = true
    }
}
