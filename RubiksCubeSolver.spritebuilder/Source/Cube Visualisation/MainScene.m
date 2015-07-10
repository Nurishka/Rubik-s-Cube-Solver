#import "MainScene.h"
typedef NS_ENUM(NSInteger, face)
{
    front, back, up, down, right, left
};


typedef NS_ENUM(NSInteger, color)
{
    none, green, blue, white, yellow, red, orange
};

typedef NS_ENUM(NSInteger, permutationEdge)
{
    UR, UF, UL, UB, DR, DF, DL, DB, FR, FL, BL, BR
};

typedef NS_ENUM(NSInteger, permutation)
{
    URF, ULF, ULB, URB, DRF, DLF, DLB, DRB
};

@implementation MainScene
{
    Cube *_cube;
    CCNode *_cubeContainer;
    NSMutableArray *_stickerNodes;
    
    CCLabelTTF *_scrambleLabel;
    CCLabelTTF *_moveNumberLabel;
    CCLabelTTF *_moveLabel;
    
    CCButton *_showLastMoveButton;
    CCButton *_showNextMoveButton;
    CCButton *_playButton;
    CCButton *_pauseButton;
    CCButton *_solveButton;
    CCButton *_scrambleButton;
    
    NSMutableArray *_solution;
    int currentSolutionIndex; // current move in a solution
    
    NSTimer *timer; // timer for auto solving the cube
}

- (void)didLoadFromCCB
{
    self.userInteractionEnabled = YES;
    
    [self initialState];
    
    _cube = [[Cube alloc] init];
    _cube.delegate = self;
    [_cube defineSolvedCube];
    _cubeContainer.positionType = CCPositionTypeNormalized;
    
    // _stickerNodes keep track of all the CCNodes, which represent each sticker
    _stickerNodes = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i = 0; i < 6; i++)
    {
        _stickerNodes[i] = [[NSMutableArray alloc] init];
    }
    
    [_cube updateFaces];
    [self drawCube];
}

#pragma mark Cube drawing
- (void)drawCube
{
    // before drawing the cube, all stickers are deleted
    for (NSMutableArray *face in _stickerNodes)
    {
        if ([face count] != 0)
        {
            for (Sticker *sticker in face)
            {
                [_cubeContainer removeChild:sticker];
            }
            [face removeAllObjects];
        }
    }
    
    for (int i = 0; i < 6; i++)
    {
        switch (i)
        {
            case front:
            {
                [self addFaceWithInitialX:(float)1/3 andY:(float)2/4 toFace:i];
                break;
            }
                
            case back:
            {
                [self addFaceWithInitialX:(float)1/3 andY:(float)1.f toFace:i];
                break;
            }
                
            case up:
            {
                [self addFaceWithInitialX:(float)1/3 andY:(float)3/4 toFace:i];
                break;
            }
                
            case down:
            {
                [self addFaceWithInitialX:(float)1/3 andY:(float)1/4 toFace:i];
                break;
            }
                
            case right:
            {
                [self addFaceWithInitialX:(float)2/3 andY:(float)2/4 toFace:i];
                break;
            }
                
            case left:
            {
                [self addFaceWithInitialX:0.f andY:(float)2/4 toFace:i];
                break;
            }
        }
    }
}

- (void) addFaceWithInitialX:(CGFloat)x andY:(CGFloat)y toFace:(int)face
{
    CGFloat initialX = x;
    NSArray *faceArr = _cube.faces[face];
    for (int j = 0; j < [faceArr count]; j++)
    {
        if (j % 3 == 0 && j != 0)
        {
            x = initialX;
            y -= (float)1/12;
        }
        Sticker *sticker = (Sticker *)[CCBReader load:@"Sticker" owner:self];
        [sticker setStickerColorInt:[(NSNumber *)faceArr[j] intValue]];
        sticker.positionType = CCPositionTypeNormalized;
        sticker.position = CGPointMake(x, y);
        
        [_cubeContainer addChild:sticker];
        [_stickerNodes[face] addObject:sticker];
        
        x += (float)1/9;
    }
}

#pragma mark Cube delegate methods
- (void)didTurnCube
{
    [self drawCube];
}

