//
//  MMSCGameManager.m
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/2/11.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCGameManager.h"
#import "MMSCGame.h"
#import "MMSCPlayer.h"

@interface MMSCGameManager ()

@property (nonatomic, strong) MMSCGame *game;

@end

@implementation MMSCGameManager

+ (MMSCGameManager *)instance {
    static MMSCGameManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MMSCGameManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _game = [[MMSCGame alloc] init];
    }
    
    return self;
}

- (void)initGameWithPlayers:(NSArray *)playerNames {
    
}

- (NSArray *)randomSeatWithPlayers:(NSArray *)playerNames {
    NSMutableArray *players = [NSMutableArray array];
    
    for (NSString *playerName in playerNames) {
        MMSCPlayer *player = [[MMSCPlayer alloc] initWithName:playerName];
        [players addObject:player];
    }
    
    self.game.players = [players copy];
    [self.game randomSeat];
    
    NSMutableArray *randomPlayerNames = [NSMutableArray array];
    for (MMSCPlayer *player in self.game.players) {
        [randomPlayerNames addObject:player.name];
    }
    
    return [randomPlayerNames copy];
}

- (NSInteger)roundCount {
    return self.game.rounds.count;
}

@end
