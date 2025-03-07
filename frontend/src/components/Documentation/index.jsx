import { useParams } from "react-router-dom"
import docs from './parameters.json'

export default function Documentation() {
    const { featureRoute, subfeatureRoute } = useParams()
    const featureDocs = subfeatureRoute ? docs[subfeatureRoute] : docs[featureRoute]
    const { sections } = featureDocs
    console.log(featureRoute)

    return (
        <div className="w-full space-y-4">
            <div className="font-bold">
                <p>API Parameters</p>
            </div>
            {
                sections.map(section => {
                    return <Section section={section} />
                })
            }
        </div>
    )
}

const Section = ({ section }) => {
    const { name, params } = section

    return (
        <div className="rounded-lg border max-w-[818px] shrink">
            <div className="border-b bg-blue-100 p-2">
                <p>{name}</p>
            </div>
            <div className="flex flex-col space-y-2">
                {params.map(param => {
                    return <Param param={param} />
                })}
            </div>
        </div>
    )
}

const Param = ({ param }) => {
    const { name, required, description } = param

    return (
        <div className="w-full flex flex-row p-4 text-sm">
            <div className="min-w-[145px] shrink">
                <p className="rounded bg-slate-300 w-fit px-1">{name}</p>
            </div>
            <div className="min-w-[100px] shrink">
                <p>{required ? 'Required' : 'Optional'}</p>
            </div>
            <div className="h-fit">
                <p>{description}</p>
            </div>
        </div>
    )
}