#pragma mark Cube scrambling and solving
- (void)scrambleCube
{
    [_cube defineSolvedCube];
    NSString *scramble = [_cube scrambleCubeAndGiveMoves];
    [self scrambleCubeState];
    _scrambleLabel.string = scramble;
    [_cube updateFaces];
    [self drawCube];

}

- (void)solveCube
{
    _solution = [NSMutableArray new];
    Cube *copyCube = [_cube mutableCopy];
    [self solveEdgesOfCube:copyCube];
    [self solveCornersOfCube:copyCube];
    
    currentSolutionIndex = 0;
    [self solveCubeState];
    
    NSArray *turnArr = [Algorithms giveTurnFromString:_solution[currentSolutionIndex]];
    [_cube turnLayerWithDrawing:[turnArr[0] intValue] counterClockwise:[turnArr[1] intValue] twice:[turnArr[2] intValue]];
}

#pragma Solving the cube
/*
    Cube solving relies on the method called Old Pochmann (mainly used by blindfold solvers), where only two permutation algorithms are used and one piece is solved at a time. The method consists of two phases, where edges are solved on the first phase and corners are solved on the second one.
*/
- (void)solveEdgesOfCube:(Cube *)cube
{
    while ([cube numberOfEdgesSolved] != 12)
    {
        Edge *edgeToSolve = cube.edges[UR];
        if (edgeToSolve.targetPermutation == UR)
        {
            for (int i = 0; i < [cube.edges count]; i++)
            {
                Edge *edge = cube.edges[i];
                if ((edge.targetPermutation != i || (edge.targetPermutation == i && edge.orientation == 1)) && edge.targetPermutation != UR)
                {
                    NSArray *solveMoves = [Algorithms giveSolveMovesForEdgeWithTargetPermutation:i withOrientation:0];
                    for (NSString *move in solveMoves)
                    {
                        [_solution addObject:move];
                        NSArray *turnArr = [Algorithms giveTurnFromString:move];
                        [cube turnLayer:[turnArr[0] intValue] counterClockwise:[turnArr[1] intValue] twice:[turnArr[2] intValue]];
                    }
                    break;
                }
            }
        }
        else
        {
            NSArray *solveMoves = [Algorithms giveSolveMovesForEdgeWithTargetPermutation:edgeToSolve.targetPermutation withOrientation:edgeToSolve.orientation];
            for (NSString *move in solveMoves)
            {
                [_solution addObject:move];
                NSArray *turnArr = [Algorithms giveTurnFromString:move];
                [cube turnLayer:[turnArr[0] intValue] counterClockwise:[turnArr[1] intValue] twice:[turnArr[2] intValue]];
            }
        }
    }
}

- (void)solveCornersOfCube:(Cube *)cube
{
    while ([cube numberOfCornersSolved] != 8)
    {
        Edge *cornerToSolve = cube.corners[ULB];
        if (cornerToSolve.targetPermutation == ULB)
        {
            for (int i = 0; i < [cube.corners count]; i++)
            {
                Corner *corner = cube.corners[i];
                if ((corner.targetPermutation != i || (corner.targetPermutation == i && corner.orientation != 0)) && corner.targetPermutation != ULB)
                {
                    NSArray *solveMoves = [Algorithms giveSolveMovesForCornerWithTargetPermutation:i withOrientation:0];
                    for (NSString *move in solveMoves)
                    {
                        [_solution addObject:move];
                        NSArray *turnArr = [Algorithms giveTurnFromString:move];
                        [cube turnLayer:[turnArr[0] intValue] counterClockwise:[turnArr[1] intValue] twice:[turnArr[2] intValue]];
                    }
                    break;
                }
            }
        }
        else
        {
            NSArray *solveMoves = [Algorithms giveSolveMovesForCornerWithTargetPermutation:cornerToSolve.targetPermutation withOrientation:cornerToSolve.orientation];
            for (NSString *move in solveMoves)
            {
                [_solution addObject:move];
                NSArray *turnArr = [Algorithms giveTurnFromString:move];
                [cube turnLayer:[turnArr[0] intValue] counterClockwise:[turnArr[1] intValue] twice:[turnArr[2] intValue]];
            }
        }
    }
    
}

