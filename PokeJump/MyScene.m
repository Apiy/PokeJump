//
//  MyScene.m
//  PokeJump
//
//  Created by Charles Lee on 2/25/14.
//  Copyright (c) 2014 Apiy. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"

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

    int totalPotions = 0;


// Gameplay - bird movement
static const float kGravity = -1300.0;
static const float kGravityJ = -1290.0;//was-1320.0
static const float kImpulse = 340.0;
static const float kImpulseJohto = 440.0;
static const float kAngularVelocity = 300;

// Gameplay - ground speed
static const float kGroundSpeed = 220.0f;
static const float kGroundSpeedJ = 270.0f;//was250.0

// Gameplay - obstacles positioning
static const float kGapMultiplier = 2.20;//was 2.20
static const float kBottomObstacleMinFraction = 0.09;
static const float kBottomObstacleMaxFraction = 0.65;

// Gameplay - obstacles timing
static const float kFirstSpawnDelay = 1.4;
static const float kEverySpawnDelay = 1.1;
static const float kFirstSpawnDelayJ = 1.2;
static const float kEverySpawnDelayJ = 1.0;
static const float kFirstSpawnDelayR = 0.0;

// Looks
static const int kNumForegrounds = 2;
static const float kMargin = 65;
static const float kAnimDelay = 0.25;
static const float kHoOhDelay = 10.0;
static const int kNumBirdFrames = 3;
static const int kNumHoOhFrames = 8;
static const float kMinDegrees = -90;
static const float kMaxDegrees = 0;
static NSString *const kFontName = @"Verdana-Bold";
static const float kFontSizeLabel = 35.0;
static const float kFontSizeCard = 50.0;
static const float kFontSizeBlank = 105.0;

static NSArray *hitBoxLines;

// App ID
static const int APP_STORE_ID = 870046888;


@interface MyScene() <SKPhysicsContactDelegate>
@end

@implementation MyScene {
    
    SKNode *_worldNode;
    
    float _playableStart;
    float _playableHeight;
    
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    
    SKSpriteNode *_player;
    SKSpriteNode *_HoOh;
    SKSpriteNode *_player001;
    SKSpriteNode *_sombrero;
    
    CGPoint _playerVelocity;
    float _playerAngularVelocity;
    
    NSTimeInterval _lastTouchTime;
    float _lastTouchY;
    
    SKAction * _dingAction;
    SKAction * _flapAction;
    SKAction * _whackAction;
    //FUCK THIS TOO
    //SKAction * _soundtracklalala;
    SKAction * _fallingAction;
    SKAction * _hitGroundAction;
    SKAction * _popAction;
    SKAction * _coinAction;
    SKAction *_highScore;
    SKAction *_state;
    SKAction *_revive;
    SKAction *_click;

    
    BOOL _hitGround;
    BOOL _hitObstacle;
    
    GameState _gameState;
    SKLabelNode *_scoreLabel;
    int _score;
    
}



-(id)initWithSize:(CGSize)size delegate:(id<MySceneDelegate>)delegate state:(GameState) state{
    if (self = [super initWithSize:size]) {
        
        self.delegate = delegate;
        
        _worldNode = [SKNode node];
        [self addChild:_worldNode];
        
        //If you ever feel like changing the score for testing
        [self setBestScore:214];
        
        //[self setupBackground];
        //[self setupForeground];
        //[self setupPlayer];
        //[self setupSounds];
        //[self startSpawning];
        //[self setupScoreLabel];
        
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        //if (_gameState == GameStateShowingScoreR) {
        //    [self setTotalPotions:totalPotions-1];
        //}
        
        if (state == GameStateMainMenu){
            [self switchToMainMenu];
            if (!hitBoxLines) {
                [self initHitboxes];
            }
        } else if (state == GameStateMainMenuS){
            [self switchToMainMenuS];
        }
        else if (state == GameStateTutorial){
            [self switchToTutorial];
        }
        else if (state == GameStateTutorialR){
            [self switchToTutorialR];
        }
        else if (state == GameStateTutorialJR){
            [self switchToTutorialJR];
        }
        else if (state == GameStateMyPokemon){
            [self switchToMyPokemon];
        }
        else if (state == GameStatePokeCard1){
            [self switchToMyPokemon1];
        }
        else if (state == GameStatePokeCard2){
            [self switchToMyPokemon2];
        }
        else if (state == GameStatePokeCard3){
            [self switchToMyPokemon3];
        }
        else if (state == GameStatePokeCard4){
            [self switchToMyPokemon4];
        }
        else if (state == GameStatePokeCard5){
            [self switchToMyPokemon5];
        }
        else if (state == GameStatePokeCard6){
            [self switchToMyPokemon6];
        }
        else if (state == GameStatePokeCard7){
            [self switchToMyPokemon7];
        }
        else if (state == GameStatePokeCard8){
            [self switchToMyPokemon8];
        }
        else if (state == GameStatePokeCard9){
            [self switchToMyPokemon9];
        }
        else if (state == GameStatePokeCard10){
            [self switchToMyPokemon10];
        }
        else if (state == GameStatePokeCard11){
            [self switchToMyPokemon11];
        }
        else if (state == GameStatePokeCard12){
            [self switchToMyPokemon12];
        }
        else if (state == GameStatePokeCard13){
            [self switchToMyPokemon13];
        }
        else if (state == GameStatePokeCard14){
            [self switchToMyPokemon14];
        }
        else if (state == GameStatePokeCard15){
            [self switchToMyPokemon15];
        }
        else if (state == GameStatePokeCard16){
            [self switchToMyPokemon16];
        }
        else if (state == GameStatePokeCard17){
            [self switchToMyPokemon17];
        }
        else if (state == GameStatePokeCard18){
            [self switchToMyPokemon18];
        }
        else if (state == GameStatePokeCard19){
            [self switchToMyPokemon19];
        }
        else if (state == GameStatePokeCard20){
            [self switchToMyPokemon20];
        }
        else if (state == GameStatePokeCard21){
            [self switchToMyPokemon21];
        }
        else if (state == GameStatePokeCard22){
            [self switchToMyPokemon22];
        }
        else if (state == GameStatePokeCard23){
            [self switchToMyPokemon23];
        }
        else if (state == GameStatePokeCard24){
            [self switchToMyPokemon24];
        }
        else if (state == GameStatePokeCard25){
            [self switchToMyPokemon25];
        }
        else if (state == GameStatePokeCard26){
            [self switchToMyPokemon26];
        }
        //[self flapPlayer];
        //_gameState = GameStatePlay;
        
        //[self switchToTutorial];
        
    }
    return self;
}

- (void)initHitboxes {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"HitBoxes" ofType:@"csv"];
    NSString* wholeFile = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    hitBoxLines = [wholeFile componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
}

#pragma mark - Setup methods

/*
- (void) loadImages{
    
    int xInc = 0;
    int yInc = 0;
    for (int i = 1; i < 13; i++){
        NSString* imageName = [NSString stringWithFormat:@"N%d@2x.png", i];
        UIImageView* imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        NSLog(@"x:%i, y:%i", xInc, yInc);
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(14 + xInc, 100 + yInc, 137, 44)];
        [label setText:[NSString stringWithFormat: @"No.%03d", i]];
        imgView.frame = CGRectMake(10 + xInc, 10 + yInc, 137, 100);
        xInc = i % 4 ? xInc + 160: 0;
        xInc = i % 4 ? yInc: yInc + 150;
        //[scrollView addSubview:imgView];
        //[scrollView addSubview:label];
        
    }
   // [UIScrollView setContentSize:CGSizeMake(640, 450)];
    
}*/
- (void)setupBackground {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"HDPokeJumpBG"];
    background.anchorPoint = CGPointMake(0.5, 1);
    background.position = CGPointMake(self.size.width/2, self.size.height);
    background.zPosition = LayerBackground;
    background.name = @"Background";
    [_worldNode addChild:background];
    
    _playableStart = self.size.height - background.size.height;
    _playableHeight = background.size.height;
    
    // 1
    CGPoint lowerLeft = CGPointMake(0, _playableStart);
    CGPoint lowerRight = CGPointMake(self.size.width, _playableStart);
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:lowerLeft toPoint:lowerRight];
    [self skt_attachDebugLineFromPoint:lowerLeft toPoint:lowerRight color:[UIColor whiteColor]];
    
    self.physicsBody.categoryBitMask = EntityCategoryGround;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = EntityCategoryPlayer;
    
}

- (void)setupBackgroundJ {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
    background.anchorPoint = CGPointMake(0.5, 1);
    background.position = CGPointMake(self.size.width/2, self.size.height);
    background.zPosition = LayerBackground;
    background.name = @"Background";
    [_worldNode addChild:background];
    
    _playableStart = self.size.height - background.size.height;
    _playableHeight = background.size.height;
    
    // 1
    CGPoint lowerLeft = CGPointMake(0, _playableStart);
    CGPoint lowerRight = CGPointMake(self.size.width, _playableStart);
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:lowerLeft toPoint:lowerRight];
    [self skt_attachDebugLineFromPoint:lowerLeft toPoint:lowerRight color:[UIColor redColor]];
    
    self.physicsBody.categoryBitMask = EntityCategoryGround;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = EntityCategoryPlayer;
    
}

- (void)setupForeground {
    for (int i = 0; i < kNumForegrounds; ++i) {
        SKSpriteNode *foreground = [SKSpriteNode spriteNodeWithImageNamed:@"NewPJGround2"];
        foreground.anchorPoint = CGPointMake(0, 1);
        foreground.position = CGPointMake(i * self.size.width, _playableStart + 25);
        foreground.zPosition = LayerForeground;
        foreground.name = @"Foreground";
        [_worldNode addChild:foreground];
    }
}

- (void)setupPokemon:(int)score {
    SKSpriteNode *newPlayer;
    if (score == 0) {
        newPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"AshSprite1"];
    }
    if (score == 252) {
        newPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"CrazyAsh0"];
    }
    else {
        newPlayer = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d", score]];
    }
    
    if (_player) {
        newPlayer.position = _player.position;
    } else {
        newPlayer.position = CGPointMake(self.size.width * 0.2, _playableHeight * 0.4 + _playableStart);
    }
    
    newPlayer.zPosition = LayerPlayer;
    [_worldNode addChild:newPlayer];
    
    CGFloat offsetX = newPlayer.frame.size.width * newPlayer.anchorPoint.x;
    CGFloat offsetY = newPlayer.frame.size.height * newPlayer.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    NSArray* coordinates = [[hitBoxLines objectAtIndex:score] componentsSeparatedByString:@","];
    NSUInteger coordCount = coordinates.count;
    for (NSUInteger n = 0; n < coordCount; n+=2) {
        int x = [[coordinates objectAtIndex:n] intValue];
        int y = [[coordinates objectAtIndex:n+1] intValue];
        if (n == 0) {
            CGPathMoveToPoint(path, NULL, x - offsetX, y - offsetY);
        }
        else {
            CGPathAddLineToPoint(path, NULL, x - offsetX, y - offsetY);
        }
    }
    
    CGPathCloseSubpath(path);
    
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

- (void)setupPlayer {
    
        SKSpriteNode *newPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"AshSprite1"];
    if (_player) {
        newPlayer.position = _player.position;
    } else {
        newPlayer.position = CGPointMake(self.size.width * 0.2, _playableHeight * 0.4 + _playableStart);
    }

        newPlayer.zPosition = LayerPlayer;
        [_worldNode addChild:newPlayer];
    
        CGFloat offsetX = newPlayer.frame.size.width * newPlayer.anchorPoint.x;
        CGFloat offsetY = newPlayer.frame.size.height * newPlayer.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
    CGPathMoveToPoint(path, NULL, 1 - offsetX, 32 - offsetY);
    CGPathAddLineToPoint(path, NULL, 11 - offsetX, 43 - offsetY);
    CGPathAddLineToPoint(path, NULL, 26 - offsetX, 43 - offsetY);
    CGPathAddLineToPoint(path, NULL, 37 - offsetX, 29 - offsetY);
    CGPathAddLineToPoint(path, NULL, 31 - offsetX, 23 - offsetY);
    CGPathAddLineToPoint(path, NULL, 30 - offsetX, 17 - offsetY);
    CGPathAddLineToPoint(path, NULL, 24 - offsetX, 15 - offsetY);
    CGPathAddLineToPoint(path, NULL, 25 - offsetX, 10 - offsetY);
    CGPathAddLineToPoint(path, NULL, 31 - offsetX, 16 - offsetY);
    CGPathAddLineToPoint(path, NULL, 27 - offsetX, 2 - offsetY);
    CGPathAddLineToPoint(path, NULL, 9 - offsetX, 3 - offsetY);
        
        CGPathCloseSubpath(path);
        
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
    
    //[self setupPlayerAnimation];
    
    
}

- (void)setupPlayerR:(int)score{
    
    SKSpriteNode *newPlayer;
    if (score == 0) {
        newPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"AshSprite1"];
    }
    if (score == 252) {
        newPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"CrazyAsh0"];
    }
    else {
        newPlayer = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d", score]];
    }
    
    if (_player) {
        newPlayer.position = _player.position;
    } else {
        newPlayer.position = CGPointMake(self.size.width * 0.2, _playableHeight * 0.4 + _playableStart);
    }
    
    newPlayer.zPosition = LayerPlayer;
    [_worldNode addChild:newPlayer];
    
    CGFloat offsetX = newPlayer.frame.size.width * newPlayer.anchorPoint.x;
    CGFloat offsetY = newPlayer.frame.size.height * newPlayer.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    NSArray* coordinates = [[hitBoxLines objectAtIndex:score] componentsSeparatedByString:@","];
    NSUInteger coordCount = coordinates.count;
    for (NSUInteger n = 0; n < coordCount; n+=2) {
        int x = [[coordinates objectAtIndex:n] intValue];
        int y = [[coordinates objectAtIndex:n+1] intValue];
        if (n == 0) {
            CGPathMoveToPoint(path, NULL, x - offsetX, y - offsetY);
        }
        else {
            CGPathAddLineToPoint(path, NULL, x - offsetX, y - offsetY);
        }
    }
    
    CGPathCloseSubpath(path);
    
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

    
    newPlayer = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d", score]];
    if (_player) {
        newPlayer.position = _player.position;
    } else {
        newPlayer.position = CGPointMake(self.size.width * 0.2, _playableHeight * 0.4 + _playableStart);
    }
    
    newPlayer.zPosition = LayerPlayer;
    [_worldNode addChild:newPlayer];
    /*
    CGFloat offsetX = newPlayer.frame.size.width * newPlayer.anchorPoint.x;
    CGFloat offsetY = newPlayer.frame.size.height * newPlayer.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 1 - offsetX, 32 - offsetY);
    CGPathAddLineToPoint(path, NULL, 11 - offsetX, 43 - offsetY);
    CGPathAddLineToPoint(path, NULL, 26 - offsetX, 43 - offsetY);
    CGPathAddLineToPoint(path, NULL, 37 - offsetX, 29 - offsetY);
    CGPathAddLineToPoint(path, NULL, 31 - offsetX, 23 - offsetY);
    CGPathAddLineToPoint(path, NULL, 30 - offsetX, 17 - offsetY);
    CGPathAddLineToPoint(path, NULL, 24 - offsetX, 15 - offsetY);
    CGPathAddLineToPoint(path, NULL, 25 - offsetX, 10 - offsetY);
    CGPathAddLineToPoint(path, NULL, 31 - offsetX, 16 - offsetY);
    CGPathAddLineToPoint(path, NULL, 27 - offsetX, 2 - offsetY);
    CGPathAddLineToPoint(path, NULL, 9 - offsetX, 3 - offsetY);
    
    CGPathCloseSubpath(path);
    
    newPlayer.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    
    [newPlayer skt_attachDebugFrameFromPath:path color:[SKColor redColor]];
    
    newPlayer.physicsBody.categoryBitMask = EntityCategoryPlayer;
    newPlayer.physicsBody.collisionBitMask = 0;
    newPlayer.physicsBody.contactTestBitMask = EntityCategoryObstacle | EntityCategoryGround;
    */
    // Swap players
    if (_player) {
        newPlayer.zRotation = _player.zRotation;
        [_player removeFromParent];
    }
    _player = newPlayer;
    
}

- (void)setupPlayerMM {
    
    SKSpriteNode *newPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"AshSprite1"];
    if (_player) {
        newPlayer.position = _player.position;
    } else {
        newPlayer.position = CGPointMake(self.size.width * 0.2, _playableHeight * 0.4 + _playableStart);
    }
    
    newPlayer.position = CGPointMake(-50, _playableHeight * 0.4 + _playableStart);
    SKAction *moveTo = [SKAction moveTo:CGPointMake(self.size.width * 0.2, _playableHeight * 0.4 + _playableStart) duration:kAnimDelay];
    moveTo.timingMode = SKActionTimingEaseInEaseOut;
    [newPlayer runAction:[SKAction sequence:@[
                                              [SKAction waitForDuration:kAnimDelay*2],
                                              moveTo
                                              ]]];
    newPlayer.zPosition = LayerPlayer;
    [_worldNode addChild:newPlayer];
    
    CGFloat offsetX = newPlayer.frame.size.width * newPlayer.anchorPoint.x;
    CGFloat offsetY = newPlayer.frame.size.height * newPlayer.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 1 - offsetX, 32 - offsetY);
    CGPathAddLineToPoint(path, NULL, 11 - offsetX, 43 - offsetY);
    CGPathAddLineToPoint(path, NULL, 26 - offsetX, 43 - offsetY);
    CGPathAddLineToPoint(path, NULL, 37 - offsetX, 29 - offsetY);
    CGPathAddLineToPoint(path, NULL, 31 - offsetX, 23 - offsetY);
    CGPathAddLineToPoint(path, NULL, 30 - offsetX, 17 - offsetY);
    CGPathAddLineToPoint(path, NULL, 24 - offsetX, 15 - offsetY);
    CGPathAddLineToPoint(path, NULL, 25 - offsetX, 10 - offsetY);
    CGPathAddLineToPoint(path, NULL, 31 - offsetX, 16 - offsetY);
    CGPathAddLineToPoint(path, NULL, 27 - offsetX, 2 - offsetY);
    CGPathAddLineToPoint(path, NULL, 9 - offsetX, 3 - offsetY);
    
    CGPathCloseSubpath(path);
    
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
    
    //[self setupPlayerAnimation];
    
    
}

- (void)setupCrazyAsh {
    
    SKSpriteNode *newPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"CrazyAsh0"];
    if (_player) {
        newPlayer.position = _player.position;
    }
    newPlayer.zPosition = LayerPlayer;
    [_worldNode addChild:newPlayer];
    
    CGFloat offsetX = newPlayer.frame.size.width * newPlayer.anchorPoint.x;
    CGFloat offsetY = newPlayer.frame.size.height * newPlayer.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 19 - offsetX, 45 - offsetY);
    CGPathAddLineToPoint(path, NULL, 32 - offsetX, 45 - offsetY);
    CGPathAddLineToPoint(path, NULL, 43 - offsetX, 30 - offsetY);
    CGPathAddLineToPoint(path, NULL, 36 - offsetX, 18 - offsetY);
    CGPathAddLineToPoint(path, NULL, 36 - offsetX, 8 - offsetY);
    CGPathAddLineToPoint(path, NULL, 31 - offsetX, 3 - offsetY);
    CGPathAddLineToPoint(path, NULL, 15 - offsetX, 2 - offsetY);
    CGPathAddLineToPoint(path, NULL, 10 - offsetX, 30 - offsetY);
    
    
    CGPathCloseSubpath(path);
    
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




- (void)setupWobble {
    SKAction *moveUp = [SKAction moveByX:0 y:10 duration:0.4];
    moveUp.timingMode = SKActionTimingEaseInEaseOut;
    SKAction *moveDown = [moveUp reversedAction];
    SKAction *sequence = [SKAction sequence:@[moveUp, moveDown]];
    SKAction *repeat = [SKAction repeatActionForever:sequence];
    [_player runAction:repeat withKey:@"Wobble"];
}


- (void)setupSounds {
    _dingAction = [SKAction playSoundFileNamed:@"ding.wav" waitForCompletion:NO];
    _flapAction = [SKAction playSoundFileNamed:@"JUMP.wav" waitForCompletion:NO];
    _whackAction = [SKAction playSoundFileNamed:@"SmackSound.wav" waitForCompletion:NO];
    _fallingAction = [SKAction playSoundFileNamed:@"FALLINGSOUND.wav" waitForCompletion:NO];
    //FUCK THIS LINE OF CODE!!!!
    //_soundtracklalala = [SKAction playSoundFileNamed:@"SOUNDTRAhhhhCK2.wav" waitForCompletion:NO];
    _hitGroundAction = [SKAction playSoundFileNamed:@"SmackSound.wav" waitForCompletion:NO];
    _popAction = [SKAction playSoundFileNamed:@"SELECT.wav" waitForCompletion:NO];
    _coinAction = [SKAction playSoundFileNamed:@"coin.wav" waitForCompletion:NO];
    _highScore = [SKAction playSoundFileNamed:@"HIGHSCORE.wav" waitForCompletion:NO];
    _state = [SKAction playSoundFileNamed:@"StateSong2.mp3" waitForCompletion:NO];
    _revive = [SKAction playSoundFileNamed:@"ReviveSound.mp3" waitForCompletion:NO];
    _click = [SKAction playSoundFileNamed:@"CLICKITY.mp3" waitForCompletion:NO];
}

- (void)setupScoreLabel {
    _scoreLabel = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    _scoreLabel.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    _scoreLabel.position = CGPointMake(self.size.width/2, self.size.height - kMargin);
    _scoreLabel.text = @"Ash";
    _scoreLabel.fontSize = kFontSizeLabel;
    _scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    _scoreLabel.zPosition = LayerUI;
    [_worldNode addChild:_scoreLabel];
}

- (void)setupScoreLabelR {
    _scoreLabel = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    _scoreLabel.fontColor = [SKColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1.0];
    _scoreLabel.position = CGPointMake(self.size.width/2, self.size.height - kMargin);
    _scoreLabel.text = [NSString stringWithFormat:@"No.%03d", [self lastScore]];
    _scoreLabel.fontSize = kFontSizeLabel;
    _scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    _scoreLabel.zPosition = LayerUI;
    [_worldNode addChild:_scoreLabel];
}

- (void)setupScoreLabelJR {
    _scoreLabel = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    _scoreLabel.fontColor = [SKColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1.0];
    _scoreLabel.position = CGPointMake(self.size.width/2, self.size.height - kMargin);
    _scoreLabel.text = [NSString stringWithFormat:@"No.%03d", [self lastScoreJ]-151];
    _scoreLabel.fontSize = kFontSizeLabel;
    _scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    _scoreLabel.zPosition = LayerUI;
    [_worldNode addChild:_scoreLabel];
}

- (void)addPokemon:(int)best {
    
    //_gameState = GameStatePokeCard1;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    [_worldNode addChild:blankSlate];
    
    /*SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"PokePlay-01"];
     play.scale = 0.4;
     play.position = CGPointMake(0, 0);
     [blankSlate addChild:play];
     */
    blankSlate.position = CGPointMake(self.size.width * 2.25, self.size.height*0.47);
    blankSlate.scale=.27;
    SKAction *moveTo = [SKAction moveTo:CGPointMake(self.size.width * 0.5, self.size.height * 0.47) duration:kAnimDelay];
    moveTo.timingMode = SKActionTimingEaseInEaseOut;
    [blankSlate runAction:[SKAction sequence:@[
                                               [SKAction waitForDuration:kAnimDelay*1.5],
                                               moveTo
                                            ]]];
    
    for (int i = 1; i <=5; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 1.85);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 2);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    for (int i = 6; i <=10; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 5.14);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        //Change the pokemon's color to black and add a white question mark
        pokeSpriteNode.color =[SKColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.3];
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 5.2);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    
    if ([self bestScore] >= 1 && [self bestScore] <= 5) {
        for (int i = 1; i <=[self bestScore]; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 1.85);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 2);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }}
    if ([self bestScore] >= 6 && [self bestScore] <= 10) {
        for (int i = 1; i <=5; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 1.85);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 2);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }
        for (int i = 6; i <=[self bestScore]; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 5.14);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            //Change the pokemon's color to black and add a white question mark
            pokeSpriteNode.color =[SKColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.3];
            pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 5.2);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }
    }
    else if ([self bestScore] >= 10){
        for (int i = 1; i <=5; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 1.85);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 2);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }
        for (int i = 6; i <=10; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 5.14);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            //Change the pokemon's color to black and add a white question mark
            pokeSpriteNode.color =[SKColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.3];
            pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 5.2);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }
    }
    
}

