import Foundation

enum Position {
    case Left, Right
}

enum DrawingOrder: Int {
    case DrawingOrderTree, DrawingOrderCharacter
}

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    // Sizes for calculating positions
    let pointsThatCharacterOverlapsWithBase: CGFloat = 2
    let treeBaseWidth: CGFloat = 128
    let treeBaseHeight: CGFloat = 26
    let treeSectionHeight: CGFloat = 80 // A tree section is the body + branches
    var mainSceneWidth: CGFloat!
    var mainSceneHeight: CGFloat!
    
    // CCNodes
    var physicsNode: CCPhysicsNode!
    var character: CCSprite!
    var timerBar: CCSprite!
    var treeSections = [TreeSection]()
    
    var btnRestart: CCButton!
    var lblScore: CCLabelTTF!
    
    // Game variables
    var lastTreeSectionHadBranch = false
    var collidedWithBranch = false
    var ranOutOfTime = false
    var userTouched = false
    var score = 0
    var timer: Float = 5
    let timerMaxTime: Float = 10
    
    func didLoadFromCCB() {
        // Assign scene width and height
        mainSceneWidth = CCDirector.sharedDirector().viewSize().width
        mainSceneHeight = CCDirector.sharedDirector().viewSize().height
        
        // Load the character
        character = CCBReader.load("Character") as CCSprite
        character.zOrder = DrawingOrder.DrawingOrderCharacter.rawValue
        physicsNode.addChild(character)
        moveCharacterTo(.Left)
        
        // Add tree sections until the tree fills the screen
        while isTreeSmallerThanScreen() {
            addTreeSection()
        }
        
        // Allow user input
        self.userInteractionEnabled = true
        
        physicsNode.collisionDelegate = self
        // Enable debugDraw
        //physicsNode.debugDraw = true
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        // Process touches only if the game hasn't ended
        if !isGameOver() {
            userTouched = true
            
            incrementTimer()
        
            // Determine if touch was at left or right and move the character accordingly
            let touchLocation = touch.locationInNode(self)
            
            if touchLocation.x <= mainSceneWidth / 2 {
                moveCharacterTo(.Left)
            } else {
                moveCharacterTo(.Right)
            }
        }
    }
    
    override func update(delta: CCTime) {
        if isGameOver() {
            gameOver()
        } else {
            decrementTimerBy(Float(delta))
            updateTimerBar()
            
            if userTouched {
                // Remove bottom tree section to simulate cutting the tree
                removeBottomTreeSection()
                updateScore()
                userTouched = false
            }
        }
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

        physicsNode.addChild(treeSection)
        treeSections.append(treeSection)
        
        // Add branches only if 2 section without branches have been added, so that the character doesn't collide with branches and has some space at the beginning
        if treeSections.count > 2 {
            // If the last piece did not have a branch then there should be 45% chance of left branch, 45% chance of right branch, and 10% chance of no branch
            var probLeft = 0.45
            var probRight = 0.45
            var probNone = 0.10
            
            // There should never be two tree pieces with branches in a row, so if we just added a section with a branch, we add a section with no branches
            if lastTreeSectionHadBranch {
                probLeft = 0
                probRight = 0
                probNone = 1
            }
            
            lastTreeSectionHadBranch = treeSection.addBranch(probLeft, probRight: probRight, probNone: probNone)
            
        }
    }
    
    func removeBottomTreeSection() {
        var index = 0
        treeSections[index].removeFromParent()
        treeSections.removeAtIndex(index)
        
        // Move remaining tree sections down, so there is a new bottom tree section
        for treeSection in treeSections {
            treeSection.position.y = treeBaseHeight + treeSectionHeight * CGFloat(index++)
        }
        
        // Add a new tree section to replace the one that was removed
        addTreeSection()
    }
    
    func isTreeSmallerThanScreen() -> Bool {
        return ((CGFloat(treeSections.count) * treeSectionHeight + treeBaseHeight) < mainSceneHeight)
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, character: CCNode!, branch: CCNode!) -> Bool {
        collidedWithBranch = true
        return true
    }
    
    func incrementTimer() {
        timer = clampf(timer + 0.25, 0, timerMaxTime)
    }
    
    func decrementTimerBy(amount: Float) {
        timer = clampf(timer - amount, 0, timerMaxTime)
        if timer == 0 {
            ranOutOfTime = true
        }
    }
    
    func updateTimerBar() {
        timerBar.scaleX = timer / 10.0
    }
    
    func updateScore() {
        score++
        lblScore.string = String(score)
    }
    
    func isGameOver() -> Bool{
        return collidedWithBranch || ranOutOfTime
    }
    
    func gameOver() {
        btnRestart.visible = true
        self.userInteractionEnabled = false
    }
    
    func restart() {
        let scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(scene)
    }
    
}
