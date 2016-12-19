//
//  MovieDetailViewController.swift
//  IMDB Favorites
//
//  Created by Olav on 04/12/16.
//  Copyright © 2016 Olav. All rights reserved.
//

import UIKit
import CoreData
import SugarRecord

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieRuntime: UILabel!
    @IBOutlet weak var movieLastSeenBtn: UIButton!
    @IBOutlet weak var movieCountry: UILabel!
    @IBOutlet weak var movieLastSeenPcr: UIDatePicker!
    @IBOutlet weak var movieDeleteBtn: UIStackView!
    
    var movie : Movie? = nil
    
    lazy var db: CoreDataDefaultStorage = {
        let store = CoreDataStore.named("movie_favorites")
        let bundle = Bundle(for: self.classForCoder)
        let model = CoreDataObjectModel.merged([bundle])
        let defaultStorage = try! CoreDataDefaultStorage(store: store, model: model)
        return defaultStorage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = movie else {
            // TODO: Error handling
            return
        }
        
        // Add the movie details to view
        movieTitle.text = movie.title
        movieYear.text = "Year: \(String(movie.year))"
        movieRating.text = "Rating: \(String(movie.rating))"
        movieGenre.text = "Genre: \(movie.genre)"
        movieRuntime.text = "Runtime: \(movie.runtime)"
        movieCountry.text = "Country: \(movie.country)"
        
        // Enable/disable picker and button for last seen date
        let seenDate = movie.seen
        if DateFormatter().string(for: seenDate) != nil {
            movieLastSeenPcr.date = movie.seen!
            movieLastSeenBtn.setTitle("Remove Last Seen Date", for: .normal)
        } else {
            movieLastSeenPcr.isHidden = true
        }
    }
    
    @IBAction func movieLastSeenToggle(_ sender: UIButton) {
        if (movieLastSeenPcr.isHidden) {
            movieLastSeenPcr.isHidden = false
            movieLastSeenBtn.setTitle("Remove Last Seen Date", for: .normal)
            let lastSeenDate = movieLastSeenPcr.date
            updateMovieLastSeenDate(lastSeen: lastSeenDate)
        } else {
            movieLastSeenPcr.isHidden = true
            movieLastSeenBtn.setTitle("Add Last Seen Date", for: .normal)
            updateMovieLastSeenDate(lastSeen: nil)
        }
    }
    
    @IBAction func deleteMovie(_ sender: UIButton) {
        do {
            try db.operation { (context, save) throws -> Void in
                let movie = try context.request(Movie.self).filtered(with: "id", equalTo: (self.movie?.id)!).fetch().first
                try context.remove([movie!])
                save()
                // Make sure to return to favorites list
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        catch {
            // TODO: Error handling
        }
    }
    
    @IBAction func movieLastSeenDateChanged(_ sender: UIDatePicker) {
        updateMovieLastSeenDate(lastSeen: movieLastSeenPcr.date)
    }
    
    func updateMovieLastSeenDate(lastSeen: Date?) {
        do {
            try db.operation { (context, save) throws -> Void in
                self.movie?.seen = lastSeen
                save()
            }
        }
        catch {
            // TODO: Error handling
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
