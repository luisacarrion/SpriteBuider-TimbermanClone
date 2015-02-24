import Foundation

enum Position {
    case Left, Right
}

class MainScene: CCNode {
    
    let pointsThatCharacterOverlapsWithBase: CGFloat = 2
    let treeBaseWidth: CGFloat = 128
    let treeBaseHeight: CGFloat = 26
    let treeSectionHeight: CGFloat = 80
    var mainSceneWidth: CGFloat!
    var mainSceneHeight: CGFloat!
    var treeSections = [TreeSection]()
    
    var physicsNode: CCPhysicsNode!
    var character: CCSprite!
    
    var btnRestart: CCButton!
    

    func didLoadFromCCB() {
        // Assign scene width to position character with respect to the center
        mainSceneWidth = CCDirector.sharedDirector().viewSize().width
        mainSceneHeight = CCDirector.sharedDirector().viewSize().height
        
        // Load the character
        character = CCBReader.load("Character") as CCSprite
        physicsNode.addChild(character)
        moveCharacterTo(.Left)
        
        // Add tree sections until the tree fills the screen
        while ((CGFloat(treeSections.count) * treeSectionHeight + treeBaseHeight) < mainSceneHeight) {
            addTreeSection()
        }
        
        
        
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
        let treeSection = CCBReader.load("TreeSection") as TreeSection
        
        treeSection.positionType.xUnit = CCPositionUnit.Normalized
        treeSection.position.x = 0.5
        treeSection.position.y = treeBaseHeight + treeSectionHeight * CGFloat(treeSections.count)

        // Add branches only if the first 2 sections without branches have been added
        if treeSections.count >= 2 {
            treeSection.addBranch()
        }
        
        physicsNode.addChild(treeSection)
        treeSections.append(treeSection)
    }
    

}
