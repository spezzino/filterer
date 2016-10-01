import Foundation
import UIKit

public class Average : Filter {
    var intensity:Int = 0
    
    public override init() {
        self.intensity = 0
    }
    
    public init(intensity: Int){
        self.intensity = intensity
    }
    
    public override func apply() {
        var totalRed = 0
        var totalGreen = 0
        var totalBlue = 0
        
        for y in 0..<self.rgbaImage.height {
            for x in 0..<self.rgbaImage.width {
                let index = y * self.rgbaImage.width + x
                var pixel = self.rgbaImage.pixels[index]
                
                totalRed += Int(pixel.red)
                totalGreen += Int(pixel.green)
                totalBlue += Int(pixel.blue)
                
            }
        }
        
        let wh = self.rgbaImage.width*self.rgbaImage.height
        
        for y in 0..<self.rgbaImage.height {
            for x in 0..<self.rgbaImage.width {
                let index = y * self.rgbaImage.width + x
                var pixel = self.rgbaImage.pixels[index]
                
                let avgRed:Int = Int(totalRed/wh)
                let redDiff:Int = Int(pixel.red) - avgRed
                
                if(redDiff>0){
                    pixel.red = UInt8(max(0,min(255, avgRed + redDiff*self.intensity)))
                }
                
                let avgGren:Int = Int(totalGreen/wh)
                let greenDiff:Int = Int(pixel.green) - avgGren
                
                if(greenDiff>0){
                    pixel.green = UInt8(max(0,min(255, avgGren + greenDiff*self.intensity)))
                }
                
                let avgBlue:Int = Int(totalBlue/wh)
                let blueDiff:Int = Int(pixel.blue) - avgBlue
                
                if(blueDiff>0){
                    pixel.blue = UInt8(max(0,min(255, avgBlue + blueDiff*self.intensity)))
                }
                
                self.rgbaImage.pixels[index] = pixel
            }
        }
    }
    
    
}