#pragma mark Buttons
- (void)showLastMove
{
    if (currentSolutionIndex != 0)
    {
        NSArray *turnArr = [Algorithms giveTurnFromString:[Algorithms giveInverseMoveForMove:_solution[currentSolutionIndex]]];
        [_cube turnLayerWithDrawing:[turnArr[0] intValue] counterClockwise:[turnArr[1] intValue] twice:[turnArr[2] intValue]];
        currentSolutionIndex--;
        
        _moveLabel.string = _solution[currentSolutionIndex];
        _moveNumberLabel.string = [NSString stringWithFormat:@"Move %d/%d", (currentSolutionIndex + 1), (int)[_solution count]];
    }
}

- (void)showNextMove
{
    if ((currentSolutionIndex + 1) != [_solution count])
    {
        currentSolutionIndex++;
        NSArray *turnArr = [Algorithms giveTurnFromString:_solution[currentSolutionIndex]];
        [_cube turnLayerWithDrawing:[turnArr[0] intValue] counterClockwise:[turnArr[1] intValue] twice:[turnArr[2] intValue]];
        
        _moveLabel.string = _solution[currentSolutionIndex];
        _moveNumberLabel.string = [NSString stringWithFormat:@"Move %d/%d", (currentSolutionIndex + 1), (int)[_solution count]];
    }
    else
    {
        if (timer.valid)
        {
            [self pauseButtonState];
        }
    }
}

- (void)play
{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(showNextMove) userInfo:nil repeats:YES];
    [self playButtonState];
}

- (void)pause
{
    if (timer.valid)
    {
        [self pauseButtonState];
    }
}

#pragma mark States For Buttons
- (void)solveCubeState
{
    _moveLabel.string = _solution[currentSolutionIndex];
    _moveLabel.visible = YES;
    _moveNumberLabel.visible = YES;
    _moveNumberLabel.string = [NSString stringWithFormat:@"Move 1/%d", (int)[_solution count]];
    _showLastMoveButton.visible = YES;
    _showNextMoveButton.visible = YES;
    _playButton.visible = YES;
    _pauseButton.visible = YES;
    _solveButton.state = CCControlStateDisabled;
    _solveButton.label.opacity = 0.25f;
    _pauseButton.state = CCControlStateDisabled;
    _pauseButton.background.opacity = 0.25f;
    _scrambleLabel.visible = NO;
}

- (void)initialState
{
    _scrambleLabel.visible = NO;
    _moveLabel.visible = NO;
    _moveNumberLabel.visible = NO;
    _showLastMoveButton.visible = NO;
    _showNextMoveButton.visible = NO;
    _playButton.visible = NO;
    _pauseButton.visible = NO;
    _solveButton.state = CCControlStateDisabled;
    _solveButton.label.opacity = 0.25f;
}
- (void)scrambleCubeState
{
    _moveLabel.visible = NO;
    _moveNumberLabel.visible = NO;
    _showLastMoveButton.visible = NO;
    _showNextMoveButton.visible = NO;
    _pauseButton.visible = NO;
    _playButton.visible = NO;
    _solveButton.state = CCControlStateNormal;
    _solveButton.label.opacity = 1.f;
    _scrambleLabel.visible = YES;
}

- (void)playButtonState
{
    _pauseButton.state = CCControlStateNormal;
    _pauseButton.background.opacity = 1.f;
    _showNextMoveButton.state = CCControlStateDisabled;
    _showNextMoveButton.background.opacity = 0.25f;
    _showLastMoveButton.state = CCControlStateDisabled;
    _showLastMoveButton.background.opacity = 0.25f;
    _scrambleButton.state = CCControlStateDisabled;
    _scrambleButton.label.opacity = 0.25f;
    _playButton.state = CCControlStateDisabled;
    _playButton.background.opacity = 0.25f;
}

- (void)pauseButtonState
{
    _showNextMoveButton.state = CCControlStateNormal;
    _showNextMoveButton.background.opacity = 1.f;
    _showLastMoveButton.state = CCControlStateNormal;
    _showLastMoveButton.background.opacity = 1.f;
    _scrambleButton.state = CCControlStateNormal;
    _scrambleButton.label.opacity = 1.f;
    _playButton.state = CCControlStateNormal;
    _playButton.background.opacity = 1.f;
    [timer invalidate];
    
}

@end