- (void)addPokemon1:(int)best {
    
    //_gameState = GameStatePokeCard1;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    [_worldNode addChild:blankSlate];
    
    /*SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"PokePlay-01"];
     play.scale = 0.4;
     play.position = CGPointMake(0, 0);
     [blankSlate addChild:play];
     */
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.47);
    blankSlate.scale=.27;
    
    for (int i = 1; i <=5; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 1.85);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 2);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    for (int i = 6; i <=10; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 5.14);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        //Change the pokemon's color to black and add a white question mark
        pokeSpriteNode.color =[SKColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.3];
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 5.2);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    
    if ([self bestScore] >= 1 && [self bestScore] <= 5) {
    for (int i = 1; i <=[self bestScore]; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 1.85);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 2);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
    }}
      if ([self bestScore] >= 6 && [self bestScore] <= 10) {
          for (int i = 1; i <=5; i++) {
              SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
              poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
              poke1.fontSize = kFontSizeBlank;
              SKSpriteNode *pokeSpriteNode;
              
              poke1.text = [NSString stringWithFormat:@"%03d", i];
              poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 1.85);
              pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
              pokeSpriteNode.scale = 4.1;
              pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 2);
              [blankSlate addChild:pokeSpriteNode];
              [blankSlate addChild:poke1];
          }
          for (int i = 6; i <=[self bestScore]; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 5.14);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            //Change the pokemon's color to black and add a white question mark
            pokeSpriteNode.color =[SKColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.3];
            pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 5.2);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }
    }
    else if ([self bestScore] >= 10){
        for (int i = 1; i <=5; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 1.85);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 2);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }
        for (int i = 6; i <=10; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 5.14);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            //Change the pokemon's color to black and add a white question mark
            pokeSpriteNode.color =[SKColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.3];
            pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 5.2);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }
    }
    [self runAction:_popAction];

}


- (void)addPokemon2:(int)best {
    
    //_gameState = GameStatePokeCard2;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    playButton.zPosition = LayerUI;
    [_worldNode addChild:playButton];
    
    SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    play.scale = 0.22;
    [playButton addChild:play];
    playButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 11; i <=15; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 8.45);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 8.65);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        for (int i = 16; i <=20; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 11.74);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 11.94);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }}
    
    if ([self bestScore] >= 11 && [self bestScore] <= 15) {
    for (int i = 11; i <=[self bestScore]; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 8.45);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 8.65);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
    }}
    if ([self bestScore] >= 16 && [self bestScore] <= 20) {
        for (int i = 11; i <=15; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 8.45);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 8.65);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        for (int i = 16; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 11.74);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 11.94);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        }}}
    else if ([self bestScore] >= 20){
        for (int i = 11; i <=15; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 8.45);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 8.65);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
            for (int i = 16; i <=20; i++) {
                SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
                poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
                poke1.fontSize = kFontSizeBlank;
                SKSpriteNode *pokeSpriteNode;
                
                poke1.text = [NSString stringWithFormat:@"%03d", i];
                poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 11.74);
                pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
                pokeSpriteNode.scale = 4.1;
                pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 11.94);
                [blankSlate addChild:pokeSpriteNode];
                [blankSlate addChild:poke1];
            }}
        
    }
    [self runAction:_popAction];

}

- (void)addPokemon3:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;

    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 21;i<=25; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 15.05);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 15.25);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    for (int i = 26; i <=30; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 18.341);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 18.528);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    
    if ([self bestScore] >= 21 && [self bestScore] <= 25) {
    for (int i = 21;i<=[self bestScore]; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 15.05);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 15.25);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }}
    if ([self bestScore] >= 26 && [self bestScore] <= 30) {
        for (int i = 21;i<=25; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 15.05);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 15.25);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }
        for (int i = 26; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 18.341);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 18.528);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        }}
    else if ([self bestScore] >= 30){
            for (int i = 21;i<=25; i++) {
                SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
                poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
                poke1.fontSize = kFontSizeBlank;
                SKSpriteNode *pokeSpriteNode;
                
                poke1.text = [NSString stringWithFormat:@"%03d", i];
                poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 15.05);
                pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
                pokeSpriteNode.scale = 4.1;
                pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 15.25);
                [blankSlate addChild:pokeSpriteNode];
                [blankSlate addChild:poke1];
            }
            for (int i = 26; i <=30; i++) {
                SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
                poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
                poke1.fontSize = kFontSizeBlank;
                SKSpriteNode *pokeSpriteNode;
                
                poke1.text = [NSString stringWithFormat:@"%03d", i];
                poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 18.341);
                pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
                pokeSpriteNode.scale = 4.1;
                pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 18.528);
                [blankSlate addChild:pokeSpriteNode];
                [blankSlate addChild:poke1];
            }
            
        }
    
    [self runAction:_popAction];

}

- (void)addPokemon4:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 31; i <=35; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 21.65);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 21.79);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 36; i <=40; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 24.938);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 25.15);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 31 && [self bestScore] <= 35) {
    for (int i = 31; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 21.65);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 21.79);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }}
    if ([self bestScore] >= 36 && [self bestScore] <= 40) {
    for (int i = 31; i <=35; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 21.65);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 21.79);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 36; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 24.938);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 25.15);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    else if ([self bestScore] >= 40){
    for (int i = 31; i <=35; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 21.65);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 21.79);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 36; i <=40; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 24.938);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 25.15);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon5:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 41; i <=45; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 28.25);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 28.42);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 46; i <=50; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 31.54);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 31.69);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 41 && [self bestScore] <= 45) {
    for (int i = 41; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 28.25);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 28.42);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }}
    if ([self bestScore] >= 46 && [self bestScore] <= 50) {
    for (int i = 41; i <=45; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 28.25);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 28.42);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 46; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 31.54);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 31.69);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    else if ([self bestScore] >= 50){
    for (int i = 41; i <=45; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 28.25);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 28.42);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 46; i <=50; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 31.54);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 31.69);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon6:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 51; i <=55; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 34.8467);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 35.04);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    for (int i = 56; i <=60; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 38.142);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 38.343);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 51 && [self bestScore] <= 55) {
    for (int i = 51; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 34.8467);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 35.04);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    if ([self bestScore] >= 56 && [self bestScore] <= 60) {
    for (int i = 51; i <=55; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 34.8467);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 35.04);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    for (int i = 56; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 38.142);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 38.343);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    else if ([self bestScore] >= 60){
    for (int i = 51; i <=55; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 34.8467);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 35.04);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    for (int i = 56; i <=60; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 38.142);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 38.343);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon7:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 61; i <=65; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 41.45);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 41.65);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 66; i <=70; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 44.74);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 44.95);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 61 && [self bestScore] <= 65) {
    for (int i = 61; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 41.45);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 41.65);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }}
    if ([self bestScore] >= 66 && [self bestScore] <= 70) {
    for (int i = 61; i <=65; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 41.45);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 41.65);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 66; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 44.74);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 44.95);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    else if ([self bestScore] >= 70){
    for (int i = 61; i <=65; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 41.45);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 41.65);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 66; i <=70; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 44.74);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 44.95);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon8:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 71; i <=75; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 48.05);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 48.18);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 76; i <=80; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 51.345);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 51.55);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 71 && [self bestScore] <= 75) {
    for (int i = 71; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 48.05);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 48.18);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }}
    if ([self bestScore] >= 76 && [self bestScore] <= 80) {
    for (int i = 71; i <=75; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 48.05);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 48.18);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 76; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 51.345);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 51.55);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    else if ([self bestScore] >= 80){
    for (int i = 71; i <=75; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 48.05);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 48.18);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 76; i <=80; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 51.345);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 51.55);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon9:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 81; i <=85; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 54.65);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 54.85);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 86; i <=90; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 57.945);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 58.1);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 81 && [self bestScore] <= 85) {
    for (int i = 81; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 54.65);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 54.85);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }}
    if ([self bestScore] >= 86 && [self bestScore] <= 90) {
    for (int i = 81; i <=85; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 54.65);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 54.85);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 86; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 57.945);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 58.1);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    else if ([self bestScore] >= 90){
    for (int i = 81; i <=85; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 54.65);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 54.85);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 86; i <=90; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 57.945);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 58.1);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon10:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 91; i <=95; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 61.25);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 61.405);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    for (int i = 96; i <=100; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 64.55);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 64.63);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 91 && [self bestScore] <= 95) {
    for (int i = 91; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 61.25);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 61.405);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    if ([self bestScore] >= 96 && [self bestScore] <= 100) {
    for (int i = 91; i <=95; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 61.25);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 61.405);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    for (int i = 96; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 64.55);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 64.63);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    else if ([self bestScore] >= 100){
    for (int i = 91; i <=95; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 61.25);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 61.405);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    for (int i = 96; i <=100; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 64.55);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 64.63);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon11:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 101; i <=105; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 67.85);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 68.0);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 106; i <=110; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 71.15);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 71.319);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 101 && [self bestScore] <= 105) {
    for (int i = 101; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 67.85);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 68.0);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }}
    if ([self bestScore] >= 106 && [self bestScore] <= 100) {
    for (int i = 101; i <=105; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 67.85);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 68.0);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 106; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 71.15);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 71.319);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    else if ([self bestScore] >= 110){
    for (int i = 101; i <=105; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 67.85);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 68.0);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 106; i <=110; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 71.15);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 71.319);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon12:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 111; i <=115; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 74.45);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 74.65);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 116; i <=120; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 77.75);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 77.93);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 111 && [self bestScore] <= 115) {
    for (int i = 111; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 74.45);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 74.65);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }}
    if ([self bestScore] >= 116 && [self bestScore] <= 110) {
    for (int i = 111; i <=115; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 74.45);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 74.65);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 116; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 77.75);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 77.93);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    else if ([self bestScore] >= 120){
    for (int i = 111; i <=115; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 74.45);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 74.65);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 116; i <=120; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 77.75);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 77.93);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon13:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 121; i <=125; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 81.05);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 81.25);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 126; i <=130; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 84.35);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 84.476);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 121 && [self bestScore] <= 125) {
    for (int i = 121; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 81.05);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 81.25);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }}
    if ([self bestScore] >= 126 && [self bestScore] <= 130) {
    for (int i = 121; i <=125; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 81.05);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 81.25);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 126; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 84.35);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 84.476);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    else if ([self bestScore] >= 130){
    for (int i = 121; i <=125; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 81.05);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 81.25);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 126; i <=130; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 84.35);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 84.476);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon14:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 131; i <=135; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 87.65);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 87.78);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    for (int i = 136; i <=140; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 90.95);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 91.12);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 131 && [self bestScore] <= 135) {
    for (int i = 131; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 87.65);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 87.78);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    if ([self bestScore] >= 136 && [self bestScore] <= 140) {
        for (int i = 131; i <=135; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 87.65);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 87.78);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }
        for (int i = 136; i <=[self bestScore]; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 90.95);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 91.12);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }}
    else if ([self bestScore] >= 140){
        for (int i = 131; i <=135; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 87.65);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 87.78);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }
        for (int i = 136; i <=140; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 90.95);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 91.12);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }}
    [self runAction:_popAction];
    
}

- (void)addPokemon15:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 141; i <=145; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 94.255);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 94.44);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 146; i <=150; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 97.55);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 97.74);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 141 && [self bestScore] <= 145) {
    for (int i = 141; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 94.255);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 94.44);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }}
    if ([self bestScore] >= 146 && [self bestScore] <= 150) {
    for (int i = 141; i <=145; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 94.255);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 94.44);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 146; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 97.55);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 97.74);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    else if ([self bestScore] >= 150){
    for (int i = 141; i <=145; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 94.255);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 94.44);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 146; i <=150; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 97.55);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 97.74);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon16:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 151; i <=155; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 100.85);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 101.03);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 156; i <=160; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 104.15);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 104.35);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 151 && [self bestScore] <= 155) {
    for (int i = 151; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 100.85);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 101.03);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }}
    if ([self bestScore] >= 156 && [self bestScore] <= 160) {
    for (int i = 151; i <=155; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 100.85);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 101.03);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 156; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 104.15);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 104.35);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    if (best-1 >= 151 && best <= 155) {
        for (int i = 151; i <=best; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 100.85);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 101.03);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
            
        }}
    if (best >= 156 && best <= 160) {
        for (int i = 151; i <=155; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 100.85);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 101.03);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
            
        }
        for (int i = 156; i <=best; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 104.15);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 104.35);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }}
    else if ([self bestScore] >= 160 || best >= 160){
    for (int i = 151; i <=155; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 100.85);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 101.03);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 156; i <=160; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 104.15);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 104.35);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon17:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 161; i <=165; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 107.45);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 107.61);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 166; i <=170; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 110.745);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 110.93);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 161 && [self bestScore] <= 165) {
    for (int i = 161; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 107.45);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 107.61);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }}
    if ([self bestScore] >= 166 && [self bestScore] <= 170) {
    for (int i = 161; i <=165; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 107.45);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 107.61);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 166; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 110.745);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 110.93);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    if (best >= 161 && best <= 165) {
        for (int i = 161; i <=best; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 107.45);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 107.61);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
            
        }}
    if (best >= 166 && best <= 170) {
        for (int i = 161; i <=165; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 107.45);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 107.61);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
            
        }
        for (int i = 166; i <=best; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 110.745);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 110.93);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }}
    else if ([self bestScore] >= 170 || best >= 170){
    for (int i = 161; i <=165; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 107.45);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 107.61);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 166; i <=170; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 110.745);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 110.93);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon18:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 171; i <=175; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 114.05);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 114.18);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    for (int i = 176; i <=180; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 117.345);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 117.46);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 171 && [self bestScore] <= 175) {
    for (int i = 171; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 114.05);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 114.18);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    if ([self bestScore] >= 176 && [self bestScore] <= 180) {
    for (int i = 171; i <=175; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 114.05);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 114.18);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    for (int i = 176; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 117.345);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 117.46);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    if (best >= 171 && best <= 175) {
        for (int i = 171; i <=best; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 114.05);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 114.18);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }}
    if (best >= 176 && best <= 180) {
        for (int i = 171; i <=175; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 114.05);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 114.18);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }
        for (int i = 176; i <=best; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 117.345);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 117.46);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }}
    else if ([self bestScore] >= 180 || best >=180){
    for (int i = 171; i <=175; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 114.05);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 114.18);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    for (int i = 176; i <=180; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 117.345);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 117.46);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon19:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 181; i <=185; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 120.65);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 120.8);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 186; i <=190; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 123.94);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 124.13);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 181 && [self bestScore] <= 185) {
    for (int i = 181; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 120.65);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 120.8);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }}
    if ([self bestScore] >= 186 && [self bestScore] <= 190) {
    for (int i = 181; i <=185; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 120.65);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 120.8);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 186; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 123.94);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 124.13);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    if (best >= 181 && best <= 185) {
        for (int i = 181; i <=best; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 120.65);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 120.8);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
            
        }}
    if (best >= 186 && best <= 190) {
        for (int i = 181; i <=185; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 120.65);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 120.8);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
            
        }
        for (int i = 186; i <=best; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 123.94);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 124.13);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }}
    else if ([self bestScore] >= 190 || best >=190){
    for (int i = 181; i <=185; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 120.65);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 120.8);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 186; i <=190; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 123.94);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 124.13);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon20:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 191; i <=195; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 127.25);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 127.45);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 196; i <=200; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 130.55);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 130.67);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 191 && [self bestScore] <= 195) {
    for (int i = 191; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 127.25);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 127.45);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }}
    if ([self bestScore] >= 196 && [self bestScore] <= 200) {
    for (int i = 191; i <=195; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 127.25);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 127.45);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 196; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 130.55);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 130.67);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    if (best >= 191 && best <= 195) {
        for (int i = 191; i <=best; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 127.25);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 127.45);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
            
        }}
    if (best >= 196 && best <= 200) {
        for (int i = 191; i <=195; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 127.25);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 127.45);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
            
        }
        for (int i = 196; i <=best; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 130.55);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 130.67);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }}
    else if ([self bestScore] >= 200 || best >= 200){
    for (int i = 191; i <=195; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 127.25);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 127.45);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 196; i <=200; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 130.55);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 130.67);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon21:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 201; i <=205; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 133.85);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 134.07);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 206; i <=210; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 137.148);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 137.28);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 201 && [self bestScore] <= 205) {
    for (int i = 201; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 133.85);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 134.07);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }}
    if ([self bestScore] >= 206 && [self bestScore] <= 210) {
    for (int i = 201; i <=205; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 133.85);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 134.07);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 206; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 137.148);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 137.28);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    if (best >= 201 && best <= 205) {
        for (int i = 201; i <=best; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 133.85);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 134.07);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
            
        }}
    if (best >= 206 && best <= 210) {
        for (int i = 201; i <=205; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 133.85);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 134.07);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
            
        }
        for (int i = 206; i <=best; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 137.148);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 137.28);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }}
    else if ([self bestScore] >= 210 || best >= 210){
    for (int i = 201; i <=205; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 133.85);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 134.07);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 206; i <=210; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 137.148);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 137.28);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon22:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 211; i <=215; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 140.45);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 140.65);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    for (int i = 216; i <=220; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 143.75);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 143.9);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 211 && [self bestScore] <= 215) {
    for (int i = 211; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 140.45);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 140.65);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    if ([self bestScore] >= 216 && [self bestScore] <= 220) {
    for (int i = 211; i <=215; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 140.45);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 140.65);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    for (int i = 216; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 143.75);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 143.9);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    if (best >= 211 && best <= 215) {
        for (int i = 211; i <=best; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 140.45);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 140.65);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }}
    if (best >= 216 && best <= 220) {
        for (int i = 211; i <=215; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 140.45);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 140.65);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }
        for (int i = 216; i <=best; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 143.75);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 143.9);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }}
    else if ([self bestScore] >= 220 || best>=220){
    for (int i = 211; i <=215; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 140.45);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 140.65);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    for (int i = 216; i <=220; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 143.75);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 143.9);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon23:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 221; i <=225; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 147.05);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 147.2);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 226; i <=230; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 150.35);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 150.55);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 221 && [self bestScore] <= 225) {
    for (int i = 221; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 147.05);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 147.2);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }}
    if ([self bestScore] >= 226 && [self bestScore] <= 230) {
    for (int i = 221; i <=225; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 147.05);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 147.2);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 226; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 150.35);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 150.55);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    if (best >= 221 && best <= 225) {
        for (int i = 221; i <=best; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 147.05);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 147.2);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
            
        }}
    if (best >= 226 && best <= 230) {
        for (int i = 221; i <=225; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 147.05);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 147.2);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
            
        }
        for (int i = 226; i <=best; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 150.35);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 150.55);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }}
    else if ([self bestScore] >= 230 || best >=230){
    for (int i = 221; i <=225; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 147.05);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 147.2);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 226; i <=230; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 150.35);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 150.55);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon24:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 231; i <=235; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 153.65);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 153.8);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 236; i <=240; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 156.95);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 157.13);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 231 && [self bestScore] <= 235) {
    for (int i = 231; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 153.65);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 153.8);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }}
    if ([self bestScore] >= 236 && [self bestScore] <= 240) {
    for (int i = 231; i <=235; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 153.65);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 153.8);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 236; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 156.95);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 157.13);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    if (best >= 231 && best <= 235) {
        for (int i = 231; i <=best; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 153.65);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 153.8);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
            
        }}
    if (best >= 236 && best <= 240) {
        for (int i = 231; i <=235; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 153.65);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 153.8);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
            
        }
        for (int i = 236; i <=best; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 156.95);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 157.13);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }}
    else if ([self bestScore] >= 240 || best >= 240){
    for (int i = 231; i <=235; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 153.65);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 153.8);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 236; i <=240; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 156.95);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 157.13);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon25:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 241; i <=245; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 160.25);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 160.39);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 246; i <=250; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 163.55);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 163.74);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }
    if ([self bestScore] >= 241 && [self bestScore] <= 245) {
    for (int i = 241; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 160.25);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 160.39);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }}
    if ([self bestScore] >= 246 && [self bestScore] <= 250) {
    for (int i = 241; i <=245; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 160.25);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 160.39);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 246; i <=[self bestScore]; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 163.55);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 163.74);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    if (best >= 241 && best <= 245) {
        for (int i = 241; i <=best; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 160.25);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 160.39);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
            
        }}
    if (best >= 246 && best <= 250) {
        for (int i = 241; i <=245; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 160.25);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 160.39);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
            
        }
        for (int i = 246; i <=best; i++) {
            SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
            poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
            poke1.fontSize = kFontSizeBlank;
            SKSpriteNode *pokeSpriteNode;
            
            poke1.text = [NSString stringWithFormat:@"%03d", i];
            poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 163.55);
            pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
            pokeSpriteNode.scale = 4.1;
            pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 163.74);
            [blankSlate addChild:pokeSpriteNode];
            [blankSlate addChild:poke1];
        }}
    else if ([self bestScore] >= 250 || best >=250){
    for (int i = 241; i <=245; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 160.25);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 160.39);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    for (int i = 246; i <=250; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 163.55);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 163.74);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
    }}
    [self runAction:_popAction];
    
}

- (void)addPokemon26:(int)best {
    
    //_gameState = GameStatePokeCard3;
    SKSpriteNode *blankSlate = [SKSpriteNode spriteNodeWithImageNamed:@"Blank-01"];
    blankSlate.zPosition = LayerUI;
    
    blankSlate.position = CGPointMake(self.size.width * 0.5, self.size.height*0.47);
    blankSlate.scale=.27;
    [_worldNode addChild:blankSlate];
    
    for (int i = 251; i <=251; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 166.85);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"B%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 167.05);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    if ([self bestScore] >= 251 || best >=251) {
    for (int i = 251; i <=251; i++) {
        SKLabelNode *poke1 = [[SKLabelNode alloc] initWithFontNamed:kFontName];
        poke1.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
        poke1.fontSize = kFontSizeBlank;
        SKSpriteNode *pokeSpriteNode;
        
        poke1.text = [NSString stringWithFormat:@"%03d", i];
        poke1.position = CGPointMake(-blankSlate.size.width * 1.3, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 166.85);
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", i]];
        pokeSpriteNode.scale = 4.1;
        pokeSpriteNode.position = CGPointMake(-blankSlate.size.width * 0.5, blankSlate.size.height * 1.1*(-i*0.6)+blankSlate.size.height * 167.05);
        [blankSlate addChild:pokeSpriteNode];
        [blankSlate addChild:poke1];
        
    }
    }}

