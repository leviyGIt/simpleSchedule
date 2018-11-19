//
//  ViewController.swift
//  simpleSchedule
//
//  Created by kirshum on 19/11/2018.
//  Copyright © 2018 kirshum. All rights reserved.
//

import UIKit

class ScheduleVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ScheduleService.loadSchedule { (result) in
            switch result {
            case .success(let data): print(data)
            default: break
            }
        }
    }


}

