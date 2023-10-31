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

import Foundation

public struct AllCoursesGroupItem: Equatable {
    public let id: String
    public let name: String

    public let courseID: String?
    public let courseName: String?
    public let courseTermName: String?
    public let courseRoles: String?

    public let concluded: Bool
    public let isFavorite: Bool

    init(from entity: CDAllCoursesGroupItem) {
        self.id = entity.id
        self.name = entity.name
        self.courseID = entity.courseID
        self.courseName = entity.courseName
        self.courseTermName = entity.courseTermName
        self.courseRoles = entity.courseRoles
        self.concluded = entity.concluded
        self.isFavorite = entity.isFavorite
    }
}
