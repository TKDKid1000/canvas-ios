//
// This file is part of Canvas.
// Copyright (C) 2023-present  Instructure, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

import Combine

public protocol GroupListInteractor {
    // MARK: - Outputs

    func getGroups() -> AnyPublisher<[AllCoursesGroupItem], Error>

    // MARK: - Inputs

    func loadAsync()
    func refresh() -> AnyPublisher<Void, Never>
    func setFilter(_ filter: String) -> AnyPublisher<Void, Never>
}

public class GroupListInteractorLive: GroupListInteractor {
    // MARK: - Dependencies

    private let env: AppEnvironment

    // MARK: - Private properties

    private let groupListStore: ReactiveStore<GetAllCoursesGroupListUseCase>
    private let searchQuery = CurrentValueSubject<String, Error>("")
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Init

    public init(env: AppEnvironment = .shared) {
        self.env = env

        groupListStore = ReactiveStore(
            useCase: GetAllCoursesGroupListUseCase()
        )
    }

    // MARK: - Outputs

    public func getGroups() -> AnyPublisher<[AllCoursesGroupItem], Error> {
        groupListStore
            .observeEntitiesWithError()
            .map { $0.map { AllCoursesGroupItem(from: $0 )}}
            .eraseToAnyPublisher()
    }

    // MARK: - Inputs

    public func loadAsync() {
        groupListStore
            .getEntities()
            .sink()
            .store(in: &subscriptions)
    }

    public func refresh() -> AnyPublisher<Void, Never> {
        groupListStore.forceFetchEntities()
    }

    public func setFilter(_ filter: String) -> AnyPublisher<Void, Never> {
        searchQuery.send(filter)
        return Just(()).eraseToAnyPublisher()
    }
}
