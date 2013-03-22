HASHTAG + MENTIONS Extractor

You can use this code to extract #hashtags or @mentions from a given NSString.

The extractor takes in a string, runs though it and outputs an array of individual hashtags (prefixed with #) and an array of mentions (no prefixes). If you don't want the "#" left in, edit the extractor.m inside the dispatch.

The extractor removes common punctuation (commas, periods, question marks, and exclamation marks). 

The extractor also handles no spaces between the tags or mentions. Check sample project

To get started, copy the Extractor.h and .m

You have a couple ways of getting the arrays: first off, you can get them from the actual extractor.m. I have added a comment where the arrays are ready. You can perform methods on them from then on.

Or you can declare yourself as the ExtractorDelegate and synthesize hashtagArray and mentionsArray.

Do be aware that the code runs on a separate thread, so when you set yourself as the delegate, it takes a second for the code to run through the string and get the arrays ready. This is why you'll see the selector bering performed after the delay in the sample project. If you need the arrays immediately as they are ready, just import the methods from extractor.m and go at it.

