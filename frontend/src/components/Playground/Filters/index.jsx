import { useDispatch } from "react-redux"
import { useParams } from "react-router-dom"
import { fetchPropertyResults } from '../../../store/marketplace';
import filterDropdownList from './filterDropdownList.json';
import SortFilter from "./SortFilter";

export default function Filters ({ setSearchParams, searchParams }) {

    const { featureRoute, subfeatureRoute } = useParams()
    const dispatch = useDispatch()

    const submitSearch = (e) => {
        const { key } = e

        if (key === 'Enter') {

            dispatch(fetchPropertyResults(searchParams))
        }

    }
    return (
        <div className="h-full w-[300px] bg-zinc-800 border-r border-zinc-600 flex flex-col p-2 space-y-2 text-zinc-300">
            <div>
                <p className="text-sm text-zinc-300">{subfeatureRoute ? subfeatureRoute : featureRoute}</p>
                <h1 className="text-2xl">Search Results</h1>
            </div>
            <div className="space-y-2">

                <input
                    className="rounded-full w-full h-8 bg-zinc-700 focus:outline-none px-2 text-white"
                    onChange={(e) => setSearchParams((prev) => {
                        return { ...prev, q: e.target.value }
                    })}
                    onKeyDown={submitSearch}
                />
            </div>
            {/* <Sort /> */}
            {filterDropdownList.map(filter => {
                return <SortFilter filter={filter}/>
            })}
            <div
                className="w-full h-fit space-y-1 flex flex-col text-white"
            >
                <p className="text-sm">Price</p>
                <div
                    className="w-full h-fit space-x-2 flex flex-row text-white"
                >

                    <input
                        className="w-full h-8 rounded bg-zinc-700 border border-zinc-400 pl-1"
                        placeholder="Min"
                        type="number"
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

        </div>
    )
}