//
//  MonthRecordsViewController.swift
//  LSDLoseWeightPlan
//
//  Created by Sidi Liu on 2020/12/23.
//

import UIKit
import Kingfisher
import Charts

class MonthRecordsViewController: BaseViewController {

    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthView: MonthDescriptionView!
    var imagePickerController: UIImagePickerController?
    
    let viewModel = RecordsViewModel()
    var dataSource: RxCollectionViewSectionedReloadDataSource<WeightModel>!
    
    var fromRect: CGRect?
    var headImage: UIImage?
    private let currentMonth = PublishRelay<String>()
    private let selectedImagePath = PublishRelay<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.delegate = self
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewModel.reloadAction.accept(())
    }
    
    override func setupSubviews() {
        let layout = collectionView.collectionViewLayout as! CardsLayout
        layout.delegate = self
        collectionView.register(nibWithCellClass: CardCell.self)
    }

    override func setupBindings() {
//        viewModel.lineDataSource
//            .subscribe(onNext: { [weak self] model in
//                if let last = model.months.last {
//                    self?.setupLineChartData(model: last)
//                }
//            }).disposed(by: disposeBag)
        
        let collectionDataSource = RxCollectionViewSectionedReloadDataSource<WeightModel> { (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withClass: CardCell.self, for: indexPath)
            cell.imageView.kf.setImage(with: URL(fileURLWithPath: item.imagePath ?? ""), placeholder: #imageLiteral(resourceName: "placeholder"))
            cell.longPressAction
                .subscribe(onNext: { [weak self] in
                    self?.currentMonth.accept(item.month)
                    self?.presentImagePickerController()
                }).disposed(by: cell.disposeBag)
                
            return cell
        }
        self.dataSource = collectionDataSource
        
        viewModel.collectionDataSource
            .bind(to: collectionView.rx.items(dataSource: collectionDataSource))
            .disposed(by: disposeBag)
        
        viewModel.collectionDataSource
            .subscribe(onNext: { [weak self] dataSource in
                self?.targetLabel.text = dataSource.first?.target
            }).disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let `self` = self else { return }
                let offset = CGPoint(x: self.collectionView.bounds.width * CGFloat(indexPath.item), y: 0)
                if offset != self.collectionView.contentOffset {
                    self.collectionView.setContentOffset(offset, animated: true)
                    return
                }
                let cell = self.collectionView.cellForItem(at: indexPath)! as! CardCell
                self.fromRect = self.collectionView.convert(cell.frame, to: nil)
                self.headImage = cell.imageView.image
                let viewController = UIStoryboard.instantiateViewController(withClass: MonthChartsViewController.self, from: "Records")!
                viewController.viewModel = ChartsViewModel(dataSource: self.dataSource[indexPath.section].items[indexPath.item])
                viewController.headImage = self.headImage
                self.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: disposeBag)
        
        selectedImagePath
            .withLatestFrom(Observable.combineLatest(currentMonth, selectedImagePath))
            .bind(to: viewModel.saveImagePathAction)
            .disposed(by: disposeBag)
    }
    
    func presentImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.imagePickerController = imagePickerController
        present(imagePickerController, animated: true, completion: nil)
    }
    
}

extension MonthRecordsViewController: CardsLayoutDelegate {
    func transition(indexPath: IndexPath, progress: CGFloat) {
        let cell = collectionView.cellForItem(at: indexPath) as? CardCell
        cell?.updateShadow(progress: progress)
    }
    
    func transition(fromIndexPath: IndexPath, toIndexPath: IndexPath, progress: CGFloat) {
        monthView.transition(month: dataSource[fromIndexPath.section].items[fromIndexPath.item].month,
                             nextMonth: dataSource[toIndexPath.section].items[toIndexPath.item].month,
                             emoji: dataSource[fromIndexPath.section].items[fromIndexPath.item].emoji,
                             nextEmoji: dataSource[toIndexPath.section].items[toIndexPath.item].emoji,
                             progress: progress)
    }
}

extension MonthRecordsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return AnimatedPushTransition()
        case .pop:
            return AnimatedPopTransition()
        default:
            return nil
        }
    }
}

extension MonthRecordsViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[.imageURL] as? URL, let path = url.droppedScheme()?.absoluteString {
            selectedImagePath.accept(path)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
