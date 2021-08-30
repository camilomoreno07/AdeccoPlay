//
//  SummaryViewController.swift
//  AdeccoPlay
//
//  Created by Camilo Moreno on 29/08/21.
//

import UIKit

class SummaryViewController: UIViewController{

    var overview: String?
    var imageLink: String?
    
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var summaryText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Recibimos la data obtenida en el MovieViewController y la ponemos en los IBOutlets
        summaryText.text = overview
        let defaultLink = "https://image.tmdb.org/t/p/w500/"
        let completeLink = defaultLink + imageLink!
        backdropImage.downloadedFrom(link: completeLink)
        
    }

}


