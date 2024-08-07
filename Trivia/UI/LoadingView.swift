//
//  LoadingView.swift
//  Trivia
//
//  Created by Chris Lucas on 18.09.20.
//  Copyright © 2020 HEIA-FR INFO. All rights reserved.
//

import Foundation
import UIKit

//
// Class : LoadingView
//
// Description : Allow to show an activity indicator (like a loading) in the center of the given view.
//
// Usage : 1) create the loading view with : var tableLoadingView = LoadingView(superView: self.view, navigationController: self.navigationController, label: "Loading...")
//         2) show or hide the loading view by respectively calling : tableLoadingView.showLoadingView() and tableLoadingView.hideLoadingView()
//
class LoadingView {

    private let loadingView = UIView()
    private let spinner = UIActivityIndicatorView()
    private let loadingLabel = UILabel()
    
    private let superView: UIView
    private let tag = 100
    
    init(superView: UIView, navigationController: UINavigationController?, label: String?) {
        self.superView = superView
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (superView.frame.width / 2) - (width / 2)
        let y = (superView.frame.height / 2) - (height / 2) - (superView is UITableView ? (navigationController?.navigationBar.frame.height)! : 0)
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)

        // Sets loading text
        if label != nil {
            loadingLabel.textColor = .gray
            loadingLabel.textAlignment = .center
            loadingLabel.text = label
            loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        }

        // Sets spinner
        spinner.style = .medium
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
    }

    // Set the activity indicator into the main view
    func showLoadingView() {

        spinner.startAnimating()
        
        loadingView.tag = tag
        superView.addSubview(loadingView)

    }

    // Remove the activity indicator from the main view
    func hideLoadingView() {

        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        superView.viewWithTag(tag)?.removeFromSuperview()

    }

}
