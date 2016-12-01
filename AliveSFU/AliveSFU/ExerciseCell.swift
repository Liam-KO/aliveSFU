//
//  ExerciseCell.swift
//  AliveSFU
//
//  Created by Jim on 2016-11-27.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class ExerciseCell: UICollectionViewCell {
    
    @IBOutlet weak var exerciseThumbnail: UIImageView!
    @IBOutlet weak var exerciseName: UILabel!

    func configure(exercise : TutorialExercise)
    {
        self.exerciseThumbnail.image = UIImage(named: exercise.name)
        exerciseName.text = exercise.name
    }
}
