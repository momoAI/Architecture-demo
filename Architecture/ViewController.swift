//
//  ViewController.swift
//  Architecture
//
//  Created by fooww on 2023/2/10.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.present(NewsListViewController(), animated: true)
    }
}

