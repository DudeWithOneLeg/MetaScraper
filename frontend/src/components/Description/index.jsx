import { useParams } from "react-router-dom"
import descriptions from './descriptions.json'

export default function Description() {
    const {featureRoute, subfeatureRoute} = useParams()
    const featureDescription = subfeatureRoute ? descriptions[subfeatureRoute] : descriptions[featureRoute]
    const {title, description} = featureDescription

    return (
        <div className="space-y-2 max-w-[534px] shrink">
            <div className="font-bold text-xl">
                <h1>{title}</h1>
            </div>
            <div className="text-sm">
                <p>{description}</p>
            </div>
        </div>
    )
}