//
// This file is part of Canvas.
// Copyright (C) 2020-present  Instructure, Inc.
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

import SwiftUI

public struct ContextCardView: View {
    @Environment(\.viewController) private var controller
    @ObservedObject private var model: ContextCardViewModel
    @ObservedObject private var offlineModeViewModel: OfflineModeViewModel

    public init(model: ContextCardViewModel, offlineModeViewModel: OfflineModeViewModel = OfflineModeViewModel(interactor: OfflineModeInteractorLive.shared)) {
        self.model = model
        self.offlineModeViewModel = offlineModeViewModel
    }

    public var body: some View {
        contextCard
            .background(Color.backgroundLightest)
            .navigationBarItems(trailing: emailButton)
            .navigationTitle(model.user.first?.name ?? "", subtitle: model.course.first?.name ?? "")
            .onAppear {
                model.viewAppeared()
            }
    }

    @ViewBuilder var emailButton: some View {
        if model.permissions.first?.sendMessages == true, model.isViewingAnotherUser {
            PrimaryButton(isAvailable: !$offlineModeViewModel.isOffline,
                          action: { model.openNewMessageComposer(controller: controller.value) }, label: {
                let color = model.isModal ? Brand.shared.buttonPrimaryBackground : Brand.shared.buttonPrimaryText
                Image.emailLine.foregroundColor(Color(color))
            })
            .accessibility(label: Text("Send message", bundle: .core))
            .identifier("ContextCard.emailContact")
        }
    }

    @ViewBuilder var contextCard: some View {
        if model.pending {
            ProgressView()
                .progressViewStyle(.indeterminateCircle())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            if let course = model.course.first, let user = model.user.first, let enrollment = model.enrollment {
                ScrollView {
                    ContextCardHeaderView(user: user, course: course, sections: model.sections.all,
                                          enrollment: enrollment, showLastActivity: model.isLastActivityVisible, isOffline: offlineModeViewModel.isOffline)
                    if enrollment.isStudent {
                        if let grades = enrollment.grades.first, !model.shouldHideScore {
                            ContextCardGradesView(grades: grades, color: Color(course.color))
                        }
                        if model.submissions.all.count != 0 {
                            ContextCardSubmissionsView(submissions: model.submissions.all)
                        }
                    }
                    if model.isSubmissionRowsVisible {
                        submissionRows
                    }
                }.onAppear {
                    UIAccessibility.post(notification: .screenChanged, argument: nil)
                }
            } else if let course = model.course.first, let user = model.user.first,
                      let enrollment = user.enrollments.first(where: { $0.course?.id == course.id}),
                      enrollment.state == .invited {
                EmptyPanda(.Sleeping, title: Text("Not enrolled"), message: Text("Invitation pending"))
            } else {
                EmptyPanda(.Unsupported, title: Text("Something went wrong"), message: Text("There was an error while communicating with the server"))
            }
        }
    }

    @ViewBuilder var submissionRows: some View {
        ForEach(model.submissions.all) { submission in
            if let assignment = model.assignment(with: submission.assignmentID) {
                Divider()
                ContextCardSubmissionRow(assignment: assignment, submission: submission)

                if model.submissions.last == submission {
                    Divider()
                }
            }
        }
    }
}

#if DEBUG
struct ContextCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContextCardView(model: ContextCardViewModel(courseID: "1", userID: "1", currentUserID: "0"))
    }
}
#endif
