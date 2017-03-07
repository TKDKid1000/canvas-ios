// @flow

import { CoursesActions } from '../actions'
import { defaultState } from '../reducer'
import { testAsyncAction } from '../../../../test/helpers/async'
import { apiResponse } from '../../../../test/helpers/apiMock'

test('refresh courses workflow', async () => {
  const course: Course = {
    id: 1,
    name: 'foo 101',
    course_code: 'foo101',
    short_name: 'foo 101',
  }

  let actions = CoursesActions({ getCourses: apiResponse([course]) })
  const result = await testAsyncAction(actions.refreshCourses(), defaultState)

  expect(result).toMatchObject([
    {
      type: actions.refreshCourses.toString(),
      pending: true,
    },
    {
      type: actions.refreshCourses.toString(),
      payload: { data: [course] },
    },
  ])
})
