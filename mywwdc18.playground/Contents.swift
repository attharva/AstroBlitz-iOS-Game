import PlaygroundSupport
import SpriteKit

/*:
# The Multiverse

 * **Overview**:
 
 1. Game is made by considering size of iPad 9.7 pro.
 
 2. Game works in portrait mode.
 
 3. Adjust game level accordingly.
 
 4. Game works on iPad, it uses core motion.
 
 * **Instructions**:
 
 1. You got to get a threshold score in order to level up and to increase the score, you got to shoot the asteroids.
 
 2. If you are hit by an asteroid then your game is over.
 
 3. As this is a motion sensor game, steer your iPad to dodge asteroids.
 
 5. Throughout journey towards blackhole you will have spectacular view of heavenly bodies.
 
 4. Once the score is above 750, a blackhole would appear on your screen, all you have to do is pass through it to reach our mother Earth. If you dont do so the game is over and you lose.
 
 * **Sources**:
 
 1. All the pngs are from openSource website mentioned below
 * ### https://opengameart.org
 * ### https://pngtree.com
 2. Particle files are created in xcode by using spritekit particle file by me.
 3. Background Music and other sounds are produced by my friends Aditya Lokhande and Mouktik Joshi. Aditya is pursuing sound engineering as a profession and Mouktik does sound production as a hobby.
 * ### moutik.joshi@gmail.com
 * ### adityanlokhande@gmail.com

*/

let width = 400
let height = 680


// Code to bring the game
let spriteView = SKView(frame: CGRect(x: 0, y: 0, width: width, height: height))


let scene = MainScene(size: CGSize(width: width, height: height))
spriteView.presentScene(scene)


PlaygroundPage.current.liveView = spriteView

