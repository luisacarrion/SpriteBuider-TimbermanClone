import Foundation

enum Position {
    case Left, Right
}

class MainScene: CCNode {
    
    let pointsThatCharacterOverlapsWithBase: CGFloat = 2
    let treeBaseWidth: CGFloat = 128
    var mainSceneWidth: CGFloat!
    
    var physicsNode: CCPhysicsNode!
    var character: CCSprite!
    

    func didLoadFromCCB() {
        // Assign scene width to position character with respect to the center
        mainSceneWidth = CCDirector.sharedDirector().viewSize().width
        
        // Load the character
        character = CCBReader.load("Character") as CCSprite
        self.addChild(character)
        moveCharacterTo(.Left)
        
        // Add tree sections to form the tree
        addTreeSection()
        
        // Allow user input
        self.userInteractionEnabled = true
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        // Determine if touch was at left or right and move the character accordingly
        let touchLocation = touch.locationInNode(self)

        if touchLocation.x <= mainSceneWidth / 2 {
            moveCharacterTo(.Left)
        } else {
            moveCharacterTo(.Right)
        }
    }
    
    func restart() {
        let scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(scene)
    }
    
    func moveCharacterTo(side: Position) {
        if (side == .Left) {
            character.flipX = false
            character.position.x = (mainSceneWidth / 2) - (treeBaseWidth / 2) + pointsThatCharacterOverlapsWithBase
        } else if (side == .Right) {
            character.flipX = true
            character.position.x = (mainSceneWidth / 2) + (treeBaseWidth / 2) + character.contentSize.width - pointsThatCharacterOverlapsWithBase
        }
    }
    
    func addTreeSection() {
        let treeSection = TreeSection()
        
        
    }
    

}
