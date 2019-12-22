var el = document.getElementById('add_item');
if (el !== null) {
  el.onclick = function(e){
    let time = new Date().getTime()
    let template = el.getAttribute('data-template')
    var uniq_template = template.replace(/\[0]/g, `[${time}]`)
    this.insertAdjacentHTML('beforebegin', uniq_template)
  };
}
