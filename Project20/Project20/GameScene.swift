//
//  GameScene.swift
//  Project20
//
//  Created by Brandon Johns on 5/6/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameTimer: Timer?
    var scoreLabel: SKLabelNode!
    var fireworks = [SKNode]()
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
   var launches = 0
    var score = 0
    {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }//didset
    }//score

    override func didMove(to view: SKView)
    {
        let background = SKSpriteNode(imageNamed: "background")                                                 //background
        background.position = CGPoint(x: 512, y: 384)                                                           // location middle screen
        background.blendMode = .replace                                                                         // .replace = making it opaque
        background.zPosition = -1                                                                               // behind
        addChild(background)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
                                                                                                                // fires every 6 sec and repeats
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)                                                                 // bottom left
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
    }//didMove
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int)
    {
        let node = SKNode()                                                                                     //creating node
        
        node.position = CGPoint(x: x, y: y)                                                                     // placing where its called
        
        let firework = SKSpriteNode(imageNamed: "rocket")                                                       //creating the rocket
        
        firework.colorBlendFactor = 1                                                                           // color fully
        firework.name = "firework"                                                                              //naming node
        node.addChild(firework)                                                                                 // add it to the created node above
        
                                                                                                                //firework is white by default
                                                                                                                // colorBlendFactor and .color change the color with no loss of preformance
        
        switch Int.random(in: 0...2)
        {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        default:
            firework.color = .red
        }// switch                                                                                              //color of fireworks
        
        let path = UIBezierPath()                                                                              // UIKit to draw path
        
        path.move(to: .zero)                                                                                    //start where the rocket starts
        path.addLine(to: CGPoint(x: xMovement, y: 1000))                                                         // move up the screen
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
                                                                                                                //path.cgPath = the path and is coregraphics
                                                                                                                //asOffset = start where the sprite starts
                                                                                                                // orientToPath = follow the direction
                                                                                                                // speed = how fast it moves
        
        
        node.run(move)                                                                                          // fireworks fit on screen
        
        if let emitter = SKEmitterNode(fileNamed:  "fuse")
        {
            emitter.position = CGPoint(x:0 , y: -22)
            node.addChild(emitter)                                                                              // adding the emitter to the node created in the beginning of the func
        }// emitter
        
        fireworks.append(node)                                                                                  // add to array
        addChild(node)
        
    }//create firework
    
    @objc func launchFireworks()
    {
        let movementAmount: CGFloat = 1800
        
        switch Int.random(in: 0...3)
        {
        case 0:
                                                                                        // fire 5 fireworks straight up
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)                                       // to left
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)                                       // to left
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)                                       // to right
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)                                       // to right
        case 1:
                                                                                        // fire 5 in a fan
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)
        case 2:
                                                                                        // fire five from left to right
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
        case 3:
                                                                                        // fire five from right to left
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
        default:
            break
        } // switch
        
        launches += 1
        
        if launches == 7
        {
            
            gameTimer?.invalidate()
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
        }
        
    }//launchFireworks
    
    func checkTouches(_ touches: Set<UITouch>)
    {
        guard let touch = touches.first else {return}                               // no touch bail out
        
        let location = touch.location(in: self)                                     //where the touch is
        
        let nodesAtPoint = nodes(at: location)                                      // nodes to touch
        
        for case let node as SKSpriteNode in nodesAtPoint                           // all fireworks can be selected
        {                                                                           // creates new node thats an SKSpriteNode
                                                                                    // if case == true
        
                                                                                        
            guard node.name == "firework" else {return  }                           // exit if the node is not a firework
            
            for parent in fireworks
            {
                guard let firework = parent.children.first as? SKSpriteNode else {continue }// exit if node is not found in the parent
                
                if firework.name == "selected" && firework.color != node.color
                {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1                                   // setting back to full color
                }
            }
            node.name = "selected"
            node.colorBlendFactor = 0                                               // setting it to white
            
        }
        
    }// checkTouches
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)                               // passes touches set to checkTouches method
    {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
        
        
    }// touchesBegan
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)                              // passes touches set to checkTouches method
    {
        
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }//touchesMoved
    
    
    override func update(_ currentTime: TimeInterval)
    {
        for (index, firework) in fireworks.enumerated().reversed()
        {
            if firework.position.y > 900                                                                // firework is high on screen
            {
                fireworks.remove(at: index)                                                             // remove from array
                firework.removeFromParent()                                                             //remove node
            }// if
        }// for
    }//update
    
    
    func explode(firework: SKNode)
    {
        
        if let emitter = SKEmitterNode(fileNamed: "explode")
        {
            emitter.position = firework.position                                                    // set the explosion at the firework location
            addChild(emitter)
        }// if let
        
        
        firework.removeFromParent()                                                                 // remove firework
        let wait = SKAction.wait(forDuration: 3.0)                                              // wait 3 seconds before destorying fireworks
        let sequence = SKAction.sequence([wait, .removeFromParent()])                           // after the 3 second wait remove
        
        firework.run(sequence)                                                                 // remove firework
    }//explode
    
    
    
    
    func explodeFireworks()
    {
        var numExploded = 0
        
        for (index, fireworksContainer) in fireworks.enumerated().reversed()
        {
            guard let firework = fireworksContainer.children.first as? SKSpriteNode else {continue}                             // checks for fireworks
            
            if firework.name == "selected"                                                                              //selected firework
            {
                explode(firework: fireworksContainer)                                                           // calls the explosion method on the fireworks
                fireworks.remove(at: index)
                numExploded += 1
            }//if
            
        }//for
        
        
        
        switch numExploded
        {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
        
    }//explodeFireworks
    
    
}//gameScene
