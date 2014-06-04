//
//  EnemyDataEntity.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/03.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "EnemyDataEntity.h"

@implementation EnemyDataEntity
@synthesize type;
@synthesize x;
@synthesize y;
@synthesize life;
@synthesize attackInterval;
@synthesize personality;

@synthesize moveCounter;
@synthesize attackCounter;
@synthesize dropFuel;

@synthesize doppel;
@synthesize random;

@synthesize poison;
@synthesize poisonCounter;
@synthesize bindCounter;
@synthesize defaultSpeed;


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        type = [aDecoder decodeIntegerForKey:@"type"];
        x = [aDecoder decodeIntegerForKey:@"x"];
        y = [aDecoder decodeIntegerForKey:@"y"];
        life = [aDecoder decodeIntegerForKey:@"life"];
        attackInterval = [aDecoder decodeIntegerForKey:@"attackInterval"];
        personality = [aDecoder decodeIntegerForKey:@"personality"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:type forKey:@"type"];
    [aCoder encodeInteger:x forKey:@"x"];
    [aCoder encodeInteger:y forKey:@"y"];
    [aCoder encodeInteger:life forKey:@"life"];
    [aCoder encodeInteger:attackInterval forKey:@"attackInterval"];
    [aCoder encodeInteger:personality forKey:@"personality"];
}

@end
