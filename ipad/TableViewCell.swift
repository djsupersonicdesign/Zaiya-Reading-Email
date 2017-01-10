//
//  TableViewCell.swift
//  
//
//  Created by Macbook Pro on 03/11/2016.
//
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    //@IBOutlet weak var photo: UIImageView!

    @IBOutlet weak var mname: UILabel!
    @IBOutlet weak var mm: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
   /* func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let guest2 = segue.destination as! ViewThree
        guest2.msub = "JUTOT"
        guest2.mbody = "MOMOMOMOMO"
    }*/
    
}
