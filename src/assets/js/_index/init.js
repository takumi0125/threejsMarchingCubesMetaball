const ENV = require('../_env');
const g = window[ENV.projectName] = window[ENV.projectName] || {};

import Main from './Main'
window.addEventListener('DOMContentLoaded', ()=> {
  g.main = new Main();
});
