//
//  TaskViewController.swift
//  ToDoList
//
//  Created by Phong Dinh on 4/6/24.
//

import UIKit

class TaskViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var field: UITextField!
    
    var update: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        guard let edit_text = UserDefaults().value(forKey: "EditString") as? String else {
            return
        }
        field.text = edit_text
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
        
        
        // Do any additional setup after loading the view.
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        
//        saveTask()
//        
//        return true
//    }
    @objc func saveTask() {
        guard let text = field.text, !text.isEmpty else {
            return
        }
        guard let edit_num = UserDefaults().value(forKey: "EditNum") as? Int else {
            return
        }
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        for x in 0..<count {
            if x == edit_num {
                UserDefaults().set(text, forKey: "task_\(x + 1)")
                break
            }
        }
        UserDefaults().set(false, forKey: "PressBack")
        update?()
        navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
