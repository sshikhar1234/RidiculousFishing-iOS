//
//  GameScene.swift
//  RidiculousFishing
//
//  Created by Shikhar Shah on 2019-10-19.
//  Copyright © 2019 Lambton. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var ctr: Int = 0
    private var hookFrame = 0
    private let SPEED:CGFloat = 450
    
    private var ship : SKSpriteNode!
    private var hook : SKSpriteNode!
    private var chain : SKSpriteNode!
    private var bg_occean : SKSpriteNode!
    private var sky : SKSpriteNode!
    private var lengthLabel : SKLabelNode!
    private var rotation: String = "right"
    
    private var hookLength: Int = 0
    private var hookDirection: String = "down"
//    private var fishes:[Fish]! = []
    private var depth: Int = 300
    
    //Flag to determine when the person starts game
    private var gameStart: Bool = false
   
    //Flag to determine when the person starts game
    private var collisionDetected: Bool = false

    //Array of spawned fishes
    private var randomFish:[SKSpriteNode]! = []

    //Array of caught fishes
    private var caughtFish:[SKSpriteNode]! = []

    //Array to keep track of rotation of all fishes
    private var rotations:[String]! = []
    let imageNames = ["fish0","fish1","fish3","fish2","fish2","jellyfish1","jellyfish2"]

    
    override func didMove(to view: SKView) {
        //1. Initialize the sprites
        self.ship = self.childNode(withName: "ship") as! SKSpriteNode
        self.hook = self.childNode(withName: "hook") as! SKSpriteNode
        self.chain = self.childNode(withName: "chain") as! SKSpriteNode
        self.bg_occean = self.childNode(withName: "bg_occean") as! SKSpriteNode
        self.sky = self.childNode(withName: "sky") as! SKSpriteNode
       
        
        
        self.lengthLabel = SKLabelNode(text: "\(self.hookLength)m")
        lengthLabel.horizontalAlignmentMode = .right
        lengthLabel.fontSize = 80
        lengthLabel.fontColor = UIColor.black
        lengthLabel.zPosition = 3
        lengthLabel.position = CGPoint(x: 400, y: 1200)
        addChild(lengthLabel)
        printScreenInfo()
        
    }
    
    func printScreenInfo(){
        print("Width: \(size.width)")
        print("Height: \(size.height)")
    }
    func spawnCreatures(){
        ctr = ctr + 1
        let random = Int.random(in: 0..<6)
        
        var randomFish = SKSpriteNode(imageNamed: imageNames[random])
            if(random%2 == 0){
                self.rotations.append("right")
                let randomXPosition = Int.random(in: 350..<600)
                randomFish.position.x = CGFloat(randomXPosition)
                randomFish.xScale = 2.5
                randomFish.yScale = 2.5
                randomFish.position.y = 0
            }
            else {
                self.rotations.append("left")
                let randomXPosition = Int.random(in: 0..<351)
                randomFish.position.x = CGFloat(randomXPosition)
                randomFish.xScale = 2.5
                randomFish.yScale = 2.5
                randomFish.position.y = 0
            }
            randomFish.zPosition = 10
            addChild(randomFish)

        self.randomFish.append(randomFish)
            
    }
    
    func touchDown(atPoint pos : CGPoint) {
    }
    func touchMoved(toPoint pos : CGPoint) {
    }
    func touchUp(atPoint pos : CGPoint) {
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let mouseTouch = touches.first
                if( mouseTouch == nil){
                    return
                }
        let loca = mouseTouch!.location(in: self)
        
        
        var slideAnimation = SKAction.moveBy(x: loca.x, y: self.chain.position.y, duration: 1)
        self.chain.position.x = loca.x
        self.hook.position.x = loca.x
        for (index,currentFish) in caughtFish.enumerated() {
            currentFish.position.x = loca.x
               }

        let nodeTouched = atPoint(loca).name
        if(nodeTouched == "ship"){
             gameStart = true
            //TODO: Animate the move effect when the player taps on Ship(GAME START)
            
            let moveUpAnimation: SKAction
            let moveDownAnimation: SKAction
            moveUpAnimation = SKAction.moveBy(x: 0, y: self.SPEED, duration: 1)
            
            //1. Move the sky up
            self.sky.run(moveUpAnimation)
            
            //2. Move the occean up
            self.bg_occean.run(moveUpAnimation)

            //3. Move the ship up
            self.ship.run(moveUpAnimation)

            //4. Move the hook down
            moveDownAnimation = SKAction.moveBy(x: 0, y: 400, duration: 1.5)
            self.chain.run(moveDownAnimation)
            self.hook.run(moveDownAnimation)

            //5. Time to spawn random fishes
            spawnCreatures()

        }
       
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        ctr = ctr + 17
        self.hookFrame = self.hookFrame + 17
        if(self.hookFrame%170 == 0 && gameStart && self.hookLength>=0){
                   self.hookLength = self.hookLength + 1
                   self.lengthLabel.text = "\(self.hookLength)/300m"
               }
        if(collisionDetected){
            moveDownFish()
            if(self.hookLength>0
                &&
                self.hookFrame%2 == 0){
                self.hookLength = self.hookLength - 1
                self.lengthLabel.text = "\(self.hookLength)/300m"

            }
        }
        else        {
            moveFish()

        }
        if(ctr % 50 == 0 && gameStart && self.hookDirection == "down"){
            spawnCreatures()
        }
       
        
    
// fish.image.transform = CGAffineTransformScale(fish.image.transform, -1, 1);
        for baitedFish in caughtFish {
            if(baitedFish.position.y > self.size.height/2)
            {
                var rotate = SKAction.rotate(byAngle: 180, duration: 5)
                
//                baitedFish.image.transform = CGAffineTransformScale(fish.image.transform, -1, 1);
                baitedFish.run(rotate)
//                baitedFish.image.transform = CGAffineTransformScale(fish.image.transform, -1, 1);

            }
        }

        //Check collision
        for (index,currentFish) in randomFish.enumerated() {
            if(self.hook.frame.intersects(currentFish.frame)){
                
                self.collisionDetected = true
              
                //Move the Sky down i.e take hook up
                let moveDownAnimation: SKAction
                moveDownAnimation = SKAction.moveBy(x: 0, y: -(self.size.height), duration: 3)
                var moveDowAnimation = SKAction.moveBy(x: 0, y: -40, duration: 1)
                if(self.hookDirection == "down"){
                    
                      self.hookDirection = "up"
                      //1. Move the sky down
                      self.sky.run(moveDownAnimation)
                                      
                      //2. Move the occean down
                      self.bg_occean.run(moveDownAnimation)
                    
                      //3. Move the ship down
                      self.ship.run(moveDownAnimation)
                    self.chain.run(moveDowAnimation)
//                    self.hook.run(moveDowAnimation)
                }
                currentFish.run(moveDowAnimation)

        
            self.caughtFish.append(currentFish)
            randomFish.remove(at: index)

                //Move fishes down
                moveDownFish()
                
        }
    }
    }
    
    
    func moveFish(){
        for (index,currentFish) in randomFish.enumerated(){
        if(currentFish != nil){
            var xPos = currentFish.position.x
            var yPos = currentFish.position.y
            var currentRotation: String = rotations[index]
                   //Check if the rotation of the fish is right or left
                   switch currentRotation {
                   case "right":
                       if(xPos >= 800){
                           //Flip the fish
                        let flip = SKAction.scaleX(to: -2.5, duration: 0.4)
                           currentFish.run(flip)

                           rotations[index] = "left"
                       }
                       else if(xPos<800){
                           //Make the fish go in horizontal direction
                           currentFish.position.x = xPos + 4
                        currentFish.position.y = yPos + 2
//                           self.randomFish.position.y = self.randomFish.position.y+1
                       }
                   case "left":
                      if(xPos <= 0){
                       //Flip the fish
                        let flip = SKAction.scaleX(to: 2.5, duration: 0.4)
                       currentFish.run(flip)
                       rotations[index] = "right"
                      }
                      else if(xPos>0){
                       //Make the fish go in horizontal direction
                      currentFish.position.x = currentFish.position.x-4
                      currentFish.position.y = currentFish.position.y+2
                       }
                   default:
                    print("")
                   }

               }

        }
    }
    
       func moveDownFish(){
        print("Move Down Fish")
            for (index,currentFish) in randomFish.enumerated(){
            if(currentFish != nil){
                var xPos = currentFish.position.x
                var yPos = currentFish.position.y
                var currentRotation: String = rotations[index]
                       //Check if the rotation of the fish is right or left
                       switch currentRotation {
                       case "right":
                           if(xPos >= 800){
                               //Flip the fish
                            let flip = SKAction.scaleX(to: -2.5, duration: 0.4)
                               currentFish.run(flip)

                               rotations[index] = "left"
                           }
                           else if(xPos<800){
                               //Make the fish go in horizontal direction
                               currentFish.position.x = xPos + 4
                            currentFish.position.y = yPos - 3
    //                           self.randomFish.position.y = self.randomFish.position.y+1
                           }
                   //        fish.image.transform = CGAffineTransformScale(fish.image.transform, -1, 1);
                       case "left":
                          if(xPos <= 0){
                           //Flip the fish
                            let flip = SKAction.scaleX(to: 2.5, duration: 0.4)
                           currentFish.run(flip)
                           rotations[index] = "right"
                          }
                          else if(xPos>0){
                           //Make the fish go in horizontal direction
                          currentFish.position.x = currentFish.position.x+4
                          currentFish.position.y = currentFish.position.y-3
                           }
                       default:
                        print("")
                       }

                   }

            }
        }
}
