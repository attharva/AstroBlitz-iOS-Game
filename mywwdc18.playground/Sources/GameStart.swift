import PlaygroundSupport
import SpriteKit
import GameplayKit
import CoreMotion



var score:Int = 0

public class GameScene: SKScene,SKPhysicsContactDelegate{
    
    var gameArea:CGRect
    
    
    public override init(size:CGSize) {
        
        
        
        let maxAspectratio:CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectratio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size:size)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min:CGFloat,max:CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    let explosionSound = SKAction.playSoundFileNamed("bigExplosion.mp3", waitForCompletion: false)
    let LaserSound =   SKAction.playSoundFileNamed("laserGun.mp3", waitForCompletion: false)
    
    
    
    
    var mainShip:SKSpriteNode!
    /*OpenSource: https://opengameart.org */
    
    
    var starBackground:SKEmitterNode!
    var scoreLabel:SKLabelNode!
    var blackhole:SKEmitterNode!
    var boosters:SKEmitterNode!
    var neutronStar:SKEmitterNode!
    var violetgalaxy:SKEmitterNode!
    var commetLeft:SKEmitterNode!
    var commetRight:SKEmitterNode!
    var galaxyB:SKEmitterNode!
    //created in xcode spritekit particle file
    
    
    var levelNo = 0
    
    var commetRightTimer:Timer!
    var commetLeftTimer:Timer!
    var starsystemTimer:Timer!
    var semiStarT:Timer!
    var miniStarT:Timer!
    
    var allAsteroids = ["aestroid_brown","aestroid_gray_2","aestroid_gray","aestroid_dark"]
    /*OpenSource https://opengameart.org */
    
    
    var AllStarsystem = ["main","Blackhole5","GalaxyBlue"]
    /* OpenSource https://pngtree.com/free-icon/load_439903 */
    
    var semiStarsystem = ["collidegalaxy1","collection","v4"]
    
    var miniStarSystem = ["starsystem1","VioletCloud","neu"]
    
