const PROPERRTY_SEARCH = 'mnarketplace/property'

const setMarketplacePropertyResults = (data) => {
    return {
        type: PROPERRTY_SEARCH,
        payload: data
    }
}

export const fetchPropertyResults = (query) => async dispatch => {
    const res = await fetch(`http://127.0.0.1:3000/facebook_property_search?query=gary`)
    const data = await res.json()

    dispatch(setMarketplacePropertyResults(data))
}

const initialState = {}

const marketplaceReducer = (state = initialState, action) => {
    switch (action.type) {
        case PROPERRTY_SEARCH:
            return {...state, propertyResults: {...action.payload}}
    
        default:
            return state;
    }
}

export default marketplaceReducer