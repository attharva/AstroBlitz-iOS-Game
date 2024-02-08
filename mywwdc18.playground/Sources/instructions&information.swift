
import PlaygroundSupport
import SpriteKit
import GameplayKit
import CoreMotion


public class instruction:SKScene {
    
    let back = SKLabelNode(fontNamed: "AppleSDGothicNeo-UltraLight")
    
   public override func didMove(to view: SKView) {
        let space = SKSpriteNode(imageNamed: "background1")
        space.size = self.size
        space.position = CGPoint(x: self.size.width/2 , y: self.size.height/2)
        space.zPosition = -1
        self.addChild(space)
        
        
        let text = "Its year 3000AD on Earth \n\n and we have barely aged 10 years.\n\nWe were on a mission\n\n to find a multiverse\n\nwhich exists beyond \n\n a wormhole.Rightnow\n\n, we are in another universe\n\n and we must return back\n\nto Earth.\n\nThrough the journey we realise\n\n that this is an unidirectional path.\n\nThis is where\n\nthe threat arises as\n\nwe have to travel through blackhole.\n\nand reach\n\n mother Earth.\n\nNew heavenly bodies can be seen\n\n throughout this journey.\n\nTo survive\n\n we must fight \n\nand destroy asteroids.\n\nAnd the blackhole\n\ntwists time and space.\n\nWould our calculations be accurate?\n\n Will we reach Earth?\n\n Will we survive?\n\nLets find out.\n\n"
        let singleLineMessage = SKLabelNode()
        singleLineMessage.fontSize = min(size.width, size.height) /
            CGFloat(text.components(separatedBy: "\n").count)
        singleLineMessage.verticalAlignmentMode = .center
        singleLineMessage.text = text
        let message = singleLineMessage.multilined()
        message.position = CGPoint(x: frame.midX + 76.7, y: frame.midY + 50)
    message.fontColor = SKColor.white
        self.addChild(message)
        
        let text4 = "Shoot asteroids, increase\nyour score. And finally go inside\na blackhole to win the\ngame.The blackhole arrives\nwhen your score is above 750."
        let singleLineMessage4 = SKLabelNode()
        
        singleLineMessage4.verticalAlignmentMode = .bottom
        singleLineMessage4.text = text4
        
        let message4 = singleLineMessage4.multilined()
        message4.position = CGPoint(x: frame.midX + 65   , y: frame.midY - 250)
        message4.fontSize = 1
    message4.fontColor = SKColor.white
        self.addChild(message4)
        
        back.fontSize = 20
        back.text = "Back"
        back.fontColor = SKColor.white
        back.position = CGPoint(x:self.size.width * 0.90,y: self.size.height * 0.93)
        self.addChild(back)
        let sound:SKAction = SKAction.playSoundFileNamed("calm.mp3", waitForCompletion: true)
        let loopSound:SKAction = SKAction.repeatForever(sound)
        self.run(loopSound)
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch : AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            
            if back.contains(pointOfTouch) {
                
                let sceneToMoveTo = MainScene(size:self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.3)
                self.view?.presentScene(sceneToMoveTo,transition:myTransition)
                
                
            }
        }
    }
}





extension SKLabelNode {
    func multilined() -> SKLabelNode {
        let substrings: [String] = self.text!.components(separatedBy: "\n")
        return substrings.enumerated().reduce(SKLabelNode()) {
            let label = SKLabelNode(fontNamed: self.fontName)
            label.text = $1.element
            
            label.fontSize = 17
            label.position = self.position
            label.horizontalAlignmentMode = self.horizontalAlignmentMode
            label.verticalAlignmentMode = self.verticalAlignmentMode
            let y = CGFloat($1.offset - substrings.count / 2) * self.fontSize
            label.position = CGPoint(x: 0, y: -y)
            $0.addChild(label)
            return $0
        }
    }
    
}


public class Information:SKScene {
    
    let back = SKLabelNode(fontNamed: "AppleSDGothicNeo-UltraLight")
    