-(void)setupScoreCard {

    if (_score > [self bestScore]) {
        _score--;
        [self setBestScore:_score];
        _score++;
        [self runAction:_highScore];
    }
    
    [self setLastScore:_score-1];
    //[self setTotalPotions:totalPotions];
    
    SKSpriteNode *scorecard = [SKSpriteNode spriteNodeWithImageNamed:@"FinalSB-01"];
    scorecard.position = CGPointMake(self.size.width * 0.5, self.size.height/2);
    scorecard.name = @"Tutorial";
    scorecard.zPosition = LayerUI;
    [_worldNode addChild:scorecard];
    
    SKLabelNode *lastScore = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    lastScore.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    lastScore.fontSize = kFontSizeCard;
    lastScore.position = CGPointMake(-scorecard.size.width * 0.33, -scorecard.size.height * 0.2);
    
    SKSpriteNode *pokeSpriteNode;
    if (_score < 1) {
        lastScore.text = [NSString stringWithFormat:@"Ash"];
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:@"AshSprite1"];
        pokeSpriteNode.scale = 1.7;
    }
    else if (_score >= 253) {
        lastScore.text = [NSString stringWithFormat:@"%03d", _score-1];
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:@"CrazyAsh1"];
        pokeSpriteNode.scale = 1.5;
    }
    else {
        lastScore.text = [NSString stringWithFormat:@"%03d", _score-1];
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", _score-1]];
        pokeSpriteNode.scale = 1.9;
    }
    pokeSpriteNode.position = CGPointMake(-scorecard.size.width * 0.13, -scorecard.size.height * 0.1);
    [scorecard addChild:pokeSpriteNode];
    [scorecard addChild:lastScore];

    
    SKLabelNode *bestScore = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    bestScore.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    bestScore.fontSize = kFontSizeCard;
    bestScore.position = CGPointMake(scorecard.size.width * 0.18, -scorecard.size.height * 0.2);
    //===========================================================================

    SKSpriteNode *bestPokeSpriteNode;
    if ([self bestScore] < 1) {
        bestScore.text = [NSString stringWithFormat:@"Ash"];
        bestPokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:@"AshSprite1"];
        bestPokeSpriteNode.scale = 1.7;
    }
    else if ([self bestScore] >= 252) {
        bestScore.text = [NSString stringWithFormat:@"%03d", [self bestScore]];
        bestPokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:@"CrazyAsh1"];
        bestPokeSpriteNode.scale = 1.5;
    }
    else {
        bestScore.text = [NSString stringWithFormat:@"%03d", [self bestScore]];
        bestPokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", [self bestScore]]];
        bestPokeSpriteNode.scale = 1.9;
    }
    bestPokeSpriteNode.position = CGPointMake(scorecard.size.width * 0.38, -scorecard.size.height * 0.1);
    [scorecard addChild:bestPokeSpriteNode];

    [scorecard addChild:bestScore];
    
    //SKSpriteNode *ash = [SKSpriteNode spriteNodeWithImageNamed:@"AshSprite1"];
    //ash.position = CGPointMake(scorecard.size.width * 0.385, -scorecard.size.height * 0.1);
    //ash.scale = 1.4;
   // [scorecard addChild:ash];

    
    SKSpriteNode *gameOver = [SKSpriteNode spriteNodeWithImageNamed:@"YouFainted-01"];
    gameOver.position = CGPointMake(self.size.width/2, self.size.height/2 + scorecard.size.height/2 - kMargin/15 + gameOver.size.height/10);
    gameOver.zPosition = LayerUI;
    [_worldNode addChild:gameOver];
    
    SKSpriteNode *okButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    okButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.32);
    okButton.zPosition = LayerUI;
    [_worldNode addChild:okButton];
    
    SKSpriteNode *ok = [SKSpriteNode spriteNodeWithImageNamed:@"Retry2-01"];
    ok.position = CGPointZero;
    ok.zPosition = LayerUI;
    [okButton addChild:ok];
    
    SKSpriteNode *shareButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    shareButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.32);
    shareButton.zPosition = LayerUI;
    [_worldNode addChild:shareButton];
    
    SKSpriteNode *share = [SKSpriteNode spriteNodeWithImageNamed:@"PokeShare-01"];
    share.position = CGPointZero;
    share.zPosition = LayerUI;
    [shareButton addChild:share];
    
    
    //NUMPOTIONS
    
    SKSpriteNode *potionButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    potionButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.16);
    potionButton.zPosition = LayerUI;
    [_worldNode addChild:potionButton];
    
    SKSpriteNode *potion = [SKSpriteNode spriteNodeWithImageNamed:@"ReviveIconPixelArt-01"];
    potion.position = CGPointZero;
    potion.zPosition = LayerUI;
    potion.position = CGPointMake(-potionButton.size.width * 0.15, potionButton.size.height * .0001);
    [potionButton addChild:potion];
    
    SKLabelNode *numPotions = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    [potionButton addChild:numPotions];
    numPotions.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    numPotions.fontSize = kFontSizeCard/2;
    numPotions.position = CGPointMake(potionButton.size.width * 0.17, -potionButton.size.height * .3);
    numPotions.zPosition = LayerUI;
    

    //ANIMATIONS ================================================
    gameOver.scale = 0;
    gameOver.alpha = 0;
    SKAction *group = [SKAction group:@[
    [SKAction fadeInWithDuration:kAnimDelay],
    [SKAction scaleTo:0.55 duration:kAnimDelay]
     ]];
    group.timingMode = SKActionTimingEaseInEaseOut;
    [gameOver runAction:[SKAction sequence:@[
    [SKAction waitForDuration:kAnimDelay],
    group
    ]]];
    
    scorecard.scale = 0.55;
    scorecard.position = CGPointMake(self.size.width * 0.5, -scorecard.size.height/2);
    SKAction *moveTo = [SKAction moveTo:CGPointMake(self.size.width/2, self.size.height/1.95) duration:kAnimDelay];
    moveTo.timingMode = SKActionTimingEaseInEaseOut;
    [scorecard runAction:[SKAction sequence:@[
     [SKAction waitForDuration:kAnimDelay*2],
     moveTo
     ]]];

    
    if (_score-1 >= 50) {
        totalPotions = totalPotions + 1;
        [self setTotalPotions:[self totalPotions]+1];
         numPotions.text = [NSString stringWithFormat:@"x%d", [self totalPotions]];
        
    } else if (_score-1 < 50){
        numPotions.text = [NSString stringWithFormat:@"x%d", [self totalPotions]];
    }
    
    //[self setTotalPotions:totalPotions-1];
    //numPotions.text = [NSString stringWithFormat:@"x%d", totalPotions];
    
    
    //[self setTotalPotions:totalPotions-1];
    //numPotions.text = [NSString stringWithFormat:@"x%d", [self totalPotions]];
    
    share.scale = 0.34;
    ok.scale = 0.18;
    potion.scale = .12;
    okButton.alpha = 0;
    shareButton.alpha = 0;
    potionButton.alpha = 0;
    SKAction *fadeIn = [SKAction sequence:@[
    [SKAction waitForDuration:kAnimDelay*3],
   [SKAction fadeInWithDuration:kAnimDelay]
   ]];
    [okButton runAction:fadeIn];
    [shareButton runAction:fadeIn];
    [potionButton runAction:fadeIn];
    //[numPotions runAction:fadeIn];
    
    SKAction *pops = [SKAction sequence:@[
    [SKAction waitForDuration:kAnimDelay],
    _popAction,
     [SKAction waitForDuration:kAnimDelay],
     _popAction,
    [SKAction waitForDuration:kAnimDelay],
    _popAction,
     [SKAction runBlock:^{
        [self switchToGameOver];
    }]
                                          ]];
    [self runAction:pops];
    
    if (_score > [self bestScore]) {
        SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"HighScoreArrow-01"];
        rateButton.zPosition = LayerUI;
        rateButton.scale = 0.13;
        [_worldNode addChild:rateButton];
        
        rateButton.position = CGPointMake(self.size.width * -1.5, self.size.height * 0.74);
        SKAction *moveTo2 = [SKAction moveTo:CGPointMake(self.size.width * 0.25, self.size.height * 0.74) duration:kAnimDelay];
        moveTo2.timingMode = SKActionTimingEaseInEaseOut;
        [rateButton runAction:[SKAction sequence:@[
                                                   [SKAction waitForDuration:kAnimDelay*2],
                                                   moveTo2
                                                   ]]];
    }
    
}

-(void)setupScoreCardJ {
    
    if (_score > [self bestScoreJ]) {
        _score--;
        [self setBestScoreJ:_score];
        _score++;
        [self runAction:_highScore];
    }
    [self setLastScoreJ:150+_score];
    
    SKSpriteNode *scorecard = [SKSpriteNode spriteNodeWithImageNamed:@"FinalSB-01"];
    scorecard.position = CGPointMake(self.size.width * 0.5, self.size.height/2);
    scorecard.name = @"Tutorial";
    scorecard.zPosition = LayerUI;
    [_worldNode addChild:scorecard];
    
    SKLabelNode *lastScore = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    lastScore.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    lastScore.fontSize = kFontSizeCard;
    lastScore.position = CGPointMake(-scorecard.size.width * 0.33, -scorecard.size.height * 0.2);
    
    SKSpriteNode *pokeSpriteNode;
    if (_score <= 1) {
        lastScore.text = [NSString stringWithFormat:@"Ash"];
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:@"AshSprite1"];
        pokeSpriteNode.scale = 1.7;
    }
    else if (_score >= 102) {
        lastScore.text = [NSString stringWithFormat:@"%03d", _score - 1];
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:@"CrazyAsh1"];
        pokeSpriteNode.scale = 1.5;
    }
    else {
        lastScore.text = [NSString stringWithFormat:@"%03d", _score - 1];
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", _score+150]];
        pokeSpriteNode.scale = 1.9;
    }
    pokeSpriteNode.position = CGPointMake(-scorecard.size.width * 0.13, -scorecard.size.height * 0.1);
    [scorecard addChild:pokeSpriteNode];
    
    
    
    
    [scorecard addChild:lastScore];
    
    
    
    SKLabelNode *bestScoreJ = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    bestScoreJ.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    bestScoreJ.fontSize = kFontSizeCard;
    bestScoreJ.position = CGPointMake(scorecard.size.width * 0.18, -scorecard.size.height * 0.2);
    //===========================================================================
    
    
    SKSpriteNode *bestPokeSpriteNode;
    if ([self bestScoreJ] < 1) {
        bestScoreJ.text = [NSString stringWithFormat:@"Ash"];
        bestPokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:@"AshSprite1"];
        bestPokeSpriteNode.scale = 1.7;
    }
    else if ([self bestScoreJ] >= 102) {
        bestScoreJ.text = [NSString stringWithFormat:@"%03d", [self bestScoreJ]];
        bestPokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:@"CrazyAsh1"];
        bestPokeSpriteNode.scale = 1.5;
    }
    else {
        bestScoreJ.text = [NSString stringWithFormat:@"%03d", [self bestScoreJ]];
        bestPokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", [self bestScoreJ]+151]];
        bestPokeSpriteNode.scale = 1.9;
    }
    bestPokeSpriteNode.position = CGPointMake(scorecard.size.width * 0.38, -scorecard.size.height * 0.1);
    [scorecard addChild:bestPokeSpriteNode];
    
    //}
    
    [scorecard addChild:bestScoreJ];
    
    //SKSpriteNode *ash = [SKSpriteNode spriteNodeWithImageNamed:@"AshSprite1"];
    //ash.position = CGPointMake(scorecard.size.width * 0.385, -scorecard.size.height * 0.1);
    //ash.scale = 1.4;
    // [scorecard addChild:ash];
    
    
    SKSpriteNode *gameOver = [SKSpriteNode spriteNodeWithImageNamed:@"YouFainted-01"];
    gameOver.position = CGPointMake(self.size.width/2, self.size.height/2 + scorecard.size.height/2 - kMargin/15 + gameOver.size.height/10);
    gameOver.zPosition = LayerUI;
    [_worldNode addChild:gameOver];
    
    SKSpriteNode *okButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    okButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.32);
    okButton.zPosition = LayerUI;
    [_worldNode addChild:okButton];
    
    SKSpriteNode *ok = [SKSpriteNode spriteNodeWithImageNamed:@"Retry2-01"];
    ok.position = CGPointZero;
    ok.zPosition = LayerUI;
    [okButton addChild:ok];
    
    SKSpriteNode *shareButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    shareButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.32);
    shareButton.zPosition = LayerUI;
    [_worldNode addChild:shareButton];
    
    SKSpriteNode *share = [SKSpriteNode spriteNodeWithImageNamed:@"PokeShare-01"];
    share.position = CGPointZero;
    share.zPosition = LayerUI;
    [shareButton addChild:share];

    //NUMPOTIONS
    
    SKSpriteNode *potionButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    potionButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.16);
    potionButton.zPosition = LayerUI;
    [_worldNode addChild:potionButton];
    
    SKSpriteNode *potion = [SKSpriteNode spriteNodeWithImageNamed:@"ReviveIconPixelArt-01"];
    potion.position = CGPointZero;
    potion.zPosition = LayerUI;
    potion.position = CGPointMake(-potionButton.size.width * 0.15, potionButton.size.height * .0001);
    [potionButton addChild:potion];
    
    SKLabelNode *numPotions = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    [potionButton addChild:numPotions];
    numPotions.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    numPotions.fontSize = kFontSizeCard/2;
    numPotions.position = CGPointMake(potionButton.size.width * 0.17, -potionButton.size.height * .3);
    numPotions.zPosition = LayerUI;
    
    //ANIMATIONS ================================================
    gameOver.scale = 0;
    gameOver.alpha = 0;
    SKAction *group = [SKAction group:@[
                                        [SKAction fadeInWithDuration:kAnimDelay],
                                        [SKAction scaleTo:0.55 duration:kAnimDelay]
                                        ]];
    group.timingMode = SKActionTimingEaseInEaseOut;
    [gameOver runAction:[SKAction sequence:@[
                                             [SKAction waitForDuration:kAnimDelay],
                                             group
                                             ]]];
    
    scorecard.scale = 0.55;
    scorecard.position = CGPointMake(self.size.width * 0.5, -scorecard.size.height/2);
    SKAction *moveTo = [SKAction moveTo:CGPointMake(self.size.width/2, self.size.height/1.95) duration:kAnimDelay];
    moveTo.timingMode = SKActionTimingEaseInEaseOut;
    [scorecard runAction:[SKAction sequence:@[
                                              [SKAction waitForDuration:kAnimDelay*2],
                                              moveTo
                                              ]]];
    
    if (_score-1 >= 50) {
        totalPotions = totalPotions + 1;
        [self setTotalPotions:[self totalPotions]+1];
        numPotions.text = [NSString stringWithFormat:@"x%d", [self totalPotions]];
        
    } else if (_score-1 < 50){
        numPotions.text = [NSString stringWithFormat:@"x%d", [self totalPotions]];
    }
    
    //[self setTotalPotions: [self totalPotions]-1];
    //numPotions.text = [NSString stringWithFormat:@"x%d", [self totalPotions]];
    
    share.scale = 0.34;
    ok.scale = 0.18;
    potion.scale = .12;
    okButton.alpha = 0;
    shareButton.alpha = 0;
    potionButton.alpha = 0;
    SKAction *fadeIn = [SKAction sequence:@[
                                            [SKAction waitForDuration:kAnimDelay*3],
                                            [SKAction fadeInWithDuration:kAnimDelay]
                                            ]];
    [okButton runAction:fadeIn];
    [shareButton runAction:fadeIn];
    [potionButton runAction:fadeIn];
    
    SKAction *pops = [SKAction sequence:@[
                                          [SKAction waitForDuration:kAnimDelay],
                                          _popAction,
                                          [SKAction waitForDuration:kAnimDelay],
                                          _popAction,
                                          [SKAction waitForDuration:kAnimDelay],
                                          _popAction,
                                          [SKAction runBlock:^{
        [self switchToGameOverJ];
    }]
                                          ]];
    [self runAction:pops];
    
}

-(void)setupScoreCardJR:(int)LSJ {
    
    if (_score + LSJ> [self bestScoreJ]) {
        _score--;
        [self setBestScoreJ:[self lastScoreJ]-151 + _score];
        _score++;
        [self runAction:_highScore];
    }
    
    SKSpriteNode *scorecard = [SKSpriteNode spriteNodeWithImageNamed:@"FinalSB-01"];
    scorecard.position = CGPointMake(self.size.width * 0.5, self.size.height/2);
    scorecard.name = @"Tutorial";
    scorecard.zPosition = LayerUI;
    [_worldNode addChild:scorecard];
    
    SKLabelNode *lastScore = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    lastScore.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    lastScore.fontSize = kFontSizeCard;
    lastScore.position = CGPointMake(-scorecard.size.width * 0.33, -scorecard.size.height * 0.2);
    
    SKSpriteNode *pokeSpriteNode;
    if (_score <= 1) {
        lastScore.text = [NSString stringWithFormat:@"Ash"];
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:@"AshSprite1"];
        pokeSpriteNode.scale = 1.7;
    }
    else if (_score >= 102) {
        lastScore.text = [NSString stringWithFormat:@"%03d", LSJ + _score - 2];
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:@"CrazyAsh1"];
        pokeSpriteNode.scale = 1.5;
    }
    else {
        lastScore.text = [NSString stringWithFormat:@"%03d", LSJ+_score - 2];
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", _score+149+LSJ]];
        pokeSpriteNode.scale = 1.9;
    }
    pokeSpriteNode.position = CGPointMake(-scorecard.size.width * 0.13, -scorecard.size.height * 0.1);
    [scorecard addChild:pokeSpriteNode];
    [scorecard addChild:lastScore];

    SKLabelNode *bestScoreJ = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    bestScoreJ.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    bestScoreJ.fontSize = kFontSizeCard;
    bestScoreJ.position = CGPointMake(scorecard.size.width * 0.18, -scorecard.size.height * 0.2);
    //===========================================================================
    
    
    SKSpriteNode *bestPokeSpriteNode;
    if ([self bestScoreJ] < 1) {
        bestScoreJ.text = [NSString stringWithFormat:@"Ash"];
        bestPokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:@"AshSprite1"];
        bestPokeSpriteNode.scale = 1.7;
    }
    else if ([self bestScoreJ] >= 102) {
        bestScoreJ.text = [NSString stringWithFormat:@"%03d", [self bestScoreJ]];
        bestPokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:@"CrazyAsh1"];
        bestPokeSpriteNode.scale = 1.5;
    }
    else {
        bestScoreJ.text = [NSString stringWithFormat:@"%03d", [self bestScoreJ]];
        bestPokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", [self bestScoreJ]+151]];
        bestPokeSpriteNode.scale = 1.9;
    }
    bestPokeSpriteNode.position = CGPointMake(scorecard.size.width * 0.38, -scorecard.size.height * 0.1);
    [scorecard addChild:bestPokeSpriteNode];
    [scorecard addChild:bestScoreJ];
    
    SKSpriteNode *gameOver = [SKSpriteNode spriteNodeWithImageNamed:@"YouFainted-01"];
    gameOver.position = CGPointMake(self.size.width/2, self.size.height/2 + scorecard.size.height/2 - kMargin/15 + gameOver.size.height/10);
    gameOver.zPosition = LayerUI;
    [_worldNode addChild:gameOver];
    
    SKSpriteNode *okButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    okButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.32);
    okButton.zPosition = LayerUI;
    [_worldNode addChild:okButton];
    
    SKSpriteNode *ok = [SKSpriteNode spriteNodeWithImageNamed:@"Retry2-01"];
    ok.position = CGPointZero;
    ok.zPosition = LayerUI;
    [okButton addChild:ok];
    
    SKSpriteNode *shareButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    shareButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.32);
    shareButton.zPosition = LayerUI;
    [_worldNode addChild:shareButton];
    
    SKSpriteNode *share = [SKSpriteNode spriteNodeWithImageNamed:@"PokeShare-01"];
    share.position = CGPointZero;
    share.zPosition = LayerUI;
    [shareButton addChild:share];
    
    //NUMPOTIONS
    
    SKSpriteNode *potionButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    potionButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.16);
    potionButton.zPosition = LayerUI;
    [_worldNode addChild:potionButton];
    
    SKSpriteNode *potion = [SKSpriteNode spriteNodeWithImageNamed:@"ReviveIconPixelArt-01"];
    potion.position = CGPointZero;
    potion.zPosition = LayerUI;
    potion.position = CGPointMake(-potionButton.size.width * 0.15, potionButton.size.height * .0001);
    [potionButton addChild:potion];
    
    SKLabelNode *numPotions = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    [potionButton addChild:numPotions];
    numPotions.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    numPotions.fontSize = kFontSizeCard/2;
    numPotions.position = CGPointMake(potionButton.size.width * 0.17, -potionButton.size.height * .3);
    numPotions.zPosition = LayerUI;
    
    //ANIMATIONS ================================================
    gameOver.scale = 0;
    gameOver.alpha = 0;
    SKAction *group = [SKAction group:@[
                                        [SKAction fadeInWithDuration:kAnimDelay],
                                        [SKAction scaleTo:0.55 duration:kAnimDelay]
                                        ]];
    group.timingMode = SKActionTimingEaseInEaseOut;
    [gameOver runAction:[SKAction sequence:@[
                                             [SKAction waitForDuration:kAnimDelay],
                                             group
                                             ]]];
    
    scorecard.scale = 0.55;
    scorecard.position = CGPointMake(self.size.width * 0.5, -scorecard.size.height/2);
    SKAction *moveTo = [SKAction moveTo:CGPointMake(self.size.width/2, self.size.height/1.95) duration:kAnimDelay];
    moveTo.timingMode = SKActionTimingEaseInEaseOut;
    [scorecard runAction:[SKAction sequence:@[
                                              [SKAction waitForDuration:kAnimDelay*2],
                                              moveTo
                                              ]]];
    
    if (_score-1 >= 50) {
        totalPotions = totalPotions + 1;
        [self setTotalPotions:[self totalPotions]+1];
        numPotions.text = [NSString stringWithFormat:@"x%d", [self totalPotions]];
        
    } else if (_score-1 < 50){
        numPotions.text = [NSString stringWithFormat:@"x%d", [self totalPotions]];
    }
    
    //[self setTotalPotions: [self totalPotions]-1];
    //numPotions.text = [NSString stringWithFormat:@"x%d", [self totalPotions]];
    
    share.scale = 0.34;
    ok.scale = 0.18;
    potion.scale = .12;
    okButton.alpha = 0;
    shareButton.alpha = 0;
    potionButton.alpha = 0;
    SKAction *fadeIn = [SKAction sequence:@[
                                            [SKAction waitForDuration:kAnimDelay*3],
                                            [SKAction fadeInWithDuration:kAnimDelay]
                                            ]];
    [okButton runAction:fadeIn];
    [shareButton runAction:fadeIn];
    [potionButton runAction:fadeIn];
    
    SKAction *pops = [SKAction sequence:@[
                                          [SKAction waitForDuration:kAnimDelay],
                                          _popAction,
                                          [SKAction waitForDuration:kAnimDelay],
                                          _popAction,
                                          [SKAction waitForDuration:kAnimDelay],
                                          _popAction,
                                          [SKAction runBlock:^{
        [self switchToGameOverJR];
    }]
                                          ]];
    [self runAction:pops];
    
}

