//
//  Edge.h
//  3x3Solver
//
//  Created by Tom on 7/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Edge : NSObject <NSCopying>

@property (nonatomic, assign) int orientation; // 0 - not flipped, 1 - flipped
@property (nonatomic, assign) int targetPermutation; 
@property (nonatomic, strong) NSArray *colors;

- (instancetype)initWithTargetPermutation:(int)targetPermutation;
@end
