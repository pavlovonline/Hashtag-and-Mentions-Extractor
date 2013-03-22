//
//  Extractor.h
//  Hashtag and Metnions Extractor
//
//  Created by Anton Pavlov on 3/22/13.
//  Copyright (c) 2013 Anton Pavlov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ExtractorDelegate <NSObject>

@property (nonatomic, strong) NSArray *hashtagArray;
@property (nonatomic, strong) NSArray *mentionsArray;

@end

@interface Extractor : NSObject

@property (nonatomic, strong) NSArray *hashtags;
@property (nonatomic, strong) NSArray *mentions;

-(void)extractHashtags:(NSString *)input;

-(void)extractMentions:(NSString *)input;

//delegate
@property (nonatomic, weak) id <ExtractorDelegate> delegate;

@end