    struct  physicsCategories{
        static let none:UInt32 = 0
        static let alienCategory:UInt32 = 0b100 //4
        static let photonTorpedoCategory:UInt32 = 0b10 //2
        static let playerCategory:UInt32 = 0b1 //1
        static let bbCategory:UInt32 =  0b101 //5
    }
    
    
    let motionManager = CMMotionManager()
    var xAccerlation:CGFloat = 0
    
    
    public override func didMove(to view: SKView) {
        
        score = 0
        
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        
        let background = SKSpriteNode(imageNamed: "back2")
        background.size = self.size
        /*OpenSource: https://opengameart.org */
        
        
        
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.name = "change"
        
        background.zPosition = -1
        
        self.addChild(background)
        
        
        
        
        starBackground = SKEmitterNode(fileNamed: "Starfield")
        
        starBackground.position = CGPoint(x: 0, y: 800)
        starBackground.advanceSimulationTime(15)
        starBackground.particleSpeedRange = 150
        
        
        starBackground.name = "sf"
        self.addChild(starBackground)
        starBackground.zPosition = -1
        
        
        
        
        
        
        mainShip = SKSpriteNode(imageNamed: "spaceship")
        /*OpenSource: https://opengameart.org */
        mainShip.position = CGPoint(x:self.size.width,y:self.size.height * 0.07)
        //player.zPosition = -1
        
        
        
        mainShip.physicsBody = SKPhysicsBody(rectangleOf: mainShip.size)
        mainShip.physicsBody?.usesPreciseCollisionDetection = true
        mainShip.physicsBody?.isDynamic = true
        mainShip.physicsBody?.categoryBitMask = physicsCategories.playerCategory
        mainShip.physicsBody?.contactTestBitMask = physicsCategories.alienCategory
        mainShip.physicsBody?.contactTestBitMask = physicsCategories.bbCategory
        mainShip.physicsBody?.collisionBitMask = physicsCategories.none
        mainShip.name = "ship"
        mainShip.setScale(0.125)
        
        
        boosters = SKEmitterNode(fileNamed: "smoke")
        
        boosters.position = CGPoint(x:mainShip.position.x - 400 , y: mainShip.position.y - 155 )
        
        
        boosters.setScale(0.8)
        
        
        
        let headlight = SKSpriteNode(imageNamed: "spark")
        /*OpenSource: https://opengameart.org */
        
        headlight.position = CGPoint(x: mainShip.position.x - 400, y: mainShip.position.y +  60)
        headlight.setScale(0.27)
        let focus = SKSpriteNode(imageNamed: "shipfocus")
        /*OpenSource: https://opengameart.org */
        focus.position = CGPoint(x: mainShip.position.x - 400, y: mainShip.position.y + 100)
        focus.setScale(0.27)
        mainShip.addChild(headlight)
        mainShip.addChild(boosters)
        mainShip.addChild(focus)
        
        
        self.addChild(mainShip)
        
        
        
        scoreLabel = SKLabelNode(text:"Score:0")
        
        scoreLabel.position = CGPoint(x:self.size.width * 0.14,y: self.size.height * 0.90)
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = UIColor.white
        scoreLabel.zPosition = 100
        score = 0
        self.addChild(scoreLabel)
        
        addSound()
        
        
        startNewLevel()
        
        
        
        commetRightTimer = Timer.scheduledTimer(timeInterval:56 , target: self, selector: #selector(addCommetRightside), userInfo: nil, repeats: true)
        
        commetLeftTimer = Timer.scheduledTimer(timeInterval: 43, target: self, selector: #selector(leftCommet), userInfo: nil, repeats: true)
        
        starsystemTimer = Timer.scheduledTimer(timeInterval: 17, target: self, selector: #selector(addStarSystem), userInfo: nil, repeats: true)
        
        semiStarT = Timer.scheduledTimer(timeInterval: 28, target: self, selector: #selector(addSemiStarSystem), userInfo: nil, repeats: true)
        
        
        miniStarT =  Timer.scheduledTimer(timeInterval: 37, target: self, selector: #selector(addMiniStar), userInfo: nil, repeats: true)
        
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
            if let accerlometerData = data {
                let accerlation = accerlometerData.acceleration
                self.xAccerlation = CGFloat(accerlation.x * 0.75) + self.xAccerlation * 0.25
            }
        }
        
        
        
    }
    
    // MARK: add sound
    
    func addSound()  {
        
        let sound:SKAction = SKAction.playSoundFileNamed("backgroundScore.mp3", waitForCompletion: true)
        
        let loopSound:SKAction = SKAction.repeatForever(sound)
        self.run(loopSound)
        
    }
    
    
   
    
    
      // MARK: add score
    
    func addScore(){
        score += 10
        scoreLabel.text = "Score:\(score)"
        
        
        if score == 300 || score == 700 || score == 1100 {
            startNewLevel()
            let levelIncreased = SKLabelNode(fontNamed:"AmericanTypewriter-Condensed")
            levelIncreased.text = "level Increased"
            levelIncreased.fontSize = 40
            levelIncreased.fontColor = SKColor.lightText
            
            
            
            levelIncreased.position = CGPoint(x:self.size.width * 0.5,y:self
                .size.height * 0.55)
            
            self.addChild(levelIncreased)
            levelIncreased.alpha = 1
            var fadeOutAction = SKAction.fadeIn(withDuration: 2)
            fadeOutAction.timingMode = .easeInEaseOut
            levelIncreased.run(fadeOutAction, completion: {
                
                
            })
            
            fadeOutAction = SKAction.fadeIn(withDuration: 3)
            fadeOutAction.timingMode = .easeInEaseOut
            levelIncreased.run(fadeOutAction, completion: {
                
                levelIncreased.text = ""
                levelIncreased.alpha = 1
                
                levelIncreased.removeFromParent()
                
                
            })
        }
        //You can increase score criteria accordingly
        if score == 750   {
            addblackhole()
        }
        if score == 1000 {
            addVioletGalaxy()
        }
        if score == 850 || score == 1300  {
            addCollapsingGalaxy()
        }
        if score == 710 || score == 1200 {
            addNeutronStar()
        }
    }
    
      // MARK: add new level
    
    func startNewLevel() {
        
        levelNo += 1
        
        if self.action(forKey: "spottingAsteroids") != nil{
            self.removeAction(forKey: "spottingAsteroids")
        }
        
        
        var level = TimeInterval()
        //increase level to increase spawing of enemies and diffculty of Game.
        
        switch levelNo {
        case 1: level = 1.6
        case 2: level = 1.2
        case 3: level = 0.7
        case 4: level = 0.3
        default:
            level = 2
        }
        
        let spot = SKAction.run(addAsteroids)
        let waitToSpot = SKAction.wait(forDuration: level)
        let spotSequence = SKAction.sequence([spot,waitToSpot])
        let spotForever = SKAction.repeatForever(spotSequence)
        
        self.run(spotForever,withKey: "spottingAsteroids")
        
    }
    
    
      // MARK: gameOver
    
    func gameOver() {
        
        currentGameState = gameState.afterGame
        
        
        
        self.enumerateChildNodes(withName: "beam"){
            laser, stop in
            laser.removeAllActions()
            laser.removeFromParent()
            
            
        }
        
        self.enumerateChildNodes(withName: "Darth") {
            Darth, stop in
            
            Darth.removeAllActions()
            
            
            
        }
        self.enumerateChildNodes(withName: "change") {
            change, stop in
            change.removeAllActions()
            
            
            
        }
        self.enumerateChildNodes(withName: "ship"){
            ship ,stop in
            ship.removeAllActions()
            ship.removeFromParent()
            
            
            
        }
        self.enumerateChildNodes(withName: "sf"){
            sf ,stop in
            sf.removeAllActions()
            sf.removeFromParent()
            
        }
        
        self.enumerateChildNodes(withName: "blackH"){
            blackH ,stop in
            blackH.removeAllActions()
            blackH.removeAllChildren()
            blackH.removeFromParent()
            
            
        }
        self.enumerateChildNodes(withName: "gasC"){
            gasC ,stop in
            gasC.removeAllActions()
            gasC.removeAllChildren()
            gasC.removeFromParent()
            
            
        }
        self.enumerateChildNodes(withName: "redN"){
            redN,stop in
            redN.removeAllActions()
            redN.removeAllChildren()
            redN.removeFromParent()
            
            
            
        }
        self.enumerateChildNodes(withName: "commetR"){
            commetR ,stop in
            commetR.removeAllActions()
            commetR.removeAllChildren()
            commetR.removeFromParent()
            
            
        }
        self.enumerateChildNodes(withName: "commetL"){
            commetL ,stop in
            commetL.removeAllActions()
            commetL.removeAllChildren()
            commetL.removeFromParent()
            
            
        }
        
        
        self.enumerateChildNodes(withName: "worm"){
            worm ,stop in
            worm.removeAllActions()
            worm.removeFromParent()
            
        }
        
        self.enumerateChildNodes(withName: "stars"){
            stars ,stop in
            stars.removeAllActions()
            stars.removeFromParent()
            
            
        }
        self.enumerateChildNodes(withName: "semistar") {
            semistar ,stop in
            semistar.removeAllActions()
            semistar.removeFromParent()
            
        }
        self.enumerateChildNodes(withName: "Mstars") {
            Mstars ,stop in
            Mstars.removeAllActions()
            Mstars.removeFromParent()
            
        }
        
        let changesceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration:0.5)
        let changeSceneSeq = SKAction.sequence([waitToChangeScene,changesceneAction])
        self.run(changeSceneSeq)
        
        
    }
    
    
    func changeScene() {
        let sceneToMoveTo = GameOver(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let Mytransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: Mytransition)
        
    }
    
    
    enum gameState {
        case preGame // before start of game
        case inGame // ongoing game
        case afterGame//after game
    }
    
    
    var currentGameState = gameState.inGame
    
    
    
      // MARK: add asteroids
    
    @objc func addAsteroids() {
        allAsteroids = GKRandomSource.sharedRandom().arrayByShufflingObjects(in:     allAsteroids) as! [String]
        let asteroid = SKSpriteNode(imageNamed:     allAsteroids[0])
        
        asteroid.name = "Darth"
        let randomAsteroidPos = GKRandomDistribution(lowestValue:  Int(gameArea.minX)  , highestValue: Int(gameArea.maxX)   )
        
        
        let position = CGFloat(randomAsteroidPos.nextInt())
        asteroid.position = CGPoint(x:position,y:self.frame.size.height + 0 +  asteroid.size.height)
        
        asteroid.physicsBody = SKPhysicsBody(rectangleOf: asteroid.size)
        asteroid.physicsBody?.isDynamic = true
        
        
        asteroid.physicsBody?.categoryBitMask = physicsCategories.alienCategory
        asteroid.physicsBody?.collisionBitMask = physicsCategories.none
        asteroid.physicsBody?.contactTestBitMask = physicsCategories.playerCategory | physicsCategories.photonTorpedoCategory
        
        asteroid.setScale(0.07)
        self.addChild(asteroid)
        
        let animationDuration:TimeInterval = 4
        
        
        
        let actionArray = SKAction.move(to: CGPoint(x:position,y:  mainShip.position.y  - 20  ), duration: animationDuration)
        let deleteAction = SKAction.removeFromParent()
        
        
        let oneRevolution:SKAction = SKAction.rotate(byAngle: CGFloat.pi * 2, duration: 1)
        let repeatRotation:SKAction = SKAction.repeatForever(oneRevolution)
        
        asteroid.run(repeatRotation)
        
        
        let AsteroidSeq = SKAction.sequence([actionArray,deleteAction])
        
        asteroid.run(AsteroidSeq)
        
        
    }
    
  // MARK: add StarSystem
    
    
    @objc func addStarSystem() {
        /* OpenSource https://pngtree.com/free-icon/load_439903 */
        AllStarsystem = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: AllStarsystem) as! [String]
        let StarS = SKSpriteNode(imageNamed: AllStarsystem[0])
        
        StarS.name = "stars"
        let randomStarPos = GKRandomDistribution(lowestValue:  Int(gameArea.minX)  , highestValue: Int(gameArea.maxX)   )
        
        let position = CGFloat(randomStarPos.nextInt())
        StarS.position = CGPoint(x:position,y:self.frame.size.height + 0 +  StarS.size.height)
        
        
        StarS.setScale(0.9)
        self.addChild(StarS)
        
        let animationDuration:TimeInterval = 10
        // var actionArray = [SKAction]()
        
        
        let actionArray = SKAction.move(to: CGPoint(x:position,y:  mainShip.position.y  - 250  ), duration: animationDuration)
        let deleteAction = SKAction.removeFromParent()
        
        StarS.zPosition = -1
        
        let StarSequence = SKAction.sequence([actionArray,deleteAction])
        
        
        
        StarS.run(StarSequence)
    }
    
     // MARK: add MiniStarSystem
    
    @objc func addMiniStar() {
        /* OpenSource https://pngtree.com/free-icon/load_439903 */
        
        miniStarSystem = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: miniStarSystem) as! [String]
        
        let miniS = SKSpriteNode(imageNamed: miniStarSystem[0])
        
        miniS.name = "Mstars"
        let randomStarPos = GKRandomDistribution(lowestValue:  Int(gameArea.minX)  , highestValue: Int(gameArea.maxX)   )
        
        let position = CGFloat(randomStarPos.nextInt())
        miniS.position = CGPoint(x:position,y:self.frame.size.height + 0 +  miniS.size.height)
        
        
        miniS.setScale(0.9)
        self.addChild(miniS)
        
        let animationDuration:TimeInterval = 10
        // var actionArray = [SKAction]()
        
        
        let actionArray = SKAction.move(to: CGPoint(x:position,y:  mainShip.position.y  - 250  ), duration: animationDuration)
        let deleteAction = SKAction.removeFromParent()
        
        miniS.zPosition = -1
        
        let StarSequence = SKAction.sequence([actionArray,deleteAction])
        
        
        
        miniS.run(StarSequence)
    }
    

      // MARK: add SSS
    
    @objc func addSemiStarSystem() {
        /* OpenSource https://pngtree.com/free-icon/load_439903 */
        semiStarsystem = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: semiStarsystem) as! [String]
        let StarS = SKSpriteNode(imageNamed: semiStarsystem[0])
        
        StarS.name = "semistar"
        let randomSemiStarPos = GKRandomDistribution(lowestValue:  Int(gameArea.minX)  , highestValue: Int(gameArea.maxX)   )
        
        let position = CGFloat(randomSemiStarPos.nextInt())
        StarS.position = CGPoint(x:position,y:self.frame.size.height + 0 +  StarS.size.height)
        
        
        StarS.setScale(0.95)
        self.addChild(StarS)
        
        let animationDuration:TimeInterval = 10
       
        
        
        let actionArray = SKAction.move(to: CGPoint(x:position,y:  mainShip.position.y  - 250  ), duration: animationDuration)
        let deleteAction = SKAction.removeFromParent()
        
        StarS.zPosition = -1
        
        let StarSequence = SKAction.sequence([actionArray,deleteAction])
        
        
        
        StarS.run(StarSequence)
    }
    
