//
//  Sticker.m
//  3x3Solver
//
//  Created by Tom on 7/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Sticker.h"
typedef NS_ENUM(NSInteger, color)
{
    none, green, blue, white, yellow, red, orange
};

@implementation Sticker
{
    CCNodeColor *_sticker;
}

- (void)setStickerColorInt:(int)color
{
    switch (color) {
        case green:
            _sticker.color = [CCColor colorWithRed:0.f green:0.62f blue:0.376f];
            break;
            
        case blue:
            _sticker.color = [CCColor colorWithRed:0.f green:0.318f blue:0.729f];
            break;
            
        case white:
            _sticker.color = [CCColor whiteColor];
            break;
            
        case yellow:
            _sticker.color = [CCColor colorWithRed:1.f green:0.835f blue:0.f];
            break;
            
        case red:
            _sticker.color = [CCColor colorWithRed:0.769f green:0.118f blue:0.227f];
            break;
            
        case orange:
            _sticker.color = [CCColor colorWithRed:1.f green:0.33f blue:0.f];
            break;
    }
}

@end
