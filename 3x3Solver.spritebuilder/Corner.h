//
//  Corner.h
//  3x3Solver
//
//  Created by Tom on 7/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Corner : NSObject <NSCopying>

@property (nonatomic, assign) int orientation; // 0 - correct, 1 - clockwise, 2 - counterclockwise
@property (nonatomic, assign) int targetPermutation;
@property (nonatomic, strong) NSArray *colors;

- (instancetype)initWithTargetPermutation:(int)targetPermutation;
@end
