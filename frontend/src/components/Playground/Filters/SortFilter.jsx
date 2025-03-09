import { useState } from "react";

export default function SortFilter({ filter }) {
    const {
        title,
        type,
        defaultValue,
        options
    } = filter
    const [isExpanded, setIsExpanded] = useState(false)
    const [selectedSort, setSelectedSort] = useState(defaultValue)
    const toggleExpand = () => setIsExpanded(!isExpanded)

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
                                    selectedSort={selectedSort}
                                    setSelectedSort={setSelectedSort}
                                    type={type}
                                />
                            )
                        } else {
                            return (
                                <SortSelect
                                    option={option}
                                    selectedSort={selectedSort}
                                    setSelectedSort={setSelectedSort}
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
    selectedSort,
    setSelectedSort
}) => {
    const { title, value } = option
    const selected = value === selectedSort
    const updateSelectedSort = () => {
        setSelectedSort(value)
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
    selectedSort,
    setSelectedSort
}) => {
    const { title, value } = option
    const selected = selectedSort.includes(value)
    const updateSelectedSort = () => {
        if (!selected) {
            setSelectedSort(prev => [...prev, value])
        } else {
            setSelectedSort(prev => prev.filter(selection => selection !== value))
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