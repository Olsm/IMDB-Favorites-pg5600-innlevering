//
//  MovieDetailViewController.swift
//  IMDB Favorites
//
//  Created by Olav on 04/12/16.
//  Copyright © 2016 Olav. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieTitle: UILabel!
    
    var mTitle = "Title"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieTitle.text = mTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}