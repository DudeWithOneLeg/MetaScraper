const SEARCH = 'marketplace/search'
const LOCATION_SEARCH = 'location/search'
let baseUrl = 'http://127.0.0.1:3000'

const setLocationResults = (data) => {
    return {
        type: LOCATION_SEARCH,
        payload: data
    }
}

export const fetchLocationResults = (query) => async dispatch  => {
    const url = `${baseUrl}/facebook_location_id_search?query=${query}`
    const res = await fetch(url)
    const data = await res.json()
    dispatch(setLocationResults(data))

}

const setMarketplacePropertyResults = (data) => {
    return {
        type: SEARCH,
        payload: data
    }
}

export const fetchPropertyResults = (params) => async dispatch => {
    let url = `/facebook_marketplace_search?`

    for (let [key, value] of Object.entries(params)) {
        url += `${key}=${value}&`
    }
    const res = await fetch(url)
    const data = await res.json()

    dispatch(setMarketplacePropertyResults(data))
}

const initialState = {}

const marketplaceReducer = (state = initialState, action) => {
    switch (action.type) {
        case SEARCH:
            return {...state, results: {...action.payload}}
        case LOCATION_SEARCH:
            return {...state, locationResults: [...action.payload]}
        default:
            return state;
    }
}

export default marketplaceReducer