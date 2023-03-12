import Vue from 'vue';
import VueKonva from 'vue-konva';
import VueMagpie from 'magpie-base';
import FollowUp from './FollowUp.vue';
import magpieConfig from './magpie.config.js';

Vue.config.productionTip = false;

// Load Konva components
Vue.use(VueKonva, { prefix: 'Canvas' });

// Load magpie components
Vue.use(VueMagpie, magpieConfig);

// start app
new Vue({
  render: (h) => h(FollowUp)
}).$mount('#app');
