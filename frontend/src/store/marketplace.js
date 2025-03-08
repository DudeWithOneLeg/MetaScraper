const PROPERRTY_SEARCH = 'marketplace/property'

const setMarketplacePropertyResults = (data) => {
    return {
        type: PROPERRTY_SEARCH,
        payload: data
    }
}

export const fetchPropertyResults = (params) => async dispatch => {
    let baseUrl = 'http://127.0.0.1:3000/facebook_marketplace_search?'

    for (let [key, value] of Object.entries(params)) {
        baseUrl += `${key}=${value}&`
    }
    const res = await fetch(baseUrl)
    const data = await res.json()

    dispatch(setMarketplacePropertyResults(data))
}

const initialState = {}

const marketplaceReducer = (state = initialState, action) => {
    switch (action.type) {
        case PROPERRTY_SEARCH:
            return {...state, results: {...action.payload}}
    
        default:
            return state;
    }
}

export default marketplaceReducer