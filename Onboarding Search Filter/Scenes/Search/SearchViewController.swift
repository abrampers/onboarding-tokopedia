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
    private var buttonNode: ASButtonNode = {
        let node = ASButtonNode()
        node.backgroundColor = UIColor.tpGreen
        node.setAttributedTitle(NSAttributedString(string: "Filter", attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14)
            ]), for: .normal)
        
        node.style.width = ASDimensionMake("100%")
        node.style.height = ASDimensionMake(40)
        
        var cornerRadius: CGFloat = 8.0
        // Use precomposition for rounding corners
        node.cornerRoundingType = ASCornerRoundingType.defaultSlowCALayer // kenapa gabisa pake .clipping or .precomposited
        node.cornerRadius = cornerRadius
        
        return node
    }()
    
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
        if self.screenWidth == nil {
            self.screenWidth = UIScreen.main.bounds.size.width
        }
        
        if self.collectionNodeInset == nil {
            self.collectionNodeInset = (self.screenWidth! - 350) / 4
            collectionNode.contentInset = UIEdgeInsets(top: 7, left: self.collectionNodeInset!, bottom: 7, right: self.collectionNodeInset!)
        }
        
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Search"
        
        bindViewModel()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    private func setupUI() {
        
    }

    private func bindViewModel() {
        let loadMoreTrigger = collectionNode.rxReachBottom.asDriver { error -> Driver<Void> in
            return .empty()
        }
        
        let newFilterTrigger = Driver<Filter>.empty()
        
        let input = SearchViewModel.Input(viewDidLoadTrigger: Driver.just(()),
                                          loadMoreTrigger: loadMoreTrigger,
                                          filterButtonTapTrigger: buttonNode.rx.tap.asDriver(onErrorRecover: { (_) -> Driver<Void> in
                                            return .empty()
                                          }),
                                          newFilterTrigger: newFilterTrigger)
        
        let output = self.viewModel.transform(input: input)

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
                let filterVC = FilterViewController(filterObject: filter)
                self?.navigationController?.present(filterVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

    }
}