-(void)setupScoreCardR:(int)LS {
    
    if (LS > [self bestScore]) {
        _score--;
        [self setBestScore:[self lastScore]+_score];
        _score++;
        [self runAction:_highScore];
    }
    
    //[self setLastScore:_score-1];
    
    SKSpriteNode *scorecard = [SKSpriteNode spriteNodeWithImageNamed:@"FinalSB-01"];
    scorecard.position = CGPointMake(self.size.width * 0.5, self.size.height/2);
    scorecard.name = @"Tutorial";
    scorecard.zPosition = LayerUI;
    [_worldNode addChild:scorecard];
    
    SKLabelNode *lastScore = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    lastScore.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    lastScore.fontSize = kFontSizeCard;
    lastScore.position = CGPointMake(-scorecard.size.width * 0.33, -scorecard.size.height * 0.2);
    
    SKSpriteNode *pokeSpriteNode;
    if (_score < 1) {
        lastScore.text = lastScore.text = [NSString stringWithFormat:@"%03d", LS+1];
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", LS+1]];
        pokeSpriteNode.scale = 1.9;
    }
    else if (_score >= 253) {
        lastScore.text = [NSString stringWithFormat:@"%03d", LS];
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:@"CrazyAsh1"];
        pokeSpriteNode.scale = 1.5;
    }
    else {
        lastScore.text = [NSString stringWithFormat:@"%03d", LS];
        pokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", LS]];
        pokeSpriteNode.scale = 1.9;//was 0.9
    }
    pokeSpriteNode.position = CGPointMake(-scorecard.size.width * 0.13, -scorecard.size.height * 0.1);
    [scorecard addChild:pokeSpriteNode];
    
    
    
    [scorecard addChild:lastScore];
    
    
    SKLabelNode *bestScore = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    bestScore.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    bestScore.fontSize = kFontSizeCard;
    bestScore.position = CGPointMake(scorecard.size.width * 0.18, -scorecard.size.height * 0.2);
    //===========================================================================
    
    SKSpriteNode *bestPokeSpriteNode;
    if ([self bestScore] < 1) {
        bestScore.text = [NSString stringWithFormat:@"Ash"];
        bestPokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:@"AshSprite1"];
        bestPokeSpriteNode.scale = 1.7;
    }
    else if ([self bestScore] >= 252) {
        bestScore.text = [NSString stringWithFormat:@"%03d", [self bestScore]];
        bestPokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:@"CrazyAsh1"];
        bestPokeSpriteNode.scale = 1.5;
    }
    else {
        bestScore.text = [NSString stringWithFormat:@"%03d", [self bestScore]];
        bestPokeSpriteNode = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d@2x", [self bestScore]]];
        bestPokeSpriteNode.scale = 1.9;
    }
    bestPokeSpriteNode.position = CGPointMake(scorecard.size.width * 0.38, -scorecard.size.height * 0.1);
    [scorecard addChild:bestPokeSpriteNode];
    
    [scorecard addChild:bestScore];
    
    //SKSpriteNode *ash = [SKSpriteNode spriteNodeWithImageNamed:@"AshSprite1"];
    //ash.position = CGPointMake(scorecard.size.width * 0.385, -scorecard.size.height * 0.1);
    //ash.scale = 1.4;
    // [scorecard addChild:ash];
    
    
    SKSpriteNode *gameOver = [SKSpriteNode spriteNodeWithImageNamed:@"YouFainted-01"];
    gameOver.position = CGPointMake(self.size.width/2, self.size.height/2 + scorecard.size.height/2 - kMargin/15 + gameOver.size.height/10);
    gameOver.zPosition = LayerUI;
    [_worldNode addChild:gameOver];
    
    SKSpriteNode *okButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    okButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.32);
    okButton.zPosition = LayerUI;
    [_worldNode addChild:okButton];
    
    SKSpriteNode *ok = [SKSpriteNode spriteNodeWithImageNamed:@"Retry2-01"];
    ok.position = CGPointZero;
    ok.zPosition = LayerUI;
    [okButton addChild:ok];
    
    SKSpriteNode *shareButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    shareButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.32);
    shareButton.zPosition = LayerUI;
    [_worldNode addChild:shareButton];
    
    SKSpriteNode *share = [SKSpriteNode spriteNodeWithImageNamed:@"PokeShare-01"];
    share.position = CGPointZero;
    share.zPosition = LayerUI;
    [shareButton addChild:share];
    
    
    //NUMPOTIONS
    
    SKSpriteNode *potionButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
    potionButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.16);
    potionButton.zPosition = LayerUI;
    [_worldNode addChild:potionButton];
    
    SKSpriteNode *potion = [SKSpriteNode spriteNodeWithImageNamed:@"ReviveIconPixelArt-01"];
    potion.position = CGPointZero;
    potion.zPosition = LayerUI;
    potion.position = CGPointMake(-potionButton.size.width * 0.15, potionButton.size.height * .0001);
    [potionButton addChild:potion];
    
    SKLabelNode *numPotions = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    [potionButton addChild:numPotions];
    numPotions.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    numPotions.fontSize = kFontSizeCard/2;
    numPotions.position = CGPointMake(potionButton.size.width * 0.17, -potionButton.size.height * .3);
    numPotions.zPosition = LayerUI;
    
    
    //ANIMATIONS ================================================
    gameOver.scale = 0;
    gameOver.alpha = 0;
    SKAction *group = [SKAction group:@[
                                        [SKAction fadeInWithDuration:kAnimDelay],
                                        [SKAction scaleTo:0.55 duration:kAnimDelay]
                                        ]];
    group.timingMode = SKActionTimingEaseInEaseOut;
    [gameOver runAction:[SKAction sequence:@[
                                             [SKAction waitForDuration:kAnimDelay],
                                             group
                                             ]]];
    
    scorecard.scale = 0.55;
    scorecard.position = CGPointMake(self.size.width * 0.5, -scorecard.size.height/2);
    SKAction *moveTo = [SKAction moveTo:CGPointMake(self.size.width/2, self.size.height/1.95) duration:kAnimDelay];
    moveTo.timingMode = SKActionTimingEaseInEaseOut;
    [scorecard runAction:[SKAction sequence:@[
                                              [SKAction waitForDuration:kAnimDelay*2],
                                              moveTo
                                              ]]];
    
    [self setTotalPotions: [self totalPotions]-1];
    numPotions.text = [NSString stringWithFormat:@"x%d", [self totalPotions]];

    share.scale = 0.34;
    ok.scale = 0.18;
    potion.scale = .12;
    okButton.alpha = 0;
    shareButton.alpha = 0;
    potionButton.alpha = 0;
    SKAction *fadeIn = [SKAction sequence:@[
                                            [SKAction waitForDuration:kAnimDelay*3],
                                            [SKAction fadeInWithDuration:kAnimDelay]
                                            ]];
    [okButton runAction:fadeIn];
    [shareButton runAction:fadeIn];
    [potionButton runAction:fadeIn];
    //[numPotions runAction:fadeIn];
    
    SKAction *pops = [SKAction sequence:@[
                                          [SKAction waitForDuration:kAnimDelay],
                                          _popAction,
                                          [SKAction waitForDuration:kAnimDelay],
                                          _popAction,
                                          [SKAction waitForDuration:kAnimDelay],
                                          _popAction,
                                          [SKAction runBlock:^{
        [self switchToGameOverR];
    }]
                                          ]];
    [self runAction:pops];
    
}


- (void)setupTutorial {
    SKSpriteNode *tutorial = [SKSpriteNode spriteNodeWithImageNamed:@"TutorialGreen-01"];
    tutorial.position = CGPointMake((int)self.size.width * 0.5, (int)_playableHeight * 0.35 + _playableStart);
    tutorial.name = @"Tutorial";
    tutorial.scale = 0.33;
    tutorial.zPosition = LayerUI;
    [_worldNode addChild:tutorial];
    
    SKSpriteNode *ready = [SKSpriteNode spriteNodeWithImageNamed:@"TutorialReady-01"];
    ready.position = CGPointMake(self.size.width * 0.5, _playableHeight * 0.65 + _playableStart);
    ready.scale = 0.33;
    ready.name = @"Tutorial";
    ready.zPosition = LayerUI;
    [_worldNode addChild:ready];
    
    //Replace 5 with last Pokemon in Kanto region
    if ([self bestScore] < 151) {
        SKSpriteNode *JohtoButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
        JohtoButton.zPosition = LayerUI;
        ///////////////////////////
        JohtoButton.name = @"JohtoButton";
        [_worldNode addChild:JohtoButton];
        
        SKSpriteNode *Johto = [SKSpriteNode spriteNodeWithImageNamed:@"JohtoButton-01"];
        Johto.scale = 0.3;
        Johto.position = CGPointMake(-13, 0);
        [JohtoButton addChild:Johto];
        
        JohtoButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.13);
        
        SKSpriteNode *Lock = [SKSpriteNode spriteNodeWithImageNamed:@"lock-6"];
        Lock.scale = 0.12;
        Lock.position = CGPointMake(38, 3);
        [JohtoButton addChild:Lock];
    }
    else if ([self bestScore] >= 151) {
        SKSpriteNode *JohtoButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
        JohtoButton.zPosition = LayerUI;
        ////////////////////////
        JohtoButton.name = @"JohtoButton";
        [_worldNode addChild:JohtoButton];
        
        SKSpriteNode *Johto = [SKSpriteNode spriteNodeWithImageNamed:@"JohtoButton-01"];
        Johto.scale = 0.4;
        Johto.position = CGPointMake(0, 0);
        [JohtoButton addChild:Johto];
        
        JohtoButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.13);
    }



}

- (void)setupMainMenu {
    
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"PokeJumpGreenLogo-01"];
    logo.position = CGPointMake(self.size.width/2, self.size.height * 0.78);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0;
    logo.alpha = 0;
    SKAction *group = [SKAction group:@[
                                        [SKAction fadeInWithDuration:kAnimDelay],
                                        [SKAction scaleTo:0.5 duration:kAnimDelay]
                                        ]];
    group.timingMode = SKActionTimingEaseInEaseOut;
    [logo runAction:[SKAction sequence:@[
                                             [SKAction waitForDuration:kAnimDelay],
                                             group
                                             ]]];
    
    // Play button
    
    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    playButton.zPosition = LayerUI;
    [_worldNode addChild:playButton];
    
    SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"PokePlay-01"];
    play.scale = 0.4;
    play.position = CGPointMake(0, 0);
    [playButton addChild:play];
    
    playButton.position = CGPointMake(self.size.width * 0.25, -playButton.size.height/2);
    SKAction *moveTo = [SKAction moveTo:CGPointMake(self.size.width * 0.25, self.size.height * 0.21) duration:kAnimDelay];
    moveTo.timingMode = SKActionTimingEaseInEaseOut;
    [playButton runAction:[SKAction sequence:@[
                                              [SKAction waitForDuration:kAnimDelay*1.5],
                                              moveTo
                                              ]]];
    
    // Rate button
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"Rate-01"];
    rate.scale = 0.205;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, -rateButton.size.height/2);
    SKAction *moveTo2 = [SKAction moveTo:CGPointMake(self.size.width * 0.75, self.size.height * 0.21) duration:kAnimDelay];
    moveTo2.timingMode = SKActionTimingEaseInEaseOut;
    [rateButton runAction:[SKAction sequence:@[
                                               [SKAction waitForDuration:kAnimDelay*1.5],
                                               moveTo2
                                               ]]];
    
    //My Pokemon Button
    
    SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosed-01"];
    myPokemonButton.zPosition = LayerUI;
    myPokemonButton.scale = 0.1;
    [_worldNode addChild:myPokemonButton];
    
    myPokemonButton.position = CGPointMake(self.size.width * 0.5, -self.size.height * 0.5);
    SKAction *moveTo3 = [SKAction moveTo:CGPointMake(self.size.width * 0.5, self.size.height * 0.09) duration:kAnimDelay];
    moveTo3.timingMode = SKActionTimingEaseInEaseOut;
    [myPokemonButton runAction:[SKAction sequence:@[
                                               [SKAction waitForDuration:kAnimDelay*1.5],
                                               moveTo3
                                               ]]];
    
    // Learn button
    //SKSpriteNode *learn = [SKSpriteNode spriteNodeWithImageNamed:@"button_learn"];
    //learn.position = CGPointMake(self.size.width * 0.5, learn.size.height/2 + kMargin);
    //learn.zPosition = LayerUI;
    //[_worldNode addChild:learn];
    
    // Bounce button
    //SKAction *scaleUp = [SKAction scaleTo:1.02 duration:0.75];
    //scaleUp.timingMode = SKActionTimingEaseInEaseOut;
    //SKAction *scaleDown = [SKAction scaleTo:0.98 duration:0.75];
    //scaleDown.timingMode = SKActionTimingEaseInEaseOut;
    
    //[learn runAction:[SKAction repeatActionForever:[SKAction sequence:@[scaleUp, scaleDown]]]];
    
    //[learn removeAllActions]; // DONLY
    

}

- (void)setupMyPokemon {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0;
    logo.alpha = 0;
    SKAction *group = [SKAction group:@[
                                        [SKAction fadeInWithDuration:kAnimDelay],
                                        [SKAction scaleTo:0.26 duration:kAnimDelay]
                                        ]];
    group.timingMode = SKActionTimingEaseInEaseOut;
    [logo runAction:[SKAction sequence:@[
                                         [SKAction waitForDuration:kAnimDelay],
                                         group
                                         ]]];
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0;
    pokeball.alpha = 0;
    SKAction *group2 = [SKAction group:@[
                                        [SKAction fadeInWithDuration:kAnimDelay],
                                        [SKAction scaleTo:0.082 duration:kAnimDelay]
                                        ]];
    group2.timingMode = SKActionTimingEaseInEaseOut;
    [pokeball runAction:[SKAction sequence:@[
                                         [SKAction waitForDuration:kAnimDelay],
                                         group2
                                         ]]];
    
    //blank slate
    

    //Add Pokemon to blank slate
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon:[self bestScore]];
    // Left button
    

    
    // Right button
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, -rateButton.size.height/2);
    SKAction *moveTo3 = [SKAction moveTo:CGPointMake(self.size.width * 0.75, self.size.height * 0.1) duration:kAnimDelay];
    moveTo3.timingMode = SKActionTimingEaseInEaseOut;
    [rateButton runAction:[SKAction sequence:@[
                                               [SKAction waitForDuration:kAnimDelay*1.5],
                                               moveTo3
                                               ]]];
}

- (void)setupMyPokemon1 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon1:[self bestScore]];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon2 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon2:[self bestScore]];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);

}

- (void)setupMyPokemon3 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon3:[self bestScore]];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon4 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon4:[self bestScore]];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon5 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon5:[self bestScore]];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon6 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon6:[self bestScore]];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon7 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon7:[self bestScore]];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon8 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon8:[self bestScore]];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon9 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon9:[self bestScore]];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon10 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon10:[self bestScore]];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon11 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon11:[self bestScore]];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon12 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon12:[self bestScore]];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon13 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon13:[self bestScore]];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon14 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon14:[self bestScore]];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon15 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon15:[self bestScore]];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon16 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon16:[self bestScoreJ]+151];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon17 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon17:[self bestScoreJ]+151];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon18 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon18:[self bestScoreJ]+151];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon19 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon19:[self bestScoreJ]+151];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon20 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon20:[self bestScoreJ]+151];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon21 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon21:[self bestScoreJ]+151];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon22 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon22:[self bestScoreJ]+151];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon23 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon23:[self bestScoreJ]+151];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon24 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon24:[self bestScoreJ]+151];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon25 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon25:[self bestScoreJ]+151];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
    SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    rateButton.zPosition = LayerUI;
    [_worldNode addChild:rateButton];
    
    SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
    rate.scale = 0.22;
    rate.position = CGPointMake(0, 0);
    [rateButton addChild:rate];
    
    rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
    
}

- (void)setupMyPokemon26 {
    
    //MyPokemon
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"MyPokemonLogo-01"];
    logo.position = CGPointMake(self.size.width*0.6, self.size.height * 0.84);
    //logo.scale = 0.5;
    logo.zPosition = LayerUI;
    [_worldNode addChild:logo];
    
    logo.scale = 0.26;
    //Home Pokemon Button
    
    SKSpriteNode *pokeball = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
    pokeball.position = CGPointMake(self.size.width*0.14, self.size.height * 0.84);
    //logo.scale = 0.5;
    pokeball.zPosition = LayerUI;
    [_worldNode addChild:pokeball];
    
    pokeball.scale = 0.082;
    
    SKLabelNode *num = [[SKLabelNode alloc] initWithFontNamed:kFontName];
    num.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
    num.fontSize = kFontSizeCard;
    //num.position = CGPointMake(-blankSlate.size.width * 0.33, -blankSlate.size.height * 0.2);
    
    [self addPokemon26:[self bestScoreJ]+151];
    
    SKSpriteNode *leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
    leftButton.zPosition = LayerUI;
    [_worldNode addChild:leftButton];
    
    SKSpriteNode *left = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
    left.scale = 0.22;
    leftButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
    [leftButton addChild:left];
    
}

- (void) setupHoOh {
    
    
    _HoOh = [SKSpriteNode spriteNodeWithImageNamed:@"HoOh0"];
    _HoOh.position = CGPointMake(self.size.width/2, self.size.height * 0.82);
    //logo.scale = 0.5;
    _HoOh.zPosition = LayerBackground;
    [_worldNode addChild:_HoOh];
    
    
}
- (void)setupPlayerAnimation {
   NSMutableArray *textures = [NSMutableArray array];
    
    // #2: Good
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Test3"];
    
    for (int i = 0; i < kNumBirdFrames; i++) {
        NSString *textureName = [NSString stringWithFormat:@"PokeSprites%d", i];
        // #1: Bad
        //    [textures addObject:[SKTexture textureWithImageNamed:textureName]];
        // #2: Good
        [textures addObject:[atlas textureNamed:textureName]];

    }
    
   for (int i = kNumBirdFrames - 2; i > 0; i--) {
    NSString *textureName = [NSString stringWithFormat:@"PokeSprites%d", i];
     [textures addObject:[atlas textureNamed:textureName]];

    }
    SKAction *playerAnimation = [SKAction animateWithTextures:textures timePerFrame:0.15];
    [_player runAction:[SKAction repeatActionForever:playerAnimation] withKey:@"animation"];

    
}

- (void)setupPlayerAnimationJ {
    NSMutableArray *textures = [NSMutableArray array];
    
    // #2: Good
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Test3"];
    
    for (int i = 0; i < kNumBirdFrames; i++) {
        NSString *textureName = [NSString stringWithFormat:@"PokeSprites%d", i];
        // #1: Bad
        //    [textures addObject:[SKTexture textureWithImageNamed:textureName]];
        // #2: Good
        [textures addObject:[atlas textureNamed:textureName]];
        
    }
    
    for (int i = kNumBirdFrames - 2; i > 0; i--) {
        NSString *textureName = [NSString stringWithFormat:@"PokeSprites%d", i];
        [textures addObject:[atlas textureNamed:textureName]];
        
    }
    SKAction *playerAnimation = [SKAction animateWithTextures:textures timePerFrame:0.13];
    [_player runAction:[SKAction repeatActionForever:playerAnimation] withKey:@"animation"];
    
    
}

- (void)setupHoOhAnimation {
    NSMutableArray *textures = [NSMutableArray array];
    
    // #2: Good
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"HoOhFrames"];
    
    for (int i = 0; i < kNumHoOhFrames; i++) {
        NSString *textureName = [NSString stringWithFormat:@"HoOh%d", i];
        // #1: Bad
        //    [textures addObject:[SKTexture textureWithImageNamed:textureName]];
        // #2: Good
        [textures addObject:[atlas textureNamed:textureName]];
        
    }
    
    for (int i = kNumBirdFrames - 7; i > 0; i--) {
        NSString *textureName = [NSString stringWithFormat:@"HoOh%d", i];
        [textures addObject:[atlas textureNamed:textureName]];
        
    }
    SKAction *playerAnimation = [SKAction animateWithTextures:textures timePerFrame:0.15];
    [_HoOh runAction:[SKAction repeatActionForever:playerAnimation] withKey:@"animation"];
    
    _HoOh.scale = 0.5;
    _HoOh.zPosition = LayerBackground;
    
    _HoOh.position = CGPointMake(self.size.width * 1.2, self.size.height * 0.55);
    SKAction *moveTo = [SKAction moveTo:CGPointMake(self.size.width * -0.6, self.size.height * 0.55) duration:kHoOhDelay*2];
    moveTo.timingMode = SKActionTimingEaseInEaseOut;
    [_HoOh runAction:[SKAction sequence:@[
                                              [SKAction waitForDuration:kAnimDelay],
                                              moveTo
                                              ]]];
    
}


- (void)setupHoOhAnimationGame {
    NSMutableArray *textures = [NSMutableArray array];
    
    // #2: Good
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"HoOhFrames"];
    
    for (int i = 0; i < kNumHoOhFrames; i++) {
        NSString *textureName = [NSString stringWithFormat:@"HoOh%d", i];
        // #1: Bad
        //    [textures addObject:[SKTexture textureWithImageNamed:textureName]];
        // #2: Good
        [textures addObject:[atlas textureNamed:textureName]];
        
    }
    
    for (int i = kNumBirdFrames - 7; i > 0; i--) {
        NSString *textureName = [NSString stringWithFormat:@"HoOh%d", i];
        [textures addObject:[atlas textureNamed:textureName]];
        
    }
    SKAction *playerAnimation = [SKAction animateWithTextures:textures timePerFrame:0.15];
    [_HoOh runAction:[SKAction repeatActionForever:playerAnimation] withKey:@"animation"];
    
    _HoOh.scale = 0.5;
    _HoOh.zPosition = LayerBackground;
    
    _HoOh.position = CGPointMake(self.size.width * 1.2, self.size.height * 0.65);
    SKAction *moveTo = [SKAction moveTo:CGPointMake(self.size.width * -0.6, self.size.height * 0.65) duration:kHoOhDelay*2.5];
    moveTo.timingMode = SKActionTimingEaseInEaseOut;
    [_HoOh runAction:[SKAction sequence:@[
                                          [SKAction waitForDuration:kAnimDelay*200],
                                          moveTo
                                          ]]];
    
}
- (void)setupCrazyAnimation {
    NSMutableArray *textures = [NSMutableArray array];
    
    // #2: Good
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"CrazyAsh"];
    
    for (int i = 0; i < kNumBirdFrames; i++) {
        NSString *textureName = [NSString stringWithFormat:@"CrazyAsh%d", i];
        // #1: Bad
        //    [textures addObject:[SKTexture textureWithImageNamed:textureName]];
        // #2: Good
        [textures addObject:[atlas textureNamed:textureName]];
        
    }
    
    for (int i = kNumBirdFrames - 2; i > 0; i--) {
        NSString *textureName = [NSString stringWithFormat:@"CrazyAsh%d", i];
        [textures addObject:[atlas textureNamed:textureName]];
        
    }
    SKAction *crazyAnimation = [SKAction animateWithTextures:textures timePerFrame:0.07];
    [_player runAction:[SKAction repeatActionForever:crazyAnimation] withKey:@"animation"];
    
    
}

#pragma mark - Gameplay

- (SKSpriteNode *)createObstacle {
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"NewTreeObstacle"];
    sprite.userData = [NSMutableDictionary dictionary];
    sprite.zPosition = LayerObstacle;
    
    CGFloat offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
    CGFloat offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 0 - offsetX, 307 - offsetY);
    CGPathAddLineToPoint(path, NULL, 47 - offsetX, 313 - offsetY);
    CGPathAddLineToPoint(path, NULL, 65 - offsetX, 311 - offsetY);
    CGPathAddLineToPoint(path, NULL, 69 - offsetX, 301 - offsetY);
    CGPathAddLineToPoint(path, NULL, 68 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 1 - offsetY);
    
    CGPathCloseSubpath(path);
    
    sprite.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    
    [sprite skt_attachDebugFrameFromPath:path color:[SKColor redColor]];
    
    sprite.physicsBody.categoryBitMask = EntityCategoryObstacle;
    sprite.physicsBody.collisionBitMask = 0;
    sprite.physicsBody.contactTestBitMask = EntityCategoryPlayer;
    
    return sprite;
}

- (void)spawnObstacle {
    
    SKSpriteNode *bottomObstacle = [self createObstacle];
    bottomObstacle.name = @"BottomObstacle";
    float startX = self.size.width + bottomObstacle.size.width/2;
    
    float bottomObstacleMin = (_playableStart - bottomObstacle.size.height/2) + _playableHeight * kBottomObstacleMinFraction;
    float bottomObstacleMax = (_playableStart - bottomObstacle.size.height/2) + _playableHeight * kBottomObstacleMaxFraction;
    bottomObstacle.position = CGPointMake(startX, RandomFloatRange(bottomObstacleMin, bottomObstacleMax));
    [_worldNode addChild:bottomObstacle];
    
    SKSpriteNode *topObstacle = [self createObstacle];
    topObstacle.name = @"TopObstacle";
    topObstacle.zRotation = DegreesToRadians(180);
    topObstacle.position = CGPointMake(startX, bottomObstacle.position.y + bottomObstacle.size.height/2 + topObstacle.size.height/2 + _player.size.height * kGapMultiplier);
    [_worldNode addChild:topObstacle];
    
    float moveX = self.size.width + topObstacle.size.width;
    float moveDuration = moveX / kGroundSpeed;
    SKAction *sequence = [SKAction sequence:@[
                                              [SKAction moveByX:-moveX y:0 duration:moveDuration],
                                              [SKAction removeFromParent]
                                              ]];
    
    [topObstacle runAction:sequence];
    [bottomObstacle runAction:sequence];
    
    
}

- (void)spawnObstacleJ {
    
    SKSpriteNode *bottomObstacle = [self createObstacle];
    bottomObstacle.name = @"BottomObstacle";
    float startX = self.size.width + bottomObstacle.size.width/2;
    
    float bottomObstacleMin = (_playableStart - bottomObstacle.size.height/2) + _playableHeight * kBottomObstacleMinFraction;
    float bottomObstacleMax = (_playableStart - bottomObstacle.size.height/2) + _playableHeight * kBottomObstacleMaxFraction;
    bottomObstacle.position = CGPointMake(startX, RandomFloatRange(bottomObstacleMin, bottomObstacleMax));
    [_worldNode addChild:bottomObstacle];
    
    SKSpriteNode *topObstacle = [self createObstacle];
    topObstacle.name = @"TopObstacle";
    topObstacle.zRotation = DegreesToRadians(180);
    topObstacle.position = CGPointMake(startX, bottomObstacle.position.y + bottomObstacle.size.height/2 + topObstacle.size.height/2 + _player.size.height * kGapMultiplier);
    [_worldNode addChild:topObstacle];
    
    float moveX = self.size.width + topObstacle.size.width;
    float moveDuration = moveX / kGroundSpeedJ;
    SKAction *sequence = [SKAction sequence:@[
                                              [SKAction moveByX:-moveX y:0 duration:moveDuration],
                                              [SKAction removeFromParent]
                                              ]];
    
    [topObstacle runAction:sequence];
    [bottomObstacle runAction:sequence];
    
    
}