      // MARK: add blackHole
    
    
    func addblackhole() {
        /* OpenSource https://pngtree.com/free-icon/load_439903 */
        blackhole = SKEmitterNode(fileNamed:"BlackHole")
        
        blackhole.name = "blackH"
        
        
        let randomStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPt = CGPoint(x:randomStart,y:self.size.height + 0  )
        let endpoint = CGPoint(x:randomEnd,y: -self.size.height + 50)
        blackhole.advanceSimulationTime(5)
        blackhole.position = startPt
        
        
        blackhole.setScale(0.23)
        
        
        let bb = SKSpriteNode(imageNamed:"violet" )
        bb.setScale(0.8)//1
        bb.position = CGPoint(x: blackhole.particlePosition.x  , y: blackhole.particlePosition.y )
        
        blackhole.physicsBody = SKPhysicsBody(rectangleOf: blackhole.particleSize)
        
        blackhole.physicsBody!.categoryBitMask = physicsCategories.bbCategory
        blackhole.physicsBody?.collisionBitMask = physicsCategories.none
        blackhole.physicsBody!.contactTestBitMask = physicsCategories.playerCategory
        blackhole.physicsBody?.affectedByGravity = false
        self.addChild(blackhole)
        blackhole.addChild(bb)
        let del = SKAction.run(gameOver)
        
        let movebb = SKAction.move(to: endpoint, duration: 4)
        let delBb = SKAction.removeFromParent()
        let bbSeq = SKAction.sequence([movebb,delBb,del])
        
        
       
        let oneRevolution:SKAction = SKAction.rotate(byAngle: CGFloat.pi * 2, duration: 1)
        let repeatRotation:SKAction = SKAction.repeatForever(oneRevolution)
        
        bb.run(repeatRotation)
        blackhole.run(bbSeq)
        
        
    }
    
