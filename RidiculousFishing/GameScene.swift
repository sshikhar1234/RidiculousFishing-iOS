//
//  GameScene.swift
//  RidiculousFishing
//
//  Created by Shikhar Shah on 2019-10-19.
//  Copyright © 2019 Lambton. All rights reserved.
//

import SpriteKit
import GameplayKit

class Fish {
    var rotation: String?
    var image: SKSpriteNode!
     init(rotation: String, image: SKSpriteNode ){
        self.rotation = rotation
        self.image = image
    }
}
class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var ctr: Int = 0
    private let SPEED:CGFloat = 450
    
    private var ship : SKSpriteNode!
    private var hook : SKSpriteNode!
    private var bg_occean : SKSpriteNode!
    private var sky : SKSpriteNode!
    private var rotation: String = "right"
    private var fishes:[Fish]! = []
    
    //Flag to determine when the person starts game
    private var gameStart: Bool = false
    //Array of fishes
    private var randomFish:[SKSpriteNode]! = []
    
    //Array to keep track of rotation of all fishes
    private var rotations:[String]! = []
    let imageNames = ["fish0","fish1","fish3","fish2","snake","jellyfish1","jellyfish2"]

    
    override func didMove(to view: SKView) {
        
        
        //1. Initialize the sprites
        self.ship = self.childNode(withName: "ship") as! SKSpriteNode
        self.hook = self.childNode(withName: "hook") as! SKSpriteNode
        self.bg_occean = self.childNode(withName: "bg_occean") as! SKSpriteNode
        self.sky = self.childNode(withName: "sky") as! SKSpriteNode
        printScreenInfo()
        
    }
    
    func printScreenInfo(){
        print("Width: \(size.width)")
        print("Height: \(size.height)")
    }
    func spawnCreatures(){
        ctr = ctr + 1
        print("Spawn Creature number \(ctr)")
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
            print(randomFish.position.x)
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
        
        
        self.hook.position.x = loca.x

        print("location: \(mouseTouch!.location(in: self.view))")
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
        moveFish()
        if(ctr % 180 == 0 && gameStart)
        {
            spawnCreatures()
        }
    }
    
    func moveFish(){
        for (index,currentFish) in randomFish.enumerated(){
        if(currentFish != nil){
            var xPos = currentFish.position.x
            var yPos = currentFish.position.y
            print(index)
            var currentRotation: String = rotations[index]
            print(currentRotation)
                   //Check if the rotation of the fish is right or left
                   switch currentRotation {
                   case "right":
                       if(xPos >= 680){
                           //Flip the fish
                        let flip = SKAction.scaleX(to: -2.5, duration: 0.4)
                           currentFish.run(flip)

                           rotations[index] = "left"
                       }
                       else if(xPos<680){
                           //Make the fish go in horizontal direction
                           currentFish.position.x = xPos + 4
                        currentFish.position.y = yPos + 1
//                           self.randomFish.position.y = self.randomFish.position.y+1
                       }
                   case "left":
                      if(xPos <= 50){
                       //Flip the fish
                        let flip = SKAction.scaleX(to: 2.5, duration: 0.4)
                       currentFish.run(flip)
                       rotations[index] = "right"
                      }
                      else if(xPos>50){
                       //Make the fish go in horizontal direction
                      currentFish.position.x = currentFish.position.x-4
                      currentFish.position.y = currentFish.position.y+1
                       }
                   default:
                       print("Right")
                   }

               }

        }
    }
}
