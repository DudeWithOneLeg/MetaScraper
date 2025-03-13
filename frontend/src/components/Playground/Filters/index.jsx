import { useState, useEffect, useContext } from "react";
import { useDispatch, useSelector } from "react-redux"
import { useParams } from "react-router-dom"
import { fetchPropertyResults } from '../../../store/marketplace';
import filterDropdownList from './filterDropdownList.json';
import SortFilter from "./SortFilter";
import { MapContainer, TileLayer, useMap, Circle } from 'react-leaflet'
import { fetchLocationResults } from "../../../store/marketplace";
import { PlaygroundContext } from "../../../context/playground";

export default function Filters({
    setSearchParams,
    searchParams,
    setShowMap
}) {

    const { featureRoute, subfeatureRoute } = useParams()
    const {
        location,
    } = useContext(PlaygroundContext)
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
                {/* <Map /> */}
            </div>
            {/* <Sort /> */}
            <div>
                <div>
                    <p>Filters</p>
                </div>
                <div onClick={() => setShowMap(true)}>
                    <div>
                        <p>Location</p>
                    </div>
                    <div
                        className="text-sm text-blue-600 rounded hover:bg-zinc-700"
                    >
                        <p>{location.name} - Within {location.radius} mi</p>
                    </div>
                </div>
            </div>
            {filterDropdownList.map(filter => {
                return <SortFilter filter={filter} />
            })}

            <PriceInput 
                setSearchParams={setSearchParams}
            />
        </div>
    )
}

const PriceInput = ({ setSearchParams }) => {
    return (
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
    )
}

export const MapDialog = ({ setShowMap }) => {
    const dispatch = useDispatch()
    const {
        setLocation,
        location,
    } = useContext(PlaygroundContext)
    const locationResults = useSelector(state => state.marketplace.locationResults)
    const [locationInput, setLocationInput] = useState(location.name)
    const [selectedRadius, setSelectedRadius] = useState(location.radius)
    const [selectedCoordinates, setSelectedCoordinates] = useState([
        location.latitude,
        location.longitude
    ])
    const [showLocationResults, setShowLocationResults] = useState(false)
    const [showRadiusList, setShowRadiusList] = useState(false)
    const mileToKm = (miles) => (miles * 1.60934).toFixed(1)
    const updateLocationInput = (e) => {
        const { value } = e.target
        setLocationInput(value)
    }

    // useEffect(() => {
    //     const km = mileToKm(selectedRadius)
    // }, [selectedRadius])


    useEffect(() => {
        const handler = setTimeout(() => {
            dispatch(fetchLocationResults(locationInput))
        }, 200);

        // Cleanup: cancel the timeout if value changes before delay
        return () => clearTimeout(handler);

    }, [locationInput])

    const applyLocationSelection = () => {
        const [latitude, longitude] = selectedCoordinates
        setLocation({
            name: locationInput,
            radius: selectedRadius,
            longitude,
            latitude
        })
        setShowMap(false)
    }

    // useEffect(() => {
    //     console.log(locationResults)

    // }, [locationResults])

    return (
        <div
            className="absolute w-full h-full flex items-center justify-center bg-black bg-opacity-50 z-10 rounded-lg text-white"
        // onClick={() => setShowMap(false)}
        >
            <div className="w-[500px] h-fit bg-zinc-800 rounded-lg divide-y divide-zinc-700">
                <div className="p-2 flex items-center ">
                    <p>Change Location</p>
                </div>
                <div className="p-2 space-y-2 h-fit">
                    <p className="text-xs text-zinc-400">Search by city, neighborhood or ZIP code.</p>
                    <div className="px-2 pb-2 space-y-2 h-fit">

                        <div className="rounded p-2 border border-zinc-400 relative">
                            <div>
                                <input
                                    className="bg-zinc-800 w-full"
                                    onChange={updateLocationInput}
                                    value={locationInput}
                                    onClick={() => setShowLocationResults(true)}
                                />
                            </div>
                            {showLocationResults ?
                                <LocationResultList
                                    results={locationResults}
                                    setShowLocationResults={setShowLocationResults}
                                    setLocationInput={setLocationInput}
                                    setSelectedCoordinates={setSelectedCoordinates}
                                /> : <></>}
                        </div>
                        <div className="rounded p-2 border border-zinc-400 relative">
                            <div

                                onClick={() => setShowRadiusList(true)}
                            >
                                <p>{selectedRadius} miles</p>
                            </div>
                            {showRadiusList ?
                                <LocationRadiusSelection
                                    setShowRadiusList={setShowRadiusList}
                                    setSelectedRadius={setSelectedRadius}
                                /> : <></>}
                        </div>
                        <div className="h-fit w-full z-10">
                            <Map
                                selectedRadius={selectedRadius}
                                selectedCoordinates={selectedCoordinates}
                            />
                        </div>
                    </div>
                </div>
                <div className="p-3 w-full flex justify-end">
                    <button
                        className="rounded px-2 py-1 flex items-center justify-center bg-blue-600"
                        onClick={applyLocationSelection}
                    >
                        Apply
                    </button>
                </div>
            </div>
        </div>
    )
}

