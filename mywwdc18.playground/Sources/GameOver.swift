import PlaygroundSupport
import SpriteKit
import GameplayKit
import CoreMotion


public class GameOver:SKScene{
    
    
    let restartLabel = SKLabelNode(fontNamed: "AppleSDGothicNeo-SemiBold")
    
    public override func didMove(to view:SKView) {
        
        
        
        let space = SKSpriteNode(imageNamed: "GameLaunch")
        
        
        space.size = self.size
        space.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        space.zPosition = -1
        self.addChild(space)
        
        
        let gameOverlabel = SKLabelNode(fontNamed:"AppleSDGothicNeo-SemiBold")
        gameOverlabel.text = "Game Over"
        gameOverlabel.fontSize = 60
        gameOverlabel.fontColor = SKColor.black
        
        
        gameOverlabel.position = CGPoint(x:self.size.width * 0.5,y:self
            .size.height * 0.7)
        gameOverlabel.zPosition = 1
        
        let scaleIn = SKAction.scale(to: 1, duration: 2)
        let scaleOut = SKAction.scale(to:0.8,duration:2)
        
        let seQ = SKAction.sequence([scaleIn,scaleOut])
        
        let repeatAction:SKAction = SKAction.repeatForever(seQ)
        
        gameOverlabel.run(repeatAction)
        
        self.addChild(gameOverlabel)
        
        
        
        let scorelabel = SKLabelNode(fontNamed: "AppleSDGothicNeo-SemiBold")
        scorelabel.text = "Score: \(score)"
        scorelabel.fontSize = 40
        scorelabel.fontColor = SKColor.black
        
        
        scorelabel.position = CGPoint(x:self.size.width/2,y:self.size.height * 0.55)
        scorelabel.zPosition = 1
        self.addChild(scorelabel)
        
        
        restartLabel.fontSize = 40
        restartLabel.text = "Restart"
        restartLabel.fontColor = SKColor.black
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.3)
        let ScIn = SKAction.scale(to: 1, duration: 2)
        let Sout = SKAction.scale(to:0.8,duration:2)
        
        let sequ = SKAction.sequence([ScIn,Sout])
        
        let repeatA:SKAction = SKAction.repeatForever(sequ)
        
        restartLabel.run(repeatA)
        self.addChild(restartLabel)
        
        
        
    }
    
    
    
   public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch : AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch) {
                
                let sceneToMoveTo = GameScene(size: self.size)

                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.3)
                self.view?.presentScene(sceneToMoveTo,transition:myTransition)
                
            }
        }
    }
    
}