    func addNeutronStar() {
        
        /* OpenSource https://pngtree.com/free-icon/load_439903 */
        neutronStar = SKEmitterNode(fileNamed:"gascloud")
        neutronStar.name = "gasC"
        
        
        let randomStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPt = CGPoint(x:randomStart,y:self.size.height + 0  )
        let endpoint = CGPoint(x:randomEnd,y: -self.size.height)
        
        neutronStar.position = startPt
        neutronStar.zPosition = -1
        let movebb = SKAction.move(to: endpoint, duration: 10)
        let delBb = SKAction.removeFromParent()
        let bbSeq = SKAction.sequence([movebb,delBb])
        neutronStar.setScale(0.9)
        
        
        
        self.addChild(neutronStar)
        neutronStar.run(bbSeq)
        
        
    }
    
      // MARK: add VGalaxy
    
    func addVioletGalaxy() {
        /* OpenSource https://pngtree.com/free-icon/load_439903 */
        
        violetgalaxy = SKEmitterNode(fileNamed:"violet")
        violetgalaxy.name = "redN"
        
        violetgalaxy.advanceSimulationTime(10)
        let randomStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPt = CGPoint(x:randomStart,y:self.size.height + 0  )
        let endpoint = CGPoint(x:randomEnd,y: -self.size.height)
        
        violetgalaxy.position = startPt
        violetgalaxy.zPosition = -1
        let movebb = SKAction.move(to: endpoint, duration: 5)
        let delBb = SKAction.removeFromParent()
        let bbSeq = SKAction.sequence([movebb,delBb])
        violetgalaxy.setScale(0.65)
        
        
        self.addChild(violetgalaxy)
        let rr = SKSpriteNode(imageNamed:"violet" )
        rr.setScale(0.8)//1
        
        violetgalaxy.addChild(rr)
        
        
        violetgalaxy.run(bbSeq)
        
        
    }
    
