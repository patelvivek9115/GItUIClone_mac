//
//  HomeViewModel.swift
//  MacOSApplication
//
//  Created by Vivek Patel on 14/03/24.
//

import Foundation

enum RepoState {
    case changes
    case history
}
enum NOLocal {
    case visual
    case finder
    case github
    
    var title: String {
        switch self {
        case .visual:
            "Open the repository in your external editor"
        case .finder:
            "View the files of your repository in finder"
        case .github:
            "Open the repository page on GitHub in your browser"
        }
    }
    var description: String {
        switch self {
        case .visual:
            "Repository menu or"
        case .finder:
            "Repository menu or"
        case .github:
            "Repository menu or"
        }
    }
    var buttomTitle: String {
        switch self {
        case .visual:
            "Open in Visual Studio Code"
        case .finder:
            "Show in Finder"
        case .github:
            "View on GitHub"
        }
    }
    var text: String {
        switch self {
        case .visual:
            "A"
        case .finder:
            "F"
        case .github:
            "G"
        }
    }
}
@Observable
class HomeViewModel: ObservableObject {
    var repoState: RepoState = .changes
    var noLocal: NOLocal = .visual
    var rotationAngle: Double = 0
    var rotationOn: Bool = false
    var addMember: Bool = false
    var commitText: String = ""
    var commitDescription: String = ""
    var memberText: String = ""
    var searchRepoText: String = ""
    var showRepos: Bool = false
    var recentList: [RecentModel] = []
    var allProjectLIst: [RecentModel] = []
    var changeHover: Bool = false
    var historyHover: Bool = false
    var branchHover: Bool = false
    var pullHover: Bool = false
    var currentRepoHover: Bool = false
    var currentBranchHover: Bool = false
    var showFeatureList: Bool = false
    var branchSelected: Bool = true
    var fetchHover: Bool = false
    var showMergePopup: Bool = false
    init() {
        var recentOne = RecentModel()
        recentOne.name = "Project 1"
        recentOne.isSelected = false
        var recentSec = RecentModel()
        recentSec.name = "Project 2"
        recentSec.isSelected = false
        var recentThird = RecentModel()
        recentThird.name = "Project 3"
        recentThird.isSelected = false
        self.recentList.append(recentOne)
        self.recentList.append(recentSec)
        self.recentList.append(recentThird)
        var projectOne = RecentModel()
        projectOne.name = "Project 1"
        projectOne.isSelected = false
        var projectSec = RecentModel()
        projectSec.name = "Project 2"
        projectSec.isSelected = false
        var projectThird = RecentModel()
        projectThird.name = "Project 3"
        projectThird.isSelected = false
        var projectFourth = RecentModel()
        projectFourth.name = "Project 4"
        projectFourth.isSelected = false
        var projectFifth = RecentModel()
        projectFifth.name = "Project 5"
        projectFifth.isSelected = false
        var projectSixth = RecentModel()
        projectSixth.name = "Project 6"
        projectSixth.isSelected = false
        self.allProjectLIst.append(projectOne)
        self.allProjectLIst.append(projectSec)
        self.allProjectLIst.append(projectThird)
        self.allProjectLIst.append(projectFourth)
        self.allProjectLIst.append(projectFifth)
        self.allProjectLIst.append(projectSixth)
    }
}
