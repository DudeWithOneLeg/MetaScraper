import { createContext, useState } from "react";

export const PlaygroundContext = createContext()

export default function PlaygroundProvider({children}) {
    const [selected, setSelected] = useState('docs')

    return (
        <PlaygroundContext.Provider value={{
            selected,
            setSelected
        }}>
            {children}
        </PlaygroundContext.Provider>
    )
}