//
//  HomeView.swift
//  MacOSApplication
//
//  Created by Vivek Patel on 14/03/24.
//

import SwiftUI

struct HomeView: View {
    enum FocusedField {
        case filter, firstName, description, none
    }
    @StateObject var viewModel = HomeViewModel()
    @FocusState private var focusedField: FocusedField?
    var body: some View {
        NavigationSplitView {
            Text("Sidebar")
                .navigationSplitViewColumnWidth(min: 0, ideal: 0, max: 0)
        } content: {
            ZStack {
                VStack(spacing: .zero) {
                    repoView
                        .onTapGesture {
                            viewModel.showRepos.toggle()
                        }
                    ZStack {
                        VStack(spacing: .zero) {
                            segmentView
                            ZStack {
                                if viewModel.repoState == .changes  {
                                    VStack(spacing: .zero) {
                                        changesView
                                        Spacer()
                                        commiteView
                                    }
                                } else {
                                    historyView
                                }
                            }
                        }
                        .isHidden(viewModel.showRepos, remove: true)
                        VStack {
                            repoListView
                            Spacer()
                        }
                        .isHidden(!viewModel.showRepos, remove: true)
                    }
                }
                .navigationSplitViewColumnWidth(min: 250, ideal: 200)
                .onAppear {
                    focusedField = HomeView.FocusedField.none
                }
                VStack {
                    HStack {
                        Spacer()
                    }
                    Spacer()
                }
                .background(Color.black.opacity(0.4))
                .onTapGesture {
                    viewModel.showFeatureList.toggle()
                }
                .isHidden(!viewModel.showFeatureList, remove: true)
            }
        } detail: {
            VStack(spacing: .zero) {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.black)
                HStack(spacing: 0) {
                    currentView
                        .onTapGesture {
                            viewModel.showRepos = false
                            viewModel.showFeatureList.toggle()
                        }
                    fetchView
                    Spacer()
                }
                .background(Color.darkGray)
                .frame(height: 45)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.black)
                ZStack {
                    ZStack {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 20) {
                                noLocal
                                list
                            }
                            .padding(.top, 40)
                            .padding(.horizontal)
                            .frame(maxWidth: 580)
                            Spacer()
                        }
                        .scrollBounceBehavior(.basedOnSize)
                        VStack {
                            HStack {
                                Spacer()
                            }
                            Spacer()
                        }
                        .background(Color.black.opacity(0.4))
                        .onTapGesture {
                            viewModel.showFeatureList.toggle()
                        }
                        .isHidden(!viewModel.showFeatureList, remove: true)
                    }
                    branchList
                        .isHidden(!viewModel.showFeatureList, remove: true)
                }
            }
            .navigationSplitViewColumnWidth(min: 420, ideal: 420)
        }
        .background(Color.lightGray)
    }
    @ViewBuilder var branchList: some View {
        HStack {
            VStack(alignment: .leading) {
                branchDescription
                HStack(spacing: 14) {
                    HStack {
                        TextField("Filter", text: $viewModel.searchRepoText)
                            .padding([.leading], 4)
                            .padding([.vertical], 3)
                            .textFieldStyle(.plain)
                            .focused($focusedField, equals: .filter)
                        Spacer()
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(LinearGradient(colors: [focusedField == .filter ? Color.lightBlue : Color.white.opacity(0.6)], startPoint: .leading, endPoint: .trailing), lineWidth: 0.8)
                    )
                    Button {
                        
                    } label: {
                        HStack {
                            if viewModel.branchSelected {
                                Text("New Branch")
                                    .font(.system(size: 12, weight: .regular, design: .default))
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 10)
                            } else {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .resizable()
                                    .scaledToFit()
                                    .fontWeight(.bold)
                                    .frame(width: 16, height: 16, alignment: .center)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 3.5)
                            }
                        }
                        .background(Color.lightestGray)
                        .cornerRadius(6)
                        .overlay {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(.white.opacity(0.6), lineWidth: 0.7)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 9)
                if viewModel.branchSelected {
                    branches
                } else {
                    pullRequest
                }
                Spacer(minLength: 0)
                mergeView
            }
            .frame(width: 360)
            .background(Color.lightGray)
            Spacer(minLength: 0)
        }
    }
    @ViewBuilder var pullRequest: some View {
        VStack {
            Image(.appNoPull)
                .resizable()
                .scaledToFit()
            VStack(alignment: .center) {
                Text("You're all set")
                    .font(.system(size: 12, weight: .medium, design: .default))
                    .multilineTextAlignment(.center)
                VStack(alignment: .center, spacing: 10) {
                    Text("No open pull in current project")
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .multilineTextAlignment(.center)
                    Text("Would you like to create a pull request from the current branch?")
                        .font(.system(size: 11, weight: .regular, design: .default))
                        .multilineTextAlignment(.center)
                }
            }
            Spacer()
        }
    }
    @ViewBuilder var branches: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Default Branch")
                    .font(.system(size: 12, weight: .medium, design: .default))
                    .multilineTextAlignment(.leading)
                HStack (alignment: .top) {
                    Image(.currentBranchIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14, alignment: .center)
                    Text("master")
                        .font(.system(size: 12, weight: .regular, design: .default))
                    Spacer(minLength: 0)
                    Text("2 months ago")
                        .font(.system(size: 12, weight: .regular, design: .default))
                }
            }
            VStack(alignment: .leading, spacing: 12) {
                Text("Recent Branches")
                    .font(.system(size: 12, weight: .medium, design: .default))
                    .multilineTextAlignment(.leading)
                HStack (alignment: .center) {
                    Image(systemName: "checkmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 10, alignment: .center)
                        .foregroundStyle(.white)
                    Text("my Branch")
                        .font(.system(size: 12, weight: .regular, design: .default))
                    Spacer(minLength: 0)
                    Text("2 months ago")
                        .font(.system(size: 12, weight: .regular, design: .default))
                }
                HStack (alignment: .top) {
                    Image(.currentBranchIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14, alignment: .center)
                    Text("develop")
                        .font(.system(size: 12, weight: .regular, design: .default))
                    Spacer(minLength: 0)
                    Text("2 months ago")
                        .font(.system(size: 12, weight: .regular, design: .default))
                }
                HStack (alignment: .top) {
                    Image(.currentBranchIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14, alignment: .center)
                    Text("release")
                        .font(.system(size: 12, weight: .regular, design: .default))
                    Spacer(minLength: 0)
                    Text("2 months ago")
                        .font(.system(size: 12, weight: .regular, design: .default))
                }
            }
        }
        .padding([.horizontal, .top], 10)
    }
    @ViewBuilder var mergeView: some View {
        VStack() {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)
            Spacer(minLength: 0)
            HStack {
                Spacer(minLength: 4)
                Image(.currentBranchIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12, alignment: .center)
                HStack(spacing: 2) {
                    Text("Choose a branch to merge into")
                        .font(.system(size: 11, weight: .regular, design: .default))
                    Text("feature/myBranch")
                        .font(.system(size: 11, weight: .semibold, design: .default))
                }
                .padding(.vertical, 5)
                Spacer(minLength: 4)
            }
            .background(Color.lightestGray)
            .cornerRadius(6)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.white.opacity(0.6), lineWidth: 0.7)
            }
            .padding(.horizontal, 12)
            Spacer(minLength: 0)
        }
        .frame(height: 50, alignment: .center)
        .onHover(perform: { hover in
            viewModel.showMergePopup = hover
        })
        .popover(isPresented: $viewModel.showMergePopup,
                 attachmentAnchor: .point(.center),
                 arrowEdge: .top,
                 content: {
            Text("Choose a branch to merge into feature/myBranch")
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .presentationCompactAdaptation(.none)
        })
    }
    @ViewBuilder var repoView: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)
            HStack(spacing: 10) {
                Image(systemName: "lock")
                    .resizable()
                    .scaledToFit()
                    .fontWeight(.bold)
                    .frame(width: 15, height: 15, alignment: .center)
                VStack(alignment: .leading) {
                    Text("Current Repository")
                        .font(.system(size: 11, weight: .regular, design: .default))
                        .foregroundColor(.gray)
                    Text("Project 1")
                        .font(.system(size: 12, weight: .medium, design: .default))
                        .foregroundColor(.white)
                }
                Spacer()
                Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .frame(width: 8, height: 4)
                    .scaledToFill()
                    .rotationEffect(.degrees(viewModel.showRepos ? 180 : 0))
            }
            .padding([.all], 8)
            .background(viewModel.showRepos ? Color.lightGray : viewModel.currentRepoHover ? Color.lightestGray : Color.darkGray)
            .onHover { over in
                viewModel.currentRepoHover = over
            }
        }
    }
    @ViewBuilder var currentView: some View {
        HStack {
            Image(.currentBranchIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16, alignment: .center)
            VStack(alignment: .leading) {
                Text("Current Branch")
                    .font(.system(size: 11, weight: .regular, design: .default))
                    .foregroundColor(.gray)
                Text("feature/myBranch")
                    .font(.system(size: 12, weight: .medium, design: .default))
                    .foregroundColor(.white)
            }
            Spacer()
            Image(systemName: "arrowtriangle.down.fill")
                .resizable()
                .frame(width: 8, height: 4)
                .scaledToFill()
            Rectangle()
                .frame(width: 1)
                .foregroundColor(.black)
        }
        .padding(.leading, 10)
        .frame(width: 225)
        .background(viewModel.currentBranchHover ? Color.lightestGray : Color.darkGray)
        .onHover { over in
            viewModel.currentBranchHover = over
        }
    }
    @ViewBuilder var fetchView: some View {
        HStack {
            Image(systemName: "arrow.triangle.2.circlepath")
                .resizable()
                .scaledToFit()
                .fontWeight(.bold)
                .frame(width: 18, height: 18, alignment: .center)
                .rotationEffect(.degrees(viewModel.rotationAngle))
            VStack(alignment: .leading) {
                Text(viewModel.rotationOn ? "Fetching origin" : "Fetch origin")
                    .font(.system(size: 12, weight: .medium, design: .default))
                    .foregroundColor(.white.opacity(viewModel.rotationOn ? 0.7 : 1))
                Text(viewModel.rotationOn ? "Hang on..." : "Last fetched 10 minutes ago")
                    .font(.system(size: 11, weight: .regular, design: .default))
                    .foregroundColor(.gray)
            }
            Spacer()
            Rectangle()
                .frame(width: 1)
                .foregroundColor(.black)
        }
        .contentShape(Rectangle())
        .padding(.leading, 10)
        .frame(width: 225)
        .background(viewModel.fetchHover ? Color.lightestGray : Color.darkGray)
        .onHover { over in
            viewModel.fetchHover = over
        }
        .onTapGesture {
            viewModel.showRepos = false
            viewModel.rotationOn = true
            Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
                withAnimation {
                    viewModel.rotationAngle += 25
                }
                if viewModel.rotationAngle >= 360 * 4 {
                    viewModel.rotationAngle = 0
                    timer.invalidate()
                    viewModel.rotationOn = false
                }
            }
        }
    }
    @ViewBuilder var segmentView: some View {
        VStack(alignment: .center,spacing: .zero) {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)
            HStack(spacing: .zero) {
                VStack(alignment: .center) {
                    Spacer(minLength: 0)
                    Text("Changes")
                    Spacer(minLength: 0)
                    Rectangle()
                        .frame(height: 3)
                        .foregroundColor(viewModel.repoState == .changes ? .lightBlue : .clear)
                }
                .background(viewModel.changeHover ? Color.lightestGray : Color.clear)
                .onHover { over in
                    viewModel.changeHover = over
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.repoState = .changes
                }
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.black)
                VStack(alignment: .center) {
                    Spacer(minLength: 0)
                    Text("History")
                    Spacer(minLength: 0)
                    Rectangle()
                        .frame(height: 3)
                        .foregroundColor(viewModel.repoState == .history ? .blue : .clear)
                }
                .background(viewModel.historyHover ? Color.lightestGray : Color.clear)
                .onHover { over in
                    viewModel.historyHover = over
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.repoState = .history
                }
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)
        }
        .frame(height: 32)
    }
    @ViewBuilder var branchDescription: some View {
        VStack(alignment: .center,spacing: .zero) {
            HStack(spacing: .zero) {
                VStack(alignment: .center) {
                    Spacer(minLength: 0)
                    Text("Branches")
                    Spacer(minLength: 0)
                    Rectangle()
                        .frame(height: 3)
                        .foregroundColor(viewModel.branchSelected ? .lightBlue : .clear)
                }
                .background(viewModel.branchHover ? Color.lightestGray : Color.clear)
                .onHover { over in
                    viewModel.branchHover = over
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.branchSelected = true
                }
                Rectangle()
                    .frame(width: 1)
                    .foregroundColor(.black)
                VStack(alignment: .center) {
                    Spacer(minLength: 0)
                    Text("Pull Requests")
                    Spacer(minLength: 0)
                    Rectangle()
                        .frame(height: 3)
                        .foregroundColor(viewModel.branchSelected ? .clear : .lightBlue)
                }
                .background(viewModel.pullHover ? Color.lightestGray : Color.clear)
                .onHover { over in
                    viewModel.pullHover = over
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.branchSelected = false
                }
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)
        }
        .frame(height: 32)
    }
    @ViewBuilder var historyView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(1...20, id: \.self) { index in
                    history(index)
                }
                Spacer()
            }
        }
    }
    @ViewBuilder func history(_ index: Int) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Spacer(minLength: 0)
            Text("History Comit \(index)")
                .font(.system(size: 11, weight: .medium, design: .default))
                .padding([.horizontal], 12)
            HStack (alignment: .top) {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 16, height: 16, alignment: .center)
                    .overlay {
                        Image(systemName: "apple.logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12, alignment: .center)
                            .foregroundColor(.black)
                    }
                Text("User Name . 2 months ago")
                    .font(.system(size: 10, weight: .regular, design: .default))
                Spacer(minLength: 0)
            }
            .padding([.horizontal], 12)
            Spacer(minLength: 0)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)
        }
        .frame(height: 52)
    }
    @ViewBuilder var changesView: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "checkmark.square.fill")
                    .resizable()
                    .frame(width: 13, height: 13, alignment: .center)
                    .scaledToFit()
                    .foregroundColor(.white.opacity(0.4))
                Spacer()
                Text("0 changed files")
                    .font(.system(size: 12, weight: .regular, design: .default))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.all, 8)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)
        }
        .background(.lightestGray)
    }
    @ViewBuilder var noLocal: some View {
        HStack {
            Spacer()
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("No local changes")
                            .font(.system(size: 30, weight: .regular, design: .default))
                            .foregroundColor(.white)
                        Text("There are no uncommitted changes in this repository. Here are some friendly suggestions for what to do next.")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(.white)
                    }
                    Spacer(minLength: 0)
                    Image(.paper)
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                }
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Preview the Pull Request from your current branch")
                            .font(.system(size: 12, weight: .medium, design: .default))
                            .foregroundColor(.white)
                        Text("The current branch (development) is already published to GitHub. Preview the changes this pull request will have before proposing your changes.")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        HStack {
                            Text("Branch menu or")
                                .font(.system(size: 12, weight: .regular, design: .default))
                                .foregroundColor(.white.opacity(0.6))
                            HStack(spacing: 4) {
                                Image(systemName: "command")
                                    .resizable()
                                    .frame(width: 8, height: 8, alignment: .center)
                                    .padding(5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(LinearGradient(colors: [Color.black], startPoint: .leading, endPoint: .trailing), lineWidth: 0.6)
                                    )
                                Image(systemName: "option")
                                    .resizable()
                                    .frame(width: 8, height: 8, alignment: .center)
                                    .padding(5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(LinearGradient(colors: [Color.black], startPoint: .leading, endPoint: .trailing), lineWidth: 0.6)
                                    )
                                Text("P")
                                    .font(.system(size: 10, weight: .regular, design: .default))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(LinearGradient(colors: [Color.black], startPoint: .leading, endPoint: .trailing), lineWidth: 0.6)
                                    )
                            }
                        }
                    }
                    HStack(spacing: 16) {
                        Text("Preview Pull Request")
                            .font(.system(size: 11, weight: .regular, design: .default))
                            .foregroundColor(.white)
                        Image(systemName: "arrowtriangle.down.fill")
                            .resizable()
                            .frame(width: 8, height: 4)
                            .scaledToFill()
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 8)
                    .background(Color.lightBlue)
                    .cornerRadius(6)
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
                .background(Color.darkBlue)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(LinearGradient(colors: [Color.lightBlue], startPoint: .leading, endPoint: .trailing), lineWidth: 0.6)
                )
            }
            Spacer()
        }
    }
    @ViewBuilder var list: some View {
        HStack {
            Spacer()
            VStack(alignment: .leading, spacing: 20) {
                listElement(.visual)
                listElement(.finder)
                listElement(.github)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(LinearGradient(colors: [Color.black], startPoint: .leading, endPoint: .trailing), lineWidth: 0.6)
            )
            Spacer()
        }
    }
    @ViewBuilder func listElement(_ state: NOLocal) -> some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(state.title)
                            .font(.system(size: 12, weight: .medium, design: .default))
                            .foregroundColor(.white)
                            .lineLimit(2)
                        Text("Select your editor in Preferences")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(.white)
                            .isHidden(state != .visual, remove: true)
                            .lineLimit(2)
                    }
                    HStack {
                        Text(state.description)
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(.white.opacity(0.6))
                        HStack(spacing: 4) {
                            Image(systemName: "command")
                                .resizable()
                                .frame(width: 8, height: 8, alignment: .center)
                                .padding(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(LinearGradient(colors: [Color.black], startPoint: .leading, endPoint: .trailing), lineWidth: 0.6)
                                )
                            Image(systemName: "shift")
                                .resizable()
                                .frame(width: 8, height: 8, alignment: .center)
                                .padding(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(LinearGradient(colors: [Color.black], startPoint: .leading, endPoint: .trailing), lineWidth: 0.6)
                                )
                            Text(state.text)
                                .font(.system(size: 10, weight: .regular, design: .default))
                                .foregroundColor(.white)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(LinearGradient(colors: [Color.black], startPoint: .leading, endPoint: .trailing), lineWidth: 0.6)
                                )
                        }
                    }
                }
                Spacer()
                Text(state.buttomTitle)
                    .font(.system(size: 12, weight: .regular, design: .default))
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(LinearGradient(colors: [Color.white], startPoint: .leading, endPoint: .trailing), lineWidth: 0.6)
                    )
            }
            Rectangle()
                .frame(height: 0.6)
                .foregroundColor(.black)
                .padding(.horizontal, -16)
                .isHidden(state == .github, remove: true)
        }
    }
    @ViewBuilder var commiteView: some View {
        VStack {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)
            HStack {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24, alignment: .center)
                    .overlay {
                        Image(systemName: "apple.logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20, alignment: .center)
                            .foregroundColor(.black)
                    }
                HStack {
                    TextField("Summary (required)", text: $viewModel.commitText)
                        .padding([.leading], 4)
                        .padding([.vertical], 3)
                        .textFieldStyle(.plain)
                        .focused($focusedField, equals: .firstName)
                    Spacer()
                }
                .background(Color.darkGray)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(LinearGradient(colors: [focusedField == .firstName ? Color.lightBlue : Color.white.opacity(0.6)], startPoint: .leading, endPoint: .trailing), lineWidth: 0.8)
                )
            }
            .padding(.horizontal, 10)
            VStack(alignment: .leading, spacing: 3) {
                TextField("Description", text: $viewModel.commitDescription, axis: .vertical)
                    .textFieldStyle(.plain)
                    .focused($focusedField, equals: .description)
                    .lineLimit(5, reservesSpace: true)
                    .padding([.all], 4)
                Button {
                    withAnimation {
                        viewModel.addMember.toggle()
                    }
                } label: {
                    Image(systemName: "person.badge.plus")
                        .resizable()
                        .frame(width: 18, height: 18, alignment: .center)
                        .foregroundColor(viewModel.addMember ? .lightBlue : .white.opacity(0.6))
                        .padding([.leading], 6)
                        .padding([.bottom], 2)
                }
                .buttonStyle(.plain)
                if viewModel.addMember {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.6))
                    TextField("Co-Authers  @username", text: $viewModel.memberText)
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .textFieldStyle(.plain)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                }
            }
            .background(Color.darkGray)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(LinearGradient(colors: [focusedField == .description ? Color.lightBlue :  Color.white.opacity(0.6)], startPoint: .leading, endPoint: .trailing), lineWidth: 0.8)
            )
            .padding([.horizontal], 10)
            Button {
                viewModel.commitText = ""
                viewModel.commitDescription = ""
            } label: {
                HStack(spacing: 20) {
                    Spacer()
                    HStack(spacing: 3) {
                        Text("Commit to")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(viewModel.commitText.isEmpty ? .white.opacity(0.6) : .white)
                            .lineLimit(1)
                        Text("feature/myBranch")
                            .font(.system(size: 12, weight: .semibold, design: .default))
                            .foregroundColor(viewModel.commitText.isEmpty ? .white.opacity(0.6) : .white)
                            .lineLimit(1)
                    }
                    Spacer()
                }
                .padding(.vertical, 6)
                .background(Color.lightBlue)
                .cornerRadius(6)
            }
            .padding([.horizontal, .bottom], 10)
            .buttonStyle(.plain)
        }
        .background(Color.lightestGray)
    }
    @ViewBuilder var repoListView: some View {
        VStack(spacing: 10) {
            HStack(spacing: 14) {
                HStack {
                    TextField("Filter", text: $viewModel.searchRepoText)
                        .padding([.leading], 4)
                        .padding([.vertical], 3)
                        .textFieldStyle(.plain)
                        .focused($focusedField, equals: .filter)
                    Spacer()
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(LinearGradient(colors: [focusedField == .filter ? Color.lightBlue : Color.white.opacity(0.6)], startPoint: .leading, endPoint: .trailing), lineWidth: 0.8)
                )
                Menu {
                    Button("Clone Repository...") {
                    }
                    Button("Create New Repository...") {
                    }
                    Button("Add Existing Repository...") {
                    }
                } label: {
                    Text("Add")
                        .font(.system(size: 12, weight: .medium, design: .default))
                }
                .colorScheme(.dark)
                .frame(width: 80)
            }
            .padding(.horizontal, 9)
            repoRecentView
            repoProjectView
        }
        .padding(.top, 10)
    }
    @ViewBuilder var repoRecentView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Recent")
                .font(.system(size: 12, weight: .medium, design: .default))
                .foregroundColor(.white)
                .padding(.horizontal, 9)
            LazyVStack(spacing: 2) {
                ForEach(Array(viewModel.recentList.enumerated()), id: \.0) { index, recent in
                    HStack(alignment: .center, spacing: 14) {
                        Image(systemName: "lock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15, alignment: .center)
                        Text(recent.name ?? "Chatie_iOS")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .frame(height: 28)
                    .padding(.horizontal, 9)
                    .background(recent.isSelected ?? true ? Color.lightestGray : Color.clear)
                    .onHover { over in
                        viewModel.recentList[index].isSelected = over
                    }
                }
            }
        }
    }
    @ViewBuilder var repoProjectView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Projects")
                .font(.system(size: 12, weight: .medium, design: .default))
                .foregroundColor(.white)
                .padding(.horizontal, 9)
            LazyVStack(spacing: 2) {
                ForEach(Array(viewModel.allProjectLIst.enumerated()), id: \.0) { index, recent in
                    HStack(alignment: .center, spacing: 14) {
                        Image(systemName: "lock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15, alignment: .center)
                        Text(recent.name ?? "")
                            .font(.system(size: 12, weight: .regular, design: .default))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .frame(height: 28)
                    .padding(.horizontal, 9)
                    .background(recent.isSelected ?? true ? Color.lightestGray : Color.clear)
                    .onHover { over in
                        viewModel.allProjectLIst[index].isSelected = over
                    }
                }
            }
        }
    }
}
#Preview {
    HomeView()
}
extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