     // MARK: add CGalaxy
    func addCollapsingGalaxy() {
        /* OpenSource https://pngtree.com/free-icon/load_439903 */
        
        galaxyB = SKEmitterNode(fileNamed:"worm")
        
        
        galaxyB.advanceSimulationTime(10)
        let randomStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPt = CGPoint(x:randomStart,y:self.size.height + 0  )
        let endpoint = CGPoint(x:randomEnd,y: -self.size.height)
        
        galaxyB.position = startPt
        galaxyB.zPosition = -1
        let movebb = SKAction.move(to: endpoint, duration: 5)
        let delBb = SKAction.removeFromParent()
        let bbSeq = SKAction.sequence([movebb,delBb])
        galaxyB.setScale(0.9)
        
        
        self.addChild(galaxyB)
        
        
        
        
        let rr = SKSpriteNode(imageNamed:"galaxy3" )
        rr.setScale(0.8)//1
        let oneRevolution:SKAction = SKAction.rotate(byAngle: CGFloat.pi * 2, duration: 30)
        let repeatRotation:SKAction = SKAction.repeatForever(oneRevolution)
        
        rr.run(repeatRotation)
        
        galaxyB.addChild(rr)
        galaxyB.run(bbSeq)
        
        
        
    }
      // MARK: add  commetR
    
