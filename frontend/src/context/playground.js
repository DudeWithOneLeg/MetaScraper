import { createContext, useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { fetchPropertyResults } from "../store/marketplace";

export const PlaygroundContext = createContext()

export default function PlaygroundProvider({children}) {
    const resultInfo = useSelector(state => state.marketplace.results)
    const dispatch = useDispatch()
    const [selected, setSelected] = useState('docs')
    const [searchParams, setSearchParams] = useState({
        q: "",
        locationName: "Lewisville, Texas", 
        radius_mi: 40,
        radius_km: 64,
        latitude: 33.046289,
        longitude: -96.994123,
        condition: [],
        sort_by: 'BEST_MATCH',
        availability: true,
        delivery_type: 'all',
        limit: 24,
        page: 0,
        next_cursor: "AbrvkJqYcXPwR-JW82eTCB8PMU3mqW7sTa92L5bQ0F8gKoO-UVP6u305mnJTh1dwhQvozgjwXWAUolCxoUIw-RZSqkFDx40E0ysNl8SnoqMn1Cud1xjNDb2pZHFE1dbTUnQqQ-n3H-5KNKj7Fa7gxFvmH2_w8IvySHyH0_puIHx2SEGsFfFaBLOYrB2rGBE5ccEnTy52uVpU0xhSk5avpKienrkGs6h3Be2wTMfRxO_Vzput9KoitqgrAwxDV56W8iPvKNB_Qdea17-5LS2hqjp2cnYElgTQhtHNr1VreJQcQjFKl_HCAvAz2BNBVoBIBb4xmgaaZLP0XipFougXr1aTDylvFJTMFDa7XLPEQLNSOboYaVZQMsvurT55GaAmiqkIaUraxkZ20EO6rqgvPCllopIz-l1S4kIm-b51lrMZ8J3Aqh8gTA4bH3oQoFOP2AJ_1kFYWNRKXTQxG2CGkVH77iL2MTULwSgh89cmK6NYOHGU3jqO483X3fOv-ALm4HTVlPBkptTUrP-R3tSY1WgckjzRZSdqBmuijfzNY9MRPwrf1W5KwQLF3zUENE8_Aw8"
    })

    useEffect(() => {
        dispatch(
            fetchPropertyResults(
                {
                    ...searchParams, 
                    condition: searchParams.condition.join(',')
                }
            )
        ).then(async () => {
            const {end_cursor} = resultInfo.page_info
            dispatch(
                fetchPropertyResults(
                    {
                        ...searchParams, 
                        condition: searchParams.condition.join(','),
                        page: 1,
                        next: true,
                        next_cursor: end_cursor
                    }
                )
            )
        })
        console.dir({...searchParams, condition: searchParams.condition.join(',')})
    },[searchParams])
    return (
        <PlaygroundContext.Provider value={{
            selected,
            setSelected,
            searchParams,
            setSearchParams,
        }}>
            {children}
        </PlaygroundContext.Provider>
    )
}