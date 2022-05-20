//
//  MovieHomeController.swift
//  mp-mvvm-basic-movie-app
//
//  Created by Arslan Kaan AYDIN on 14.05.2022.
//

import UIKit
import SnapKit
import Alamofire

//MARK: - Protocols
protocol MovieOutput {
    func selectedMovies(imdbID: String)
}


class MovieHomeController: UIViewController {
    // MARK: - Properties
    
    // UI Elements
    private let mainTableView: UITableView = UITableView()
    private let searchController: UISearchController = UISearchController()
    private let noResultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = Color.appWhite
        label.text = "There were no results."
        return label
    }()
    // Service
    private let service = Services()
    // Data
    private var search = [Search]()
    // View Model
    private var viewModel: MovieHomeProtocol = MovieHomeViewModel(service: Services())
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.appBlack
        configure()
        viewModel.delegate = self
    }
    
    // MARK: - Functions
    private func configure() {
        addSubviews()
        drawDesign()
        makeTableView()
        makeNoResultLabel()
    }
    
    private func drawDesign() {
        // TableView
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.register(MovieHomeTableViewCell.self, forCellReuseIdentifier: MovieHomeTableViewCell.Identifier.custom.rawValue)
        mainTableView.rowHeight = 150
        mainTableView.separatorStyle = .none
        // NavigationBar
        configureNavigationBar(largeTitleColor: .systemGray, backgoundColor: Color.appBlack, tintColor: Color.appWhite, title: "Movieflix", preferredLargeTitle: false)
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsCancelButton = false
    }
    
    private func addSubviews() {
        view.addSubview(mainTableView)
        view.addSubview(noResultLabel)
    }
    
}

// MARK: - Tableview Extension

extension MovieHomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        search.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MovieHomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: MovieHomeTableViewCell.Identifier.custom.rawValue) as? MovieHomeTableViewCell else {
            return UITableViewCell()
        }
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 75
        cell.saveModel(model: search[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.delegate?.selectedMovies(imdbID: search[indexPath.row].imdbID)
    }
}

// MARK: - Snapkit Extension

extension MovieHomeController {
    private func makeTableView() {
        mainTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().inset(15)
        }
    }
    
    private func makeNoResultLabel() {
        noResultLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

}

// MARK: - Search Controller Extension
extension MovieHomeController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let writtenText = searchController.searchBar.text else { return }
        let searchMovieName = writtenText.replacingOccurrences(of: " ", with: "%20")
        
        if writtenText == "" {
            noResultLabel.isHidden = false
        }else{
            noResultLabel.isHidden = true
        }
        
        service.searchMovie(searchMovieName: searchMovieName, completion: {
            data in
            self.search = data ?? []
            if writtenText.count > 3 && data == nil {
                self.makeAlert(titleInput: "Error", messageInput: "The movie not found")
            }
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        })
    }
}
// MARK: - ViewModel Extension
extension MovieHomeController: MovieOutput {
    func selectedMovies(imdbID: String) {
        viewModel.getMovieDetail(movieImdbId: imdbID) { data in
            guard let data = data else { return }
            self.navigationController?.pushViewController(MovieDetailController(detailResults: data), animated: true)
        }
        
    }
    
}
// MARK: - Alert
extension MovieHomeController {
    func makeAlert(titleInput:String, messageInput:String) {
           let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
            self.searchController.searchBar.text = nil
        }
           alert.addAction(okButton)
           self.present(alert, animated: true, completion: nil)
    }
}
