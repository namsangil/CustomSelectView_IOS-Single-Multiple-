//
//  ViewController.swift
//  CustomSelectViewIOS
//
//  Created by nam on 2017. 11. 2..
//  Copyright © 2017년 nam. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CustomSelectViewControllerSingleSelectDelegate, CustomSelectViewControllerMultiSelectDelegate{
    @IBOutlet weak var singleChangeBtn: UIButton!
    @IBOutlet weak var multiChangeBtn: UIButton!
    let Keys : [String] = ["1","2","3","4"]
    let values : [String] = ["One", "Two", "Three", "Four"]
    var selectKeys : [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        selectKeys = Keys
        self.singleChangeBtn.backgroundColor = UIColor(red: 100, green: 100, blue: 100)
        self.multiChangeBtn.backgroundColor = UIColor(red: 100, green: 100, blue: 100)
        self.singleChangeBtn.setTitle(values[0], for: .normal)
        self.multiChangeBtn.setTitle("전체", for: .normal)
        self.singleChangeBtn.addTarget(self, action: #selector(changeSingle), for: .touchUpInside)
        self.multiChangeBtn.addTarget(self, action: #selector(changeMultiple), for: .touchUpInside)
        
        

        
    }
    @objc func changeSingle(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc: CustomSelectViewController = storyboard.instantiateViewController(withIdentifier: "CustomSelectViewController") as! CustomSelectViewController
        vc.keyList = Keys
        vc.valueList = values
        vc.selectMode = .SINGLETYPE
        vc.singleSelectDelegate = self
        vc.titleName = "select view 1"
        vc.singleSelectedKey = Keys[0]
        
        self.present(vc, animated: true, completion: nil)
    }
    @objc func changeMultiple(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc: CustomSelectViewController = storyboard.instantiateViewController(withIdentifier: "CustomSelectViewController") as! CustomSelectViewController
        vc.keyList = Keys
        vc.valueList = values
        vc.selectMode = .MULTITYPE
        vc.multiSelectDelegate = self
        vc.multiSelectedKeyList = selectKeys
        vc.titleName = "select view 2"
        
        self.present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onSelectItem(_ target: CustomSelectViewController, _ key: String) {
        for (idx, item) in Keys.enumerated(){
            if(item == key) {
                singleChangeBtn.setTitle(values[idx], for: .normal)
            }
        }
    }
    
    func onSelectItems(_ target: CustomSelectViewController, _ keys: [String]) {
        selectKeys = keys
        var str = [String]()
        for (_, item1) in keys.enumerated(){
            for(idx2, item2) in Keys.enumerated(){
                if(item1 == item2){
                    str.append(values[idx2])
                    break
                }
            }
        }
        multiChangeBtn.setTitle("\(str)", for: .normal)
    }


}

