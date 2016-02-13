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
    self.game.players = [self createPlayersWithNames:playerNames];
    
    [self.game gameInit];
}

- (NSArray *)randomSeatWithPlayers:(NSArray *)playerNames {
    
    self.game.players = [self createPlayersWithNames:playerNames];
    [self.game randomSeat];
    
    return [self playerNames];
}

- (NSArray *)createPlayersWithNames:(NSArray *)playerNames {
    NSMutableArray *players = [NSMutableArray array];
    
    for (NSString *playerName in playerNames) {
        MMSCPlayer *player = [[MMSCPlayer alloc] initWithName:playerName];
        [players addObject:player];
    }
    
    return [players copy];
}

- (NSInteger)roundCount {
    return self.game.rounds.count;
}

- (NSString *)currentRoundName {
    MMSCRound *currentRound = [self.game currentRound];
    return [currentRound roundName];
}

- (NSString *)currentOYAName {
    MMSCPlayer *oya = [self.game getOYA];
    return oya.name;
}

- (NSUInteger)currentOYAIndex {
    return self.game.oyaIndex;
}

- (NSArray *)playerNames {
    NSMutableArray *playerNames = [NSMutableArray array];
    for (MMSCPlayer *player in self.game.players) {
        [playerNames addObject:player.name];
    }
    
    return [playerNames copy];
}

- (NSArray *)currentPlayerWinds {
    NSMutableArray *playerWinds = [NSMutableArray array];
    for (MMSCPlayer *player in self.game.players) {
        [playerWinds addObject:[self convertWindEnumToCharacter:player.wind]];
    }
    
    return playerWinds;
}

- (NSArray *)currentPlayerScores {
    NSMutableArray *playerScores = [NSMutableArray array];
    for (MMSCPlayer *player in self.game.players) {
        [playerScores addObject:@(player.score)];
    }
    
    return playerScores;
}

- (NSString *)convertWindEnumToCharacter:(MMSCWind)wind {
    switch (wind) {
        case MMSCWindEast:
            return @"東";
        case MMSCWindSouth:
            return @"南";
        case MMSCWindWest:
            return @"西";
        case MMSCWindNorth:
            return @"北";
    }
}

- (NSString *)roundNameAtIndex:(NSUInteger)index {
    NSAssert(index < self.game.rounds.count, @"round index out of bound");
    
    MMSCRound *round = self.game.rounds[index];
    return round.roundName;
}

- (NSArray *)roundScoreChangesAtIndex:(NSUInteger)index {
    NSAssert(index < self.game.rounds.count, @"round index out of bound");
    
    MMSCRound *round = self.game.rounds[index];
    return [round roundScoreChanges];
}

- (NSArray *)currentRoundScoreChanges {
    MMSCRound *round = [self.game currentRound];
    return [round roundScoreChanges];
}

- (NSArray *)currentRichiPlayers {
    MMSCRound *currentRound = [self.game currentRound];
    return currentRound.richiPlayerIndexes;
}

- (void)richiAtPlayers:(NSArray *)richiPlayerIndexes {
    NSMutableArray *currentRichiPlayers = [[self currentRichiPlayers] mutableCopy];
    for (NSNumber *playerIndex in richiPlayerIndexes) {
        if ([currentRichiPlayers containsObject:playerIndex]) { // 之前已经立直过了
            [currentRichiPlayers removeObject:playerIndex];
        } else {
            [self.game richiAtPlayerIndex:playerIndex.unsignedIntegerValue];
        }
    }
    
    if (currentRichiPlayers.count > 0) { // 有取消的情况发生
        for (NSNumber *playerIndex in currentRichiPlayers) {
            [self.game cancelRichiAtPlayerIndex:playerIndex.unsignedIntegerValue];
        }
    }
}

@end
