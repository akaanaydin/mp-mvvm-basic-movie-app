//
//  MovieDetailController.swift
//  mp-mvvm-basic-movie-app
//
//  Created by Arslan Kaan AYDIN on 14.05.2022.
//

import UIKit
import SnapKit
import Kingfisher

class MovieDetailController: UIViewController {
    
    private enum Side {
        case head
        case tail
    }
    
    private var currentSide: Side = .head
    private let service = Services()
    private var detailResults: DetailResults
    var imdbID: String = String()
    
    private let movieImage : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .orange
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    private let imdbView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = false
        view.layer.cornerRadius = 40
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 5
        return view
    }()
    
    private let detailView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.layer.cornerRadius = 30
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private let containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let imdbRatingLabel: UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.textColor = .systemGray
        return label
    }()
    
    private let plotLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let directorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let writerLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let actorsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.text = """
        👆🏼
        Please touch the poster to see details
        """
        return label
    }()
    
    init(detailResults: DetailResults) {
        self.detailResults = detailResults
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        addSubviews()
        drawDesign()
        tapGesture()
        setUp()
        makeContainerView()
        makeMovieImage()
        makeDetailView()
        makeTitleLabel()
        makeImdbRatingLabel()
        makePlotLabel()
        makeGenreLabel()
        makeDirectorLabel()
        makeWriterLabel()
        makeActorsLabel()
        makeImdbView()
        makeInformationLabel()
    }
    
    func drawDesign() {
        view.backgroundColor = .white
    }
    
    func addSubviews() {
        view.addSubview(containerView)
        view.addSubview(informationLabel)
        containerView.addSubview(movieImage)
        containerView.addSubview(imdbView)
        containerView.addSubview(detailView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(imdbRatingLabel)
        containerView.addSubview(plotLabel)
        containerView.addSubview(genreLabel)
        containerView.addSubview(directorLabel)
        containerView.addSubview(writerLabel)
        containerView.addSubview(actorsLabel)
        
    }
    
    func tapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapContainer))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    func setUp() {
        let urlImage = URL(string: detailResults.poster)
        movieImage.kf.setImage(with: urlImage)
        titleLabel.text = detailResults.title
        imdbRatingLabel.text = """
        IMDB
        \(detailResults.imdbRating)
        """
        plotLabel.text = detailResults.plot
        genreLabel.text = detailResults.genre
        directorLabel.text = """
        Director
        \(detailResults.director)
        """
        writerLabel.text = """
        Writer
        \(detailResults.writer)
        """
        actorsLabel.text = """
        Actors
        \(detailResults.actors)
        """
    }
    
    func hideLabels(_ status: Bool){
        titleLabel.isHidden = status
        plotLabel.isHidden = status
        genreLabel.isHidden = status
        directorLabel.isHidden = status
        writerLabel.isHidden = status
        actorsLabel.isHidden = status
    }
    
    func reverseHideLabels(_ status: Bool){
        imdbRatingLabel.isHidden = status
        imdbView.isHidden = status
        informationLabel.isHidden = status
    }
    
    @objc
    func tapContainer() {
        switch currentSide {
        case .head:
            UIView.transition(from: movieImage,
                              to: detailView,
                              duration: 1,
                              options: [.transitionFlipFromRight, .showHideTransitionViews],
                              completion: nil)
            currentSide = .tail
            hideLabels(false)
            reverseHideLabels(true)
        case .tail:
            UIView.transition(from: detailView,
                              to: movieImage,
                              duration: 1,
                              options: [.transitionFlipFromLeft, .showHideTransitionViews],
                              completion: nil)
            currentSide = .head
            hideLabels(true)
            reverseHideLabels(false)
        }
    }
}

extension MovieDetailController {
    
    
    private func makeContainerView() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(200)
            
        }
    }
    
    private func makeInformationLabel() {
        informationLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(20)
            make.left.right.equalTo(containerView)
        }
    }
    
    private func makeImdbView() {
        imdbView.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(10)
            make.height.width.equalTo(80)
            make.right.equalTo(containerView).inset(10)
        }
    }
    
    private func makeMovieImage() {
        movieImage.snp.makeConstraints { make in
            make.center.equalTo(containerView)
            make.height.width.equalTo(containerView)
        }
    }
    
    private func makeDetailView() {
        detailView.snp.makeConstraints { make in
            make.center.equalTo(containerView)
            make.height.width.equalTo(containerView)
        }
    }
    
    private func makeTitleLabel() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(10)
            make.centerX.equalTo(containerView)
            make.left.equalTo(containerView).offset(10)
            make.right.equalTo(containerView).inset(10)
        }
    }
    
    private func makeImdbRatingLabel() {
        imdbRatingLabel.snp.makeConstraints { make in
            make.center.equalTo(imdbView)
        }
    }
    
    private func makePlotLabel() {
        plotLabel.snp.makeConstraints { make in
            make.top.equalTo(genreLabel.snp.bottom).offset(10)
            make.right.left.equalTo(titleLabel)
            make.centerX.equalTo(containerView)
        }
    }
    
    private func makeGenreLabel() {
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalTo(containerView)
            make.left.right.equalTo(titleLabel)
        }
    }
    
    private func makeDirectorLabel() {
        directorLabel.snp.makeConstraints { make in
            make.top.equalTo(plotLabel.snp.bottom).offset(10)
            make.centerX.equalTo(containerView)
            make.left.right.equalTo(titleLabel)
        }
    }
    
    private func makeWriterLabel() {
        writerLabel.snp.makeConstraints { make in
            make.top.equalTo(directorLabel.snp.bottom).offset(10)
            make.centerX.equalTo(containerView)
            make.left.right.equalTo(titleLabel)
        }
    }
    
    private func makeActorsLabel() {
        actorsLabel.snp.makeConstraints { make in
            make.top.equalTo(writerLabel.snp.bottom).offset(10)
            make.centerX.equalTo(containerView)
            make.left.right.equalTo(titleLabel)
        }
    }
    
}
