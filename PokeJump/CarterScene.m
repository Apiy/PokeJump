//
//  CarterScene.m
//  PokeJump
//
//  Created by Charles Lee on 6/10/14.
//  Copyright (c) 2014 Apiy. All rights reserved.
//

#import "CarterScene.h"

typedef NS_ENUM(int, Layer) {
    LayerBackground,
    LayerObstacle,
    LayerForeground,
    LayerPlayer,
    LayerUI,
    LayerFlash
};

typedef NS_OPTIONS(int, EntityCategory) {
    EntityCategoryPlayer = 1 << 0,
    EntityCategoryObstacle = 1 << 1,
    EntityCategoryGround = 1 << 2
};

@implementation CarterScene {
    
    SKNode *_worldNode;
    
    float _playableStart;
    float _playableHeight;
    
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    
    SKSpriteNode *_player;
    SKSpriteNode *_player001;
    SKSpriteNode *_sombrero;
    
    CGPoint _playerVelocity;
    float _playerAngularVelocity;
    
    NSTimeInterval _lastTouchTime;
    float _lastTouchY;
    
    SKAction * _dingAction;
    SKAction * _flapAction;
    SKAction * _whackAction;
    SKAction * _fallingAction;
    SKAction * _hitGroundAction;
    SKAction * _popAction;
    SKAction * _coinAction;
    SKAction *_highScore;
    SKAction *_soundtrack2;
    
    BOOL _hitGround;
    BOOL _hitObstacle;
    
    GameState _gameState;
    SKLabelNode *_scoreLabel;
    int _score;
    
}

-(id)initWithSize:(CGSize)size delegate:(id<MySceneDelegate>)delegate state:(GameState) state {
    return self;
}

// Ignore the above code

-(void)updateScore {
    
    [_worldNode enumerateChildNodesWithName:@"BottomObstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *obstacle = (SKSpriteNode *)node;
        
        NSNumber *passed = obstacle.userData[@"Passed"];
        if (passed && passed.boolValue) return;
        
        if (_player.position.x > obstacle.position.x) {
            if (_score < 1) {
                _score++;
                _scoreLabel.text = [NSString stringWithFormat:@"No.%03d", _score];
            }
            else {
                _scoreLabel.text = [NSString stringWithFormat:@"No.%03d", _score];
                [self runAction:_coinAction];
                _score++;
                
                obstacle.userData[@"Passed"] = @YES;
                
                [self setupPlayer:_score];
            }
        }
        
    }];
}

- (void)setupPlayer:(int)score {
    
    SKSpriteNode *newPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"N01"];
    if (_player) {
        newPlayer.position = _player.position;
    }
    newPlayer.zPosition = LayerPlayer;
    [_worldNode addChild:newPlayer];
    
    CGFloat offsetX = newPlayer.frame.size.width * newPlayer.anchorPoint.x;
    CGFloat offsetY = newPlayer.frame.size.height * newPlayer.anchorPoint.y;
    
    CGMutablePathRef path = [self loadHitBoxForPoke:score];
    
    newPlayer.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    
    [newPlayer skt_attachDebugFrameFromPath:path color:[SKColor redColor]];
    
    newPlayer.physicsBody.categoryBitMask = EntityCategoryPlayer;
    newPlayer.physicsBody.collisionBitMask = 0;
    newPlayer.physicsBody.contactTestBitMask = EntityCategoryObstacle | EntityCategoryGround;
    
    // Swap players
    if (_player) {
        newPlayer.zRotation = _player.zRotation;
        [_player removeFromParent];
    }
    _player = newPlayer;
    
}

- (CGMutablePathRef)loadHitBoxForPoke:(int)score {
    CGMutablePathRef path = CGPathCreateMutable();
    
    for (<#type *object#> in <#collection#>) {
        <#statements#>
    }
    
    
    CGPathCloseSubpath(path);
    return path;
}

@end

