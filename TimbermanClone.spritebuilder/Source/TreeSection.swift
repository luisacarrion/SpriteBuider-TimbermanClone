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
    
    func addBranch() {
        let probability = arc4random() % 100
        NSLog("probability: \(probability)")
        if probability < 50 {
            addBranchAt(.Left)
        } else {
            addBranchAt(.Right)
        }
    }
    
    func addBranchAt(side: Position) {
        let branch = CCSprite.spriteWithImageNamed("assets/branch.png") as CCSprite
        branch.position.x = 2
        
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
