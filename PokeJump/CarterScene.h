//
//  CarterScene.h
//  PokeJump
//
//  Created by Charles Lee on 6/10/14.
//  Copyright (c) 2014 Apiy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(int, GameState) {
    GameStateMainMenu,
    GameStateTutorial,
    GameStateLockedJohto,
    GameStatePlay,
    GameStatePlayJ,
    GameStateFalling,
    GameStateFallingJ,
    GameStateShowingScore,
    GameStateShowingScoreJ,
    GameStateGameOver
};

@protocol MySceneDelegate
- (UIImage *)screenshot;
- (void)shareString:(NSString *)string url:(NSURL*)url image:(UIImage *)image;

@end

@interface CarterScene : SKScene

-(id)initWithSize:(CGSize)size delegate:(id<MySceneDelegate>)delegate state:(GameState) state;

@property (strong, nonatomic) id<MySceneDelegate> delegate;

@end