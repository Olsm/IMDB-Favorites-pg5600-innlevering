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
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieLastSeen: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieRuntime: UILabel!
    var movie : Movie? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = movie else {
            // TODO: Error handling
            return
        }
        
        let title = movie.title
        let year = String(describing: movie.year)
        let lastSeen = DateFormatter().string(for: movie.seen)
        let rating = String(movie.rating)
        //let genre = "Genre: "
        let runtime = movie.runtime
        
        movieTitle.text = "Title: \(title)"
        movieYear.text = "Year: \(year)"
        movieRating.text = "Rating: \(rating)"
        //movieGenre.text = "Genre: \(genre)"
        movieRuntime.text = "Runtime: \(runtime)"
        if let lastSeen = lastSeen {
            movieLastSeen.text = "Last Seen: \(lastSeen)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Show navigation bar only in this view
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

}
