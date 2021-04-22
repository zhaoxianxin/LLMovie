//
//  JKAdapterLabel.m
//  AlertAssemble
//
//  Created by 四威 on 2016/8/5.
//  Copyright © 2016年 JeanKyle. All rights reserved.
//

#import "JKAdapterLabel.h"
#import "UIView+JKAlert.h"
#import "NSString+JKAlert.h"

@implementation JKAdapterLabel

- (instancetype)initWithText:(NSString *)text font:(UIFont *)font maxWitdth:(CGFloat)maxWidth {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] init];
        label.text = text;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.font = font;
        label.textAlignment = NSTextAlignmentCenter;
        
        CGFloat textRealWidth = [text widthWithFont:font];
        CGFloat textRealHight = [text heightWithWidth:maxWidth font:font];
        label.jk_width = textRealWidth <= maxWidth ? textRealWidth : maxWidth;
        label.jk_height = textRealWidth <= maxWidth ? font.lineHeight : textRealHight;
        self.jk_size = label.jk_size;
        
        [self addSubview:label];
    }
    return self;
}

@end
