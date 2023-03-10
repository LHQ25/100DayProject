import {useState} from "react";

function App()  {

    const [item, setItem] = useState('')
    const [list, setList] = useState(['1', '2', '3'])

    const addItem = () => {
        setList([...list, item])
        setItem('')
    }

    const handlerFiledChange = ({target}) => {
        setItem(target.value)
    }

    const createItem = list.map((item, index, _) => <li key={index}>{item}</li>)

    return <div >
      <input value={item} onChange={handlerFiledChange}/>
      <button onClick={addItem}>add</button>
      <ul>
        { createItem }
      </ul>
    </div>
}

export default App;
