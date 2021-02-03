//
//  MonthDescriptionCell.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2021/1/8.
//

import UIKit

class MonthDescriptionCell: RxTableViewCell {

    @IBOutlet weak var monthView: MonthDescriptionView!
    @IBOutlet weak var weightValueLabel: UILabel!
    @IBOutlet weak var weightTitleLabel: UILabel!
    @IBOutlet weak var weightUnitLabel: UILabel!
    @IBOutlet weak var burpeesValueLabel: UILabel!
    @IBOutlet weak var burpeesTitleLabel: UILabel!
    @IBOutlet weak var pushUpsValueLabel: UILabel!
    @IBOutlet weak var pushUpsTitleLabel: UILabel!
    @IBOutlet weak var fullBodyValueLabel: UILabel!
    @IBOutlet weak var fullBodyTitleLabel: UILabel!
    
    let viewModel = MonthDescriptionCellViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupSubviews() {
        weightTitleLabel.text = "Weight \n Changed"
    }
    
    override func setupBindings() {
        viewModel.dataSource
            .flatMapLatest { Observable.just($0.month) }
            .bind(to: monthView.monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dataSource
            .flatMapLatest { Observable.just($0.emoji) }
            .bind(to: monthView.emojiLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dataSource
            .flatMapLatest { data -> Observable<String> in
                let days = data.days.filter { $0.weight > 0 }
                guard let first = days.first, let last = days.last else {
                    return Observable.just("0")
                }
                let deta = last.weight - first.weight
                let symbol = deta > 0 ? "+" : "-"
                let value = symbol + String(format: "%.1f", deta.abs)
                return Observable.just(value)
            }
            .bind(to: weightValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dataSource
            .flatMapLatest { data -> Observable<String> in
                let value = data.days.map { $0.burpees }.reduce(0) { $0 + $1 }
                return Observable.just("\(value)")
            }
            .bind(to: burpeesValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dataSource
            .flatMapLatest { data -> Observable<String> in
                let value = data.days.map { $0.pushUps }.reduce(0) { $0 + $1 }
                return Observable.just("\(value)")
            }
            .bind(to: pushUpsValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dataSource
            .flatMapLatest { data -> Observable<String> in
                let value = data.days.map { $0.fullBody }.reduce(0) { $0 + $1 }
                return Observable.just("\(value)")
            }
            .bind(to: fullBodyValueLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
}
