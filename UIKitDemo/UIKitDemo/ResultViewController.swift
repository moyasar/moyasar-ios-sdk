//
//  ResultViewController.swift
//  UIKitDemo
//
//  Created by Abdulaziz Alrabiah on 04/11/2023.
//

import UIKit

class ResultViewController: UIViewController {
    
    let resultTitle: String
    let resultSubTitle: String
    
    init(resultTitle: String, resultSubTitle: String) {
        self.resultTitle = resultTitle
        self.resultSubTitle = resultSubTitle
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        let resultTitleLabel = UILabel()
        resultTitleLabel.text = resultTitle
        resultTitleLabel.textAlignment = .center
        resultTitleLabel.frame.size = CGSize(width: view.frame.size.width - 50, height: 40)
        resultTitleLabel.textColor = .black
        resultTitleLabel.center = view.center
        view.addSubview(resultTitleLabel)
        
        let resultSubTitleLabel = UITextView()
        resultSubTitleLabel.text = resultSubTitle
        resultSubTitleLabel.textAlignment = .center
        resultSubTitleLabel.isEditable = false
        resultSubTitleLabel.frame.size = CGSize(width: view.frame.size.width - 50, height: 100)
        resultSubTitleLabel.textColor = .black
        resultSubTitleLabel.center = CGPoint(x: view.center.x, y: view.center.y + 60)
        view.addSubview(resultSubTitleLabel)
    }
}