    @objc func addCommetRightside(){
        
        
        //created in xcode spritekit particle file
        
        commetRight = SKEmitterNode(fileNamed:"fire1")
        commetRight.name =  "commetR"
        commetRight.advanceSimulationTime(20)
        
        let randomStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPt = CGPoint(x:randomStart,y:self.size.height + 0  )
        let endpoint = CGPoint(x:randomEnd,y: -self.size.height)
        
        commetRight.position = startPt
        
        let movebb = SKAction.move(to: endpoint, duration: 8)
        let delBb = SKAction.removeFromParent()
        let bbSeq = SKAction.sequence([movebb,delBb])
        commetRight.setScale(0.5)
        
        
        
        self.addChild(commetRight)
        
        
        commetRight.run(bbSeq)
        
        
        
    }
    
    
      // MARK: add commetL
    
    @objc func leftCommet() {
        
        //created in xcode spritekit particle file
        
        commetLeft = SKEmitterNode(fileNamed:"fire2")
        
        commetLeft.name = "commetL"
        let randomStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPt = CGPoint(x:randomStart,y:self.size.height + 0  )
        let endpoint = CGPoint(x:randomEnd,y: -self.size.height)
        
        commetLeft.position = startPt
        
        let movebb = SKAction.move(to: endpoint, duration: 8)
        let delBb = SKAction.removeFromParent()
        let bbSeq = SKAction.sequence([movebb,delBb])
        commetLeft.setScale(0.5)
        commetLeft.advanceSimulationTime(20)
        
        
        self.addChild(commetLeft)
        
        
        commetLeft.run(bbSeq)
        
        
    }
    
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == gameState.inGame {
            fireMissile()
        }
        
    }
    
      // MARK: add missile
    
    @objc func fireMissile() {
        
        let missile = SKSpriteNode(imageNamed:"bullet")/*OpenSource: https://opengameart.org */
        
        
        
        missile.name = "beam"
        missile.position = mainShip.position
        missile.zPosition = 1
        missile.position.y += 2
        
        missile.physicsBody = SKPhysicsBody(circleOfRadius: missile.size.width/2)
        missile.physicsBody?.isDynamic = true
        
        missile.physicsBody?.categoryBitMask = physicsCategories.photonTorpedoCategory
        missile.physicsBody?.collisionBitMask = physicsCategories.none
        missile.physicsBody?.contactTestBitMask = physicsCategories.alienCategory
        missile.physicsBody?.usesPreciseCollisionDetection = true
        missile.setScale(0.2)
        self.addChild(missile)
        
        
        let animationDuration:TimeInterval = 0.8
        
        let moveLaser = SKAction.moveTo(y: self.size.height + missile.size.height, duration:animationDuration)
        let deleteLaser = SKAction.removeFromParent()
        let LaserSequence = SKAction.sequence([LaserSound,moveLaser,deleteLaser])
        missile.run(LaserSequence)
        
    }
    
    
    public override func didSimulatePhysics() {
        if currentGameState == gameState.inGame {
            mainShip.position.x += xAccerlation * 50
            
            if mainShip.position.x < gameArea.minX + mainShip.size.width / 2{
                mainShip.position.x = gameArea.minX + mainShip.size.width / 2
                
            }
            else if mainShip.position.x > gameArea.maxX - mainShip.size.width / 2{
                mainShip.position.x = gameArea.maxX - mainShip.size.width / 2
                
            }
        }
    }
      // MARK: physcics body
    
    public func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
            
        }
            
        else {
            body1 = contact.bodyB
            body2 = contact.bodyA
            
        }
        if body1.categoryBitMask == physicsCategories.playerCategory && body2.categoryBitMask ==
            physicsCategories.alienCategory {
            //if player has hit the enemy
            
            explosionScene(position: body2.node!.position)
            
            if body1.node != nil{
                explosionScene(position: body1.node!.position)
            }
            if body2.node != nil{
                explosionScene(position: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            gameOver()
            
            
        }
        var body3 = SKPhysicsBody()
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body3 = contact.bodyB
            
        }
            
        else {
            body1 = contact.bodyB
            body3 = contact.bodyA
            
        }
        
        if body1.categoryBitMask == physicsCategories.playerCategory && body3.categoryBitMask ==
            physicsCategories.bbCategory {
            //if player has hit the blackhole
            
            changeBackground()
            blackhole.removeFromParent()
            body3.node?.removeFromParent()
            
            let wonGame = SKLabelNode(fontNamed:"AmericanTypewriter-Condensed")
            wonGame.text = "You Have Reached Our Starsystem"
            wonGame.fontSize = 20
            wonGame.fontColor = SKColor.lightText
            
            
            
            wonGame.position = CGPoint(x:self.size.width * 0.5,y:self
                .size.height * 0.55)
            
            self.addChild(wonGame)
            wonGame.alpha = 1
            var fadeOutAction = SKAction.fadeIn(withDuration: 2)
            fadeOutAction.timingMode = .easeInEaseOut
            wonGame.run(fadeOutAction, completion: {
                
                
            })
            
           
            fadeOutAction = SKAction.fadeIn(withDuration: 3.3)
            fadeOutAction.timingMode = .easeInEaseOut
            wonGame.run(fadeOutAction, completion: {
                
                wonGame.text = "Continue To Increase Score"
                wonGame.alpha = 1
            
                
            })
            fadeOutAction = SKAction.fadeIn(withDuration: 4.3)
            fadeOutAction.timingMode = .easeInEaseOut
            wonGame.run(fadeOutAction, completion: {
                
                wonGame.text = ""
                wonGame.alpha = 1
                wonGame.removeFromParent()
                
            })
            
        }
        
        
        
        
        
        if body1.categoryBitMask == physicsCategories.photonTorpedoCategory && body2.categoryBitMask == physicsCategories.alienCategory && (body2.node?.position.y)! < self.size.height
        {
            //if bullet hit enemy
            
            addScore()
            if body2.node != nil{
                explosionScene(position: body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            
        }
    }
    
      // MARK: add explosion
    
    func explosionScene(position:CGPoint){
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.removeAllActions()
        
        explosion.removeFromParent()
        explosion.removeAllChildren()
        
        
        explosion.position = position
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 0.4, duration: 0.5)
        let fadeout = SKAction.fadeOut(withDuration: 0.8)
        let delete = SKAction.removeFromParent()
        
        let explosionSeq = SKAction.sequence([explosionSound,scaleIn,fadeout,delete])
        explosion.run(explosionSeq)
    }
    
    
      // MARK: change background
    
    func changeBackground()  {
        
        enumerateChildNodes(withName: "change") {
            change ,stop in
            change.removeAllActions()
            
            
        }
        enumerateChildNodes(withName: "change") {
            back ,stop in
            
            let background = SKSpriteNode(imageNamed: "space1")
            background.size = self.size
            
            back.addChild(background)
        }
        enumerateChildNodes(withName: "ship"){
            ship ,stop  in
            let scaleIn = SKAction.scale(to: 0.2, duration: 0.8)
            let scaleOut = SKAction.scale(to:0.125,duration:0.8)
            
            let oneRevolution:SKAction = SKAction.rotate(byAngle: CGFloat.pi * 2, duration: 1)
            
            let seQ = SKAction.sequence([scaleIn,scaleOut,oneRevolution])
            ship.run(seQ)
        }
        
    }
    
}
