//
//  ViewController.swift
//  SeamlessSlideUpScrollViewSample
//
//  Created by indy on 2016. 6. 7..
//  Copyright © 2016년 Gen X Hippies Company. All rights reserved.
//

import UIKit
import SeamlessSlideUpScrollView

class ViewController: UIViewController {

    @IBOutlet weak var slideUpView: SeamlessSlideUpView!
    @IBOutlet var tableView: SeamlessSlideUpTableView!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var bgBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.reloadData()
        
        slideUpView.delegate = self
    }

    @IBAction func toggleSlideUpView(_ sender: AnyObject) {
        
        if self.slideUpView.isHidden {
            self.slideUpView.show(expandFull: false)
            self.button.setTitle("Slide Down", for: UIControlState())
        } else {
            self.slideUpView.hide()
            self.button.setTitle("Slide Up", for: UIControlState())
        }
    }
}

extension ViewController: SeamlessSlideUpViewDelegate {
    
    func slideUpViewWillAppear(_ slideUpView: SeamlessSlideUpView, height: CGFloat) {
        self.bgBottomConstraint.constant = height
        UIView.animate(withDuration: 0.2, animations: { [weak self] in self?.view.layoutIfNeeded() }) 
        self.button.setTitle("Slide Down", for: UIControlState())
    }
    
    func slideUpViewDidAppear(_ slideUpView: SeamlessSlideUpView, height: CGFloat) {
    }
    
    func slideUpViewWillDisappear(_ slideUpView: SeamlessSlideUpView) {
        self.bgBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.2, animations: { [weak self] in self?.view.layoutIfNeeded() }) 
        self.button.setTitle("Slide Up", for: UIControlState())
    }

    func slideUpViewDidDisappear(_ slideUpView: SeamlessSlideUpView) {
    }
    
    func slideUpViewDidDrag(_ slideUpView: SeamlessSlideUpView, height: CGFloat) {
        self.bgBottomConstraint.constant = min(height, self.slideUpView.bounds.height - self.slideUpView.topWindowHeight)
        self.view.layoutIfNeeded()
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        guard let label = cell.viewWithTag(1) as? UILabel else {
            return UITableViewCell()
        }
        
        label.text = "\((indexPath as NSIndexPath).row): Table row"
        
        return cell
    }
    
}
