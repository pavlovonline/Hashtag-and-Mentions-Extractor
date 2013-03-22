//
//  Extractor.m
//  Hashtag and Metnions Extractor
//
//  Created by Anton Pavlov on 3/22/13.
//  Copyright (c) 2013 Anton Pavlov. All rights reserved.
//

#import "Extractor.h"

@implementation Extractor
@synthesize hashtags=_hashtags;
@synthesize mentions=_mentions;
@synthesize delegate=_delegate;

-(void)extractHashtags:(NSString *)input
{
    NSString *contains=@"#";
    NSCharacterSet *characterSet=[NSCharacterSet characterSetWithCharactersInString:contains];
    if ([input rangeOfCharacterFromSet:characterSet].location!=NSNotFound)
    {
        //this means we have a hashtag
        dispatch_queue_t hashtags=dispatch_queue_create("hastags", NULL);
        dispatch_async(hashtags, ^{
            
            NSString *foundString;
            __block NSMutableSet *foundTags=[NSMutableSet set];
            __block NSMutableArray *foundTagsWithoutHashes=[NSMutableArray array];
            NSScanner *scanner=[NSScanner scannerWithString:input];
            
            while (![scanner isAtEnd]) {
                [scanner scanUpToCharactersFromSet:characterSet intoString:nil];
                [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&foundString];
                
                foundString=[foundString lowercaseString];
                
                NSLog(@"found string %@", foundString);
                NSLog(@"found string %@", foundTags);
                
                //now need to double check if user forgot to enter space between tags
                
                NSRegularExpression *expression=[NSRegularExpression regularExpressionWithPattern:contains options:NSRegularExpressionCaseInsensitive error:nil];
                NSUInteger matches=[expression numberOfMatchesInString:foundString options:0 range:NSMakeRange(0, [foundString length])];
                if (matches>1)
                {
                    //means user forgot to put in a space between tags, must do it manually
                    NSScanner *secondScanner=[NSScanner scannerWithString:foundString];
                    __block NSMutableString *anotherString=[[NSMutableString alloc]init];
                    
                    while (![secondScanner isAtEnd]) {
                        [secondScanner scanUpToCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:nil];
                        [secondScanner scanUpToString:@"#" intoString:&anotherString];
                        NSLog(@"another string %@", anotherString);
                        [foundTagsWithoutHashes addObject:anotherString];
                        
                        
                    }//second scanner is at end
                    
                    //need to add back hashes and add to original array
                    
                    for (int i=0; i<[foundTagsWithoutHashes count]; i++)
                    {
                        NSMutableString *corrected=[[foundTagsWithoutHashes objectAtIndex:i]mutableCopy];
                        [corrected insertString:@"#" atIndex:0];
                        [foundTags addObject:corrected];
                    }
                    
                }//matches over 1 over
                else{
                    [foundTags addObject:foundString];
                }
            }//scanner is at end
            
            NSArray *foundTagsArray=[foundTags allObjects];
            NSMutableArray *newTagsArray=[NSMutableArray array];
            
            NSCharacterSet *comaSet=[NSCharacterSet characterSetWithCharactersInString:@","];
            NSCharacterSet *dotSet=[NSCharacterSet characterSetWithCharactersInString:@"."];
            NSCharacterSet *exclSet=[NSCharacterSet characterSetWithCharactersInString:@"!"];
            NSCharacterSet *qSet=[NSCharacterSet characterSetWithCharactersInString:@"?"];
            //remove dots and comas
            for (int i=0; i<foundTagsArray.count; i++)
            {
                NSString *string=[foundTagsArray objectAtIndex:i];
                
                if ([string rangeOfCharacterFromSet:comaSet].location!=NSNotFound)
                {
                    string=[string stringByReplacingOccurrencesOfString:@"," withString:@""];
                }
                
                if ([string rangeOfCharacterFromSet:dotSet].location!=NSNotFound)
                {
                    string=[string stringByReplacingOccurrencesOfString:@"." withString:@""];
                }
                
                if ([string rangeOfCharacterFromSet:exclSet].location!=NSNotFound)
                {
                    string=[string stringByReplacingOccurrencesOfString:@"!" withString:@""];
                }
                
                if ([string rangeOfCharacterFromSet:qSet].location!=NSNotFound)
                {
                    string=[string stringByReplacingOccurrencesOfString:@"?" withString:@""];
                }
                
                [newTagsArray addObject:string];
            }
            [self.delegate setHashtagArray:[newTagsArray copy]];
            //if you choose not to use the delegate method, at this point the array is ready, just set it up and perfrom your own methods on it.
        });
    }//entered text contains #
    else
    {
        //do nothing
    }
}

