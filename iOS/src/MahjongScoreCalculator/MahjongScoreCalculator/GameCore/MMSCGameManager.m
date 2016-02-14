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
#import "MMSCTsuMoResult.h"
#import "MMSCTwoWinnerResult.h"
#import "MMSCNormalWinResult.h"
#import "MMSCDrawManganResult.h"

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

- (NSInteger)currentRichiCount {
    NSInteger currentRichiScore = [self.game currentRound].richiScore;
    return currentRichiScore / 1000;
}

- (void)tsumoAtPlayer:(NSUInteger)playerIndex fan:(NSInteger)fan fu:(NSInteger)fu {
    
    MMSCTsuMoResult *tsumoResult = [[MMSCTsuMoResult alloc] init];
    tsumoResult.winnerIndex = playerIndex;
    tsumoResult.fan = fan;
    tsumoResult.fu  = fu;
    
    [self.game endCurrentRoundWithResult:tsumoResult];
}

- (void)ronAtPlayers:(NSArray *)winners loser:(NSUInteger)loserIndex fan:(NSArray *)fan fu:(NSArray *)fu {
    MMSCRoundResult *result = nil;
    if (winners.count > 1) {
        MMSCTwoWinnerResult *twoWinResult = [[MMSCTwoWinnerResult alloc] init];
        twoWinResult.winner1Index = [winners[0] unsignedIntegerValue];
        twoWinResult.winner2Index = [winners[1] unsignedIntegerValue];
        
        twoWinResult.fanOfWiiner1 = [fan[0] integerValue];
        twoWinResult.fanOfWinner2 = [fan[1] integerValue];
        
        twoWinResult.fuOfWinner1 = [fu[0] integerValue];
        twoWinResult.fuOfWinner2 = [fu[1] integerValue];
        
        twoWinResult.payerIndex = loserIndex;
        result = twoWinResult;
    } else {
        MMSCNormalWinResult *normalResult = [[MMSCNormalWinResult alloc] init];
        normalResult.winnerIndex = [winners[0] unsignedIntegerValue];
        normalResult.fan = [fan[0] integerValue];
        normalResult.fu = [fu[0] integerValue];
        
        normalResult.payerIndex = loserIndex;
        result= normalResult;
    }
    
    [self.game endCurrentRoundWithResult:result];
}

- (void)drawForType:(NSInteger)type players:(NSArray *)players oyaTenpai:(BOOL)oyaTenpai {
    MMSCRoundResult *result = nil;
    if (type == MMSCDrawType_DrawMangan) {
        MMSCDrawManganResult *drawMangan = [[MMSCDrawManganResult alloc] init];
        drawMangan.type = type;
        drawMangan.manganPlayerIndexes = players;
        drawMangan.oyaTenpai = oyaTenpai;
        result = drawMangan;
    } else {
        MMSCDrawResult *drawResult = [[MMSCDrawResult alloc] init];
        drawResult.type = type;
        drawResult.tenpaiPlayerIndexes = players;
        result = drawResult;
    }
    
    [self.game endCurrentRoundWithResult:result];
}

- (BOOL)isGameEnded {
    return [self.game isGameEnded];
}

- (NSArray *)sortedPlayers {
    NSArray *sortedPlayers = [self.game playerRank];
    
    NSMutableArray *playerNames = [NSMutableArray array];
    for (MMSCPlayer *player in sortedPlayers) {
        [playerNames addObject:player.name];
    }
    
    return [playerNames copy];
}

@end
