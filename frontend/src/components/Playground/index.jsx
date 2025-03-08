import { useEffect, useState } from "react";
import { useSelector, useDispatch } from "react-redux"
import { useParams } from "react-router-dom"
import { fetchPropertyResults } from '../../store/marketplace';

export default function Playground() {
    const { featureRoute, subfeatureRoute } = useParams()
    const resultInfo = useSelector(state => state.marketplace.results)
    const [searchParams, setSearchParams] = useState({latitude: 33.046289, longitude: -96.994123})
    const [results, setResults] = useState(null)
    const [pageInfo, setPageInfo] = useState(null)
    console.log(resultInfo)
    // const {results} = resultInfo
    const dispatch = useDispatch()

    useEffect(() => {
        dispatch(fetchPropertyResults(searchParams))
    }, [dispatch])

    useEffect(() => {
        if (resultInfo) {
            const { results, page_info } = resultInfo
            setPageInfo(page_info)
            setResults(results)
        }
    }, [resultInfo])

    return (
        <div className="flex flex-row w-full h-full">
            <Filters setSearchParams={setSearchParams} searchParams={searchParams} />
            <div className="flex flex-wrap w-full h-full overflow-y-scroll bg-zinc-800 justify-center">

                {results?.map(result => {
                    return <Result result={result} />
                })}
            </div>
            {/* <div className="absolute w-full h-full inset-0 bg-opacity-25 bg-zinc-400"/> */}


        </div>
    )
}

const Result = ({ result }) => {
    const {
        primary_listing_photo: {
            image: { uri }
        },
        listing_price: { formatted_amount },
        custom_title,
        custom_sub_titles_with_rendering_flags: custom_subtitles,
        marketplace_listing_title,
        location: {reverse_geocode: {city_page: {display_name}}}
    } = result


    return (
        <div className="rounded flex flex-col basis-1/6 p-2 space-y-2 cursor-pointer">
            <div>
                <img src={uri ? uri : ''} className="rounded-lg" />
            </div>
            <div className="text-white">
                <p>{formatted_amount ? formatted_amount : ''}</p>
                <p>{custom_title ? custom_title : ''}</p>
                {custom_subtitles.length ? custom_subtitles.map(custom_subtitle => {
                    const { subtitle } = custom_subtitle
                    return (
                        <p className="text-xs text-gray-400">{subtitle ? subtitle : ''}</p>
                    )
                }) : (marketplace_listing_title ? <p className="text-sm line-clamp-2">{marketplace_listing_title}</p> : '')}
                <p className="text-xs text-gray-400">{display_name ? display_name : ''}</p>
            </div>

        </div>
    )
}

const Filters = ({ setSearchParams, searchParams }) => {

    const { featureRoute, subfeatureRoute } = useParams()
    const dispatch = useDispatch()

    const submitSearch = (e) => {
        const { key } = e

        if (key === 'Enter') {

            dispatch(fetchPropertyResults(searchParams))
        }

    }
    return (
        <div className="h-full w-[300px] bg-zinc-700 border-r border-zinc-600 flex flex-col p-3 space-y-2 text-white">
            <div>
                <p className="text-sm text-zinc-300">{subfeatureRoute ? subfeatureRoute : featureRoute}</p>
                <h1 className="text-2xl">Search Results</h1>
            </div>
            <div className="space-y-2">

                <input
                    className="rounded-full w-full h-8 bg-zinc-600 focus:outline-none px-2 text-white"
                    onChange={(e) => setSearchParams((prev) => {
                        return { ...prev, q: e.target.value }
                    })}
                    onKeyDown={submitSearch}
                />
            </div>
            <div
                className="w-full h-fit space-y-1 flex flex-col text-white"
            >
                <p className="text-sm">Price</p>
                <div
                    className="w-full h-fit space-x-2 flex flex-row text-white"
                >

                    <input
                        className="w-full h-8 rounded bg-zinc-600 border border-zinc-400 pl-1"
                        placeholder="Min"
                        type="number"
                        onChange={(e) => setSearchParams(prev => {
                            const {value: min_price} = e.target
                            return {...prev, min_price}
                        })}
                    />

                    <input
                        className="w-full h-8 rounded bg-zinc-600 border border-zinc-400 pl-1"
                        placeholder="Max"
                        type="number"
                        onChange={(e) => setSearchParams(prev => {
                            const {value: max_price} = e.target
                            return {...prev, max_price}
                        })}
                    />
                </div>

            </div>

        </div>
    )
}