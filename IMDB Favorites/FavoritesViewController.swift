//
//  FirstViewController.swift
//  IMDB Favorites
//
//  Created by Olav on 03/12/16.
//  Copyright © 2016 Olav. All rights reserved.
//

import UIKit
import CoreData
import SugarRecord

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imdbAvgView: IMDBAverageView!
    
    var movies = [Movie]()
    var recommendedMode = false
    
    lazy var db: CoreDataDefaultStorage = {
        let store = CoreDataStore.named("movie_favorites")
        let bundle = Bundle(for: self.classForCoder)
        let model = CoreDataObjectModel.merged([bundle])
        let defaultStorage = try! CoreDataDefaultStorage(store: store, model: model)
        return defaultStorage
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recommendedMode {
            return getRecommendedMovies().count
        } else {
            return movies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie: Movie
        if recommendedMode {
            movie = getRecommendedMovies()[indexPath.row]
        } else {
            movie = movies[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        var newCellText = ""
        if (movie.isRecommended()) {
            newCellText += "★ "
        }
        newCellText += "\(movie.title) (\(movie.year))"
        cell.textLabel?.text = newCellText
        
        return cell
    }
    
    func getRecommendedMovies() -> [Movie] {
        return movies.filter{$0.isRecommended()}
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowMovieSegue", sender: movies[indexPath.row])
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            recommendedMode = false
        } else {
            recommendedMode = true
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let guest = segue.destination as! MovieDetailViewController
        guest.movie = (sender as! Movie)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        movies = try! db.fetch(FetchRequest<Movie>())
        
        // Set the average imdb rating
         imdbAvgView.calculateAverage(movies: movies)
        
        // If there are no favorites, add info how to add movies
        if movies.count == 0 {
            
            // Create an UILabel for showing info on no results
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No movie favorite yet. \n\n1. Go to search \n2. Enter a title and click search. \n3. Click a movie to add it. \n4. Click it again to remove it."
            noDataLabel.textColor = UIColor.blue
            
            // Make label multiline and automatically wrap by word
            noDataLabel.textAlignment = NSTextAlignment.left
            noDataLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            noDataLabel.numberOfLines = 0
            
            // Set the label to the background view
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = .none
            tableView.separatorStyle = .singleLine
        }
        
        tableView.reloadData()
    }

}

extension Movie {
    func isRecommended() -> Bool {
        if seen != nil &&
            Date().years(from: seen!) >= 3 &&
            rating > 7.0 {
            return true
        }
        return false
    }
}

// http://stackoverflow.com/a/27184261
extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
}

