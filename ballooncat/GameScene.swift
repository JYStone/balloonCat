//
//  GameScene.swift
//  ballooncat
//
//  Created by Alfred on 14-8-28.
//  Copyright (c) 2014年 HackSpace. All rights reserved.
//

import SpriteKit

class GameScene: SKScene ,SKPhysicsContactDelegate{
    
    var catTexture:SKTexture!
    var catLeftTexture:SKTexture!
    var catRightTexture:SKTexture!
    
    var cloudTexture:SKTexture!
    var groundTexture:SKTexture!
    var grassTexture:SKTexture!
    var cloudyBgTexture:SKTexture!
    var sunBgTexture:SKTexture!
    var mountainTexture:SKTexture!
    var gameOverTexture:SKTexture!
    
    var cat:SKSpriteNode!
    var cloud:SKSpriteNode!
    var ground:SKSpriteNode!
    var grass:SKSpriteNode!
    var cloudyBg:SKSpriteNode!
    var mountain:SKSpriteNode!
    
    var sunBg1:SKSpriteNode!
    var sunBg2:SKSpriteNode!
    var sunBg3:SKSpriteNode!
    
    var backGroundScene:SKNode!
    var levelGroup:SKNode!
    
    var score:Int = 0
    var scoreLabel:SKLabelNode!
    
    var catCategory:UInt32 = 1<<1
    var worldCategory:UInt32 = 1<<2
    var cloudyCategory:UInt32 = 1<<3
    var scoreCategory:UInt32 = 1<<4
    
    var flyLeft:CGFloat = 1.0
    
    var userDefault = NSUserDefaults.standardUserDefaults()
    var touchSound = SKAction.playSoundFileNamed("touch.mp3", waitForCompletion: false)
    var bonusSound = SKAction.playSoundFileNamed("bonus.mp3", waitForCompletion: false)
    
    
    override init(size:CGSize){
        super.init(size: size)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        catTexture = SKTexture(imageNamed: "cat")
        catLeftTexture = SKTexture(imageNamed: "catleft")
        catRightTexture = SKTexture(imageNamed: "catright")
        
        cloudTexture = SKTexture(imageNamed: "cloud")
        groundTexture = SKTexture(imageNamed: "ground")
        grassTexture = SKTexture(imageNamed: "grass")
        cloudyBgTexture = SKTexture(imageNamed: "cloudybg")
        sunBgTexture = SKTexture(imageNamed: "sunbg")
        mountainTexture = SKTexture(imageNamed: "mountain")
        gameOverTexture = SKTexture(imageNamed: "gameover")
        
        cat = SKSpriteNode(texture: catTexture)
        ground = SKSpriteNode(texture: groundTexture)
        grass = SKSpriteNode(texture: grassTexture)
        cloudyBg = SKSpriteNode(texture: cloudyBgTexture)
        mountain = SKSpriteNode(texture: mountainTexture)
        
        sunBg1 = SKSpriteNode(texture: sunBgTexture)
        sunBg2 = SKSpriteNode(texture: sunBgTexture)
        sunBg3 = SKSpriteNode(texture: sunBgTexture)
        
        sunBg1.position = CGPointMake(0, ground.size.height + sunBg1.size.height * 0.5)
        sunBg1.zPosition = 3
        sunBg2.position = CGPointMake(0, sunBg1.position.y + sunBg2.size.height - 2)
        sunBg2.zPosition = 3
        sunBg3.position = CGPointMake(0, sunBg2.position.y + sunBg3.size.height - 2)
        sunBg3.zPosition = 3
        
        
        ground.position = CGPointMake(0, ground.size.height * 0.5)
        ground.zPosition = 4
        
        mountain.position = CGPointMake(0, ground.size.height + mountain.size.height * 0.5)
        mountain.zPosition = 4
        
        grass.position = CGPointMake(0, ground.size.height + grass.size.height * 0.5)
        grass.zPosition = 6
        
        var worldEdge = SKNode()
        worldEdge.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(0, -200, 320, 568))
        worldEdge.physicsBody?.categoryBitMask = worldCategory
        worldEdge.physicsBody?.contactTestBitMask = catCategory
        worldEdge.physicsBody?.collisionBitMask = catCategory
        
        backGroundScene = SKNode()
        backGroundScene.position.x = self.frame.width * 0.5
        backGroundScene.addChild(sunBg1)
        backGroundScene.addChild(sunBg2)
        backGroundScene.addChild(sunBg3)
        backGroundScene.addChild(ground)
        backGroundScene.addChild(mountain)
        backGroundScene.addChild(grass)
//        backGroundScene.addChild(physicsGround)
        self.addChild(worldEdge)
        
        self.addChild(backGroundScene)
        
        cat.position = CGPointMake(ground.size.width * 0.5, ground.size.height + cat.size.height * 0.5)
        cat.zPosition = 5
        cat.physicsBody = SKPhysicsBody(circleOfRadius: cat.size.width * 0.5, center: CGPointMake(0, 15))
        cat.physicsBody?.categoryBitMask = catCategory
        cat.physicsBody?.contactTestBitMask = cloudyCategory
        cat.physicsBody?.collisionBitMask = cloudyCategory
        cat.physicsBody?.dynamic = true
//        cat.physicsBody.affectedByGravity = false
        self.addChild(cat)
        
