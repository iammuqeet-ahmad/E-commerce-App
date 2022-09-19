// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require jquery.easy-autocomplete
//= require popper
//= require bootstrap-sprockets
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

$(document).on('turbolinks:load', function () {
  $('#flash_messages').delay(500).fadeOut();
})


// const plus = document.querySelector(".plus"),
//     minus = document.querySelector(".minus"),
//     num = document.querySelector(".num");
//     let a = 1;
//     plus.addEventListener("click", ()=>{
//       a++;
//       a = (a < 10) ? "0" + a : a;
//       num.innerText = a;
//     });

//     minus.addEventListener("click", ()=>{
//       if(a > 1){
//         a--;
//         a = (a < 10) ? "0" + a : a;
//         num.innerText = a;
//       }
//     });