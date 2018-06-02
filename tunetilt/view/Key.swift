//
//  Key.swift
//  tunetilt
//
//  Created by Jonathan Moallem on 28/5/18.
//  Copyright © 2018 Blinking Light Studios. All rights reserved.
//

import UIKit

class Key: UIButton {
    
    // Fields
    var charges: Int = 1
    weak var delegate: KeyDelegate?
    
    override init(frame: CGRect) {
        // Get a randomly assigned type
        super.init(frame: frame)
        
        // Set up default properties
        self.layer.borderWidth = 3
        self.layer.cornerRadius = (bounds.maxX/2)
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.titleLabel?.font =  UIFont(name: "GermaniaOne-Regular", size: bounds.maxX/2)
    }
    
    func setNote(to note: String) {
        setTitle(note, for: .normal)
        
        if note.last == "#" {
            backgroundColor = UIColor.black
            setTitleColor(UIColor.white , for: .normal)
        }
        else {
            backgroundColor = UIColor.white
            setTitleColor(UIColor.black , for: .normal)
        }

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Send touch event to deleagte callback
        delegate?.onKeyTapped(self)
    }
}

// The pong's delegate protocol
protocol KeyDelegate: AnyObject {
    func onKeyTapped(_ key: Key)
}
