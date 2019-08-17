//
//  SourseNewViewController.swift
//  newApp
//
//  Created by Yolankyi SERHII on 8/13/19.
//  Copyright © 2019 Yolankyi SERHII. All rights reserved.
//

import UIKit

class SourseNewViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        var selectSourses = ""
        for sours in sourse {
            selectSourses += "\(sours.key),"
        }
        if selectSourses != "" {
            selectSourses.removeLast()
        }
        ref.child("users").child("\(user!.uid)").child("sourse").setValue(selectSourses)
        self.performSegue(withIdentifier: "backToMainMenuFromSourses", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return allSoursesNews?["sources"].count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SoursesNews") as? SourcesOptionsCell
        cell?.data = allSoursesNews?["sources"][indexPath.row]
        if sourse["\(cell!.id ?? "")"] != nil {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? SourcesOptionsCell
        sourse["\(cell?.id ?? "")"] = "\(cell?.id ?? "")"
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? SourcesOptionsCell
        sourse["\(cell?.id ?? "")"] = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
    }
}
