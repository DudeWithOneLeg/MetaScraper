import { Routes, Route } from 'react-router'
import Navigation from './components/Navigation';
import logo from './logo.svg';
import './App.css';

function App() {


  return (
    <Routes>
      <Route path='/' element={<Navigation />}>
      <Route path='/:featureRoute' element={<></>} />
        <Route path='/:featureRoute/:subfeatureRoute' element={<></>} />
      </Route>
    </Routes>
  );
}

export default App;
