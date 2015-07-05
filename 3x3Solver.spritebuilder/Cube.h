//
//  Cube.h
//  Rubik's Cube Solver
//
//  Created by Tom on 7/2/15.
//  Copyright (c) 2015 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Cube <NSObject>

- (void)didTurnCube;

@end

@interface Cube : NSObject

@property (nonatomic, strong) NSMutableArray *faces;

- (void) defineSolvedCube;
- (void) turnLayer:(int)face counterClockwise:(BOOL)counterClockwise;

@property (weak) id<Cube> delegate;

@end
