//
//  DRPAboutBackgroundView.m
//  DR Player
//
//  Created by Richard on 09/01/14.
//
//

#import "DRPAboutBackgroundView.h"

@interface DRPAboutBackgroundView ()
@property (nonatomic, strong) SKScene *mainScene;
@end

@implementation DRPAboutBackgroundView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self)
    {
        [self setupScene];
    }
    return self;
}

- (void)setupScene
{
    self.mainScene = [SKScene sceneWithSize:self.frame.size];
    self.mainScene.backgroundColor = [NSColor whiteColor];
    self.mainScene.scaleMode = SKSceneScaleModeAspectFill;
    self.mainScene.anchorPoint = CGPointMake(0.5f, 0.5f);
    
    NSString *emitterNodePath = [[NSBundle mainBundle] pathForResource:@"particle1" ofType:@"sks"];
    self.emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterNodePath];
    
    self.emitterNode.particleColorSequence = [[SKKeyframeSequence alloc] initWithKeyframeValues:@[[SKColor lightGrayColor], [SKColor clearColor]] times:@[@0.0f, @0.8f]];
    
    [self.mainScene addChild:self.emitterNode];
    
//    NSImage *logoImage = [NSImage imageNamed:@"AppIcon"];
//    CGFloat scale = self.window.screen.backingScaleFactor;
//    
//    logoImage.size = CGSizeMake(256.0f*scale, 256.0f*scale);
//    
//    SKTexture *logoTexture = [SKTexture textureWithImage:logoImage];
//    SKSpriteNode *logoNode = [[SKSpriteNode alloc] initWithTexture:logoTexture];
//    logoNode.position = CGPointMake(-self.bounds.size.width/2 + logoNode.frame.size.width/2 + 20.0f, 0.0f);
//    [self.mainScene addChild:logoNode];
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    
    SKLabelNode *appNameLabelNode = [SKLabelNode labelNodeWithFontNamed:@"LucidaGrande-Bold"];
    appNameLabelNode.fontColor = [SKColor blackColor];
    appNameLabelNode.fontSize = 25.0f;
    appNameLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    appNameLabelNode.position = CGPointMake(0.0f, 60.0f);
    appNameLabelNode.text = infoPlist[@"CFBundleName"];
    
    [self.mainScene addChild:appNameLabelNode];
    
    SKLabelNode *aboutVersionLabelNode = [SKLabelNode labelNodeWithFontNamed:@"LucidaGrande-Bold"];
    aboutVersionLabelNode.fontColor = [SKColor blackColor];
    aboutVersionLabelNode.fontSize = 14.0f;
    aboutVersionLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    aboutVersionLabelNode.position = CGPointMake(0.0f, 20.0f);
    aboutVersionLabelNode.text = [NSString localizedStringWithFormat:@"Version %@ (v%@)", infoPlist[@"CFBundleShortVersionString"], infoPlist[@"CFBundleVersion"]];
    
    [self.mainScene addChild:aboutVersionLabelNode];
    
    NSString *copyrightString = NSLocalizedStringFromTable(@"NSHumanReadableCopyright", @"InfoPlist", @"");
    NSArray *copyrightStringComponents = [copyrightString componentsSeparatedByString:@"\n"];
    
    [copyrightStringComponents enumerateObjectsUsingBlock:^(NSString *copyrightStringComponent, NSUInteger idx, BOOL *stop) {
        
        SKLabelNode *aboutCopyrightLabelNode = [SKLabelNode labelNodeWithFontNamed:@"LucidaGrande"];
        aboutCopyrightLabelNode.fontColor = [SKColor blackColor];
        aboutCopyrightLabelNode.fontSize = 14.0f;
        aboutCopyrightLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        aboutCopyrightLabelNode.position = CGPointMake(0.0f, -20.0f * idx+1);
        aboutCopyrightLabelNode.text = copyrightStringComponent;
        [self.mainScene addChild:aboutCopyrightLabelNode];
        
    }];
}

- (void)awakeFromNib
{
    [self presentScene:self.mainScene];
}

@end
