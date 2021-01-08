//
//  MonthChartsViewController.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2021/1/7.
//

import UIKit

class MonthChartsViewController: BaseViewController {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var image: UIImage!
    let originFrame = CGRect(x: 0, y: -40, width: Constants.screenWidth, height: 600)
    
    private let topInset: CGFloat = 500
    private let maxPullDownDistance: CGFloat = 40
    private var lastOffsetY: CGFloat = -500
    private var didEndDragging = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headImageView.frame = originFrame
        headImageView.image = image
    }
    
    override func setupSubviews() {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        tableView.register(nibWithCellClass: MonthDescriptionCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    

}

extension MonthChartsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MonthDescriptionCell.self, for: indexPath)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let start = -topInset
        let end = start - maxPullDownDistance
        switch offsetY {
        case end ..< start:
            if didEndDragging {
                return
            }
            var bounds = headImageView.bounds
            bounds.size.height -= lastOffsetY - offsetY
            headImageView.bounds = bounds
            lastOffsetY = offsetY
        case -Constants.screenHeight ..< end:
            navigationController?.popViewController(animated: true)
        default:
            return
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        didEndDragging = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        didEndDragging = true
        let start = -topInset
        let end = start - maxPullDownDistance
        switch scrollView.contentOffset.y {
        case end ..< start:
            lastOffsetY = -topInset
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let `self` = self else { return }
                self.headImageView.frame = self.originFrame
            }
        default:
            return
        }
    }
    
}
