import { createContext, useState } from "react";

export const PlaygroundContext = createContext()

export default function PlaygroundProvider({children}) {
    const [selected, setSelected] = useState('docs')
    const [location, setLocation] = useState({
        name: "Lewisville, Texas", 
        radius: 40,
        latitude: 33.046289,
        longitude: -96.994123
    })
    return (
        <PlaygroundContext.Provider value={{
            selected,
            setSelected,
            location,
            setLocation,
        }}>
            {children}
        </PlaygroundContext.Provider>
    )
}