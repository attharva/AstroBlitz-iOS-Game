import PlaygroundSupport
import SpriteKit
import GameplayKit
import CoreMotion


public class MainScene:SKScene {
    

    
    var beginTimer:Timer!
    var beginT:Timer!
    var beginTi:Timer!
    let startGame = SKLabelNode(fontNamed: "AppleSDGothicNeo-UltraLight")
    let Instructions = SKLabelNode(fontNamed: "AvenirNextCondensed-Italic")
    let Info = SKLabelNode(fontNamed: "AvenirNextCondensed-Italic")
    
    public override func didMove(to view: SKView) {
        let space = SKSpriteNode(imageNamed: "background1")
        /* OpenSource https://pngtree.com/free-icon/load_439903 */
        space.size = self.size
        space.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        space.zPosition = -1
        
        
        
        self.addChild(space)
        
        let sound:SKAction = SKAction.playSoundFileNamed("calm.mp3", waitForCompletion: true)
        let loopSound:SKAction = SKAction.repeatForever(sound)
        self.run(loopSound)
        
        
        addGameStory()
        
        beginTimer = Timer.scheduledTimer(timeInterval: 15.2, target: self, selector: #selector(addBegin), userInfo: nil, repeats: false)
        
        beginT = Timer.scheduledTimer(timeInterval: 14, target: self, selector: #selector(AddIns), userInfo: nil, repeats: false)
        beginTi = Timer.scheduledTimer(timeInterval: 14, target: self, selector: #selector(AddInfo), userInfo: nil, repeats: false)
    }
    
    
    @objc func AddIns() {
        
        Instructions.fontSize = 10
        Instructions.text = "Story"
        Instructions.fontColor = SKColor.gray
        Instructions.position = CGPoint(x:self.size.width * 0.9,y: self.size.height * 0.9)
        let scaleIn = SKAction.scale(to: 1.5, duration: 2)
        let scaleOut = SKAction.scale(to:1,duration:2)
        
        let seQ = SKAction.sequence([scaleIn,scaleOut])
        
        let repeatAction:SKAction = SKAction.repeatForever(seQ)
        
        Instructions.run(repeatAction)
        
        Instructions.name = "story"
        
        self.addChild(Instructions)
        
        
    }
    @objc func AddInfo() {
        
        Info.fontSize = 10
        Info.text = "Information"
        Info.fontColor = SKColor.gray
        Info.position = CGPoint(x:self.size.width * 0.5,y: self.size.height * 0.9)
        let scaleIn = SKAction.scale(to: 1.5, duration: 2)
        let scaleOut = SKAction.scale(to:1,duration:2)
        
        let seQ = SKAction.sequence([scaleIn,scaleOut])
        
        let repeatAction:SKAction = SKAction.repeatForever(seQ)
        
        Info.run(repeatAction)
        Info.name = "info"
        
        self.addChild(Info)
        
    }
    
    @objc func addBegin() {
        startGame.text = "START"
        startGame.fontSize = 30
        startGame.fontColor = SKColor.gray
        startGame.position =  CGPoint(x: self.size.width/1.5, y: self.size.height * 0.2)
        
        startGame.zPosition = 1
        startGame.name = "startButton"
        
        let scaleIn = SKAction.scale(to: 1, duration: 2)
        let scaleOut = SKAction.scale(to:0.8,duration:2)
        
        let seQ = SKAction.sequence([scaleIn,scaleOut])
        
        let repeatAction:SKAction = SKAction.repeatForever(seQ)
        
        startGame.run(repeatAction)
         
        
        self.addChild(startGame)
       
    }
    
    func addGameStory(){
        let gameOverlabel = SKLabelNode(fontNamed:"AmericanTypewriter-Condensed")
        gameOverlabel.text = "My"
        gameOverlabel.fontSize = 36
        gameOverlabel.fontColor = SKColor.gray
        
        
        
        gameOverlabel.position = CGPoint(x:self.size.width * 0.69,y:self
            .size.height * 0.55)
         gameOverlabel.name = "gameOver"
        self.addChild(gameOverlabel)
        gameOverlabel.alpha = 0
        var fadeOutAction = SKAction.fadeIn(withDuration: 2)
        fadeOutAction.timingMode = .easeInEaseOut
        gameOverlabel.run(fadeOutAction, completion: {
            gameOverlabel.alpha = 1
            
        })
        
        fadeOutAction = SKAction.fadeIn(withDuration: 5)
        fadeOutAction.timingMode = .easeInEaseOut
        gameOverlabel.run(fadeOutAction, completion: {
            gameOverlabel.text = "WWDC18"
            gameOverlabel.alpha = 1
        })
        fadeOutAction = SKAction.fadeIn(withDuration: 9)
        fadeOutAction.timingMode = .easeInEaseOut
        gameOverlabel.run(fadeOutAction, completion: {
            gameOverlabel.text = "Project Presents"
            gameOverlabel.alpha = 1
            
        })
       
        fadeOutAction = SKAction.fadeIn(withDuration: 12)
        fadeOutAction.timingMode = .easeInEaseOut
        gameOverlabel.run(fadeOutAction, completion: {
            
            gameOverlabel.text = "The Multiverse"
            gameOverlabel.alpha = 1
            
           
            
        })
        
    }
    
    
    
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch : AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            
            if  startGame.contains(pointOfTouch) {
                
                var Loading:SKSpriteNode!
                Loading = SKSpriteNode(imageNamed: "loading")
                Loading.position = CGPoint(x:self.size.width,y:self.size.height * 0.07)
                let oneRevolution:SKAction = SKAction.rotate(byAngle: CGFloat.pi * 2, duration: 1)
                let repeatRotation:SKAction = SKAction.repeatForever(oneRevolution)
                
                Loading.run(repeatRotation)
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.3)
                self.view?.presentScene(sceneToMoveTo,transition:myTransition)
                self.removeAllChildren()
                self.removeAllActions()
                
            }
        }
        for touch : AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            
            if  Instructions.contains(pointOfTouch) {
                
                let sceneToMoveTo = instruction(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.3)
                self.view?.presentScene(sceneToMoveTo,transition:myTransition)
                
            }
        }
        for touch : AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            
            if  Info.contains(pointOfTouch) {
                
                let sceneToMoveTo = Information(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.3)
                self.view?.presentScene(sceneToMoveTo,transition:myTransition)
               
            }
        }
        
    }
    
}