        levelGroup = SKNode()
        self.addChild(levelGroup)
        
        levelGroup.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.waitForDuration(1.8),SKAction.runBlock({
            var level = SKNode()
            level.zPosition = 7
            
            var randX = CGFloat(rand() % 160) - 80
            
            var leftCloud = SKSpriteNode(texture: self.cloudTexture)
            leftCloud.position = CGPointMake(-125, 0)
            leftCloud.physicsBody = SKPhysicsBody(rectangleOfSize: leftCloud.size)
            leftCloud.physicsBody?.categoryBitMask = self.cloudyCategory
            leftCloud.physicsBody?.contactTestBitMask = self.catCategory
            leftCloud.physicsBody?.collisionBitMask = self.catCategory
            leftCloud.physicsBody?.dynamic = false
            
            var rightCloud = SKSpriteNode(texture: self.cloudTexture)
            rightCloud.position = CGPointMake(125, 0)
            rightCloud.physicsBody = SKPhysicsBody(rectangleOfSize: rightCloud.size)
            rightCloud.physicsBody?.categoryBitMask = self.cloudyCategory
            rightCloud.physicsBody?.contactTestBitMask = self.catCategory
            rightCloud.physicsBody?.collisionBitMask = self.catCategory
            rightCloud.physicsBody?.dynamic = false
            
            var scoreField = SKNode()
            scoreField.position = CGPointMake(0, 0)
            scoreField.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(30, 1))
            scoreField.physicsBody?.categoryBitMask = self.scoreCategory
            scoreField.physicsBody?.contactTestBitMask = self.catCategory
            scoreField.physicsBody?.collisionBitMask = self.catCategory
            scoreField.physicsBody?.dynamic = false
            
            level.addChild(leftCloud)
            level.addChild(rightCloud)
            level.addChild(scoreField)
            self.levelGroup.addChild(level)
            
            level.position = CGPointMake(self.frame.width * 0.5 + randX, self.frame.height + leftCloud.size.height)
            level.runAction(SKAction.sequence([SKAction.moveToY(-leftCloud.size.height, duration: 5),SKAction.removeFromParent()]))

            
        })])))
        
        scoreLabel = SKLabelNode()
        scoreLabel.text = "\(score)"
        scoreLabel.zPosition = 10
        scoreLabel.position = CGPointMake(self.frame.width * 0.5, self.frame.height * 0.7)
        scoreLabel.fontName = getFont().fontName
        scoreLabel.fontColor = SKColor.blackColor()
        self.addChild(scoreLabel)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        self.physicsWorld.gravity = CGVectorMake(2.5 * flyLeft,0)
        self.runAction(touchSound)
        flyLeft = -flyLeft
        if flyLeft == 1 {
            cat.texture = catLeftTexture
        }else{
            cat.texture = catRightTexture
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        sunBg1.position.y -= 2
        sunBg2.position.y -= 2
        sunBg3.position.y -= 2
        
        if sunBg1.position.y < -sunBg1.size.height * 0.5{
            sunBg1.position.y = sunBg3.position.y + sunBg1.size.height - 2
        }
        
        if sunBg2.position.y < -sunBg2.size.height * 0.5{
            sunBg2.position.y = sunBg1.position.y + sunBg2.size.height - 2
        }
        
        if sunBg3.position.y < -sunBg3.size.height * 0.5{
            sunBg3.position.y = sunBg2.position.y + sunBg3.size.height - 2
        }
        
        if ground.position.y < -200{
            ground.removeFromParent()
        }else{
            ground.position.y -= 2
        }
        
        if grass.position.y < -200{
            grass.removeFromParent()
        }else{
            grass.position.y -= 2
        }
        
        if mountain.position.y < -200{
            mountain.removeFromParent()
        }else{
            mountain.position.y -= 2
        }
        
        /* Called before each frame is rendered */
    }
    
    
    func didBeginContact(contact: SKPhysicsContact!) {
        if contact.bodyA.categoryBitMask == cloudyCategory || contact.bodyB.categoryBitMask == cloudyCategory || contact.bodyA.categoryBitMask == worldCategory || contact.bodyB.categoryBitMask == worldCategory{
            self.view?.paused = true
            scoreLabel.hidden = true
            
            userDefault.setInteger(score, forKey: "total")
            
            var bestScore = userDefault.integerForKey("best")
            if score > bestScore{
                userDefault.setInteger(score, forKey: "best")
            }
            
            userDefault.synchronize()
            
            NSNotificationCenter.defaultCenter().postNotificationName("gameOverNotification", object: nil)
         
        }else if contact.bodyA.categoryBitMask == scoreCategory || contact.bodyB.categoryBitMask == scoreCategory{
            score++
            scoreLabel.text = "\(score)"
            self.runAction(bonusSound)
        }
    }
    
    func getFont()->UIFont{
        var hiloginbold = UIFont(name: "HILOGINBOLD", size: 28)
        
        return hiloginbold!
    }

    
    
}
