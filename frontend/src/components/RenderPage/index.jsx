import { useContext, useEffect } from "react";
import { PlaygroundContext } from "../../context/playground";
import Documentation from "../Documentation"
import Description from "../Description"
import FeatureToggle from "../FeatureToggle"
import Playground from "../Playground";

// const pages = {
//     'marketplace': Marketplace
// }

export default function RenderPage() {
    const { selected, setSelected } = useContext(PlaygroundContext)
    
    // const {featureRoute} = useParams()

    return (
        <div className={`w-full h-full flex flex-col  ${selected === 'docs' ? 'justify-center' : 'items-center'}`}>
                <FeatureToggle />



                {selected === 'docs' ?

                    <div className="max-w-[1250px] shrink p-7 space-y-8 flex flex-col h-full">
                        <Description />
                        <Documentation />
                    </div>
                    : <Playground />}
        </div>
    )
}