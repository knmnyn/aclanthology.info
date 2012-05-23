/*
Flot plugin for selecting regions.

The plugin defines the following options:

  selection: {
    mode: null or "x" or "y" or "xy",
    color: color
  }

Selection support is enabled by setting the mode to one of "x", "y" or
"xy". In "x" mode, the user will only be able to specify the x range,
similarly for "y" mode. For "xy", the selection becomes a rectangle
where both ranges can be specified. "color" is color of the selection.

When selection support is enabled, a "plotselected" event will be
emitted on the DOM element you passed into the plot function. The
event handler gets a parameter with the ranges selected on the axes,
like this:

  placeholder.bind("plotselected", function(event, ranges) {
    alert("You selected " + ranges.xaxis.from + " to " + ranges.xaxis.to)
    // similar for yaxis - with multiple axes, the extra ones are in
    // x2axis, x3axis, ...
  });

The "plotselected" event is only fired when the user has finished
making the selection. A "plotselecting" event is fired during the
process with the same parameters as the "plotselected" event, in case
you want to know what's happening while it's happening,

A "plotunselected" event with no arguments is emitted when the user
clicks the mouse to remove the selection.

The plugin allso adds the following methods to the plot object:

- setSelection(ranges, preventEvent)

  Set the selection rectangle. The passed in ranges is on the same
  form as returned in the "plotselected" event. If the selection mode
  is "x", you should put in either an xaxis range, if the mode is "y"
  you need to put in an yaxis range and both xaxis and yaxis if the
  selection mode is "xy", like this:

    setSelection({ xaxis: { from: 0, to: 10 }, yaxis: { from: 40, to: 60 } });

  setSelection will trigger the "plotselected" event when called. If
  you don't want that to happen, e.g. if you're inside a
  "plotselected" handler, pass true as the second parameter. If you
  are using multiple axes, you can specify the ranges on any of those,
  e.g. as x2axis/x3axis/... instead of xaxis, the plugin picks the
  first one it sees.
  
- clearSelection(preventEvent)

  Clear the selection rectangle. Pass in true to avoid getting a
  "plotunselected" event.

- getSelection()

  Returns the current selection in the same format as the
  "plotselected" event. If there's currently no selection, the
  function returns null.

*/
(function(a){function b(b){function e(a){c.active&&(b.getPlaceholder().trigger("plotselecting",[h()]),m(a))}function f(b){if(b.which!=1)return;document.body.focus(),document.onselectstart!==undefined&&d.onselectstart==null&&(d.onselectstart=document.onselectstart,document.onselectstart=function(){return!1}),document.ondrag!==undefined&&d.ondrag==null&&(d.ondrag=document.ondrag,document.ondrag=function(){return!1}),l(c.first,b),c.active=!0,a(document).one("mouseup",g)}function g(a){return document.onselectstart!==undefined&&(document.onselectstart=d.onselectstart),document.ondrag!==undefined&&(document.ondrag=d.ondrag),c.active=!1,m(a),q()?j():(b.getPlaceholder().trigger("plotunselected",[]),b.getPlaceholder().trigger("plotselecting",[null])),!1}function h(){if(!q())return null;var d={},e=c.first,f=c.second;return a.each(b.getAxes(),function(a,b){if(b.used){var c=b.c2p(e[b.direction]),g=b.c2p(f[b.direction]);d[a]={from:Math.min(c,g),to:Math.max(c,g)}}}),d}function j(){var a=h();b.getPlaceholder().trigger("plotselected",[a]),a.xaxis&&a.yaxis&&b.getPlaceholder().trigger("selected",[{x1:a.xaxis.from,y1:a.yaxis.from,x2:a.xaxis.to,y2:a.yaxis.to}])}function k(a,b,c){return b<a?a:b>c?c:b}function l(a,d){var e=b.getOptions(),f=b.getPlaceholder().offset(),g=b.getPlotOffset();a.x=k(0,d.pageX-f.left-g.left,b.width()),a.y=k(0,d.pageY-f.top-g.top,b.height()),e.selection.mode=="y"&&(a.x=a==c.first?0:b.width()),e.selection.mode=="x"&&(a.y=a==c.first?0:b.height())}function m(a){if(a.pageX==null)return;l(c.second,a),q()?(c.show=!0,b.triggerRedrawOverlay()):n(!0)}function n(a){c.show&&(c.show=!1,b.triggerRedrawOverlay(),a||b.getPlaceholder().trigger("plotunselected",[]))}function o(a,c){var d,e,f,g,h;g=b.getUsedAxes();for(i=0;i<g.length;++i){d=g[i];if(d.direction==c){h=c+d.n+"axis",!a[h]&&d.n==1&&(h=c+"axis");if(a[h]){e=a[h].from,f=a[h].to;break}}}a[h]||(d=c=="x"?b.getXAxes()[0]:b.getYAxes()[0],e=a[c+"1"],f=a[c+"2"]);if(e!=null&&f!=null&&e>f){var j=e;e=f,f=j}return{from:e,to:f,axis:d}}function p(a,d){var e,f,g=b.getOptions();g.selection.mode=="y"?(c.first.x=0,c.second.x=b.width()):(f=o(a,"x"),c.first.x=f.axis.p2c(f.from),c.second.x=f.axis.p2c(f.to)),g.selection.mode=="x"?(c.first.y=0,c.second.y=b.height()):(f=o(a,"y"),c.first.y=f.axis.p2c(f.from),c.second.y=f.axis.p2c(f.to)),c.show=!0,b.triggerRedrawOverlay(),!d&&q()&&j()}function q(){var a=5;return Math.abs(c.second.x-c.first.x)>=a&&Math.abs(c.second.y-c.first.y)>=a}var c={first:{x:-1,y:-1},second:{x:-1,y:-1},show:!1,active:!1},d={};b.clearSelection=n,b.setSelection=p,b.getSelection=h,b.hooks.bindEvents.push(function(a,b){var c=a.getOptions();c.selection.mode!=null&&b.mousemove(e),c.selection.mode!=null&&b.mousedown(f)}),b.hooks.drawOverlay.push(function(b,d){if(c.show&&q()){var e=b.getPlotOffset(),f=b.getOptions();d.save(),d.translate(e.left,e.top);var g=a.color.parse(f.selection.color);d.strokeStyle=g.scale("a",.8).toString(),d.lineWidth=1,d.lineJoin="round",d.fillStyle=g.scale("a",.4).toString();var h=Math.min(c.first.x,c.second.x),i=Math.min(c.first.y,c.second.y),j=Math.abs(c.second.x-c.first.x),k=Math.abs(c.second.y-c.first.y);d.fillRect(h,i,j,k),d.strokeRect(h,i,j,k),d.restore()}})}a.plot.plugins.push({init:b,options:{selection:{mode:null,color:"#e8cfac"}},name:"selection",version:"1.0"})})(jQuery);