- (void)startSpawning {
    
    SKAction *firstDelay = [SKAction waitForDuration:kFirstSpawnDelay];
    SKAction *spawn = [SKAction performSelector:@selector(spawnObstacle) onTarget:self];
    SKAction *everyDelay = [SKAction waitForDuration:kEverySpawnDelay];
    SKAction *spawnSequence = [SKAction sequence:@[spawn, everyDelay]];
    SKAction *foreverSpawn = [SKAction repeatActionForever:spawnSequence];
    SKAction *overallSequence = [SKAction sequence:@[firstDelay, foreverSpawn]];
    [self runAction:overallSequence withKey:@"Spawn"];
    
}

- (void)startSpawningR {
    
    SKAction *firstDelay = [SKAction waitForDuration:kFirstSpawnDelayR];
    SKAction *spawn = [SKAction performSelector:@selector(spawnObstacle) onTarget:self];
    SKAction *everyDelay = [SKAction waitForDuration:kEverySpawnDelay];
    SKAction *spawnSequence = [SKAction sequence:@[spawn, everyDelay]];
    SKAction *foreverSpawn = [SKAction repeatActionForever:spawnSequence];
    SKAction *overallSequence = [SKAction sequence:@[firstDelay, foreverSpawn]];
    [self runAction:overallSequence withKey:@"Spawn"];
    
}

- (void)startSpawningJ {
    
    SKAction *firstDelay = [SKAction waitForDuration:kFirstSpawnDelayJ];
    SKAction *spawn = [SKAction performSelector:@selector(spawnObstacleJ) onTarget:self];
    SKAction *everyDelay = [SKAction waitForDuration:kEverySpawnDelayJ];
    SKAction *spawnSequence = [SKAction sequence:@[spawn, everyDelay]];
    SKAction *foreverSpawn = [SKAction repeatActionForever:spawnSequence];
    SKAction *overallSequence = [SKAction sequence:@[firstDelay, foreverSpawn]];
    [self runAction:overallSequence withKey:@"Spawn"];
    
}

- (void)stopSpawning {
    [self removeActionForKey:@"Spawn"];
    [_worldNode enumerateChildNodesWithName:@"TopObstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeAllActions];
    }];
    [_worldNode enumerateChildNodesWithName:@"BottomObstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeAllActions];
    }];
}

- (void)flapPlayer {
    
    // Play sound
    [self runAction:_flapAction];
    
    // Apply impulse
    _playerVelocity = CGPointMake(0, kImpulse);
    
    // Angular velocity
    _playerAngularVelocity = DegreesToRadians(kAngularVelocity);
    _lastTouchTime = _lastUpdateTime;
    _lastTouchY = _player.position.y;
    
    // Move sombrero
   // SKAction *moveUp = [SKAction moveByX:0 y:12 duration:0.15];
   // moveUp.timingMode = SKActionTimingEaseInEaseOut;
   // SKAction *moveDown = [moveUp reversedAction];
    //[_sombrero runAction:[SKAction sequence:@[moveUp, moveDown]]];
    
}
- (void)flapPlayerJohto {
    
    // Play sound
    [self runAction:_flapAction];
    
    // Apply impulse
    _playerVelocity = CGPointMake(0, kImpulseJohto);
    
    // Angular velocity
    _playerAngularVelocity = DegreesToRadians(kAngularVelocity);
    _lastTouchTime = _lastUpdateTime;
    _lastTouchY = _player.position.y;
    
    // Move sombrero
    // SKAction *moveUp = [SKAction moveByX:0 y:12 duration:0.15];
    // moveUp.timingMode = SKActionTimingEaseInEaseOut;
    // SKAction *moveDown = [moveUp reversedAction];
    //[_sombrero runAction:[SKAction sequence:@[moveUp, moveDown]]];
    
}
//TOUCHES+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    switch (_gameState) {
        case GameStateMainMenu:
            if (touchLocation.y < self.size.height * 0.15 && touchLocation.x > self.size.width * 0.2 && touchLocation.x < self.size.width * 0.8) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
                myPokemonButton.scale = 0.1;
                myPokemonButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.09);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
                
            }
            else if (touchLocation.y > self.size.height * 0.3) {
                
            }
            else if (touchLocation.x < self.size.width * 0.06) {
                
            }
            else if (touchLocation.x > self.size.width * 0.94) {
                
            }
            else if (touchLocation.x < self.size.width * 0.46 && touchLocation.y > self.size.width * .15) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                playButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.21);
                playButton.zPosition = LayerUI;
                [_worldNode addChild:playButton];
                
                SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"PokePlay-01"];
                play.scale = 0.4;
                play.position = CGPointMake(0, 0);
                [playButton addChild:play];
            }
            else if (touchLocation.x > self.size.width * 0.54 && touchLocation.y > self.size.width * .15) {
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.21);
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"Rate-01"];
                rate.scale = 0.205;
                rate.position = CGPointMake(0, 0);
                [rateButton addChild:rate];
            }
            break;
        case GameStateMainMenuS:
            if (touchLocation.y < self.size.height * 0.2 && touchLocation.x > self.size.width * 0.2 && touchLocation.x < self.size.width * 0.8) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
                myPokemonButton.scale = 0.1;
                myPokemonButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.09);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
                
            }
            else if (touchLocation.y > self.size.height * 0.3) {
                
            }
            else if (touchLocation.x < self.size.width * 0.06) {
                
            }
            else if (touchLocation.x > self.size.width * 0.94) {
                
            }
            else if (touchLocation.x < self.size.width * 0.46 && touchLocation.y > self.size.width * .15) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                playButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.21);
                playButton.zPosition = LayerUI;
                [_worldNode addChild:playButton];
                
                SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"PokePlay-01"];
                play.scale = 0.4;
                play.position = CGPointMake(0, 0);
                [playButton addChild:play];
            }
            else if (touchLocation.x > self.size.width * 0.54 && touchLocation.y > self.size.width * .15) {
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.21);
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"Rate-01"];
                rate.scale = 0.205;
                rate.position = CGPointMake(0, 0);
                [rateButton addChild:rate];
            }
            break;
        case GameStateMyPokemon:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard1:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard2:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard3:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard4:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard5:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard6:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard7:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard8:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard9:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard10:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard11:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard12:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard13:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard14:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard15:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard16:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard17:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard18:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard19:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard20:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard21:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard22:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard23:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard24:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard25:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            } else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"RightArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStatePokeCard26:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallClosedBlue4-01"];
                myPokemonButton.scale = 0.09;
                myPokemonButton.position = CGPointMake(self.size.width*0.14, self.size.height * 0.845);
                myPokemonButton.zPosition = LayerUI;
                [_worldNode addChild:myPokemonButton];
            } else if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height * 0.5){
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"LeftArrow-01"];
                rate.scale = 0.22;
                rateButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.1);
                [rateButton addChild:rate];
            }
            break;
        case GameStateTutorial:
            if ([self bestScore] < 151) {
            if (touchLocation.x < self.size.width * .45 && touchLocation.y < self.size.height * 0.3){
                        }
            else{
                [self switchToPlay];
            }
            }
            else if ([self bestScore] >= 151) {
                if (touchLocation.x < self.size.width * .45 && touchLocation.y < self.size.height * 0.3){
                    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                    playButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.13);
                    playButton.zPosition = LayerUI;
                    playButton.name = @"JohtoHL";
                    [_worldNode addChild:playButton];
                    
                    SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"JohtoButton-01"];
                    play.scale = 0.4;
                    play.position = CGPointMake(0, 0);
                    [playButton addChild:play];
                }
                else{
                    [self switchToPlay];
                }
            }
            break;