   public override func didMove(to view: SKView) {
    let space = SKSpriteNode(imageNamed: "Instructions")
    space.size = self.size
    space.position = CGPoint(x: self.size.width/2 , y: self.size.height/2)
    space.zPosition = -1
    self.addChild(space)
        
        let text = "A black hole is a region of spacetime exhibiting \nsuch strong gravitational effects that nothing\nnot even light can escape from inside."
        let singleLineMessage = SKLabelNode()
    
        singleLineMessage.verticalAlignmentMode = .top 
        singleLineMessage.text = text
        
        let message = singleLineMessage.multilined()
        message.position = CGPoint(x: frame.midX - 35  , y: frame.midY + 271 )
        message.fontSize = 5
 message.fontColor = SKColor.gray
        self.addChild(message)
        
        let sound:SKAction = SKAction.playSoundFileNamed("calm.mp3", waitForCompletion: true)
        let loopSound:SKAction = SKAction.repeatForever(sound)
        self.run(loopSound)
        
        let text1 = "A wormhole is a theoretical passage through\n space-time that could create shortcuts\n for long journeys across the universe."
        let singleLineMessage1 = SKLabelNode()
        
        singleLineMessage1.verticalAlignmentMode = .top
        singleLineMessage1.text = text1
        
        let message1 = singleLineMessage1.multilined()
        message1.position = CGPoint(x: frame.midX - 40  , y: frame.midY + 160)
        message1.fontSize = 5
     message1.fontColor = SKColor.gray
        self.addChild(message1)
        
        let text3 = "Neutron star is extremely dense,\n primarily of neutrons,especially the\n collapsed core of a supernova."
        let singleLineMessage3 = SKLabelNode()
        
        singleLineMessage3.verticalAlignmentMode = .top
        singleLineMessage3.text = text3
        
        let message3 = singleLineMessage3.multilined()
        message3.position = CGPoint(x: frame.midX - 65 , y: frame.midY + 50)
        message3.fontSize = 5
     message3.fontColor = SKColor.gray
        self.addChild(message3)
        
        let text4 = "Colliding galaxies are galaxies whose\n gravitational fields result in a disturbance\n of one another "
        let singleLineMessage4 = SKLabelNode()
        
        singleLineMessage4.verticalAlignmentMode = .top
        singleLineMessage4.text = text4
        
        let message4 = singleLineMessage4.multilined()
        message4.position = CGPoint(x: frame.midX - 60  , y: frame.midY - 145)
        message4.fontSize = 5
     message4.fontColor = SKColor.gray
        self.addChild(message4)
        
        
        let text5 = "A GALAXY is a gravitationally bound system\n of stars,interstellar gas,dust and dark matter"
        let singleLineMessage5 = SKLabelNode()
        
        singleLineMessage5.verticalAlignmentMode = .top
        singleLineMessage5.text = text5
        
        let message5 = singleLineMessage5.multilined()
        message5.position = CGPoint(x: frame.midX - 40  , y: frame.midY - 60)
        message5.fontSize = 5
    message5.fontColor = SKColor.gray
        self.addChild(message5)
        
        
        
        
        
        
        
        let bH:SKSpriteNode!
        
        bH = SKSpriteNode(imageNamed: "Blackhole5")
        bH.position =  CGPoint(x: frame.midX + 150 , y: frame.midY + 271)
        self.addChild(bH)
        bH.setScale(0.3)
        
        let wH:SKSpriteNode!
        
        wH = SKSpriteNode(imageNamed: "wormHole5")
        wH.position = CGPoint(x: frame.midX + 150  , y: frame.midY + 160)
        self.addChild(wH)
        wH.setScale(0.07)
        
        let gl:SKSpriteNode!
        gl = SKSpriteNode(imageNamed: "main")
        gl.position = CGPoint(x: frame.midX + 155 , y: frame.midY - 50 )
        self.addChild(gl)
        gl.setScale(0.1)
        
        let cgl:SKSpriteNode!
        cgl = SKSpriteNode(imageNamed: "collidegalaxy1")
        cgl.position = CGPoint(x: frame.midX + 150 , y: frame.midY - 155 )
        self.addChild(cgl)
        cgl.setScale(0.075)
        
        let nS:SKSpriteNode!
        nS = SKSpriteNode(imageNamed: "neutronStar1")
        nS.position = CGPoint(x: frame.midX + 150 , y: frame.midY + 50 )
        self.addChild(nS)
        nS.setScale(0.075)
        
        back.fontSize = 20
        back.text = "Back"
        back.fontColor = SKColor.white
        back.position = CGPoint(x:self.size.width * 0.90,y: self.size.height * 0.10)
        self.addChild(back)
    }
   public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch : AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            
            if back.contains(pointOfTouch) {
                
                let sceneToMoveTo = MainScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.3)
                self.view?.presentScene(sceneToMoveTo,transition:myTransition)
            
                
            }
        }
    }
}



