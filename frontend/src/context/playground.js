import { createContext, useEffect, useState } from "react";
import { useDispatch } from "react-redux";
import { fetchPropertyResults } from "../store/marketplace";

export const PlaygroundContext = createContext()

export default function PlaygroundProvider({children}) {
    const dispatch = useDispatch()
    const [selected, setSelected] = useState('docs')
    const [location, setLocation] = useState({
        name: "Lewisville, Texas", 
        radius_km: 64,
        latitude: 33.046289,
        longitude: -96.994123
    })
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
        delivery_type: 'all'
    })

    useEffect(() => {
        dispatch(fetchPropertyResults({...searchParams, condition: searchParams.condition.join(',')}))
        console.dir({...searchParams, condition: searchParams.condition.join(',')})
    },[searchParams])
    return (
        <PlaygroundContext.Provider value={{
            selected,
            setSelected,
            location,
            setLocation,
            searchParams,
            setSearchParams,
        }}>
            {children}
        </PlaygroundContext.Provider>
    )
}