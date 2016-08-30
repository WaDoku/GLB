// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require ckeditor/init
//= require_tree .

var count = 0;
var pages = ["page0", "page1", "page2", "page3", "page4", "page5", "page6", "page7", "page8"];
var page_titles = ["oben", "mitte", "unten", "oben", "mitte", "unten", "oben", "mitte", "unten"];

$(document).ready(function () {
  set_page_number()
});

$(document).on("page:load", function() {
  set_page_number()
})

function set_page_number() {
  count = 0;
  var default_page_number = document.getElementById("kennzahl").dataset.kennzahl;
  document.getElementById("page_count").innerHTML = 'Seite ' + default_page_number + ', oben';
}

function back_first_switch() {
  count = 0;
  write_page_count();
}

function back_switch() {
  if (count <= 0) {
    count = 0;
  } else {
    count--;
  }
  write_page_count();
}

function forward_switch() {
  if (count >= 8) {
    count = 8;
  } else {
    count++;
  }
  write_page_count();
}

function write_page_count() {

  var page_number_as_string = document.getElementById("kennzahl").dataset.kennzahl;
  var page_number_as_integer = Math.floor(page_number_as_string);       
  if (count > 2) {
    console.log('else 1')
      page_number_as_integer += 1;
  }
  if (count > 5) {
    console.log('else 2')
      page_number_as_integer += 1;
  } 
  document.getElementById("page_count").innerHTML = 'Seite ' + page_number_as_integer.toString() + ", " + page_titles[count];


  for (var i = 0; i < 9; i++) {
    if (count == i) {
      document.getElementById(pages[i]).style.display = "block";
    } else {
      document.getElementById(pages[i]).style.display = "none";
    }
  }

}