const LocationResultList = ({
    results,
    setShowLocationResults,
    setLocationInput,
    setSelectedCoordinates
}) => {
    const handleLocationResultSelection = ({
        single_line_address,
        longitude,
        latitude
    }) => {
        setLocationInput(single_line_address)
        setSelectedCoordinates([latitude, longitude])
        setShowLocationResults(false)
    }

    return (
        <div className="rounded absolute top-full z-40 bg-zinc-800 w-full shadow-lg">
            {results.map(result => {
                const {
                    node: {
                        single_line_address,
                        location: {
                            longitude,
                            latitude
                        }
                    }
                } = result
                return (
                    <div
                        className="rounded p-2 hover:bg-zinc-700 cursor-pointer"
                        onClick={() => handleLocationResultSelection({ single_line_address, longitude, latitude })}>
                        <p>{single_line_address}</p>
                    </div>
                )
            })}
        </div>
    )
}

const LocationRadiusSelection = ({
    setShowRadiusList,
    setSelectedRadius
}) => {

    const radiusOptions = [1, 2, 5, 10, 20, 40, 60, 80, 100, 250, 500]
    const handleRadiusSelection = (value) => {
        setSelectedRadius(value)
        setShowRadiusList(false)
    }

    return (
        <div className="rounded absolute top-full left-0 z-40 bg-zinc-800 w-full shadow-xl shadow-black p-2">
            {radiusOptions.map(radius => {
                return (
                    <div
                        className="rounded p-2 hover:bg-zinc-700 cursor-pointer"
                        onClick={() => handleRadiusSelection(radius)}>
                        <p>{radius} miles</p>
                    </div>
                )
            })}
        </div>
    )
}

export const Map = ({
    selectedRadius,
    selectedCoordinates
}) => {

    return (

        <MapContainer
            center={[selectedCoordinates[0], selectedCoordinates[1]]}
            zoom={8}
            scrollWheelZoom={false}
            className="w-full h-[300px] rounded z-10"
        >
            <MapContent
                selectedRadius={selectedRadius}
                selectedCoordinates={selectedCoordinates}
            />
        </MapContainer>

    );
}

// Create a new component for the map content
const MapContent = ({
    selectedRadius,
    selectedCoordinates
}) => {
    const map = useMap();
    const [center, setCenter] = useState(map.getCenter());
    const radiusToZoom = {
        '1': 13,
        '2': 12,
        '5': 11,
        '10': 10,
        '20': 9,
        '40': 8,
        '60': 8,
        '80': 7,
        '100': 7,
        '250': 6,
        '500': 5
    }

    useEffect(() => {
        const handleMove = () => {
            setCenter(map.getCenter());
        };

        map.on('moveend', handleMove);

        // Cleanup listener
        return () => {
            map.off('moveend', handleMove);
        };
    }, [map]);

    useEffect(() => {
        map.setZoom(radiusToZoom[`${selectedRadius}`])
    }, [selectedRadius])

    useEffect(() => {
        const [lat, lng] = selectedCoordinates
        map.setView([lat, lng], radiusToZoom[`${selectedRadius}`])
    }, [selectedCoordinates])

    return (
        <>
            <TileLayer
                attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                url="https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png"
            />
            <Circle
                radius={selectedRadius * 1000}
                center={Object.values(center)} />
        </>
    );
}