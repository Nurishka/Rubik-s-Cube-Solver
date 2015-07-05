#import "MainScene.h"
typedef NS_ENUM(NSInteger, face)
{
    front, back, up, down, right, left
};

@implementation MainScene
{
    Cube *_cube;
    CCNode *_cubeContainer;
    NSMutableArray *_stickerNodes;
}

- (void)didLoadFromCCB
{
    self.userInteractionEnabled = YES;
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


#pragma mark Buttons
- (void)RCW
{
    [_cube turnLayer:right counterClockwise:NO];
}

- (void)RCCW
{
    [_cube turnLayer:right counterClockwise:YES];
}

- (void)LCW
{
    [_cube turnLayer:left counterClockwise:NO];
}

- (void)LCCW
{
    [_cube turnLayer:left counterClockwise:YES];
}

- (void)BCW
{
    [_cube turnLayer:back counterClockwise:NO];
}

- (void)BCCW
{
    [_cube turnLayer:back counterClockwise:YES];
}

- (void)FCW
{
    [_cube turnLayer:front counterClockwise:NO];
}

- (void)FCCW
{
    [_cube turnLayer:front counterClockwise:YES];
}

- (void)UCW
{
    [_cube turnLayer:up counterClockwise:NO];
}

- (void)UCCW
{
    [_cube turnLayer:up counterClockwise:YES];
}

- (void)DCW
{
    [_cube turnLayer:down counterClockwise:NO];
}

- (void)DCCW
{
    [_cube turnLayer:down counterClockwise:YES];
}

@end
