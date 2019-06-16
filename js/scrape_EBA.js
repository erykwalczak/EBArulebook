var url = 'https://eba.europa.eu/regulation-and-policy/single-rulebook/interactive-single-rulebook/-/interactive-single-rulebook/toc/504'; 

var page = new WebPage(); 
var fs = require('fs'); 

page.open(url, function (status) { 
just_wait(); }); 

function just_wait() { 
setTimeout(function() { 
fs.write('website_phantom.html', 
page.content, 'w'); 
phantom.exit(); }, 2500); 
}
