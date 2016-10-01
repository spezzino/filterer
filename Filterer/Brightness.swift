import Foundation
import UIKit

public class Brightness : Filter {
    var brightness: Float = 0
    
    public override init(){
        self.brightness = 0
    }
    
    public init(brightness:Float){
        self.brightness = max(-1,min(1,brightness))
    }
    
    public override func apply() {
        for y in 0..<self.rgbaImage.height {
            for x in 0..<self.rgbaImage.width {
                let index = y * self.rgbaImage.width + x
                var pixel = self.rgbaImage.pixels[index]
                
                let factor = Int(255*self.brightness)
                
                pixel.red = UInt8(max(0,min(255,Int(pixel.red) + factor)))
                pixel.green = UInt8(max(0,min(255,Int(pixel.green) + factor)))
                pixel.blue = UInt8(max(0,min(255,Int(pixel.blue) + factor)))
                self.rgbaImage.pixels[index] = pixel
            }
        }
    }
    
    
}
