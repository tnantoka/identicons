$(function() {

  $editor = $('.js_editor');
  $color = $('.js_color');
  $colorText = $('.js_color_text');
  $generate = $('.js_generate');

  $('.js_cell').on('click', function(e) {
    e.preventDefault()
    $(this).toggleClass('is_fill');
    update();
  });

  $('.js_grid_check').on('change', function() {
    if ($(this).prop('checked')) {
      $editor.addClass('grid');
    } else {
      $editor.removeClass('grid');
    }
  }).change();

  $('.js_color_text').on('keyup', update);

  update();

  function update() {
    var cells = [];
    $editor.find('.js_cell').each(function(i) {
      cells.push($(this).hasClass('is_fill') ? 1 : 0);
    });
    var fill = cells.join('');
    
    var color = $colorText.val()
    $color.css('background', '#' + color);
    $colorText.css('border-color', '#' + color);
    $generate.attr('href', '/gen/' + fill + '/' + color);
  }
});

