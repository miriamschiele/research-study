(function(e){function t(t){for(var n,a,s=t[0],c=t[1],u=t[2],d=0,p=[];d<s.length;d++)a=s[d],Object.prototype.hasOwnProperty.call(o,a)&&o[a]&&p.push(o[a][0]),o[a]=0;for(n in c)Object.prototype.hasOwnProperty.call(c,n)&&(e[n]=c[n]);l&&l(t);while(p.length)p.shift()();return i.push.apply(i,u||[]),r()}function r(){for(var e,t=0;t<i.length;t++){for(var r=i[t],n=!0,a=1;a<r.length;a++){var c=r[a];0!==o[c]&&(n=!1)}n&&(i.splice(t--,1),e=s(s.s=r[0]))}return e}var n={},o={app:0},i=[];function a(e){return s.p+"js/"+({}[e]||e)+"."+{"chunk-bee0745c":"c42d27f2"}[e]+".js"}function s(t){if(n[t])return n[t].exports;var r=n[t]={i:t,l:!1,exports:{}};return e[t].call(r.exports,r,r.exports,s),r.l=!0,r.exports}s.e=function(e){var t=[],r=o[e];if(0!==r)if(r)t.push(r[2]);else{var n=new Promise((function(t,n){r=o[e]=[t,n]}));t.push(r[2]=n);var i,c=document.createElement("script");c.charset="utf-8",c.timeout=120,s.nc&&c.setAttribute("nonce",s.nc),c.src=a(e);var u=new Error;i=function(t){c.onerror=c.onload=null,clearTimeout(d);var r=o[e];if(0!==r){if(r){var n=t&&("load"===t.type?"missing":t.type),i=t&&t.target&&t.target.src;u.message="Loading chunk "+e+" failed.\n("+n+": "+i+")",u.name="ChunkLoadError",u.type=n,u.request=i,r[1](u)}o[e]=void 0}};var d=setTimeout((function(){i({type:"timeout",target:c})}),12e4);c.onerror=c.onload=i,document.head.appendChild(c)}return Promise.all(t)},s.m=e,s.c=n,s.d=function(e,t,r){s.o(e,t)||Object.defineProperty(e,t,{enumerable:!0,get:r})},s.r=function(e){"undefined"!==typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},s.t=function(e,t){if(1&t&&(e=s(e)),8&t)return e;if(4&t&&"object"===typeof e&&e&&e.__esModule)return e;var r=Object.create(null);if(s.r(r),Object.defineProperty(r,"default",{enumerable:!0,value:e}),2&t&&"string"!=typeof e)for(var n in e)s.d(r,n,function(t){return e[t]}.bind(null,n));return r},s.n=function(e){var t=e&&e.__esModule?function(){return e["default"]}:function(){return e};return s.d(t,"a",t),t},s.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},s.p="/research-study/",s.oe=function(e){throw console.error(e),e};var c=window["webpackJsonp"]=window["webpackJsonp"]||[],u=c.push.bind(c);c.push=t,c=c.slice();for(var d=0;d<c.length;d++)t(c[d]);var l=u;i.push([0,"chunk-vendors"]),r()})({0:function(e,t,r){e.exports=r("56d7")},1:function(e,t){},2:function(e,t){},"56d7":function(e,t,r){"use strict";r.r(t);var n=r("2b0e"),o=r("7591"),i=r.n(o),a=r("3665"),s=function(){var e=this,t=e._self._c;return t("Experiment",{attrs:{title:"magpie demo"}},[t("InstructionScreen",{attrs:{title:"Welcome"}},[e._v(" In this study, a short description of a problem is displayed. Then, you are asked to come up with a method to solve the problem. ")]),e.chooseQuestion()>.75?t("TextareaScreen",{attrs:{options:e.randomOption(),question:"In your opinion what does Addison need to do to reduce crime?",qud:"Crime is a wild beast preying on the city of Addison. The crime rate in the once peaceful city has steadily increased over the past three years. In fact, these days it seems that crime is lurking in every neighborhood. In 2004, 46,177 crimes were reported compared to more than 55,000 reported in 2007. The rise in violent crime is particularly alarming. In 2004, there were 330 murders in the city, in 2007, there were over 500."}}):e._e(),e.chooseQuestion()>.5&&e.chooseQuestion()<=.75?t("TextareaScreen",{attrs:{options:e.randomOption(),question:"In your opinion what does Addison need to do to reduce crime?",qud:"Crime is a virus infecting on the city of Addison. The crime rate in the once peaceful city has steadily increased over the past three years. In fact, these days it seems that crime is plaguing every neighborhood. In 2004, 46,177 crimes were reported compared to more than 55,000 reported in 2007. The rise in violent crime is particularly alarming. In 2004, there were 330 murders in the city, in 2007, there were over 500."}}):e._e(),e.chooseQuestion()>.25&&e.chooseQuestion()<=.5?t("TextareaScreen",{attrs:{options:e.randomOption(),question:"In your opinion what does Addison need to do to reduce crime?",qud:" Crime is a wild beast preying on the city of Addison. The crime rate in the once peaceful city has steadily increased over the past three years. In fact, these days it seems that crime is lurking in every neighborhood. The rise in violent crime is particularly alarming."}}):e._e(),e.chooseQuestion()<=.25?t("TextareaScreen",{attrs:{options:e.randomOption(),question:"In your opinion what does Addison need to do to reduce crime?",qud:"Crime is a virus infecting on the city of Addison. The crime rate in the once peaceful city has steadily increased over the past three years. In fact, these days it seems that crime is plaguing every neighborhood. The rise in violent crime is particularly alarming."}}):e._e(),t("Screen",[t("Slide",[e._v(" Please rate the reliability of the text. "),t("RatingInput",{attrs:{quid:"Quelle",right:"very reliable",left:"not reliable",response:e.$magpie.measurements.rating},on:{"update:response":function(t){return e.$set(e.$magpie.measurements,"rating",t)}}}),t("button",{on:{click:function(t){return e.$magpie.saveAndNextScreen()}}},[e._v("Submit")])],1)],1),t("ForcedChoiceScreen",{attrs:{options:["Democrat","Republican","neither","rather not say"],question:"Please state your political affiliation."}}),t("PostTestScreen"),t("SubmitResultsScreen")],1)},c=[],u=r("2ef0"),d=r.n(u),l={methods:{chooseQuestion:function(){return console.log(this.random),this.random},randomOption:function(){const e=this.options[Math.floor(Math.random()*this.options.length)],t=this.options.find(t=>t!==e);return[e,t]}},name:"App",data(){return{options:["Reform educational practices and create after school programs","Increase street patrols that look for criminals"],random:Math.random()}},computed:{_(){return d.a}}},p=l,h=r("2877"),m=Object(h["a"])(p,s,c,!1,null,null,null),f=m.exports,y={experimentId:"102",serverUrl:"https://mcmpact.ikw.uni-osnabrueck.de/magpie/",socketUrl:"wss://mcmpact.ikw.uni-osnabrueck.de/magpie/socket",completionUrl:"https://...",contactEmail:"m.schiele12@gmail.com",mode:"directLink",language:"en"};n["default"].config.productionTip=!1,n["default"].use(i.a,{prefix:"Canvas"}),n["default"].use(a["a"],y),new n["default"]({render:e=>e(f)}).$mount("#app")}});
//# sourceMappingURL=app.d17c6ae4.js.map