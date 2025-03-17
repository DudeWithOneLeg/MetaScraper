import { useState, useContext, useEffect } from "react";
import { PlaygroundContext } from "../../../context/playground";

export default function SortFilter({ filter }) {
    const {
        title,
        key,
        type,
        defaultValue,
        options
    } = filter
    const {setSearchParams} = useContext(PlaygroundContext)
    const [isExpanded, setIsExpanded] = useState(['range', 'boolean'].includes(type) ? true : false)
    const [selectedValue, setSelectedValue] = useState(defaultValue)
    const [defaultMin, setDefaultMin] = useState(0)
    const [defaultMax, setDefaultMax] = useState(214748364700)
    const toggleExpand = () => setIsExpanded(!isExpanded)

    useEffect(() => {
        setSearchParams(prev => {
            const newParams =  {...prev}
            newParams[key] = selectedValue
            return {...newParams}
        })
    },[selectedValue])

    return (
        <div

        >
            <div
                className="rounded w-full hover:bg-zinc-700 p-2 text-sm cursor-pointer"
                onClick={toggleExpand}

            >
                <p>{title}</p>

            </div>
            {isExpanded ?
                <div>
                    {options?.map(option => {

                        if (type === 'radio') {
                            return (
                                <SortRadio
                                    option={option}
                                    selectedValue={selectedValue}
                                    setSelectedValue={setSelectedValue}
                                />
                            )
                        } else if (type === "select") {
                            return (
                                <SortSelect
                                    option={option}
                                    selectedValue={selectedValue}
                                    setSelectedValue={setSelectedValue}
                                />
                            )
                        } else if (type === "range") {
                            return (
                                <FilterRange
                                    option={option}
                                    defaultMin={defaultMin}
                                    setDefaultMin={setDefaultMin}
                                    defaultMax={defaultMax}
                                    setDefaultMax={setDefaultMax}
                                />
                            )
                        }
                    })}
                </div> : <></>}
        </div>
    )
}

const SortRadio = ({
    option,
    selectedValue,
    setSelectedValue
}) => {
    const { title, value } = option
    const selected = value === selectedValue
    const updateSelectedSort = () => {
        setSelectedValue(value)
    }

    return (
        <div
            className="rounded w-full hover:bg-zinc-700 p-2 px-3 text-sm cursor-pointer flex flex-row items-center justify-between"
            onClick={updateSelectedSort}
        >
            <p>{title}</p>
            <div className="rounded-full border w-5 h-5 p-1">
                {selected ? <div className="rounded-full bg-blue-400 h-full w-full" /> : <></>}
            </div>
        </div>
    )
}

const SortSelect = ({
    option,
    selectedValue,
    setSelectedValue
}) => {
    const { title, value } = option
    const selected = selectedValue.includes(value)
    const updateSelectedSort = () => {
        if (!selected) {
            setSelectedValue(prev => [...prev, value])
        } else {
            setSelectedValue(prev => prev.filter(selection => selection !== value))
        }
    }

    return (
        <div
            className="rounded w-full hover:bg-zinc-700 p-2 px-3 text-sm cursor-pointer flex flex-row items-center justify-between"
            onClick={updateSelectedSort}
        >
            <p>{title}</p>
            <div className="rounded border w-5 h-5 p-1">
                {selected ? <div className="bg-blue-400 h-full w-full" /> : <></>}
            </div>
        </div>
    )
}

const FilterRange = ({
    option,
    defaultMin,
    defaultMax
}) => {
    const { title, value } = option
    const {
        setSearchParams
    } = useContext(PlaygroundContext)
    return (
        <div
            className="w-full h-fit space-y-1 flex flex-col text-white"
        >
            <p className="text-sm">{title}</p>
            <div
                className="w-full h-fit space-x-2 flex flex-row text-white"
            >

                <input
                    className="w-full h-8 rounded bg-zinc-700 border border-zinc-400 pl-1"
                    placeholder="Min"
                    type="number"
                    value={defaultMin}
                    onChange={(e) => setSearchParams(prev => {
                        const { value: min_price } = e.target
                        return { ...prev, min_price }
                    })}
                />

                <input
                    className="w-full h-8 rounded bg-zinc-700 border border-zinc-400 pl-1"
                    placeholder="Max"
                    type="number"
                    onChange={(e) => setSearchParams(prev => {
                        const { value: max_price } = e.target
                        return { ...prev, max_price }
                    })}
                />
            </div>

        </div>
    )
}