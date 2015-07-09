//
//  Cube.h
//  Rubik's Cube Solver
//
//  Created by Tom on 7/2/15.
//  Copyright (c) 2015 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Edge.h"
#import "Corner.h"
#import "Center.h"
#import "Algorithms.h"

@protocol Cube <NSObject>

- (void)didTurnCube; // MainScene will be notified when the cube is turned, so that it draws the updated state

@end

@interface Cube : NSObject <NSMutableCopying>

@property (nonatomic, strong) NSMutableArray *faces; // used only for visualisation of the cube, gets all data about the state of the cube from edges and corners
@property (nonatomic, strong) NSMutableArray *centers;
@property (nonatomic, strong) NSMutableArray *edges;
@property (nonatomic, strong) NSMutableArray *corners;
@property (weak) id<Cube> delegate;

- (void) defineSolvedCube; // sets up a solved cube
- (void) turnLayer:(int)face counterClockwise:(BOOL)counterClockwise twice:(BOOL)isTwice;
- (void) turnLayerWithDrawing:(int)face counterClockwise:(BOOL)counterClockwise twice:(BOOL)isTwice;

- (NSString *)scrambleCubeAndGiveMoves; // scrambles the cube and returns a string with performed moves


- (void) updateFaces; // called after the needed moves are made, faces array is updated and can be drawn on the screen
- (int) numberOfEdgesSolved;
- (int) numberOfCornersSolved;
@end
