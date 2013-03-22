//
//  ViewController.h
//  Hashtag and Metnions Extractor
//
//  Created by Anton Pavlov on 3/22/13.
//  Copyright (c) 2013 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Extractor.h"

@interface ViewController : UIViewController <ExtractorDelegate>
@property (weak, nonatomic) IBOutlet UITextView *input;
@property (weak, nonatomic) IBOutlet UITextView *outputHashtagView;
@property (weak, nonatomic) IBOutlet UITextView *outputMentionsView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


@end
