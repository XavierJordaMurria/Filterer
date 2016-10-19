import UIKit

public struct Transformations
{
    public var mRgbaImg: RGBAImage
    public var mTotals:Totals
    
    public init(rgbaIMG: RGBAImage, totals:Totals)
    {
        mRgbaImg   = rgbaIMG
        mTotals = totals
    }
    
    /**
     * Converts a RGB RGBAImage in a greyScale UIImage.
        @params: percentage of grey scale to aply to the RGBAImage. from 0 to 1.
        @return: UIImage with the filter.
     **/
    public mutating func rgb2grey(greyIntensity:Double)-> UIImage?
    {
        for y in 0..<mRgbaImg.height
        {
            for x in 0..<mRgbaImg.width
            {
                let index = y * mRgbaImg.width + x
                var pixel = mRgbaImg.pixels[index]

                let grey = Double((Int(pixel.red) + Int(pixel.green) + Int(pixel.blue))/3)*greyIntensity
                
                pixel.red = UInt8(grey + Double(pixel.red)*(1-greyIntensity))
                pixel.green = UInt8(grey + Double(pixel.green)*(1-greyIntensity))
                pixel.blue  = UInt8(grey + Double(pixel.blue)*(1-greyIntensity))
                
                mRgbaImg.pixels[index] = pixel
            }
        }
        
        return mRgbaImg.toUIImage()
    }
    
    public mutating func brightness(intensity:Int)-> UIImage?
    {
        for y in 0..<mRgbaImg.height
        {
            for x in 0..<mRgbaImg.width
            {
                let index = y * mRgbaImg.width + x
                var pixel = mRgbaImg.pixels[index]
                
                pixel.red = truncate(value: Int(pixel.red) + intensity)
                pixel.green = truncate(value: Int(pixel.green) + intensity)
                pixel.blue  = truncate(value: Int(pixel.blue) + intensity)
                
                mRgbaImg.pixels[index] = pixel
            }
        }
        
        return mRgbaImg.toUIImage()
    }

    public mutating func rgb2Rgrey()-> UIImage?
    {
        for y in 0..<mRgbaImg.height
        {
            for x in 0..<mRgbaImg.width
            {
                let index = y * mRgbaImg.width + x
                var pixel = mRgbaImg.pixels[index]
                
                if(Int(pixel.red) < mTotals.RedAvg/2 )
                {
                    let grey = UInt8( ((Int(pixel.red) + Int(pixel.green) + Int(pixel.blue))/3))
                    pixel.red = grey
                    pixel.green = grey
                    pixel.blue  = grey
                }
                
                mRgbaImg.pixels[index] = pixel
            }
        }
        
        return mRgbaImg.toUIImage()
    }
    
    private func truncate(value:Int)->UInt8
    {
        var val:Int = value
        
        if(val > 250)
            {val = 250}
        else if (val < 0)
            {val = 0}

        return UInt8(val)
    }
}
