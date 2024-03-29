//
//  SearchViewController.swift
//  Onboarding Search Filter
//
//  Created by Dhio Etanasti on 07/10/18.
//

import AsyncDisplayKit
import RxCocoa
import RxDataSources
import RxSwift
import RxCocoa_Texture
import RxASDataSources

// MARK: SearchViewController
public class SearchViewController: ASViewController<ASDisplayNode> {
    
    private let disposeBag = DisposeBag()
    private var viewModel: SearchViewModel = SearchViewModel(filter: Filter(), useCase: DefaultSearchUseCase())
    
    private var filterVC: FilterViewController!
    
    private var screenWidth: CGFloat?
    private var collectionNodeInset: CGFloat?
    
    // MARK: CollectionNode setup
    private var collectionNode: ASCollectionNode = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        let node = ASCollectionNode(collectionViewLayout: flowLayout)
        node.backgroundColor = .white
        node.style.flexGrow = 1
        node.contentInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        node.showsVerticalScrollIndicator = false
        
        return node
    }()
    
    // MARK: ButtonNode setup
    private var buttonNode: ASButtonNode = ButtonNode(named: "Filter")
    
    public init() {
        let rootNode = ASDisplayNode()
        rootNode.backgroundColor = .white
        super.init(node: rootNode)
        
        rootNode.automaticallyManagesSubnodes = true
        rootNode.automaticallyRelayoutOnSafeAreaChanges = true
        
        rootNode.layoutSpecBlock = { [weak self] _, _ -> ASLayoutSpec in
            guard let self = self else { return ASLayoutSpec() }
            let buttonInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 4,
                                                                         left: 8,
                                                                         bottom: 8,
                                                                         right: 8),
                                                    child: self.buttonNode)
            let stackSpec = ASStackLayoutSpec(direction: .vertical,
                                              spacing: 4,
                                              justifyContent: .spaceBetween,
                                              alignItems: .center,
                                              children: [self.collectionNode, buttonInsetSpec])
            
            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: self.node.safeAreaInsets.top,
                                                          left: self.node.safeAreaInsets.left,
                                                          bottom: self.node.safeAreaInsets.bottom,
                                                          right: self.node.safeAreaInsets.right),
                                     child: stackSpec)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        if screenWidth == nil {
            screenWidth = UIScreen.main.bounds.size.width
        }
        
        if collectionNodeInset == nil {
            collectionNodeInset = (self.screenWidth! - 350) / 4
            collectionNode.contentInset = UIEdgeInsets(top: 7, left: self.collectionNodeInset!, bottom: 7, right: self.collectionNodeInset!)
        }
        
        if UIScreen.main.bounds.size.height > 667 {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        bindViewModel()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    private func setupUI() {
        
    }
    
    private var newFilterTrigger = Driver<Filter>.empty()

    private func bindViewModel() {
        let loadMoreTrigger = collectionNode.rxReachBottom.asDriver { error -> Driver<Void> in
            return .empty()
        }
        
        let newFilterTrigger = PublishSubject<Filter>()
//        let newFilterTrigger = navigationController?.rx.deallocating.asDriver(onErrorRecover: { (_) -> Driver<Void> in
//            return .empty()
//        })
        
        let input = SearchViewModel.Input(viewDidLoadTrigger: Driver.just(()),
                                          loadMoreTrigger: loadMoreTrigger,
                                          filterButtonTapTrigger: buttonNode.rx.tap.asDriver(onErrorRecover: { (_) -> Driver<Void> in
                                            return .empty()
                                          }),
                                          newFilterTrigger: newFilterTrigger)
        
        let output = viewModel.transform(input: input)

        let configureCellBlock: RxASCollectionReloadDataSource<SectionOfProducts>.ConfigureCellBlock = { (dataSource, collectionNode, indexPath, product) -> ASCellNodeBlock in
            let cell = SearchCollectionCellNode(product: product)
            return {
                return cell
            }
        }
        let dataSource = RxASCollectionReloadDataSource<SectionOfProducts>(configureCellBlock: configureCellBlock, configureSupplementaryView: nil)
        
        output.searchList
            .map({ (products) -> [SectionOfProducts] in
                return [SectionOfProducts(items: products)]
            })
            .drive(collectionNode.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.openFilter
            .drive(onNext: { [weak self] (filter) in
                guard let self = self else { return }
                self.filterVC = FilterViewController(filterObject: filter)
                let navCon = UINavigationController(rootViewController: self.filterVC)
                navCon.modalPresentationStyle = .pageSheet
                self.navigationController?.present(navCon, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

    }
}

//class UseCase {
//    func getFilter(from viewController: UIViewController) -> Driver<Filter> {
//        let filter = FilterVC()
//        viewController.present(filter)
//        
//        return Observable.create { observer in
//            filter.onSelected = { filterData
//                obbserver.onNext(filterData)
//            }
//        }
//    }
//    
//    
//}