//==============================REVIVE STUFF============================
//==============================REVIVE STUFF============================
//==============================REVIVE STUFF============================
        case GameStateTutorialR:
            //if ([self bestScore] < 151) {
                    [self switchToPlayR:[self lastScore]];
            //[self checkHitGround];
            //}
            break;
        case GameStateTutorialJR:
            //if ([self bestScore] < 151) {
            [self switchToPlayJR:[self lastScoreJ]];
            //[self checkHitGround];
            //}
            break;
        case GameStateLockedJohto:
            if (touchLocation.y < self.size.height * 0.5){
                
                SKSpriteNode *gotItButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                gotItButton.zPosition = LayerUI;
                gotItButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.32);
                [_worldNode addChild:gotItButton];
                
                SKSpriteNode *gotIt = [SKSpriteNode spriteNodeWithImageNamed:@"Gotit-01"];
                gotIt.scale = 0.35;
                gotIt.position = CGPointMake(0, 0);
                [gotItButton addChild:gotIt];
                
                [self switchToNewGame:GameStateTutorial];
            }
            break;
        case GameStateReviveHey:
            if (touchLocation.y < self.size.height * 0.5){
                
                SKSpriteNode *gotItButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                gotItButton.zPosition = LayerUI;
                gotItButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.32);
                [_worldNode addChild:gotItButton];
                
                SKSpriteNode *gotIt = [SKSpriteNode spriteNodeWithImageNamed:@"Gotit-01"];
                gotIt.scale = 0.35;
                gotIt.position = CGPointMake(0, 0);
                [gotItButton addChild:gotIt];
                
                [self switchToNewGame:GameStateTutorial];
            }
            break;
        case GameStateZeroRevives:
            if (touchLocation.y < self.size.height * 0.4 && touchLocation.y > self.size.height * 0.2 && touchLocation.x > self.size.width * 0.15 && touchLocation.x < self.size.width * 0.85){
                
                [self switchToNewGame:GameStateTutorial];
                
            }
            break;
        case GameStatePlayR:
            if ([self bestScore] < 151) {
                    
                    //RETURN HERE REVIVE STUFF
                    //[self setupPokemon:_score];
                    [self flapPlayer];
                    //self updatePlayer];
                    
                    //[self updateScoreR];
                    //[self setupPlayerR:[self bestScore]];
                
            }
            else if ([self bestScore] >= 151) {
                if (touchLocation.x < self.size.width * .45 && touchLocation.y < self.size.height * 0.3){
                    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                    playButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.10);
                    playButton.zPosition = LayerUI;
                    playButton.name = @"JohtoHL";
                    [_worldNode addChild:playButton];
                    
                    SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"JohtoButton-01"];
                    play.scale = 0.4;
                    play.position = CGPointMake(0, 0);
                    [playButton addChild:play];
                }
                else{
                    [self flapPlayer];
                }
            }
            break;
        case GameStatePlayJR:
            if ([self bestScore] < 151) {
                
                //RETURN HERE REVIVE STUFF
                //[self setupPokemon:_score];
                [self flapPlayer];
                //self updatePlayer];
                
                //[self updateScoreR];
                //[self setupPlayerR:[self bestScore]];
                
            }
            else if ([self bestScore] >= 151) {
                if (touchLocation.x < self.size.width * .45 && touchLocation.y < self.size.height * 0.3){
                    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                    playButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.10);
                    playButton.zPosition = LayerUI;
                    playButton.name = @"JohtoHL";
                    [_worldNode addChild:playButton];
                    
                    SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"JohtoButton-01"];
                    play.scale = 0.4;
                    play.position = CGPointMake(0, 0);
                    [playButton addChild:play];
                }
                else{
                    [self flapPlayer];
                }
            }
            break;
        case GameStatePlay:
            [self flapPlayer];
            break;
        case GameStatePlayJ:
            [self flapPlayer];
            break;
        case GameStateFalling:
            break;
        case GameStateFallingJ:
            break;
        case GameStateFallingR:
            break;
        case GameStateFallingJR:
            break;
        case GameStateShowingScore:
            break;
        case GameStateShowingScoreJ:
            break;
        case GameStateShowingScoreR:
            break;
        case GameStateGameOver:
            if (touchLocation.y < self.size.height * 0.2 && touchLocation.y > self.size.height * 0.08 && touchLocation.x > self.size.width * 0.15 && touchLocation.x < self.size.width * 0.85) {
                SKSpriteNode *potionButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                potionButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.16);
                potionButton.zPosition = LayerUI;
                [_worldNode addChild:potionButton];
                
                SKSpriteNode *potion = [SKSpriteNode spriteNodeWithImageNamed:@"ReviveIconPixelArt-01"];
                potion.position = CGPointZero;
                potion.zPosition = LayerUI;
                potion.position = CGPointMake(-potionButton.size.width * 0.15, potionButton.size.height * .0001);
                potion.scale = 0.12;
                [potionButton addChild:potion];
                
                SKLabelNode *numPotions = [[SKLabelNode alloc] initWithFontNamed:kFontName];
                [potionButton addChild:numPotions];
                numPotions.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
                numPotions.fontSize = kFontSizeCard/2;
                numPotions.position = CGPointMake(potionButton.size.width * 0.17, -potionButton.size.height * .3);
                numPotions.zPosition = LayerUI;
                
            }
            else if (touchLocation.y > self.size.height * 0.5 && touchLocation.x > self.size.width * 0.4 && touchLocation.x < self.size.width * 0.6 && touchLocation.y < self.size.height * 0.9) {
                
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
                myPokemonButton.zPosition = LayerUI;
                myPokemonButton.scale = 0.1;
                [_worldNode addChild:myPokemonButton];
                
                myPokemonButton.position = CGPointMake(self.size.width * 0.506, self.size.height * 0.764);
                
            }
            else if (touchLocation.x < self.size.width * 0.06) {
                
            }
            else if (touchLocation.x > self.size.width * 0.94) {
                
            }
            else if (touchLocation.x < self.size.width * 0.46) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                playButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.32);
                playButton.zPosition = LayerUI;
                [_worldNode addChild:playButton];
                
                SKSpriteNode *ok = [SKSpriteNode spriteNodeWithImageNamed:@"Retry2-01"];
                ok.scale = 0.18;
                ok.position = CGPointZero;
                ok.zPosition = LayerUI;
                [playButton addChild:ok];
            }
            else if (touchLocation.x > self.size.width * 0.54) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                playButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.32);
                playButton.zPosition = LayerUI;
                [_worldNode addChild:playButton];
                
                SKSpriteNode *ok = [SKSpriteNode spriteNodeWithImageNamed:@"PokeShare-01"];
                ok.scale = 0.34;
                ok.position = CGPointZero;
                ok.zPosition = LayerUI;
                [playButton addChild:ok];
            }
            //if (touchLocation.x < self.size.width * 0.6) {
            //    [self switchToNewGame:GameStateMainMenu];
            //} else {
            //    [self shareScore];
            //}
            break;
        case GameStateGameOverR:
            if (touchLocation.y < self.size.height * 0.2 && touchLocation.y > self.size.height * 0.08 && touchLocation.x > self.size.width * 0.15 && touchLocation.x < self.size.width * 0.85) {
                SKSpriteNode *potionButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                potionButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.16);
                potionButton.zPosition = LayerUI;
                [_worldNode addChild:potionButton];
                
                SKSpriteNode *potion = [SKSpriteNode spriteNodeWithImageNamed:@"ReviveIconPixelArt-01"];
                potion.position = CGPointZero;
                potion.zPosition = LayerUI;
                potion.position = CGPointMake(-potionButton.size.width * 0.15, potionButton.size.height * .0001);
                potion.scale = 0.12;
                [potionButton addChild:potion];
                
                SKLabelNode *numPotions = [[SKLabelNode alloc] initWithFontNamed:kFontName];
                [potionButton addChild:numPotions];
                numPotions.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
                numPotions.fontSize = kFontSizeCard/2;
                numPotions.position = CGPointMake(potionButton.size.width * 0.17, -potionButton.size.height * .3);
                numPotions.zPosition = LayerUI;
                
            }
            else if (touchLocation.y > self.size.height * 0.5 && touchLocation.x > self.size.width * 0.4 && touchLocation.x < self.size.width * 0.6 && touchLocation.y < self.size.height * 0.9) {
                
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
                myPokemonButton.zPosition = LayerUI;
                myPokemonButton.scale = 0.1;
                [_worldNode addChild:myPokemonButton];
                
                myPokemonButton.position = CGPointMake(self.size.width * 0.506, self.size.height * 0.764);
                
            }
            else if (touchLocation.x < self.size.width * 0.06) {
                
            }
            else if (touchLocation.x > self.size.width * 0.94) {
                
            }
            else if (touchLocation.x < self.size.width * 0.46) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                playButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.32);
                playButton.zPosition = LayerUI;
                [_worldNode addChild:playButton];
                
                SKSpriteNode *ok = [SKSpriteNode spriteNodeWithImageNamed:@"Retry2-01"];
                ok.scale = 0.18;
                ok.position = CGPointZero;
                ok.zPosition = LayerUI;
                [playButton addChild:ok];
            }
            else if (touchLocation.x > self.size.width * 0.54) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                playButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.32);
                playButton.zPosition = LayerUI;
                [_worldNode addChild:playButton];
                
                SKSpriteNode *ok = [SKSpriteNode spriteNodeWithImageNamed:@"PokeShare-01"];
                ok.scale = 0.34;
                ok.position = CGPointZero;
                ok.zPosition = LayerUI;
                [playButton addChild:ok];
            }
            //if (touchLocation.x < self.size.width * 0.6) {
            //    [self switchToNewGame:GameStateMainMenu];
            //} else {
            //    [self shareScore];
            //}
            break;
        case GameStateGameOverJ:
            if (touchLocation.y < self.size.height * 0.2 && touchLocation.y > self.size.height * 0.08 && touchLocation.x > self.size.width * 0.15 && touchLocation.x < self.size.width * 0.85) {
                SKSpriteNode *potionButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                potionButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.16);
                potionButton.zPosition = LayerUI;
                [_worldNode addChild:potionButton];
                
                SKSpriteNode *potion = [SKSpriteNode spriteNodeWithImageNamed:@"ReviveIconPixelArt-01"];
                potion.position = CGPointZero;
                potion.zPosition = LayerUI;
                potion.position = CGPointMake(-potionButton.size.width * 0.15, potionButton.size.height * .0001);
                potion.scale = 0.12;
                [potionButton addChild:potion];
                
                SKLabelNode *numPotions = [[SKLabelNode alloc] initWithFontNamed:kFontName];
                [potionButton addChild:numPotions];
                numPotions.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
                numPotions.fontSize = kFontSizeCard/2;
                numPotions.position = CGPointMake(potionButton.size.width * 0.17, -potionButton.size.height * .3);
                numPotions.zPosition = LayerUI;
                
            }
            else if (touchLocation.y > self.size.height * 0.5 && touchLocation.x > self.size.width * 0.4 && touchLocation.x < self.size.width * 0.6 && touchLocation.y < self.size.height * 0.9) {
                
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
                myPokemonButton.zPosition = LayerUI;
                myPokemonButton.scale = 0.1;
                [_worldNode addChild:myPokemonButton];
                
                myPokemonButton.position = CGPointMake(self.size.width * 0.506, self.size.height * 0.764);
                
            }
            else if (touchLocation.x < self.size.width * 0.06) {
                
            }
            else if (touchLocation.x > self.size.width * 0.94) {
                
            }
            else if (touchLocation.x < self.size.width * 0.46) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                playButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.32);
                playButton.zPosition = LayerUI;
                [_worldNode addChild:playButton];
                
                SKSpriteNode *ok = [SKSpriteNode spriteNodeWithImageNamed:@"Retry2-01"];
                ok.scale = 0.18;
                ok.position = CGPointZero;
                ok.zPosition = LayerUI;
                [playButton addChild:ok];
            }
            else if (touchLocation.x > self.size.width * 0.54) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                playButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.32);
                playButton.zPosition = LayerUI;
                [_worldNode addChild:playButton];
                
                SKSpriteNode *ok = [SKSpriteNode spriteNodeWithImageNamed:@"PokeShare-01"];
                ok.scale = 0.34;
                ok.position = CGPointZero;
                ok.zPosition = LayerUI;
                [playButton addChild:ok];
            }
            //if (touchLocation.x < self.size.width * 0.6) {
            //    [self switchToNewGame:GameStateMainMenu];
            //} else {
            //    [self shareScore];
            //}
            break;

            
        case GameStateGameOverJR:
            if (touchLocation.y < self.size.height * 0.2 && touchLocation.y > self.size.height * 0.08 && touchLocation.x > self.size.width * 0.15 && touchLocation.x < self.size.width * 0.85) {
                SKSpriteNode *potionButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                potionButton.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.16);
                potionButton.zPosition = LayerUI;
                [_worldNode addChild:potionButton];
                
                SKSpriteNode *potion = [SKSpriteNode spriteNodeWithImageNamed:@"ReviveIconPixelArt-01"];
                potion.position = CGPointZero;
                potion.zPosition = LayerUI;
                potion.position = CGPointMake(-potionButton.size.width * 0.15, potionButton.size.height * .0001);
                potion.scale = 0.12;
                [potionButton addChild:potion];
                
                SKLabelNode *numPotions = [[SKLabelNode alloc] initWithFontNamed:kFontName];
                [potionButton addChild:numPotions];
                numPotions.fontColor = [SKColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0];
                numPotions.fontSize = kFontSizeCard/2;
                numPotions.position = CGPointMake(potionButton.size.width * 0.17, -potionButton.size.height * .3);
                numPotions.zPosition = LayerUI;
                
            }
            else if (touchLocation.y > self.size.height * 0.5 && touchLocation.x > self.size.width * 0.4 && touchLocation.x < self.size.width * 0.6 && touchLocation.y < self.size.height * 0.9) {
                
                SKSpriteNode *myPokemonButton = [SKSpriteNode spriteNodeWithImageNamed:@"PokeBallOpened-01"];
                myPokemonButton.zPosition = LayerUI;
                myPokemonButton.scale = 0.1;
                [_worldNode addChild:myPokemonButton];
                
                myPokemonButton.position = CGPointMake(self.size.width * 0.506, self.size.height * 0.764);
                
            }
            else if (touchLocation.x < self.size.width * 0.06) {
                
            }
            else if (touchLocation.x > self.size.width * 0.94) {
                
            }
            else if (touchLocation.x < self.size.width * 0.46) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                playButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.32);
                playButton.zPosition = LayerUI;
                [_worldNode addChild:playButton];
                
                SKSpriteNode *ok = [SKSpriteNode spriteNodeWithImageNamed:@"Retry2-01"];
                ok.scale = 0.18;
                ok.position = CGPointZero;
                ok.zPosition = LayerUI;
                [playButton addChild:ok];
            }
            else if (touchLocation.x > self.size.width * 0.54) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButtonHL"];
                playButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.32);
                playButton.zPosition = LayerUI;
                [_worldNode addChild:playButton];
                
                SKSpriteNode *ok = [SKSpriteNode spriteNodeWithImageNamed:@"PokeShare-01"];
                ok.scale = 0.34;
                ok.position = CGPointZero;
                ok.zPosition = LayerUI;
                [playButton addChild:ok];
            }
            //if (touchLocation.x < self.size.width * 0.6) {
            //    [self switchToNewGame:GameStateMainMenu];
            //} else {
            //    [self shareScore];
            //}
            break;
        default:
            NSLog(@"How'd you get here?");
    
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    switch (_gameState) {
        case GameStateMainMenu:
            if (touchLocation.y < self.size.height * 0.15 && touchLocation.x > self.size.width * 0.2 && touchLocation.x < self.size.width * 0.8) {
                [self switchToNewGame:GameStateMyPokemon];  //Change this line to the "My Pokemon" view
                [self runAction:_popAction];
            }
            else if (touchLocation.y > self.size.height * 0.5) {
                SKSpriteNode *state = [SKSpriteNode spriteNodeWithImageNamed:@"state"];
                state.zPosition = LayerUI;
                state.scale = 0.13;
                [_worldNode addChild:state];
                [state runAction:_state];
                
                state.position = CGPointMake(self.size.width * 1.5, self.size.height*0.6);
                SKAction *moveTo = [SKAction moveTo:CGPointMake(self.size.width * 0.5, self.size.height * 0.6) duration:kAnimDelay/2];
                moveTo.timingMode = SKActionTimingEaseInEaseOut;
                [state runAction:[SKAction sequence:@[
                                                           [SKAction waitForDuration:kAnimDelay * 0.0],
                                                           moveTo
                                                           ]]];
                [self switchToMainMenuS];
            }
            else if (touchLocation.x < self.size.width * 0.06 && touchLocation.y < self.size.height * 0.5) {
                
            }
            else if (touchLocation.x > self.size.width * 0.94 && touchLocation.y < self.size.height * 0.5) {
                
            }
            else if (touchLocation.x < self.size.width * 0.46 && touchLocation.y < self.size.height * 0.5) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                playButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.21);
                playButton.zPosition = LayerUI;
                [_worldNode addChild:playButton];
                
                SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"PokePlay-01"];
                play.scale = 0.4;
                play.position = CGPointMake(0, 0);
                [playButton addChild:play];
                [self switchToNewGame:GameStateTutorial];
                [self runAction:_popAction];
            }
            else if (touchLocation.x > self.size.width * 0.54 && touchLocation.y < self.size.height * 0.5) {
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.21);
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"Rate-01"];
                rate.scale = 0.205;
                rate.position = CGPointMake(0, 0);
                [rateButton addChild:rate];
                [self rateApp];
                [self runAction:_popAction];
            }
            break;
        case GameStateMainMenuS:
            if (touchLocation.y < self.size.height * 0.2 && touchLocation.x > self.size.width * 0.2 && touchLocation.x < self.size.width * 0.8) {
                [self switchToNewGame:GameStateMyPokemon];  //Change this line to the "My Pokemon" view
                [self runAction:_popAction];
            }
            else if (touchLocation.y > self.size.height * 0.5) {
            }
            else if (touchLocation.x < self.size.width * 0.06 && touchLocation.y < self.size.height * 0.5) {
                
            }
            else if (touchLocation.x > self.size.width * 0.94 && touchLocation.y < self.size.height * 0.5) {
                
            }
            else if (touchLocation.x < self.size.width * 0.46 && touchLocation.y < self.size.height * 0.5) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                playButton.position = CGPointMake(self.size.width * 0.21, self.size.height * 0.21);
                playButton.zPosition = LayerUI;
                [_worldNode addChild:playButton];
                
                SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"PokePlay-01"];
                play.scale = 0.4;
                play.position = CGPointMake(0, 0);
                [playButton addChild:play];
                [self switchToNewGame:GameStateTutorial];
                [self runAction:_popAction];
            }
            else if (touchLocation.x > self.size.width * 0.54 && touchLocation.y < self.size.height * 0.5) {
                SKSpriteNode *rateButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                rateButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.25);
                rateButton.zPosition = LayerUI;
                [_worldNode addChild:rateButton];
                
                SKSpriteNode *rate = [SKSpriteNode spriteNodeWithImageNamed:@"Rate-01"];
                rate.scale = 0.205;
                rate.position = CGPointMake(0, 0);
                [rateButton addChild:rate];
                [self rateApp];
                [self runAction:_popAction];
            }
            break;
        case GameStateMyPokemon:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard2];
                //[self addPokemon2:[self bestScore]];
                //[self switchToPokeCard2];
            }
            break;
        case GameStatePokeCard1:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                //[self addPokemon2:[self bestScore]];
                //[self switchToPokeCard2];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                //[self addPokemon2:[self bestScore]];
                //[self switchToPokeCard2];
                [self switchToNewGame1:GameStatePokeCard2];
            }
            break;
        case GameStatePokeCard2:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame1:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
            //[self addPokemon1:[self bestScore]];
            //[self switchToPokeCard1];
                [self switchToNewGame1:GameStatePokeCard1];
                }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                //[self addPokemon3:[self bestScore]];
                //[self switchToPokeCard3];
                [self switchToNewGame1:GameStatePokeCard3];
            }
            break;
        case GameStatePokeCard3:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                //[self addPokemon2:[self bestScore]];
                //[self switchToPokeCard2];
                [self switchToNewGame1:GameStatePokeCard2];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                //[self addPokemon4:[self bestScore]];
                //[self switchToPokeCard4];
                [self switchToNewGame1:GameStatePokeCard4];
            }
            break;
        case GameStatePokeCard4:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard3];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard5];
            }
            break;
        case GameStatePokeCard5:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard4];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard6];
            }
            break;
        case GameStatePokeCard6:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard5];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard7];
            }
            break;
        case GameStatePokeCard7:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard6];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard8];
            }
            break;
        case GameStatePokeCard8:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard7];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard9];
            }
            break;
        case GameStatePokeCard9:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard8];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard10];
            }
            break;
        case GameStatePokeCard10:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard9];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard11];
            }
            break;
        case GameStatePokeCard11:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard10];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard12];
            }
            break;
        case GameStatePokeCard12:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard11];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard13];
            }
            break;
        case GameStatePokeCard13:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard12];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard14];
            }
            break;
        case GameStatePokeCard14:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard13];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard15];
            }
            break;
        case GameStatePokeCard15:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard14];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard16];
            }
            break;
        case GameStatePokeCard16:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard15];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard17];
            }
            break;
        case GameStatePokeCard17:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard16];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard18];
            }
            break;
        case GameStatePokeCard18:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard17];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard19];
            }
            break;
        case GameStatePokeCard19:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard18];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard20];
            }
            break;
        case GameStatePokeCard20:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard19];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard21];
            }
            break;
        case GameStatePokeCard21:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard20];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard22];
            }
            break;
        case GameStatePokeCard22:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard21];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard23];
            }
            break;
        case GameStatePokeCard23:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard22];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard24];
            }
            break;
        case GameStatePokeCard24:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard23];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard25];
            }
            break;
        case GameStatePokeCard25:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard24];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                [self switchToNewGame1:GameStatePokeCard26];
            }
        case GameStatePokeCard26:
            if (touchLocation.y > self.size.height * 0.7 && touchLocation.x < self.size.width * 0.4) {
                [self switchToNewGame:GameStateMainMenu];
            }
            if (touchLocation.x < self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {
                //[self addPokemon25:[self bestScore]];
                //[self switchToPokeCard25];
                [self switchToNewGame1:GameStatePokeCard25];
            }
            else if (touchLocation.x > self.size.width * 0.5 && touchLocation.y < self.size.height *0.5) {

            }
            break;
        case GameStateTutorial:
            if ([self bestScore] < 151) {
                if (touchLocation.x < self.size.width * .45 && touchLocation.y < self.size.height * 0.2){
                    //[self switchToJohto];
                    
                    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                    playButton.zPosition = LayerUI;
                    [_worldNode addChild:playButton];
                    [playButton runAction:_popAction];
                    
                    SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"JohtoBox-01"];
                    play.scale = 0.56;
                    play.position = CGPointMake(0, 0);
                    [playButton addChild:play];
                    
                    playButton.position = CGPointMake(self.size.width * 0.5, -playButton.size.height/3);
                    SKAction *moveTo = [SKAction moveTo:CGPointMake(self.size.width * 0.5, self.size.height * 0.6) duration:kAnimDelay/2];
                    moveTo.timingMode = SKActionTimingEaseInEaseOut;
                    [playButton runAction:[SKAction sequence:@[
                                                               [SKAction waitForDuration:kAnimDelay * 0.0],
                                                               moveTo
                                                               ]]];
                    
                    SKSpriteNode *gotItButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                    gotItButton.zPosition = LayerUI;
                    [_worldNode addChild:gotItButton];
                    
                    SKSpriteNode *gotIt = [SKSpriteNode spriteNodeWithImageNamed:@"Gotit-01"];
                    gotIt.scale = 0.35;
                    gotIt.position = CGPointMake(0, 0);
                    [gotItButton addChild:gotIt];
                    
                    gotItButton.position = CGPointMake(self.size.width * 0.5, -gotItButton.size.height/3);
                    SKAction *moveButtonTo = [SKAction moveTo:CGPointMake(self.size.width * 0.5, self.size.height * 0.32) duration:kAnimDelay/1.7];
                    moveButtonTo.timingMode = SKActionTimingEaseInEaseOut;
                    [gotItButton runAction:[SKAction sequence:@[
                                                                [SKAction waitForDuration:kAnimDelay * 0.0],
                                                                moveButtonTo
                                                                ]]];
                    [self switchToZeroRevives];
                }
                else{
                    [self switchToPlay];
                }
            }
            else if ([self bestScore] >= 151) {
                if (touchLocation.x < self.size.width * .5 && touchLocation.y < self.size.height * 0.3){
                    [self switchToJohto];
                }
                else{
                    [self switchToPlay];
                }
            }
            break;
        case GameStateLockedJohto:
            if (touchLocation.y < self.size.height * 0.5){
                [self switchToNewGame:GameStateTutorial];
            }
            break;
        case GameStateTutorialR:
            break;
        case GameStateZeroRevives:
            break;
        case GameStatePlayR:
            break;
        case GameStatePlay:
            break;
        case GameStatePlayJ:
            break;
        case GameStatePlayJR:
            break;
        case GameStateFalling:
            break;
        case GameStateFallingJ:
            break;
        case GameStateFallingR:
            break;
        case GameStateShowingScore:
            break;
        case GameStateShowingScoreJ:
            break;
        case GameStateShowingScoreR:
            break;
        case GameStateReviveHey:
            break;
        case GameStateGameOver:
            if (touchLocation.y < self.size.height * 0.25 && touchLocation.y > self.size.height * 0.08 && touchLocation.x > self.size.width * 0.15 && touchLocation.x < self.size.width * 0.85) {
                
                if ([self lastScore] < 1 && [self totalPotions] == 0) {
                    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                    [_worldNode addChild:playButton];
                    playButton.zPosition = LayerUI;
                    [playButton runAction:_popAction];
                    
                    SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"ReviveBox2-01"];
                    play.scale = 0.28;
                    play.position = CGPointMake(0, -self.size.height * .05);
                    play.zPosition = LayerUI;
                    [playButton addChild:play];
                    
                    playButton.position = CGPointMake(self.size.width * 0.5, -playButton.size.height/3);
                    SKAction *moveTo = [SKAction moveTo:CGPointMake(self.size.width * 0.5, self.size.height * 0.6) duration:kAnimDelay/2];
                    moveTo.timingMode = SKActionTimingEaseInEaseOut;
                    [playButton runAction:[SKAction sequence:@[
                                                               [SKAction waitForDuration:kAnimDelay * 0.0],
                                                               moveTo
                                                               ]]];
                    
                    SKSpriteNode *gotItButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                    [play addChild:gotItButton];
                    
                    gotItButton.zPosition = LayerUI;
                    SKSpriteNode *gotIt = [SKSpriteNode spriteNodeWithImageNamed:@"Gotit-01"];
                    gotIt.scale = 0.37;
                    gotIt.position = CGPointMake(0, 0);
                    gotIt.zPosition = LayerUI;
                    [gotItButton addChild:gotIt];
                    
                    gotItButton.position = CGPointMake(-play.size.width * 0.00001, -play.size.height);
                    gotItButton.scale = 3.7;
                    SKAction *moveButtonTo = [SKAction moveTo:CGPointMake(-play.size.width * 0.0001, -play.size.height * 1.25) duration:kAnimDelay/1.7];
                    moveButtonTo.timingMode = SKActionTimingEaseInEaseOut;
                    gotItButton.zPosition = LayerUI;
                    [gotItButton runAction:[SKAction sequence:@[
                                                                [SKAction waitForDuration:kAnimDelay * 0.0],
                                                                moveButtonTo
                                                                ]]];
                    [self switchToZeroRevives];

                }
                else if ([self lastScore] < 1) {
                    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                    [_worldNode addChild:playButton];
                    playButton.zPosition = LayerUI;
                    [playButton runAction:_popAction];
                    
                    SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"ReviveAsh-01"];
                    play.scale = 0.28;
                    play.position = CGPointMake(0, -self.size.height * .05);
                    play.zPosition = LayerUI;
                    [playButton addChild:play];
                    
                    playButton.position = CGPointMake(self.size.width * 0.5, -playButton.size.height/3);
                    SKAction *moveTo = [SKAction moveTo:CGPointMake(self.size.width * 0.5, self.size.height * 0.6) duration:kAnimDelay/2];
                    moveTo.timingMode = SKActionTimingEaseInEaseOut;
                    [playButton runAction:[SKAction sequence:@[
                                                               [SKAction waitForDuration:kAnimDelay * 0.0],
                                                               moveTo
                                                               ]]];
                    
                    SKSpriteNode *gotItButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                    [play addChild:gotItButton];
                    
                    gotItButton.zPosition = LayerUI;
                    SKSpriteNode *gotIt = [SKSpriteNode spriteNodeWithImageNamed:@"Gotit-01"];
                    gotIt.scale = 0.37;
                    gotIt.position = CGPointMake(0, 0);
                    gotIt.zPosition = LayerUI;
                    [gotItButton addChild:gotIt];
                    
                    gotItButton.position = CGPointMake(-play.size.width * 0.00001, -play.size.height);
                    gotItButton.scale = 3.7;
                    SKAction *moveButtonTo = [SKAction moveTo:CGPointMake(-play.size.width * 0.0001, -play.size.height * 1.25) duration:kAnimDelay/1.7];
                    moveButtonTo.timingMode = SKActionTimingEaseInEaseOut;
                    gotItButton.zPosition = LayerUI;
                    [gotItButton runAction:[SKAction sequence:@[
                                                                [SKAction waitForDuration:kAnimDelay * 0.0],
                                                                moveButtonTo
                                                                ]]];
                    [self switchToZeroRevives];
                    
                }
                else if ([self totalPotions] == 0) {
                    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                    [_worldNode addChild:playButton];
                    playButton.zPosition = LayerUI;
                    [playButton runAction:_popAction];
                    
                    SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"ReviveBox2-01"];
                    play.scale = 0.28;
                    play.position = CGPointMake(0, -self.size.height * .05);
                    play.zPosition = LayerUI;
                    [playButton addChild:play];
                    
                    playButton.position = CGPointMake(self.size.width * 0.5, -playButton.size.height/3);
                    SKAction *moveTo = [SKAction moveTo:CGPointMake(self.size.width * 0.5, self.size.height * 0.6) duration:kAnimDelay/2];
                    moveTo.timingMode = SKActionTimingEaseInEaseOut;
                    [playButton runAction:[SKAction sequence:@[
                                                               [SKAction waitForDuration:kAnimDelay * 0.0],
                                                               moveTo
                                                               ]]];
                    
                    SKSpriteNode *gotItButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                    [play addChild:gotItButton];
                    
                    gotItButton.zPosition = LayerUI;
                    SKSpriteNode *gotIt = [SKSpriteNode spriteNodeWithImageNamed:@"Gotit-01"];
                    gotIt.scale = 0.37;
                    gotIt.position = CGPointMake(0, 0);
                    gotIt.zPosition = LayerUI;
                    [gotItButton addChild:gotIt];
                    
                    gotItButton.position = CGPointMake(-play.size.width * 0.00001, -play.size.height);
                    gotItButton.scale = 3.7;
                    SKAction *moveButtonTo = [SKAction moveTo:CGPointMake(-play.size.width * 0.0001, -play.size.height * 1.25) duration:kAnimDelay/1.7];
                    moveButtonTo.timingMode = SKActionTimingEaseInEaseOut;
                    gotItButton.zPosition = LayerUI;
                    [gotItButton runAction:[SKAction sequence:@[
                                                                [SKAction waitForDuration:kAnimDelay * 0.0],
                                                                moveButtonTo
                                                                ]]];
                    [self switchToZeroRevives];
                } else if ([self totalPotions] >= 1){
                    [self switchToNewGame2:GameStateTutorialR];
                    
                }
                
            }
            else if (touchLocation.y > self.size.height * 0.5 && touchLocation.x > self.size.width * 0.4 && touchLocation.x < self.size.width * 0.6 && touchLocation.y < self.size.height * 0.9) {
                [self switchToNewGame:GameStateMyPokemon];
                
            }
            else if (touchLocation.x < self.size.width * 0.06) {
            }
            else if (touchLocation.x > self.size.width * 0.94) {
                
            }
            else if (touchLocation.x < self.size.width * 0.46 && touchLocation.y < self.size.height * 0.5) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                playButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.32);
                playButton.zPosition = LayerUI;
                [_worldNode addChild:playButton];
                
                SKSpriteNode *ok = [SKSpriteNode spriteNodeWithImageNamed:@"Retry2-01"];
                ok.scale = 0.18;
                ok.position = CGPointZero;
                ok.zPosition = LayerUI;
                [playButton addChild:ok];
                [self switchToNewGame:GameStateTutorial];
            }
            else if (touchLocation.x > self.size.width * 0.54 && touchLocation.y < self.size.height * 0.5) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                playButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.32);
                playButton.zPosition = LayerUI;
                [_worldNode addChild:playButton];
                
                SKSpriteNode *ok = [SKSpriteNode spriteNodeWithImageNamed:@"PokeShare-01"];
                ok.scale = 0.34;
                ok.position = CGPointZero;
                ok.zPosition = LayerUI;
                [playButton addChild:ok];
                [self shareScore];
            }
            //if (touchLocation.x < self.size.width * 0.6) {
            //    [self switchToNewGame:GameStateMainMenu];
            //} else {
            //    [self shareScore];
            //}
            break;
        case GameStateGameOverJ:
            if (touchLocation.y < self.size.height * 0.25 && touchLocation.y > self.size.height * 0.08 && touchLocation.x > self.size.width * 0.15 && touchLocation.x < self.size.width * 0.85) {
                
                if ([self lastScoreJ] < 151 && [self totalPotions] == 0) {
                    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                    [_worldNode addChild:playButton];
                    playButton.zPosition = LayerUI;
                    [playButton runAction:_popAction];
                    
                    SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"ReviveJohto-01"];
                    play.scale = 0.28;
                    play.position = CGPointMake(0, -self.size.height * .05);
                    play.zPosition = LayerUI;
                    [playButton addChild:play];
                    
                    playButton.position = CGPointMake(self.size.width * 0.5, -playButton.size.height/3);
                    SKAction *moveTo = [SKAction moveTo:CGPointMake(self.size.width * 0.5, self.size.height * 0.6) duration:kAnimDelay/2];
                    moveTo.timingMode = SKActionTimingEaseInEaseOut;
                    [playButton runAction:[SKAction sequence:@[
                                                               [SKAction waitForDuration:kAnimDelay * 0.0],
                                                               moveTo
                                                               ]]];
                    
                    SKSpriteNode *gotItButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                    [play addChild:gotItButton];
                    
                    gotItButton.zPosition = LayerUI;
                    SKSpriteNode *gotIt = [SKSpriteNode spriteNodeWithImageNamed:@"Gotit-01"];
                    gotIt.scale = 0.37;
                    gotIt.position = CGPointMake(0, 0);
                    gotIt.zPosition = LayerUI;
                    [gotItButton addChild:gotIt];
                    
                    gotItButton.position = CGPointMake(-play.size.width * 0.00001, -play.size.height);
                    gotItButton.scale = 3.7;
                    SKAction *moveButtonTo = [SKAction moveTo:CGPointMake(-play.size.width * 0.0001, -play.size.height * 1.25) duration:kAnimDelay/1.7];
                    moveButtonTo.timingMode = SKActionTimingEaseInEaseOut;
                    gotItButton.zPosition = LayerUI;
                    [gotItButton runAction:[SKAction sequence:@[
                                                                [SKAction waitForDuration:kAnimDelay * 0.0],
                                                                moveButtonTo
                                                                ]]];
                    [self switchToZeroRevives];
                    
                }
                else if ([self lastScoreJ] < 151 && [self totalPotions] >= 1) {
                    
                    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                    [_worldNode addChild:playButton];
                    playButton.zPosition = LayerUI;
                    [playButton runAction:_popAction];
                    
                    SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"ReviveAsh-01"];
                    play.scale = 0.28;
                    play.position = CGPointMake(0, -self.size.height * .05);
                    play.zPosition = LayerUI;
                    [playButton addChild:play];
                    
                    playButton.position = CGPointMake(self.size.width * 0.5, -playButton.size.height/3);
                    SKAction *moveTo = [SKAction moveTo:CGPointMake(self.size.width * 0.5, self.size.height * 0.6) duration:kAnimDelay/2];
                    moveTo.timingMode = SKActionTimingEaseInEaseOut;
                    [playButton runAction:[SKAction sequence:@[
                                                               [SKAction waitForDuration:kAnimDelay * 0.0],
                                                               moveTo
                                                               ]]];
                    
                    SKSpriteNode *gotItButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                    [play addChild:gotItButton];
                    
                    gotItButton.zPosition = LayerUI;
                    SKSpriteNode *gotIt = [SKSpriteNode spriteNodeWithImageNamed:@"Gotit-01"];
                    gotIt.scale = 0.37;
                    gotIt.position = CGPointMake(0, 0);
                    gotIt.zPosition = LayerUI;
                    [gotItButton addChild:gotIt];
                    
                    gotItButton.position = CGPointMake(-play.size.width * 0.00001, -play.size.height);
                    gotItButton.scale = 3.7;
                    SKAction *moveButtonTo = [SKAction moveTo:CGPointMake(-play.size.width * 0.0001, -play.size.height * 1.25) duration:kAnimDelay/1.7];
                    moveButtonTo.timingMode = SKActionTimingEaseInEaseOut;
                    gotItButton.zPosition = LayerUI;
                    [gotItButton runAction:[SKAction sequence:@[
                                                                [SKAction waitForDuration:kAnimDelay * 0.0],
                                                                moveButtonTo
                                                                ]]];
                    [self switchToZeroRevives];
                    //this is the problem, might be the self lastscore variable
                    //may need to make a self lastscoreJ
                    [self switchToNewGame:GameStateTutorialJR];
                    
                }
            
                else if ([self totalPotions] == 0) {
                    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                    [_worldNode addChild:playButton];
                    playButton.zPosition = LayerUI;
                    [playButton runAction:_popAction];
                    
                    SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"ReviveJohto-01"];
                    play.scale = 0.28;
                    play.position = CGPointMake(0, -self.size.height * .05);
                    play.zPosition = LayerUI;
                    [playButton addChild:play];
                    
                    playButton.position = CGPointMake(self.size.width * 0.5, -playButton.size.height/3);
                    SKAction *moveTo = [SKAction moveTo:CGPointMake(self.size.width * 0.5, self.size.height * 0.6) duration:kAnimDelay/2];
                    moveTo.timingMode = SKActionTimingEaseInEaseOut;
                    [playButton runAction:[SKAction sequence:@[
                                                               [SKAction waitForDuration:kAnimDelay * 0.0],
                                                               moveTo
                                                               ]]];
                    
                    SKSpriteNode *gotItButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                    [play addChild:gotItButton];
                    
                    gotItButton.zPosition = LayerUI;
                    SKSpriteNode *gotIt = [SKSpriteNode spriteNodeWithImageNamed:@"Gotit-01"];
                    gotIt.scale = 0.37;
                    gotIt.position = CGPointMake(0, 0);
                    gotIt.zPosition = LayerUI;
                    [gotItButton addChild:gotIt];
                    
                    gotItButton.position = CGPointMake(-play.size.width * 0.00001, -play.size.height);
                    gotItButton.scale = 3.7;
                    SKAction *moveButtonTo = [SKAction moveTo:CGPointMake(-play.size.width * 0.0001, -play.size.height * 1.25) duration:kAnimDelay/1.7];
                    moveButtonTo.timingMode = SKActionTimingEaseInEaseOut;
                    gotItButton.zPosition = LayerUI;
                    [gotItButton runAction:[SKAction sequence:@[
                                                                [SKAction waitForDuration:kAnimDelay * 0.0],
                                                                moveButtonTo
                                                                ]]];
                    [self switchToZeroRevives];
                } else if ([self totalPotions] >= 1){
                    [self switchToNewGame2:GameStateTutorialJR];
                    
                }
                
                
            }
            else if (touchLocation.y > self.size.height * 0.5 && touchLocation.x > self.size.width * 0.4 && touchLocation.x < self.size.width * 0.6 && touchLocation.y < self.size.height * 0.9) {
                [self switchToNewGame:GameStateMyPokemon];
                
            }
            else if (touchLocation.x < self.size.width * 0.06) {
            }
            else if (touchLocation.x > self.size.width * 0.94) {
                
            }
            else if (touchLocation.x < self.size.width * 0.46 && touchLocation.y < self.size.height * 0.5) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                playButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.32);
                playButton.zPosition = LayerUI;
                [_worldNode addChild:playButton];
                
                SKSpriteNode *ok = [SKSpriteNode spriteNodeWithImageNamed:@"Retry2-01"];
                ok.scale = 0.18;
                ok.position = CGPointZero;
                ok.zPosition = LayerUI;
                [playButton addChild:ok];
                [self switchToNewGame:GameStateTutorial];
            }
            else if (touchLocation.x > self.size.width * 0.54 && touchLocation.y < self.size.height * 0.5) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                playButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.32);
                playButton.zPosition = LayerUI;
                [_worldNode addChild:playButton];
                
                SKSpriteNode *ok = [SKSpriteNode spriteNodeWithImageNamed:@"PokeShare-01"];
                ok.scale = 0.34;
                ok.position = CGPointZero;
                ok.zPosition = LayerUI;
                [playButton addChild:ok];
                [self shareScore];
            }
            //if (touchLocation.x < self.size.width * 0.6) {
            //    [self switchToNewGame:GameStateMainMenu];
            //} else {
            //    [self shareScore];
            //}
            break;

        case GameStateGameOverR:
            if (touchLocation.y < self.size.height * 0.25 && touchLocation.y > self.size.height * 0.08 && touchLocation.x > self.size.width * 0.15 && touchLocation.x < self.size.width * 0.85) {
                    SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                    [_worldNode addChild:playButton];
                    playButton.zPosition = LayerUI;
                    [playButton runAction:_popAction];
                    
                    SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"ReviveHey-01"];
                    play.scale = 0.28;
                    play.position = CGPointMake(0, -self.size.height * .05);
                    play.zPosition = LayerUI;
                    [playButton addChild:play];
                    
                    playButton.position = CGPointMake(self.size.width * 0.5, -playButton.size.height/3);
                    SKAction *moveTo = [SKAction moveTo:CGPointMake(self.size.width * 0.5, self.size.height * 0.6) duration:kAnimDelay/2];
                    moveTo.timingMode = SKActionTimingEaseInEaseOut;
                    [playButton runAction:[SKAction sequence:@[
                                                               [SKAction waitForDuration:kAnimDelay * 0.0],
                                                               moveTo
                                                               ]]];
                    
                    SKSpriteNode *gotItButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                    [play addChild:gotItButton];
                    
                    gotItButton.zPosition = LayerUI;
                    SKSpriteNode *gotIt = [SKSpriteNode spriteNodeWithImageNamed:@"Gotit-01"];
                    gotIt.scale = 0.37;
                    gotIt.position = CGPointMake(0, 0);
                    gotIt.zPosition = LayerUI;
                    [gotItButton addChild:gotIt];
                    
                    gotItButton.position = CGPointMake(-play.size.width * 0.00001, -play.size.height);
                    gotItButton.scale = 3.7;
                    SKAction *moveButtonTo = [SKAction moveTo:CGPointMake(-play.size.width * 0.0001, -play.size.height * 1.25) duration:kAnimDelay/1.7];
                    moveButtonTo.timingMode = SKActionTimingEaseInEaseOut;
                    gotItButton.zPosition = LayerUI;
                    [gotItButton runAction:[SKAction sequence:@[
                                                                [SKAction waitForDuration:kAnimDelay * 0.0],
                                                                moveButtonTo
                                                                ]]];
                    [self switchToReviveHey];
                
            }
            else if (touchLocation.y > self.size.height * 0.5 && touchLocation.x > self.size.width * 0.4 && touchLocation.x < self.size.width * 0.6 && touchLocation.y < self.size.height * 0.9) {
                [self switchToNewGame:GameStateMyPokemon];
                
            }
            else if (touchLocation.x < self.size.width * 0.06) {
            }
            else if (touchLocation.x > self.size.width * 0.94) {
                
            }
            else if (touchLocation.x < self.size.width * 0.46 && touchLocation.y < self.size.height * 0.5) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                playButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.32);
                playButton.zPosition = LayerUI;
                [_worldNode addChild:playButton];
                
                SKSpriteNode *ok = [SKSpriteNode spriteNodeWithImageNamed:@"Retry2-01"];
                ok.scale = 0.18;
                ok.position = CGPointZero;
                ok.zPosition = LayerUI;
                [playButton addChild:ok];
                [self switchToNewGame:GameStateTutorial];
            }
            else if (touchLocation.x > self.size.width * 0.54 && touchLocation.y < self.size.height * 0.5) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                playButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.32);
                playButton.zPosition = LayerUI;
                [_worldNode addChild:playButton];
                
                SKSpriteNode *ok = [SKSpriteNode spriteNodeWithImageNamed:@"PokeShare-01"];
                ok.scale = 0.34;
                ok.position = CGPointZero;
                ok.zPosition = LayerUI;
                [playButton addChild:ok];
                [self shareScore];
            }
            //if (touchLocation.x < self.size.width * 0.6) {
            //    [self switchToNewGame:GameStateMainMenu];
            //} else {
            //    [self shareScore];
            //}
            break;
            
        case GameStateGameOverJR:
            if (touchLocation.y < self.size.height * 0.25 && touchLocation.y > self.size.height * 0.08 && touchLocation.x > self.size.width * 0.15 && touchLocation.x < self.size.width * 0.85) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                [_worldNode addChild:playButton];
                playButton.zPosition = LayerUI;
                [playButton runAction:_popAction];
                
                SKSpriteNode *play = [SKSpriteNode spriteNodeWithImageNamed:@"ReviveHey-01"];
                play.scale = 0.28;
                play.position = CGPointMake(0, -self.size.height * .05);
                play.zPosition = LayerUI;
                [playButton addChild:play];
                
                playButton.position = CGPointMake(self.size.width * 0.5, -playButton.size.height/3);
                SKAction *moveTo = [SKAction moveTo:CGPointMake(self.size.width * 0.5, self.size.height * 0.6) duration:kAnimDelay/2];
                moveTo.timingMode = SKActionTimingEaseInEaseOut;
                [playButton runAction:[SKAction sequence:@[
                                                           [SKAction waitForDuration:kAnimDelay * 0.0],
                                                           moveTo
                                                           ]]];
                
                SKSpriteNode *gotItButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                [play addChild:gotItButton];
                
                gotItButton.zPosition = LayerUI;
                SKSpriteNode *gotIt = [SKSpriteNode spriteNodeWithImageNamed:@"Gotit-01"];
                gotIt.scale = 0.37;
                gotIt.position = CGPointMake(0, 0);
                gotIt.zPosition = LayerUI;
                [gotItButton addChild:gotIt];
                
                gotItButton.position = CGPointMake(-play.size.width * 0.00001, -play.size.height);
                gotItButton.scale = 3.7;
                SKAction *moveButtonTo = [SKAction moveTo:CGPointMake(-play.size.width * 0.0001, -play.size.height * 1.25) duration:kAnimDelay/1.7];
                moveButtonTo.timingMode = SKActionTimingEaseInEaseOut;
                gotItButton.zPosition = LayerUI;
                [gotItButton runAction:[SKAction sequence:@[
                                                            [SKAction waitForDuration:kAnimDelay * 0.0],
                                                            moveButtonTo
                                                            ]]];
                [self switchToReviveHey];
                
            }
            else if (touchLocation.y > self.size.height * 0.5 && touchLocation.x > self.size.width * 0.4 && touchLocation.x < self.size.width * 0.6 && touchLocation.y < self.size.height * 0.9) {
                [self switchToNewGame:GameStateMyPokemon];
                
            }
            else if (touchLocation.x < self.size.width * 0.06) {
            }
            else if (touchLocation.x > self.size.width * 0.94) {
                
            }
            else if (touchLocation.x < self.size.width * 0.46 && touchLocation.y < self.size.height * 0.5) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                playButton.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.32);
                playButton.zPosition = LayerUI;
                [_worldNode addChild:playButton];
                
                SKSpriteNode *ok = [SKSpriteNode spriteNodeWithImageNamed:@"Retry2-01"];
                ok.scale = 0.18;
                ok.position = CGPointZero;
                ok.zPosition = LayerUI;
                [playButton addChild:ok];
                [self switchToNewGame:GameStateTutorial];
            }
            else if (touchLocation.x > self.size.width * 0.54 && touchLocation.y < self.size.height * 0.5) {
                SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"FINALSuperButton"];
                playButton.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.32);
                playButton.zPosition = LayerUI;
                [_worldNode addChild:playButton];
                
                SKSpriteNode *ok = [SKSpriteNode spriteNodeWithImageNamed:@"PokeShare-01"];
                ok.scale = 0.34;
                ok.position = CGPointZero;
                ok.zPosition = LayerUI;
                [playButton addChild:ok];
                [self shareScore];
            }
            //if (touchLocation.x < self.size.width * 0.6) {
            //    [self switchToNewGame:GameStateMainMenu];
            //} else {
            //    [self shareScore];
            //}
            break;
        default:
            NSLog(@"How did you get here?");
    
    }
}

