//
//  SecondViewController.swift
//  IMDB Favorites
//
//  Created by Olav on 03/12/16.
//  Copyright © 2016 Olav. All rights reserved.
//

import UIKit

class AddMovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate, UISearchDisplayDelegate {

    @IBOutlet weak var movieSearch: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // End first responders on touches (remove keyboard)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "test"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("test: \(indexPath.row)")
    }


}

