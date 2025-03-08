import { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { fetchPropertyResults } from './store/marketplace';

export default function PropertySearch() {
    const propertyResults = useSelector(state => state.marketplace.results)
    const dispatch = useDispatch()

    useEffect(() => {
        dispatch(fetchPropertyResults())
    }, [dispatch])

    useEffect(() => {
        if (propertyResults) {
            console.log(propertyResults)
        }
    }, [propertyResults])
    return (
        <div>

        </div>
    )
}