//TOUCHES+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#pragma mark - Switch state

- (void)switchToMainMenu {
    
    _gameState = GameStateMainMenu;
    [self setupBackground];
    [self setupForeground];
    [self setupPlayerMM];
    [self setupPlayerAnimation];
    //[self setupSombrero];
    [self setupWobble];
    [self setupMainMenu];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];

}

- (void)switchToMainMenuS {
    
    _gameState = GameStateMainMenuS;

}

- (void)switchToMyPokemon {
    
    _gameState = GameStateMyPokemon;
    [self setupBackground];
    [self setupForeground];
    //[self setupPlayerMM];
    //[self setupPlayerAnimation];
    //[self setupSombrero];
    //[self setupWobble];
    [self setupMyPokemon];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
    
    //[_player removeAllActions]; // DONLY
}

- (void)switchToMyPokemon1 {
    
    _gameState = GameStatePokeCard1;
    [self setupBackground];
    [self setupForeground];
    //[self setupPlayerMM];
    //[self setupPlayerAnimation];
    //[self setupSombrero];
    //[self setupWobble];
    [self setupMyPokemon1];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}

- (void)switchToMyPokemon2 {
    
    _gameState = GameStatePokeCard2;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon2];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];

}

- (void)switchToMyPokemon3 {
    
    _gameState = GameStatePokeCard3;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon3];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}

- (void)switchToMyPokemon4 {
    
    _gameState = GameStatePokeCard4;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon4];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}
- (void)switchToMyPokemon5 {
    
    _gameState = GameStatePokeCard5;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon5];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}

- (void)switchToMyPokemon6 {
    
    _gameState = GameStatePokeCard6;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon6];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}
- (void)switchToMyPokemon7 {
    
    _gameState = GameStatePokeCard7;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon7];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}

- (void)switchToMyPokemon8 {
    
    _gameState = GameStatePokeCard8;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon8];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}
- (void)switchToMyPokemon9 {
    
    _gameState = GameStatePokeCard9;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon9];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}

- (void)switchToMyPokemon10 {
    
    _gameState = GameStatePokeCard10;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon10];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}
- (void)switchToMyPokemon11 {
    
    _gameState = GameStatePokeCard11;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon11];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}

- (void)switchToMyPokemon12 {
    
    _gameState = GameStatePokeCard12;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon12];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}
- (void)switchToMyPokemon13 {
    
    _gameState = GameStatePokeCard13;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon13];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}

- (void)switchToMyPokemon14 {
    
    _gameState = GameStatePokeCard14;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon14];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}
- (void)switchToMyPokemon15 {
    
    _gameState = GameStatePokeCard15;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon15];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}

- (void)switchToMyPokemon16 {
    
    _gameState = GameStatePokeCard16;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon16];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}
- (void)switchToMyPokemon17 {
    
    _gameState = GameStatePokeCard17;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon17];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}

- (void)switchToMyPokemon18 {
    
    _gameState = GameStatePokeCard18;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon18];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}
- (void)switchToMyPokemon19 {
    
    _gameState = GameStatePokeCard19;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon19];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}

- (void)switchToMyPokemon20 {
    
    _gameState = GameStatePokeCard20;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon20];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}
- (void)switchToMyPokemon21 {
    
    _gameState = GameStatePokeCard21;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon21];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}

- (void)switchToMyPokemon22 {
    
    _gameState = GameStatePokeCard22;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon22];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}
- (void)switchToMyPokemon23 {
    
    _gameState = GameStatePokeCard23;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon23];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}

- (void)switchToMyPokemon24 {
    
    _gameState = GameStatePokeCard24;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon24];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}
- (void)switchToMyPokemon25 {
    
    _gameState = GameStatePokeCard25;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon25];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}

- (void)switchToMyPokemon26 {
    
    _gameState = GameStatePokeCard26;
    [self setupBackground];
    [self setupForeground];
    [self setupMyPokemon26];
    [self setupHoOh];
    [self setupHoOhAnimation];
    [self setupSounds];
    
}

- (void)switchToFalling {
    _gameState = GameStateFalling;
    
    // Screen shake
    SKAction *shake =
    [SKAction skt_screenShakeWithNode:_worldNode amount:CGPointMake(0, 7.0)
                         oscillations:10 duration:1.0];
    [_worldNode runAction:shake];
    
    // Flash
    SKSpriteNode *whiteNode = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:self.size];
    whiteNode.position = CGPointMake(self.size.width*0.5, self.size.height*0.5);
    whiteNode.zPosition = LayerFlash;
    [_worldNode addChild:whiteNode];
    [whiteNode runAction:[SKAction sequence:@[
                                              [SKAction waitForDuration:0.01],
                                              [SKAction removeFromParent]
                                              ]]];
    
    
    // Transition code...
    [self runAction:[SKAction sequence:@[
                                         _whackAction,
                                         [SKAction waitForDuration:0.1],
                                         _fallingAction]]];
    
    [_player removeAllActions];
    [self stopSpawning];
}

- (void)switchToFallingJ {
    _gameState = GameStateFallingJ;
    
    // Screen shake
    SKAction *shake =
    [SKAction skt_screenShakeWithNode:_worldNode amount:CGPointMake(0, 7.0)
                         oscillations:10 duration:1.0];
    [_worldNode runAction:shake];
    
    // Flash
    SKSpriteNode *whiteNode = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:self.size];
    whiteNode.position = CGPointMake(self.size.width*0.5, self.size.height*0.5);
    whiteNode.zPosition = LayerFlash;
    [_worldNode addChild:whiteNode];
    [whiteNode runAction:[SKAction sequence:@[
                                              [SKAction waitForDuration:0.01],
                                              [SKAction removeFromParent]
                                              ]]];
    
    
    // Transition code...
    [self runAction:[SKAction sequence:@[
                                         _whackAction,
                                         [SKAction waitForDuration:0.1],
                                         _fallingAction]]];
    
    [_player removeAllActions];
    [self stopSpawning];
}

- (void)switchToFallingJR {
    _gameState = GameStateFallingJR;
    
    // Screen shake
    SKAction *shake =
    [SKAction skt_screenShakeWithNode:_worldNode amount:CGPointMake(0, 7.0)
                         oscillations:10 duration:1.0];
    [_worldNode runAction:shake];
    
    // Flash
    SKSpriteNode *whiteNode = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:self.size];
    whiteNode.position = CGPointMake(self.size.width*0.5, self.size.height*0.5);
    whiteNode.zPosition = LayerFlash;
    [_worldNode addChild:whiteNode];
    [whiteNode runAction:[SKAction sequence:@[
                                              [SKAction waitForDuration:0.01],
                                              [SKAction removeFromParent]
                                              ]]];
    
    
    // Transition code...
    [self runAction:[SKAction sequence:@[
                                         _whackAction,
                                         [SKAction waitForDuration:0.1],
                                         _fallingAction]]];
    
    [_player removeAllActions];
    [self stopSpawning];
}

- (void)switchToFallingR {
    _gameState = GameStateFallingR;
    
    // Screen shake
    SKAction *shake =
    [SKAction skt_screenShakeWithNode:_worldNode amount:CGPointMake(0, 7.0)
                         oscillations:10 duration:1.0];
    [_worldNode runAction:shake];
    
    // Flash
    SKSpriteNode *whiteNode = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:self.size];
    whiteNode.position = CGPointMake(self.size.width*0.5, self.size.height*0.5);
    whiteNode.zPosition = LayerFlash;
    [_worldNode addChild:whiteNode];
    [whiteNode runAction:[SKAction sequence:@[
                                              [SKAction waitForDuration:0.01],
                                              [SKAction removeFromParent]
                                              ]]];
    
    
    // Transition code...
    [self runAction:[SKAction sequence:@[
                                         _whackAction,
                                         [SKAction waitForDuration:0.1],
                                         _fallingAction]]];
    
    [_player removeAllActions];
    [self stopSpawning];
}

- (void)switchToShowScore {
    
    _gameState = GameStateShowingScore;
    
    [_player removeAllActions];
    [self stopSpawning];
    
    [self setupScoreCard];
    
}

- (void)switchToShowScoreJ {
    
    _gameState = GameStateShowingScoreJ;
    
    [_player removeAllActions];
    [self stopSpawning];
    
    [self setupScoreCardJ];
    
}

- (void)switchToShowScoreJR {
    
    _gameState = GameStateShowingScoreJR;
    
    [_player removeAllActions];
    [self stopSpawning];
    
    [self setTotalPotions:[self totalPotions]-1];
    [self setupScoreCardJR:[self lastScoreJ]-150];
    
    
}

- (void)switchToShowScoreR {
    
    _gameState = GameStateShowingScoreR;
    
    [_player removeAllActions];
    [self stopSpawning];
    
    //[self setTotalPotions:[self totalPotions]-1];
    [self setupScoreCardR:[self lastScore]+_score-1];
    
    
}
- (void)switchToNewGame: (GameState)state {
    
    [self runAction:_popAction];
    
    SKScene *newScene = [[MyScene alloc] initWithSize:self.size delegate:self.delegate state:state];
    SKTransition *transition = [SKTransition fadeWithColor:[SKColor blackColor] duration:0.2];
    [self.view presentScene:newScene transition:transition];
}
- (void)switchToNewGame1: (GameState)state {
    
    [self runAction:_click];
    
    SKScene *newScene = [[MyScene alloc] initWithSize:self.size delegate:self.delegate state:state];
    //SKTransition *transition = [SKTransition fadeWithColor:[SKColor blackColor] duration:0.2];
    [self.view presentScene:newScene];
}
- (void)switchToNewGame2: (GameState)state {
    
    [self runAction:_revive];
    
    SKScene *newScene = [[MyScene alloc] initWithSize:self.size delegate:self.delegate state:state];
    SKTransition *transition = [SKTransition fadeWithColor:[SKColor blackColor] duration:0.2];
    [self.view presentScene:newScene transition:transition];
}
- (void)switchToTutorial {
    
    _gameState = GameStateTutorial;
    [self setupBackground];
    [self setupForeground];
    [self setupPlayer];
    [self setupPlayerAnimation];
    [self setupSounds];
    //[self setupSombrero];
    [self setupWobble];
    [self setupScoreLabel];
    [self setupTutorial];
    [self setupHoOh];
    [self setupHoOhAnimationGame];
    
}
//==============================REVIVE STUFF============================
//==============================REVIVE STUFF============================
//==============================REVIVE STUFF============================
- (void)switchToTutorialR {
    
    //[self setLastScore:_score];
    _gameState = GameStateTutorialR;
    [self setupBackground];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"HDPokeJumpBGSUNSET"];
    background.anchorPoint = CGPointMake(0.5, 1);
    background.position = CGPointMake(self.size.width/2, self.size.height);
    background.zPosition = LayerBackground;
    background.name = @"Background";
    [_worldNode addChild:background];
    [self setupForeground];
    [self setupPokemon:[self lastScore]];
    [self updateScoreR];
    //[self setupPlayer];
    //[self setupPlayerAnimation];
    [self setupSounds];
    //[self setupSombrero];
    [self setupWobble];
    [self setupScoreLabelR];
    //[self setupTutorial];
    [self setupHoOh];
    [self setupHoOhAnimationGame];
}

- (void)switchToTutorialJR {
    
    //[self setLastScore:_score];
    _gameState = GameStateTutorialJR;
    [self setupBackground];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"HDPokeJumpBGSUNSET"];
    background.anchorPoint = CGPointMake(0.5, 1);
    background.position = CGPointMake(self.size.width/2, self.size.height);
    background.zPosition = LayerBackground;
    background.name = @"Background";
    [_worldNode addChild:background];
    [self setupForeground];
    [self setupPokemon:[self lastScoreJ]];
    [self updateScoreR];
    //[self setupPlayer];
    //[self setupPlayerAnimation];
    [self setupSounds];
    //[self setupSombrero];
    [self setupWobble];
    [self setupScoreLabelJR];
    //[self setupTutorial];
    [self setupHoOh];
    [self setupHoOhAnimationGame];
}
//==============================REVIVE STUFF============================
//==============================REVIVE STUFF============================
//==============================REVIVE STUFF============================

- (void)switchToLockedJohto {
    
    _gameState = GameStateLockedJohto;
    
}

- (void)switchToReviveHey {
    
    _gameState = GameStateReviveHey;
    
}

- (void)switchToZeroRevives{
    _gameState = GameStateZeroRevives;
    
}


- (void)switchToPlay {
    
    // Set state
    _gameState = GameStatePlay;
    
    // Remove tutorial
    [_worldNode enumerateChildNodesWithName:@"Tutorial" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:[SKAction sequence:@[
                                             [SKAction fadeOutWithDuration:0.5],
                                             [SKAction removeFromParent]
                                             ]]];
    }];
    
    //Remove JohtoButton
    [_worldNode enumerateChildNodesWithName:@"JohtoButton" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:[SKAction sequence:@[
                                             [SKAction fadeOutWithDuration:0.00001],
                                             [SKAction removeFromParent]
                                             ]]];
    }];
    
    //Remove JohtoButton
    [_worldNode enumerateChildNodesWithName:@"JohtoHL" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:[SKAction sequence:@[
                                             [SKAction fadeOutWithDuration:0.00001],
                                             [SKAction removeFromParent]
                                             ]]];
    }];
    
    // Remove wobble
    [_player removeActionForKey:@"Wobble"];
    
    // Start spawning
    [self startSpawning];
    
    // Move player
    [self flapPlayer];
    [self setupPlayerAnimation];
    
}

