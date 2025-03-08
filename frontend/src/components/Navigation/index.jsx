import { useState } from 'react'
import { Outlet, useNavigate, useParams } from 'react-router'

export default function Navigation() {
    return (
        <div className="flex flex-row h-screen w-screen">
            <div className='min-w-[300px] bg-slate-800 h-screen space-y-6 p-2'>
                <div className='p-4'>
                    <h1 className='font-bold text-2xl text-white'>Meta Scraper</h1>
                </div>
                <div className='space-y-2 pl-2'>
                    <div className='pl-2'>
                        <p className='text-zinc-400 text-xs'>API DOCUMENTATION</p>
                    </div>
                    <Features />
                </div>

            </div>
            <div className='h-screen w-full flex flex-col'>
                <div className='w-full h-14 bg-blue-50 border-b'/>

                <div className='w-full h-full flex flex-col overflow-y-scroll'>
                    {/* <div className='h-[60px] w-full border-b bg-blue-50' /> */}

                    <Outlet /> 
                </div>
                
            </div>

        </div>
    )
}


function Features() {
    const {featureRoute, subfeatureRoute} = useParams()
    const navigate = useNavigate()
    const [expand, setExpand] = useState(false)
    
    return (
        features.map(feature => {
            const { name, route, subFeatures } = feature
            const onClick = () => {
                navigate(route)
                setExpand(true)
            }
            return (
                <div className='text-sm'>
                    <div
                        className={`rounded-full pl-2 p-1 ${!subfeatureRoute && (featureRoute === route.replace('/', '')) ? 'bg-orange-400 font-bold' : 'hover:bg-slate-700'} text-white px-4 w-fit cursor-pointer`}
                        onClick={onClick}
                    >
                        <p>{name}</p>
                    </div>
                    {featureRoute === route.replace('/', '') ?
                        <div className='h-fit w-full pl-2 text-white'>
                            {subFeatures?.map(subFeature => {
                                const { name, route } = subFeature
                                const navToFeaturePage = () => navigate(`/marketplace/${route}`)

                                return (
                                    <div
                                        className={`rounded-full p-1 ${(subfeatureRoute === route.replace('/', '')) ? 'bg-orange-400 font-bold' : 'hover:bg-slate-700'} text-white px-4 w-fit cursor-pointer`}
                                        onClick={navToFeaturePage}
                                    >
                                        <p>{name}</p>
                                    </div>
                                )
                            })}

                        </div> : <></>}
                </div>
            )
        })
    )
}

const features = [
    {
        name: 'Marketplace API',
        route: '/marketplace',
        subFeatures: [
            {
                name: 'Vehicles',
                route: 'vehicles'
            },
            {
                name: 'Property Rentals',
                route: 'propertyRentals'
            },
            {
                name: 'Apparel',
                route: 'apparel'
            },
            {
                name: 'Classifieds',
                route: 'classifieds'
            },
            {
                name: 'Electronics',
                route: 'electronics'
            },
            {
                name: 'Entertainment',
                route: 'entertainment'
            },
            {
                name: 'Family',
                route: 'family'
            },
            {
                name: 'Free Stuff',
                route: 'freeStuff'
            },
            {
                name: 'Garden & Outdoor',
                route: 'gardenOutdoor'
            },
            {
                name: 'Hobbies',
                route: 'hobbies'
            },
            {
                name: 'Home Goods',
                route: 'homeGoods'
            },
            {
                name: 'Home Improvement Supplies',
                route: 'homeImprovementSupplies'
            },
            {
                name: 'Home Sales',
                route: 'homeSales'
            },
            {
                name: 'Musical Instruments',
                route: 'musicalInstruments'
            },
            {
                name: 'Office Supplies',
                route: 'officeSupplies'
            },
            {
                name: 'Pet Supplies',
                route: 'petSupplies'
            },
            {
                name: 'Sporting Goods',
                route: 'sportingGoods'
            },
            {
                name: 'Toys & Games',
                route: 'toysGames'
            },
        ]
    }
]