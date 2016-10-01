import Foundation
import UIKit

public class Grayscale : Filter {
    
    public override init(){
    }
    
    public override func apply() {
        for y in 0..<self.rgbaImage.height {
            for x in 0..<self.rgbaImage.width {
                let index = y * self.rgbaImage.width + x
                var pixel = self.rgbaImage.pixels[index]
                
                let avg = UInt8((Int(pixel.red) + Int(pixel.green) + Int(pixel.blue))/3)
                
                pixel.red = avg
                pixel.green = avg
                pixel.blue = avg
                
                self.rgbaImage.pixels[index] = pixel
            }
        }
    }
    
    
}
