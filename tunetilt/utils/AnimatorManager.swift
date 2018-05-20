//
//  AnimatorController.swift
//  pongagon-2
//
//  Created by Jonathan Moallem on 24/4/18.
//  Copyright © 2018 Sudo-Code Software. All rights reserved.
//

import UIKit
import CoreMotion

class AnimatorManager {
    
    // Fields
    var animator: UIDynamicAnimator
    var motionManager: CMMotionManager?
    var timer: Timer?
    
    // Behaviours
    var gravity: UIGravityBehavior
    var elasticity: UIDynamicItemBehavior
    var collision: UICollisionBehavior
    
    init(context: UIView) {        
        // Create the animator and motion manager
        animator = UIDynamicAnimator(referenceView: context)
        motionManager = CMMotionManager()
        
        // Add gravity
        gravity = UIGravityBehavior()
        animator.addBehavior(gravity)
        
        // Add elasticity
        elasticity = UIDynamicItemBehavior()
        elasticity.elasticity = 0.8
        animator.addBehavior(elasticity)
        
        // Add collision
        collision = UICollisionBehavior()
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
    }
    
    func startGravityUpdates() {
        updateGravity()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer: Timer) in
            self.updateGravity()
        })
    }
    
    func addObject(_ object: UIView) {
        // Add the item to the collidable objects
        gravity.addItem(object)
        elasticity.addItem(object)
        collision.addItem(object)
    }
    
    func removeObject(_ object: UIView) {
        // Add the item to the collidable objects
        gravity.removeItem(object)
        elasticity.removeItem(object)
        collision.removeItem(object)
    }
    
    func updateGravity() {
        gravity.gravityDirection = currentGravityDirection()
    }
    
    func currentGravityDirection() -> CGVector {
        var gravityDirection = CGVector()
        motionManager!.startAccelerometerUpdates()
        if let accelerometerData = motionManager!.accelerometerData {
            gravityDirection = CGVector(dx: accelerometerData.acceleration.x * 2, dy: -accelerometerData.acceleration.y * 2)
        }
        return gravityDirection
    }
}
