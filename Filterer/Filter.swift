import Foundation
import UIKit

public class Filter : NSObject{
    var image:UIImage!
    var rgbaImage:RGBAImage!
    
    public func setBaseImage(image:UIImage!){
        self.image = image
        self.rgbaImage = RGBAImage(image: image)
    }
    
    public func apply() {
    }
    
    public func toUIImage() -> UIImage{
        return self.rgbaImage.toUIImage()!
    }
}
