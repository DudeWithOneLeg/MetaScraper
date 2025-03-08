import { useContext } from "react";
import { PlaygroundContext } from "../../context/playground";

export default function FeatureToggle() {
    const {selected, setSelected} = useContext(PlaygroundContext)
    // const [] = useState('docs')

    return (
        <div className="w-full p-3">
            <div className="flex flex-row w-fit space-x-2 shadow-lg">
                <div
                    className={`${selected === 'docs' ? 'bg-blue-100' : 'hover:bg-blue-50'} rounded-t px-1 cursor-pointer`}
                    onClick={() => setSelected('docs')}
                >
                    <p>Docs</p>
                </div>
                <div
                    className={`${selected === 'playground' ? 'bg-blue-100' : 'hover:bg-blue-50'} rounded-t px-1 cursor-pointer`}
                    onClick={() => setSelected('playground')}
                >
                    <p>Playground</p>
                </div>
            </div>
        </div>
    )
}