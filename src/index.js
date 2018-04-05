import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

const app = Main.embed(document.getElementById('root'), {
  environment: process.env.NODE_ENV,
});

app.ports.gtmPageView.subscribe(function(locationHash) {
  dataLayer.push({
    event: 'spa-page-view',
    locationHash: '/' + locationHash,
  });
});

app.ports.gtmAnalyzeProperty.subscribe(function(propertyAnalysisArgs) {
  dataLayer.push({
    event: 'analyze-property',
    propertyAnalysisArgs: propertyAnalysisArgs,
  });
});
