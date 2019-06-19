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

// MARK: SearchViewController
public class SearchViewController: ASViewController<ASDisplayNode> {
    
    private let disposeBag = DisposeBag()
    private var viewModel: SearchViewModel = SearchViewModel(filter: Filter(), useCase: DefaultSearchUseCase())
    
    private var screenWidth: CGFloat!
    
    // MARK: CollectionNode setup
    private var collectionNode: ASCollectionNode = {
        let flowLayout = UICollectionViewFlowLayout()
        
        let node = ASCollectionNode(collectionViewLayout: flowLayout)
        node.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        node.style.flexGrow = 1
        
        return node
    }()
    
    // MARK: ButtonNode setup
    private var buttonNode: ASButtonNode = {
        let node = ASButtonNode()
        node.backgroundColor = #colorLiteral(red: 0, green: 0.8308004737, blue: 0.5435867906, alpha: 1)
        node.setAttributedTitle(NSAttributedString(string: "Filter", attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14)
            ]), for: .normal)
        
        node.style.width = ASDimensionMake("100%")
        node.style.height = ASDimensionMake(50)
        
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
        
        self.title = "Search"
        
        rootNode.automaticallyManagesSubnodes = true
        
        // TODO: Harus pake weak apa engga?
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
            
            return stackSpec
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.screenWidth = UIScreen.main.bounds.size.width
        bindViewModel()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    private func setupUI() {
        
    }

    private func bindViewModel() {
        
    }
}
