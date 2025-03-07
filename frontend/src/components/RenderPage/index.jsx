import Documentation from "../Documentation"
import Description from "../Description"

// const pages = {
//     'marketplace': Marketplace
// }

export default function RenderPage() {
    // const {featureRoute} = useParams()

    return (
            <div className="min-w-[1280px] shrink p-7 space-y-8">
                <Description />
                <Documentation />
            </div>
    )
}