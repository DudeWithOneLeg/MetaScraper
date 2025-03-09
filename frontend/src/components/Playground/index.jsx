import { useEffect, useState } from "react";
import { useSelector, useDispatch } from "react-redux"
import { useParams } from "react-router-dom"
import { fetchPropertyResults } from '../../store/marketplace';
import Filters from "./Filters";

export default function Playground() {
    const { featureRoute, subfeatureRoute } = useParams()
    const resultInfo = useSelector(state => state.marketplace.results)
    const [searchParams, setSearchParams] = useState({ latitude: 33.046289, longitude: -96.994123 })
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
            <Filters
                setSearchParams={setSearchParams}
                searchParams={searchParams}
            />
            <div className="flex flex-wrap w-full h-full overflow-y-scroll bg-zinc-900 justify-center">

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
        location: { 
            reverse_geocode: { 
                city_page: { 
                    display_name 
                } 
            } 
        }
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

