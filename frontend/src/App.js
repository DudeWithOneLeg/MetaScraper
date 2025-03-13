import { Routes, Route } from 'react-router-dom'
import Navigation from './components/Navigation';
import RenderPage from './components/RenderPage';
import logo from './logo.svg';
import './App.css';

function App() {


  return (
    <Routes>
      <Route path='/' element={<Navigation />}>
        <Route path='/:featureRoute' element={<RenderPage />} />
        <Route path='/:featureRoute/:subfeatureRoute' element={<RenderPage />} />
      </Route>
    </Routes>
  );
}

export default App;
