//
//  UIImage+LaunchImage.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/3/3.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "UIImage+LaunchImage.h"

static const char* GetScaleSuffix(float scale, float maxScale)
{
    if (scale > maxScale)
        scale = maxScale;
    if (scale <= 1.0)
        return "";
    if (scale <= 2.0)
        return "@2x";
    return "@3x";
}


@implementation UIImage (LaunchImage)

+ (UIImage *)launchImage:(BOOL)isPortrait
{
    bool orientPortrait  = isPortrait;
    bool orientLandscape = !isPortrait;
    
    bool rotateToPortrait  = isPortrait;
    bool rotateToLandscape = !isPortrait;
    
    const char* orientSuffix = "";
    CGSize size = [[UIScreen mainScreen] bounds].size;
    bool _isOrientable = UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone || (size.height == 736 || size.width == 736);
    
    bool _ios70orNewer = [[[UIDevice currentDevice] systemVersion] compare: @"7.0" options: NSNumericSearch] != NSOrderedAscending;
    
    if (_isOrientable)
    {
        if (orientPortrait && rotateToPortrait)
            orientSuffix = "-Portrait";
        else if (orientLandscape && rotateToLandscape)
            orientSuffix = "-Landscape";
        else if (rotateToPortrait)
            orientSuffix = "-Portrait";
        else
            orientSuffix = "-Landscape";
    }
    
    NSString* imageName;
    
    {
        // Old launch image from file
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
        {
            // iPads
            const char* iOSSuffix = _ios70orNewer ? "-700" : "";
            const char* scaleSuffix = GetScaleSuffix([UIScreen mainScreen].scale, 2.0);
            imageName = [NSString stringWithFormat:@"LaunchImage%s%s%s~ipad",
                         iOSSuffix, orientSuffix, scaleSuffix];
        }
        else
        {
            // iPhones
            float scale = [UIScreen mainScreen].scale;
            const char* scaleSuffix = GetScaleSuffix(scale, 3.0);
            const char* iOSSuffix = _ios70orNewer ? "-700" : "";
            const char* rezolutionSuffix = "";
            CGSize size = [[UIScreen mainScreen] bounds].size;
            
            if (size.height == 568 || size.width == 568) // iPhone5
                rezolutionSuffix = "-568h";
            else if (size.height == 667 || size.width == 667) // iPhone6
            {
                rezolutionSuffix = "-667h";
                iOSSuffix = "-800";
                
                if (scale > 2.0) // iPhone6+ in display zoom mode
                    scaleSuffix = "@2x";
            }
            else if (size.height == 736 || size.width == 736) // iPhone6+
            {
                rezolutionSuffix = "-736h";
                iOSSuffix = "-800";
            }
            imageName = [NSString stringWithFormat:@"LaunchImage%s%s%s%s",
                         iOSSuffix, orientSuffix, rezolutionSuffix, scaleSuffix];
        }
        
        NSString* imagePath = [[NSBundle mainBundle] pathForResource: imageName ofType: @"png"];
        
        UIImage* image = [UIImage imageWithContentsOfFile: imagePath];
        
        
        return image;
    }
    
}

@end
