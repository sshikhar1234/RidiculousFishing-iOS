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
    
    private let SPEED:CGFloat = 450
    
    private var ship : SKSpriteNode!
    private var hook : SKSpriteNode!
    private var bg_occean : SKSpriteNode!
    private var sky : SKSpriteNode!
    private var randomFish: SKSpriteNode!
    private var rotation: String = "right"
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
//        let numberOfImages: UInt32 = 2
//        let random = arc4random_uniform(numberOfImages)
        let imageName = "fish1"
        self.randomFish = SKSpriteNode(imageNamed: imageName)
        self.randomFish.zPosition = 10
        addChild(self.randomFish)
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
        print("location: \(mouseTouch!.location(in: self.view))")
        let nodeTouched = atPoint(loca).name
        if(nodeTouched == "ship"){
            
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
        moveFish()
        
    }
    
    func moveFish(){
        if(randomFish != nil){
               var xPos = self.randomFish.position.x
                   //Check if the rotation of the fish is right or left
                   switch rotation {
                   case "right":
                       if(xPos >= 680){
                           //Flip the fish
                           let flip = SKAction.scaleX(to: -1, duration: 0.4)
                           randomFish.run(flip)
                           rotation = "left"
                       }
                       else if(xPos<680){
                           //Make the fish go in horizontal direction
                           self.randomFish.position.x = self.randomFish.position.x+4
                           self.randomFish.position.y = self.randomFish.position.y+1
                       }
                   case "left":
                      if(xPos <= 50){
                       //Flip the fish
                       let flip = SKAction.scaleX(to: 1, duration: 0.4)
                       randomFish.run(flip)
                       rotation = "right"
                       
                      }
                      else if(xPos>50){
                       //Make the fish go in horizontal direction
                      self.randomFish.position.x = self.randomFish.position.x-4
                      self.randomFish.position.y = self.randomFish.position.y+1
                       }
                   default:
                       print("Right")
                   }
                 
               }
              
    }
}
