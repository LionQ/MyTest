//
//  HelloWorldLayer.m
//  Cocos2DSimpleGame
//
//  Created by Constance Yang on 12-10-16.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void) spriteMoveFinished:(id) sender
{
    CCSprite *sprite =  (CCSprite *) sender;
    [self removeChild:sprite cleanup:YES];
}
-(void)addTarget
{

    CCSprite * target = [CCSprite spriteWithFile:@"Target.png" rect:CGRectMake(0, 0, 27, 40)];
    //determine where to spawn the target along the Y axis.
    CGSize size =[[CCDirector sharedDirector]winSize];
    int minY = target.contentSize.height/2;
    int maxY = size.height -target.contentSize.height/2;
    int actualY = (arc4random()%(maxY-minY))+minY;
    
    //create the target slightly off-screen along the right edge. and along a //random position along the y axis as calculated above.
    target.position = ccp(size.width+(target.contentSize.width/2),actualY);
    [self addChild:target];
    
    //Determine the speed of the target.
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int actualDuration = (arc4random()%(maxDuration -minDuration))+minDuration;
    
    //Create the action
    id actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(-target.contentSize.width/2,actualY)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
    [target runAction:[CCSequence actions:actionMove,actionMoveDone,nil]];
    
}
-(void) gameLogic:(ccTime)dt
{
    [self addTarget];
}

// on "init" you need to initialize your instance
-(id) init
{
    if (self=[super initWithColor:ccc4(255, 255, 255, 255)])
    {
        CGSize size =[[CCDirector sharedDirector]winSize];
        CCSprite *player = [CCSprite spriteWithFile:@"Player.png" rect:CGRectMake(0, 0, 27, 40)];
        player.position = ccp(player.contentSize.width/2, size.height/2);
        [self addChild:player];
        //call gameLogic about every second.
        [self schedule:@selector(gameLogic:) interval:1.0];
    }
    return self;
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
