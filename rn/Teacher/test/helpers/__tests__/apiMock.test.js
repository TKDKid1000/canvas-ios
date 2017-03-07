/* @flow */

import { apiResponse, apiError } from '../apiMock'

describe('apiResponse', () => {
  it('should mock data', async () => {
    const fn = apiResponse({ foo: 'bar' })
    const response = await fn(1)
    expect(response.data.foo).toEqual('bar')
  })

  it('should mock pagination', async () => {
    const getPageThree = apiResponse([3])
    const getPageTwo = apiResponse([2], { next: getPageThree })
    const getPageOne = apiResponse([1], { next: getPageTwo })

    const page1 = await getPageOne()
    const page2 = await page1.next()
    const page3 = await page2.next()

    expect(page1.data).toEqual([1])
    expect(page2.data).toEqual([2])
    expect(page3.data).toEqual([3])
  })

  it('should mock status by default', async () => {
    const fn = apiResponse([])
    const response = await fn()
    expect(response.status).toBe(200)
  })

  it('should mock custom status', async () => {
    const fn = apiResponse([], { status: 302 })
    const response = await fn()
    expect(response.status).toBe(302)
  })

  it('should mock headers by default', async () => {
    const fn = apiResponse([])
    const response = await fn()
    expect(response.headers).toEqual({ link: null })
  })

  it('should mock custom headers', async () => {
    const expectedHeaders = {
      link: null,
      'Content-Type': 'application/json',
    }
    const fn = apiResponse([], { headers: expectedHeaders })
    const response = await fn()
    expect(response.headers).toEqual(expectedHeaders)
  })
})

describe('apiError', async () => {
  it('should mock error', async () => {
    const fn = apiError()
    let caughtError = false
    try {
      await fn()
    } catch (error) {
      caughtError = true
      expect(error.status).toBe(401)
      expect(error.data.errors).toHaveLength(1)
      expect(error.data.errors[0].message).toEqual('Default mock api error')
    }
    expect(caughtError).toBeTruthy()
  })

  it('should mock custom error', async () => {
    const fn = apiError({ status: 500, message: 'Server Error' })
    let caughtError = false
    try {
      await fn()
    } catch (error) {
      caughtError = true
      expect(error.status).toBe(500)
      expect(error.data.errors).toHaveLength(1)
      expect(error.data.errors[0].message).toEqual('Server Error')
    }
    expect(caughtError).toBeTruthy()
  })
})
