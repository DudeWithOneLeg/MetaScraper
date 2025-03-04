import { createStore, combineReducers, applyMiddleware, compose } from '@reduxjs/toolkit';
import { thunk } from 'redux-thunk';
import marketplaceReducer from './marketplace';

const rootReducer = combineReducers({
    marketplace: marketplaceReducer
})

// const store = configureStore({
//     reducer,
//     middleware: (getDefaultMiddleware) =>
//         getDefaultMiddleware({
//             immutableCheck: false, // Disable ImmutableStateInvariantMiddleware
//             serializableCheck: false, // Optional: Disable SerializableStateInvariantMiddleware
//         }),
// }, applyMiddleware(thunk))
let enhancer;

if (process.env.NODE_ENV === "production") {
  enhancer = applyMiddleware(thunk);
} else {
  const logger = require("redux-logger").default;
  const composeEnhancers =
    window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;
  enhancer = composeEnhancers(applyMiddleware(thunk, logger));
}

const configureStore = (preloadedState) => {
  return createStore(rootReducer, preloadedState, enhancer);
};

export default configureStore;