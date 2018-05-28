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
    weak var delegate: KeyDelegate?
    
    override init(frame: CGRect) {
        // Get a randomly assigned type
        super.init(frame: frame)
        
        // Set up default properties
        self.layer.borderWidth = bounds.maxX/20
        self.titleLabel!.adjustsFontSizeToFitWidth = true
        self.layer.cornerRadius = (bounds.maxX/2)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.masksToBounds = true;
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
        delegate?.onKeyTapped(titleLabel!.text!)
    }
}

// The pong's delegate protocol
protocol KeyDelegate: AnyObject {
    func onKeyTapped(_ note: String)
}