- (void)switchToPlayR:(int)score {
    
    // Set state
    _gameState = GameStatePlayR;
    
    // Remove wobble
    [_player removeActionForKey:@"Wobble"];
    
    // Start spawning
    [self startSpawningR];
    
    // Move player
    [self flapPlayer];
    SKSpriteNode *newPlayer;
    if (score == 0) {
        newPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"AshSprite1"];
    }
    if (score == 252) {
        newPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"CrazyAsh0"];
    }
    else {
        newPlayer = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d", score]];
    }
    
    if (_player) {
        newPlayer.position = _player.position;
    } else {
        newPlayer.position = CGPointMake(self.size.width * 0.2, _playableHeight * 0.4 + _playableStart);
    }
    
    newPlayer.zPosition = LayerPlayer;
    [_worldNode addChild:newPlayer];
    
    CGFloat offsetX = newPlayer.frame.size.width * newPlayer.anchorPoint.x;
    CGFloat offsetY = newPlayer.frame.size.height * newPlayer.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    NSArray* coordinates = [[hitBoxLines objectAtIndex:score] componentsSeparatedByString:@","];
    NSUInteger coordCount = coordinates.count;
    for (NSUInteger n = 0; n < coordCount; n+=2) {
        int x = [[coordinates objectAtIndex:n] intValue];
        int y = [[coordinates objectAtIndex:n+1] intValue];
        if (n == 0) {
            CGPathMoveToPoint(path, NULL, x - offsetX, y - offsetY);
        }
        else {
            CGPathAddLineToPoint(path, NULL, x - offsetX, y - offsetY);
        }
    }
    
    CGPathCloseSubpath(path);
    
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
    
    
    newPlayer = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d", score]];
    if (_player) {
        newPlayer.position = _player.position;
    } else {
        newPlayer.position = CGPointMake(self.size.width * 0.2, _playableHeight * 0.4 + _playableStart);
    }
    
    newPlayer.zPosition = LayerPlayer;
    [_worldNode addChild:newPlayer];
    /*
     CGFloat offsetX = newPlayer.frame.size.width * newPlayer.anchorPoint.x;
     CGFloat offsetY = newPlayer.frame.size.height * newPlayer.anchorPoint.y;
     
     CGMutablePathRef path = CGPathCreateMutable();
     
     CGPathMoveToPoint(path, NULL, 1 - offsetX, 32 - offsetY);
     CGPathAddLineToPoint(path, NULL, 11 - offsetX, 43 - offsetY);
     CGPathAddLineToPoint(path, NULL, 26 - offsetX, 43 - offsetY);
     CGPathAddLineToPoint(path, NULL, 37 - offsetX, 29 - offsetY);
     CGPathAddLineToPoint(path, NULL, 31 - offsetX, 23 - offsetY);
     CGPathAddLineToPoint(path, NULL, 30 - offsetX, 17 - offsetY);
     CGPathAddLineToPoint(path, NULL, 24 - offsetX, 15 - offsetY);
     CGPathAddLineToPoint(path, NULL, 25 - offsetX, 10 - offsetY);
     CGPathAddLineToPoint(path, NULL, 31 - offsetX, 16 - offsetY);
     CGPathAddLineToPoint(path, NULL, 27 - offsetX, 2 - offsetY);
     CGPathAddLineToPoint(path, NULL, 9 - offsetX, 3 - offsetY);
     
     CGPathCloseSubpath(path);
     
     newPlayer.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
     
     [newPlayer skt_attachDebugFrameFromPath:path color:[SKColor redColor]];
     
     newPlayer.physicsBody.categoryBitMask = EntityCategoryPlayer;
     newPlayer.physicsBody.collisionBitMask = 0;
     newPlayer.physicsBody.contactTestBitMask = EntityCategoryObstacle | EntityCategoryGround;
     */
    // Swap players
    if (_player) {
        newPlayer.zRotation = _player.zRotation;
        [_player removeFromParent];
    }
    _player = newPlayer;
    
    //[self setupPlayerAnimation];
    
    //[self setupPlayerR];
    
}

- (void)switchToJohto {
    
    // Set state
    _gameState = GameStatePlayJ;
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"HDPokeJumpBGSUNSET"];
    background.anchorPoint = CGPointMake(0.5, 1);
    background.position = CGPointMake(self.size.width/2, self.size.height);
    background.zPosition = LayerBackground;
    background.name = @"Background";
    [_worldNode addChild:background];
    
    _scoreLabel.text = @"Ash";
    _scoreLabel.fontColor = [UIColor whiteColor];
    
    // Remove tutorial
    [_worldNode enumerateChildNodesWithName:@"Tutorial" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:[SKAction sequence:@[
                                             [SKAction fadeOutWithDuration:0.5],
                                             [SKAction removeFromParent]
                                             ]]];
    }];
    
    //Remove JohtoButton
    [_worldNode enumerateChildNodesWithName:@"JohtoButton" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:[SKAction sequence:@[
                                             [SKAction fadeOutWithDuration:0.00001],
                                             [SKAction removeFromParent]
                                             ]]];
    }];
    
    //Remove JohtoButton
    [_worldNode enumerateChildNodesWithName:@"JohtoHL" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:[SKAction sequence:@[
                                             [SKAction fadeOutWithDuration:0.00001],
                                             [SKAction removeFromParent]
                                             ]]];
    }];
    
    // Remove wobble
    [_player removeActionForKey:@"Wobble"];
    
    // Start spawning
    [self startSpawningJ];
    
    // Move player
    [self flapPlayer];
    [self setupPlayerAnimationJ];
    
   // if (_player.position.y <= _playableStart) {
   //     [self switchToShowScoreJ];
   // }
    
    
}

- (void)switchToPlayJR:(int)score {
    
    // Set state
    _gameState = GameStatePlayJR;
    
    // Remove wobble
    [_player removeActionForKey:@"Wobble"];
    
    // Start spawning
    [self startSpawningJ];
    
    // Move player
    [self flapPlayer];
    SKSpriteNode *newPlayer;
    if (score == 0) {
        newPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"AshSprite1"];
    }
    if (score == 252) {
        newPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"CrazyAsh0"];
    }
    else {
        newPlayer = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d", score]];
    }
    
    if (_player) {
        newPlayer.position = _player.position;
    } else {
        newPlayer.position = CGPointMake(self.size.width * 0.2, _playableHeight * 0.4 + _playableStart);
    }
    
    newPlayer.zPosition = LayerPlayer;
    [_worldNode addChild:newPlayer];
    
    CGFloat offsetX = newPlayer.frame.size.width * newPlayer.anchorPoint.x;
    CGFloat offsetY = newPlayer.frame.size.height * newPlayer.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    NSArray* coordinates = [[hitBoxLines objectAtIndex:score] componentsSeparatedByString:@","];
    NSUInteger coordCount = coordinates.count;
    for (NSUInteger n = 0; n < coordCount; n+=2) {
        int x = [[coordinates objectAtIndex:n] intValue];
        int y = [[coordinates objectAtIndex:n+1] intValue];
        if (n == 0) {
            CGPathMoveToPoint(path, NULL, x - offsetX, y - offsetY);
        }
        else {
            CGPathAddLineToPoint(path, NULL, x - offsetX, y - offsetY);
        }
    }
    
    CGPathCloseSubpath(path);
    
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
    
    
    newPlayer = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"N%d", score]];
    if (_player) {
        newPlayer.position = _player.position;
    } else {
        newPlayer.position = CGPointMake(self.size.width * 0.2, _playableHeight * 0.4 + _playableStart);
    }
    
    newPlayer.zPosition = LayerPlayer;
    [_worldNode addChild:newPlayer];
    /*
     CGFloat offsetX = newPlayer.frame.size.width * newPlayer.anchorPoint.x;
     CGFloat offsetY = newPlayer.frame.size.height * newPlayer.anchorPoint.y;
     
     CGMutablePathRef path = CGPathCreateMutable();
     
     CGPathMoveToPoint(path, NULL, 1 - offsetX, 32 - offsetY);
     CGPathAddLineToPoint(path, NULL, 11 - offsetX, 43 - offsetY);
     CGPathAddLineToPoint(path, NULL, 26 - offsetX, 43 - offsetY);
     CGPathAddLineToPoint(path, NULL, 37 - offsetX, 29 - offsetY);
     CGPathAddLineToPoint(path, NULL, 31 - offsetX, 23 - offsetY);
     CGPathAddLineToPoint(path, NULL, 30 - offsetX, 17 - offsetY);
     CGPathAddLineToPoint(path, NULL, 24 - offsetX, 15 - offsetY);
     CGPathAddLineToPoint(path, NULL, 25 - offsetX, 10 - offsetY);
     CGPathAddLineToPoint(path, NULL, 31 - offsetX, 16 - offsetY);
     CGPathAddLineToPoint(path, NULL, 27 - offsetX, 2 - offsetY);
     CGPathAddLineToPoint(path, NULL, 9 - offsetX, 3 - offsetY);
     
     CGPathCloseSubpath(path);
     
     newPlayer.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
     
     [newPlayer skt_attachDebugFrameFromPath:path color:[SKColor redColor]];
     
     newPlayer.physicsBody.categoryBitMask = EntityCategoryPlayer;
     newPlayer.physicsBody.collisionBitMask = 0;
     newPlayer.physicsBody.contactTestBitMask = EntityCategoryObstacle | EntityCategoryGround;
     */
    // Swap players
    if (_player) {
        newPlayer.zRotation = _player.zRotation;
        [_player removeFromParent];
    }
    _player = newPlayer;
    
    //[self setupPlayerAnimation];
    
    //[self setupPlayerR];
    
}




- (void)switchToGameOver {
    _gameState = GameStateGameOver;
}

- (void)switchToGameOverR {
    _gameState = GameStateGameOverR;
}

- (void)switchToGameOverJ {
    _gameState = GameStateGameOverJ;
}

- (void)switchToGameOverJR {
    _gameState = GameStateGameOverJR;
}
- (void)switchToPokeCard1 {
    _gameState = GameStatePokeCard1;
    //[self addPokemon2:[self bestScore]];
}
- (void)switchToPokeCard2 {
    _gameState = GameStatePokeCard2;
}
- (void)switchToPokeCard3 {
    _gameState = GameStatePokeCard3;
}
- (void)switchToPokeCard4 {
    _gameState = GameStatePokeCard4;
}
- (void)switchToPokeCard5 {
    _gameState = GameStatePokeCard5;
}
- (void)switchToPokeCard6 {
    _gameState = GameStatePokeCard6;
}
- (void)switchToPokeCard7 {
    _gameState = GameStatePokeCard7;
}
- (void)switchToPokeCard8 {
    _gameState = GameStatePokeCard8;
}
- (void)switchToPokeCard9 {
    _gameState = GameStatePokeCard9;
}
- (void)switchToPokeCard10 {
    _gameState = GameStatePokeCard10;
}
- (void)switchToPokeCard11 {
    _gameState = GameStatePokeCard11;
}
- (void)switchToPokeCard12 {
    _gameState = GameStatePokeCard12;
}
- (void)switchToPokeCard13 {
    _gameState = GameStatePokeCard13;
}
- (void)switchToPokeCard14 {
    _gameState = GameStatePokeCard14;
}
- (void)switchToPokeCard15 {
    _gameState = GameStatePokeCard15;
}
- (void)switchToPokeCard16 {
    _gameState = GameStatePokeCard16;
}
- (void)switchToPokeCard17 {
    _gameState = GameStatePokeCard17;
}
- (void)switchToPokeCard18 {
    _gameState = GameStatePokeCard18;
}
- (void)switchToPokeCard19 {
    _gameState = GameStatePokeCard19;
}
- (void)switchToPokeCard20 {
    _gameState = GameStatePokeCard20;
}
- (void)switchToPokeCard21 {
    _gameState = GameStatePokeCard21;
}
- (void)switchToPokeCard22 {
    _gameState = GameStatePokeCard22;
}
- (void)switchToPokeCard23 {
    _gameState = GameStatePokeCard23;
}
- (void)switchToPokeCard24 {
    _gameState = GameStatePokeCard24;
}
- (void)switchToPokeCard25 {
    _gameState = GameStatePokeCard25;
}
- (void)switchToPokeCard26 {
    _gameState = GameStatePokeCard26;
}


#pragma mark - Updates

- (void)checkHitGround {
    if (_hitGround || _player.position.y <= 10) {
        _hitGround = NO;
        _playerVelocity = CGPointZero;
        _player.position = CGPointMake(_player.position.x, (_playableStart - 25) + _player.size.width/2);
        _player.zRotation = DegreesToRadians(-90);
        
        [self runAction:_hitGroundAction];
        [self switchToShowScore];
    }
}

- (void)checkHitGroundJ {
    if (_hitGround || _player.position.y <= 10) {
        _hitGround = NO;
        _playerVelocity = CGPointZero;
        _player.position = CGPointMake(_player.position.x, (_playableStart - 25) + _player.size.width/2);
        _player.zRotation = DegreesToRadians(-90);
        
        [self runAction:_hitGroundAction];
        [self switchToShowScoreJ];
    }
}

- (void)checkHitGroundJR {
    if (_hitGround || _player.position.y <= 10) {
        _hitGround = NO;
        _playerVelocity = CGPointZero;
        _player.position = CGPointMake(_player.position.x, (_playableStart - 25) + _player.size.width/2);
        _player.zRotation = DegreesToRadians(-90);
        
        [self runAction:_hitGroundAction];
        [self switchToShowScoreJR];
    }
}

- (void)checkHitGroundR {
    if (_hitGround || _player.position.y <= 10) {
        _hitGround = NO;
        _playerVelocity = CGPointZero;
        _player.position = CGPointMake(_player.position.x, (_playableStart - 25) + _player.size.width/2);
        _player.zRotation = DegreesToRadians(-90);
        
        [self runAction:_hitGroundAction];
        [self switchToShowScoreR];
    }
}

- (void)checkHitObstacle {
    if (_hitObstacle) {
        _hitObstacle = NO;
        [self switchToFalling];
    }
}

- (void)checkHitObstacleJ {
    if (_hitObstacle) {
        _hitObstacle = NO;
        [self switchToFallingJ];
    }
}

- (void)checkHitObstacleJR {
    if (_hitObstacle) {
        _hitObstacle = NO;
        [self switchToFallingJR];
    }
}

- (void)checkHitObstacleR {
    if (_hitObstacle) {
        _hitObstacle = NO;
        [self switchToFallingR];
    }
}

- (void)updatePlayer {
    
    // Apply gravity
    CGPoint gravity = CGPointMake(0, kGravity);
    CGPoint gravityStep = CGPointMultiplyScalar(gravity, _dt);
    _playerVelocity = CGPointAdd(_playerVelocity, gravityStep);
    
    // Apply velocity
    CGPoint velocityStep = CGPointMultiplyScalar(_playerVelocity, _dt);
    _player.position = CGPointAdd(_player.position, velocityStep);
      _player.position = CGPointMake(_player.position.x, MIN(_player.position.y, self.size.height));
    
    // Temporary halt when hits ground
    //  if (_player.position.y - _player.size.height/2 <= _playableStart) {
    //    _player.position = CGPointMake(_player.position.x, _playableStart + _player.size.height/2);
    //    return;
    //  }
    
    // Check if it's time to rate down
    if (_player.position.y < _lastTouchY) {
        _playerAngularVelocity = -DegreesToRadians(kAngularVelocity);
    }
    
    // Rotate player
    float angularStep = _playerAngularVelocity * _dt;
    _player.zRotation += angularStep;
    _player.zRotation = MIN(MAX(_player.zRotation, DegreesToRadians(kMinDegrees)), DegreesToRadians(kMaxDegrees));
    
}

- (void)updatePlayerJ {
    
    // Apply gravity
    CGPoint gravity = CGPointMake(0, kGravityJ);
    CGPoint gravityStep = CGPointMultiplyScalar(gravity, _dt);
    _playerVelocity = CGPointAdd(_playerVelocity, gravityStep);
    
    // Apply velocity
    CGPoint velocityStep = CGPointMultiplyScalar(_playerVelocity, _dt);
    _player.position = CGPointAdd(_player.position, velocityStep);
    _player.position = CGPointMake(_player.position.x, MIN(_player.position.y, self.size.height));
    
    // Temporary halt when hits ground
    //  if (_player.position.y - _player.size.height/2 <= _playableStart) {
    //    _player.position = CGPointMake(_player.position.x, _playableStart + _player.size.height/2);
    //    return;
    //  }
    
    // Check if it's time to rate down
    if (_player.position.y < _lastTouchY) {
        _playerAngularVelocity = -DegreesToRadians(kAngularVelocity);
    }
    
    // Rotate player
    float angularStep = _playerAngularVelocity * _dt;
    _player.zRotation += angularStep;
    _player.zRotation = MIN(MAX(_player.zRotation, DegreesToRadians(kMinDegrees)), DegreesToRadians(kMaxDegrees));
    
}



- (void)updateForeground {
    
    [_worldNode enumerateChildNodesWithName:@"Foreground" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *foreground = (SKSpriteNode *)node;
        CGPoint moveAmt = CGPointMake(-kGroundSpeed * _dt, 0);
        foreground.position = CGPointAdd(foreground.position, moveAmt);
        
        if (foreground.position.x < -foreground.size.width) {
            foreground.position = CGPointAdd(foreground.position, CGPointMake(foreground.size.width * kNumForegrounds, 0));
        }
        
    }];
    
}

- (void)updateForegroundJ {
    
    [_worldNode enumerateChildNodesWithName:@"Foreground" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *foreground = (SKSpriteNode *)node;
        CGPoint moveAmt = CGPointMake(-kGroundSpeedJ * _dt, 0);
        foreground.position = CGPointAdd(foreground.position, moveAmt);
        
        if (foreground.position.x < -foreground.size.width) {
            foreground.position = CGPointAdd(foreground.position, CGPointMake(foreground.size.width * kNumForegrounds, 0));
        }
        
    }];
    
}

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
             
             
             [self setupPokemon:_score-1];
             if (_score > 252) {
                 [self setupCrazyAnimation];
             }
         }
     }

 }];
 
 }

-(void)updateScoreJohto {
    
    [_worldNode enumerateChildNodesWithName:@"BottomObstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *obstacle = (SKSpriteNode *)node;
        
        NSNumber *passed = obstacle.userData[@"Passed"];
        if (passed && passed.boolValue) return;
        
        if (_player.position.x > obstacle.position.x) {
            if (_score < 1) {
                _score++;
                _scoreLabel.text = [NSString stringWithFormat:@"No.%03d", _score];
                _scoreLabel.fontColor = [UIColor whiteColor];
            }
            else {
                _scoreLabel.text = [NSString stringWithFormat:@"No.%03d", _score];
                _scoreLabel.fontColor = [UIColor whiteColor];
                [self runAction:_coinAction];
                _score++;
                
                obstacle.userData[@"Passed"] = @YES;
                
                if (_score <= 100) {
                    [self setupPokemon:_score+150];
                }
                else {
                    [self setupCrazyAsh];
                    [self setupCrazyAnimation];
                }
                
                //else {
                //    [self setupPlayer];
                //}
                
            }
        }
        
    }];
    
}

-(void)updateScoreR {
    
    //[self setupScoreCard];
    /*
    if (_score > [self bestScore]) {
        _score--;
        [self setBestScore:_score];
        _score++;
        [self runAction:_highScore];
    }
    */
    [_worldNode enumerateChildNodesWithName:@"BottomObstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *obstacle = (SKSpriteNode *)node;
        
        NSNumber *passed = obstacle.userData[@"Passed"];
        if (passed && passed.boolValue) return;
        
        if (_player.position.x > obstacle.position.x) {
            if (_score < 1) {
                _score++;
                _scoreLabel.text = [NSString stringWithFormat:@"No.%03d", [self lastScore]+_score];
                _scoreLabel.fontColor = [UIColor whiteColor];
            }
            else {
                _scoreLabel.text = [NSString stringWithFormat:@"No.%03d", [self lastScore]+_score];
                _scoreLabel.fontColor = [UIColor whiteColor];
                [self runAction:_coinAction];
                _score++;
                
                obstacle.userData[@"Passed"] = @YES;
                
                if (_score <= 251) {
                    [self setupPokemon:[self lastScore]+_score-1];
                }
                else {
                    [self setupCrazyAsh];
                    [self setupCrazyAnimation];
                }
                
                //else {
                //    [self setupPlayer];
                //}
                
            }
        }
        
    }];
    
}

-(void)updateScoreJR {
    
    [_worldNode enumerateChildNodesWithName:@"BottomObstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *obstacle = (SKSpriteNode *)node;
        
        NSNumber *passed = obstacle.userData[@"Passed"];
        if (passed && passed.boolValue) return;
        
        if (_player.position.x > obstacle.position.x) {
            if (_score < 1) {
                _score++;
                _scoreLabel.text = [NSString stringWithFormat:@"No.%03d", [self lastScoreJ]-151+_score];
                _scoreLabel.fontColor = [UIColor whiteColor];
            }
            else {
                _scoreLabel.text = [NSString stringWithFormat:@"No.%03d", [self lastScoreJ]-151+_score];
                _scoreLabel.fontColor = [UIColor whiteColor];
                [self runAction:_coinAction];
                _score++;
                
                obstacle.userData[@"Passed"] = @YES;
                
                if (_score <= 100) {
                    [self setupPokemon:[self lastScoreJ]+_score-1];
                }
                else {
                    [self setupCrazyAsh];
                    [self setupCrazyAnimation];
                }
                
                //else {
                //    [self setupPlayer];
                //}
                
            }
        }
        
    }];
    
}


-(void)update:(CFTimeInterval)currentTime {
    if (_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    } else {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    
    switch (_gameState) {
        case GameStateMainMenu:
            break;
        case GameStateTutorial:
            break;
        case GameStateTutorialR:
            break;
        case GameStateTutorialJR:
            break;
        case GameStateLockedJohto:
            break;
        case GameStateReviveHey:
            break;
        case GameStateZeroRevives:
            break;
        case GameStatePlayR:
            [self updateForeground];//good
            [self updatePlayer];//good
            [self checkHitGroundR];//changes scorecard
            [self checkHitObstacleR];//makes sure scorecardR comes up
            [self updateScoreR];//done!
            break;
        case GameStatePlay:
            [self updateForeground];
            [self updatePlayer];
            [self checkHitGround];
            [self checkHitObstacle];
            [self updateScore];
            break;
        case GameStatePlayJ:
            [self updateForegroundJ];
            [self updatePlayerJ];
            [self checkHitGroundJ];
            [self checkHitObstacleJ];
            [self updateScoreJohto];
            break;
        case GameStatePlayJR:
            [self updateForegroundJ];
            [self updatePlayerJ];
            [self checkHitGroundJR];
            [self checkHitObstacleJR];
            [self updateScoreJR];
            break;
        case GameStateFalling:
            [self checkHitGround];
            [self updatePlayer];
            break;
        case GameStateFallingJ:
            [self checkHitGroundJ];
            [self updatePlayerJ];
            break;
        case GameStateFallingJR:
            [self checkHitGroundJR];
            [self updatePlayerJ];
            break;
        case GameStateFallingR:
            [self checkHitGroundR];
            [self updatePlayer];
            break;
        case GameStateShowingScore:
            [self updateScore];
            break;
        case GameStateShowingScoreJ:
            [self updateScore];
            break;
        case GameStateShowingScoreR:
            [self updateScore];
            break;
        case GameStateGameOver:
            [self updateScore];
            break;
        case GameStateGameOverR:
            //[self updateScoreR];
            break;
        case GameStateGameOverJ:
            [self updateScoreJohto];
            break;
        case GameStateGameOverJR:
            //[self updateScoreR];
            break;
    }
}



#pragma mark - Special

- (void)shareScore {
    
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%d?mt=8",APP_STORE_ID];
    NSURL *url = [NSURL URLWithString:urlString];
    
    UIImage *screenshot = [self.delegate screenshot];
    _score--;
    
    NSString *initialTextString = [NSString stringWithFormat:@"YES! I just got to Pokemon No. %03d on PokeJump! #PokeJump", _score];
    [self.delegate shareString:initialTextString url:url image:screenshot];
}

- (void)rateApp {
    
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%d?mt=8", APP_STORE_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
}

#pragma mark - Score

- (int)lastScore {
    return [[NSUserDefaults standardUserDefaults] integerForKey: @"LastScore"];
}

- (void)setLastScore:(int)lastScore {
    [[NSUserDefaults standardUserDefaults] setInteger:lastScore forKey:@"LastScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (int)lastScoreJ {
    return [[NSUserDefaults standardUserDefaults] integerForKey: @"LastScore"];
}

- (void)setLastScoreJ:(int)lastScore {
    [[NSUserDefaults standardUserDefaults] setInteger:lastScore forKey:@"LastScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (int)bestScore {
    return [[NSUserDefaults standardUserDefaults] integerForKey: @"BestScore"];
}

- (void)setBestScore:(int)bestScore {
    [[NSUserDefaults standardUserDefaults] setInteger:bestScore forKey:@"BestScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (int)bestScoreJ {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"BestScoreJ"];
}

- (void)setBestScoreJ:(int)bestScoreJ {
    [[NSUserDefaults standardUserDefaults] setInteger:bestScoreJ forKey:@"BestScoreJ"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (int)totalPotions {
    return [[NSUserDefaults standardUserDefaults] integerForKey: @"TotalPotions"];
}

- (void)setTotalPotions:(int)totalPotions {
    [[NSUserDefaults standardUserDefaults] setInteger:totalPotions forKey:@"TotalPotions"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Collision Detection

- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *other = (contact.bodyA.categoryBitMask == EntityCategoryPlayer ? contact.bodyB : contact.bodyA);
    if (other.categoryBitMask == EntityCategoryGround) {
        _hitGround = YES;
        return;
    }
    if (other.categoryBitMask == EntityCategoryObstacle) {
        _hitObstacle = YES;
        return;
    }
}

@end