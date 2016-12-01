//
//  TutorialInstructionsViewController.swift
//  AliveSFU
//
//  Created by Jim on 2016-11-30.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class TutorialInstructionsViewController: UIViewController {

    @IBOutlet weak var targetMuscleLabel: UILabel!
    @IBOutlet weak var equipmentNameLabel: UILabel!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelView: UIView!

    var exercise = TutorialExercise()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Add SFU Red color to border
        let borderColor = UIColor.init(red: 166, green: 25, blue: 46).cgColor
        labelView.layer.borderColor = borderColor
        
        configurePage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    //Configures the size of the instructions page and update labels accordingly
    func configurePage() {
        equipmentNameLabel.text = exercise.equipmentName
        exerciseNameLabel.text = exercise.name
        targetMuscleLabel.text = exercise.targetMuscle
        let instructionsImage = UIImage(named:"Pec Dec Instructions")
        let sizeMultiplier = self.view.frame.width / (instructionsImage?.size.width)!
        let imageView = UIImageView(frame : CGRect(x: 0, y: 0, width: scrollView.frame.width, height: (instructionsImage?.size.height)!*sizeMultiplier))
        imageView.image = UIImage(named:"Pec Dec Instructions")
        scrollView.contentSize = imageView.frame.size
        scrollView.addSubview(imageView)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
