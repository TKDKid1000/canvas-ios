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

public class CourseSelectorInteractorLive: CourseSelectorInteractor {
    // MARK: - Outputs
    public var state = CurrentValueSubject<StoreState, Never>(.loading)
    public var courses = CurrentValueSubject<[Course], Never>([])

    // MARK: - Private
    private var subscriptions = Set<AnyCancellable>()
    private let env: AppEnvironment
    private let enrollmentsStore: Store<GetConversationCourses>

    public init(env: AppEnvironment) {
        self.env = env
        self.enrollmentsStore = env.subscribe(GetConversationCourses())

        enrollmentsStore
            .statePublisher
            .subscribe(state)
            .store(in: &subscriptions)

        /* conversationStore
            .allObjects
            .map {
                $0.first?.subject ?? NSLocalizedString("No Subject", comment: "")
            }
            .subscribe(subject)
            .store(in: &subscriptions)
*/
        enrollmentsStore.refresh()
    }
}
