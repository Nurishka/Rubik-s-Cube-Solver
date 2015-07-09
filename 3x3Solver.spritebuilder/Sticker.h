//
//  Sticker.h
//  3x3Solver
//
//  Created by Tom on 7/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Sticker : CCNode // the class is only used for visualisation of the cube

@property (nonatomic, strong) CCNodeColor *sticker;

- (void)setStickerColorInt:(int)color;

@end
