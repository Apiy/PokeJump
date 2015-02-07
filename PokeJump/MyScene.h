//
//  MyScene.h
//  PokeJump
//

//  Copyright (c) 2014 Apiy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(int, GameState) {
    GameStateMainMenu,
    GameStateMainMenuS,
    GameStateMyPokemon,
    GameStatePokeCard1,
    GameStatePokeCard2,
    GameStatePokeCard3,
    GameStatePokeCard4,
    GameStatePokeCard5,
    GameStatePokeCard6,
    GameStatePokeCard7,
    GameStatePokeCard8,
    GameStatePokeCard9,
    GameStatePokeCard10,
    GameStatePokeCard11,
    GameStatePokeCard12,
    GameStatePokeCard13,
    GameStatePokeCard14,
    GameStatePokeCard15,
    GameStatePokeCard16,
    GameStatePokeCard17,
    GameStatePokeCard18,
    GameStatePokeCard19,
    GameStatePokeCard20,
    GameStatePokeCard21,
    GameStatePokeCard22,
    GameStatePokeCard23,
    GameStatePokeCard24,
    GameStatePokeCard25,
    GameStatePokeCard26,
    GameStateTutorial,
    GameStateTutorialR,
    GameStateTutorialJR,
    GameStateLockedJohto,
    GameStateReviveHey,
    GameStateZeroRevives,
    GameStateZeroRevivesJ,
    GameStatePlay,
    GameStatePlayR,
    GameStatePlayJR,
    GameStatePlayJ,
    GameStateFalling,
    GameStateFallingJ,
    GameStateFallingJR,
    GameStateFallingR,
    GameStateShowingScore,
    GameStateShowingScoreJ,
    GameStateShowingScoreJR,
    GameStateShowingScoreR,
    GameStateGameOver,
    GameStateGameOverR,
    GameStateGameOverJ, 
    GameStateGameOverJR
};

@protocol MySceneDelegate
- (UIImage *)screenshot;
- (void)shareString:(NSString *)string url:(NSURL*)url image:(UIImage *)image;

@end

@interface MyScene : SKScene

-(id)initWithSize:(CGSize)size delegate:(id<MySceneDelegate>)delegate state:(GameState) state;

@property (strong, nonatomic) id<MySceneDelegate> delegate;

@end