-(void)extractMentions:(NSString *)input
{
    NSString *containsMention=@"@";
    NSCharacterSet *characterSetMention=[NSCharacterSet characterSetWithCharactersInString:containsMention];
    if ([input rangeOfCharacterFromSet:characterSetMention].location!=NSNotFound)
    {
        //this means we have a mention
        dispatch_queue_t mentions=dispatch_queue_create("mentions", NULL);
        dispatch_async(mentions, ^{
            
            
            
            NSString *foundString;
            __block NSMutableArray *foundMentions=[NSMutableArray array];
            NSScanner *scanner=[NSScanner scannerWithString:input];
            
            while (![scanner isAtEnd]) {
                [scanner scanUpToCharactersFromSet:characterSetMention intoString:nil];
                [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:&foundString];
                
                NSLog(@"found string %@", foundString);
                NSLog(@"found string array %@", foundMentions);
                
                //now need to double check if user forgot to enter space between mentions
                
                NSRegularExpression *expression=[NSRegularExpression regularExpressionWithPattern:containsMention options:NSRegularExpressionCaseInsensitive error:nil];
                NSUInteger matches=[expression numberOfMatchesInString:foundString options:0 range:NSMakeRange(0, [foundString length])];
                if (matches>1)
                {
                    //means user forgot to put in a space between tags, must do it manually
                    NSScanner *secondScanner=[NSScanner scannerWithString:foundString];
                    __block NSMutableString *anotherString=[[NSMutableString alloc]init];
                    
                    while (![secondScanner isAtEnd]) {
                        [secondScanner scanUpToCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:nil];
                        [secondScanner scanUpToString:@"@" intoString:&anotherString];
                        NSLog(@"another string %@", anotherString);
                        [foundMentions addObject:anotherString];
                        
                        
                    }//second scanner is at end
  
                }//matches over 1 over
                else{
                    [foundMentions addObject:foundString];
                }
            }//scanner is at end
            
            //now we have our mentions properly separated, ready to create objects
            
            NSCharacterSet *comaSet=[NSCharacterSet characterSetWithCharactersInString:@","];
            NSCharacterSet *dotSet=[NSCharacterSet characterSetWithCharactersInString:@"."];
            NSCharacterSet *exclSet=[NSCharacterSet characterSetWithCharactersInString:@"!"];
            NSCharacterSet *qSet=[NSCharacterSet characterSetWithCharactersInString:@"?"];

            //do some more maintenance on the mentions (if there are still any @left)
            NSMutableSet *tempSet=[NSMutableSet set];
            for (int i=0; i<[foundMentions count]; i++)
            {
                NSString *string=[foundMentions objectAtIndex:i];
                
                if ([string rangeOfCharacterFromSet:comaSet].location!=NSNotFound)
                {
                    string=[string stringByReplacingOccurrencesOfString:@"," withString:@""];
                }
                
                if ([string rangeOfCharacterFromSet:dotSet].location!=NSNotFound)
                {
                    string=[string stringByReplacingOccurrencesOfString:@"." withString:@""];
                }
                
                if ([string rangeOfCharacterFromSet:exclSet].location!=NSNotFound)
                {
                    string=[string stringByReplacingOccurrencesOfString:@"!" withString:@""];
                }
                
                if ([string rangeOfCharacterFromSet:qSet].location!=NSNotFound)
                {
                    string=[string stringByReplacingOccurrencesOfString:@"?" withString:@""];
                }
                
                if ([string rangeOfCharacterFromSet:characterSetMention].location!=NSNotFound)
                {
                    NSString *replacement=[string stringByReplacingOccurrencesOfString:@"@" withString:@""];
                    [tempSet addObject:replacement];
                }
                else
                {
                    [tempSet addObject:string];
                }
            }
            
            [self.delegate setMentionsArray:[NSArray arrayWithArray:[tempSet allObjects]]];
            //if you choose not to use the delegate method, at this point the array is ready, just set it up and perfrom your own methods on it.
            
            });
    }//entered text contains @

}

@end
