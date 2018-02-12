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

public class UIUtilities {
    
    public static func imageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(rect)
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                return image
            } else {
                UIGraphicsEndImageContext()
                return nil
            }
        } else {
            UIGraphicsEndImageContext()
            return nil
        }
    }
    
    public static func tintedImageWithColor(originalImage: UIImage?, color: UIColor) -> UIImage? {
        if let image = originalImage {
            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
            let context = UIGraphicsGetCurrentContext()!
            let rect = CGRect(origin: CGPoint.zero, size: image.size)
            color.setFill()
            image.draw(in: rect)
            context.setBlendMode(.sourceIn)
            context.fill(rect)
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return resultImage
        } else {
            return nil
        }
    }
    
}
