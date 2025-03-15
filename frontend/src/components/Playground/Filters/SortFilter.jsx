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
    const [isExpanded, setIsExpanded] = useState(false)
    const [selectedValue, setSelectedValue] = useState(defaultValue)
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
                    {options.map(option => {

                        if (type === 'radio') {
                            return (
                                <SortRadio
                                    option={option}
                                    selectedValue={selectedValue}
                                    setSelectedValue={setSelectedValue}
                                    type={type}
                                />
                            )
                        } else {
                            return (
                                <SortSelect
                                    option={option}
                                    selectedValue={selectedValue}
                                    setSelectedValue={setSelectedValue}
                                    type={type}
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