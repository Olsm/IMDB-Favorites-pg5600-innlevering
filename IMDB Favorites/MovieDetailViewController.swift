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
    var db: CoreDataDefaultStorage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = movie else {
            // TODO: Error handling
            return
        }
        guard db != nil else {
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
        } else {
            movieLastSeenPcr.isHidden = true
        }
        updateMovieLastSeenPcr()
    }
    
    @IBAction func movieLastSeenToggle(_ sender: UIButton) {
        if (movieLastSeenPcr.isHidden) {
            movieLastSeenPcr.isHidden = false
            updateMovieLastSeenDate(lastSeen: movieLastSeenPcr.date)
        } else {
            movieLastSeenPcr.isHidden = true
            updateMovieLastSeenDate(lastSeen: nil)
        }
        
        updateMovieLastSeenPcr()
    }
    
    func updateMovieLastSeenPcr() {
        if (movieLastSeenPcr.isHidden) {
            movieLastSeenBtn.setTitle("Add Last Seen Date", for: .normal)
        } else {
            movieLastSeenBtn.setTitle("Remove Last Seen Date", for: .normal)
            
            // Set minimum year for datepicker
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            let minimumDate = formatter.date(from: String(movie!.year))
            
            // TODO: Set minimum date as release date
            //formatter.dateFormat = "dd mmm yyyy"
            //let releaseDate = formatter.date(from: movie.release)
            
            movieLastSeenPcr.minimumDate = minimumDate
            movieLastSeenPcr.maximumDate = Date()
        }
    }
    
    @IBAction func deleteMovie(_ sender: UIButton) {
        do {
            try db!.operation { (context, save) throws in
                
                // Delete movie from context and database
                let movie: Movie? = try context.request(Movie.self).filtered(with: "id", equalTo: self.movie!.id).fetch().first
                if let movie = movie {
                    try context.remove(movie)
                    save()
                    
                    // Go back to favorites view
                    let _ = self.navigationController?.popViewController(animated: true)
                }
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
            try db!.operation { (context, save) throws -> Void in
                let movie = try context.request(Movie.self).filtered(with: "id", equalTo: self.movie!.id).fetch().first
                if let movie = movie {
                    movie.seen = lastSeen
                    save()
                }
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
