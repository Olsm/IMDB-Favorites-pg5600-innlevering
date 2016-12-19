//
//  IMDBAverageView.swift
//  IMDB Favorites
//
//  Created by Olav on 18/12/16.
//  Copyright © 2016 Olav. All rights reserved.
//

import UIKit

class IMDBAverageView: UIView {
    
    @IBOutlet weak var avgLabel: UILabel!
    
    @IBOutlet var view: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    func initSubViews() {
        let nib = UINib(nibName: "IMDBAverageView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        view.frame = bounds
        addSubview(view)
    }
    
    // Set the average imdb rating
    func calculateAverage(movies: [Movie]) {
        let avgString = "Average in IMDB: "
        let sum = movies.reduce(0.0) {$0 + ($1.rating)}
        if sum == 0 {
            avgLabel.text = "\(avgString)-"
        } else {
            let average = sum / Double(movies.count)
            avgLabel.text = "\(avgString)\(average.roundTo(places: 1))"
        }
        avgLabel.sizeToFit()
    }
    
}

// from http://stackoverflow.com/a/32581409
extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
