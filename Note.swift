//
//  ViewController.swift
//  ToDoList
//
//  Created by Phong Dinh on 4/6/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var DeleteButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var Add_Edit: UIBarButtonItem!
    var tasks = [String]()
    var index = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        DeleteButton.isEnabled = false
        self.title = "Tasks"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Setup
        
        if !UserDefaults().bool(forKey: "setup") {
            UserDefaults().setValue(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
        }
        // Get all current saved tasks
        updateTask()
        
    }
    
    func updateTask() {
        
        tasks.removeAll()
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        for x in 0..<count {
            if let task = UserDefaults().value(forKey: "task_\(x + 1)") as? String {
                tasks.append(task)
            }
        }
        tableView.reloadData()
    }
    @IBAction func TapDelete(_ sender: Any) {
        if(DeleteButton.isEnabled) {
            tasks.remove(at: index)
            UserDefaults().set(tasks.count, forKey: "count")
            tableView.reloadData()
            DeleteButton.isEnabled = false
            Add_Edit.title = "Add"
        }
    }
    @IBAction func Check(_ sender: Any) {
        if(Add_Edit.title == "Add") {
            TapAdd()
        } else {
            TapEdit()
        }
    }
    func TapAdd() {
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        vc.title = "New Task"
        vc.update = {
            DispatchQueue.main.async {
                self.updateTask()
            }
        }
        index = -1
        navigationController?.pushViewController(vc, animated: true)
        
    }
    func TapEdit() {
        let edit = storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
        edit.title = "Edit Task"
        edit.update = {
            DispatchQueue.main.async {
                self.updateTask()
            }
        }
        navigationController?.pushViewController(edit, animated: true)
        guard let check = UserDefaults().value(forKey: "PressBack") as? Bool else {
            return
        }
        if check == false {
            print(check)
            index = -1
            Add_Edit.title = "Add"
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if index == indexPath.row {
            tableView.deselectRow(at: indexPath, animated: true)
            Add_Edit.title = "Add"
            index = -1
            DeleteButton.isEnabled = false
        }
        else {
            
            //select = indexPath.row
            DeleteButton.isEnabled = true
            index = indexPath.row
            Add_Edit.title = "Edit"
            UserDefaults().set(true, forKey: "PressBack")
            UserDefaults().set(index, forKey: "EditNum")
            UserDefaults().set(tasks[index], forKey: "EditString")
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row]
        
        return cell
    }
    
}
