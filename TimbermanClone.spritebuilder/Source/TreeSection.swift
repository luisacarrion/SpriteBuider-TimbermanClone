//
//  TreeSection.swift
//  TimbermanClone
//
//  Created by Maria Luisa on 2/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class TreeSection: CCNode {

    var leftBranchContainer: CCNode!
    var rightBranchContainer: CCNode!
    
    func didLoadFromCCB() {
        self.zOrder = DrawingOrder.DrawingOrderTree.rawValue
    }
    
    func addBranch(probLeft: Double, probRight: Double, probNone: Double) -> Bool {
        
        let probability: Double = Double(arc4random() % 100) / 100
        NSLog("probability: \(probability)")
        
        var branchAdded = false
        
        if probability < probLeft {
            NSLog("left")
            addBranchAt(.Left)
            branchAdded = true
        } else if probability < probLeft + probRight {
            NSLog("right")
            addBranchAt(.Right)
            branchAdded = true
        }

        NSLog("branchAdded: \(branchAdded)")
        return branchAdded
    }
    
    func addBranchAt(side: Position) {
        let branch = CCSprite.spriteWithImageNamed("assets/branch.png") as CCSprite
        branch.position.x = 2

        branch.physicsBody = CCPhysicsBody(rect: CGRect(origin: ccp(0, 0), size: branch.contentSize), cornerRadius: CGFloat(0))
        branch.physicsBody.type = CCPhysicsBodyType.Static
        branch.physicsBody.collisionType = "branch"
        branch.physicsBody.sensor = true
        
        if side == .Left {
            branch.flipX = true
            branch.positionType = CCPositionTypeMake(CCPositionUnit.Points, CCPositionUnit.Points, CCPositionReferenceCorner.BottomRight)
            branch.anchorPoint = ccp(1, 0)
            leftBranchContainer.addChild(branch)
        } else if side == .Right {
            branch.anchorPoint = ccp(0, 0)
            rightBranchContainer.addChild(branch)
        }
    }
}
