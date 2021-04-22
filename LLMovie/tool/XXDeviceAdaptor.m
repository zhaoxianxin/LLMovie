//
//  XXDeviceAdaptor.m
//  LLMovie
//
//  Created by cfc-zhaoxianxin on 2021/3/12.
//

#import "XXDeviceAdaptor.h"

@implementation XXDeviceAdaptor
+ (CGFloat)adaptorSize:(CGFloat)size {
    if (XX_IPHONE) {
        CGFloat adjustSize = size * 1.15/3;
        if (XX_IPHONE_X || XX_IPHONE_6) {
            return adjustSize * 375/414;
        } else if (XX_IPHONE_6P || XX_IPHONE_XROrMax) {
            return adjustSize;
        } else if (XX_IPHONE_12) {
            return adjustSize * 390/414;
        } else if (XX_IPHONE_12_MAX ) {
            return adjustSize * 428/414;
        } else if (XX_IPHONE_12_MINI ) {
            return adjustSize * 360/414;
        } else {
            return adjustSize * 320/414;
        }
    }
    return 0;
}
@end
