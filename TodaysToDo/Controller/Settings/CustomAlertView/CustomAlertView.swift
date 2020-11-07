//
//  CustomAlertView.swift
//  TodaysToDo
//
//  Created by Nekokichi on 2020/11/07.
//

import UIKit

class CustomAlertView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }

    func loadNib() {
        let nib = UINib(nibName: "CustomAlertView", bundle: Bundle(for: type(of: self)))
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }

}
