//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by Finn Ebeling on 29.03.24.
//

import UIKit

public final class ErrorView: UIView {
    @IBOutlet private var button: UIButton!
    
    public var message: String? {
        button.title(for: .normal)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        button.setTitle(nil, for: .normal)
    }
}
