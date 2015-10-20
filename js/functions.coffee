jQuery('document').ready ($) -> 
	$('.gameover').hide()
	$('.gameend').hide()
	jQuery('.highscore').html(localStorage.highscore) if localStorage.highscore
	$('.start').click ->
		$('.menu').hide(
			"drop"
			{direction: "left"}
			"slow"
			() ->
				ig.main( '#canvas', GritsEvasion, 60, window.innerWidth, window.innerHeight, 1 )
		)
		$('.hud').show()

	$('.pause').click ->
		ig.game.resumeGame()
 
	$('.back2menu').click ->
		$('.gameover').hide(
			"drop"
			{direction: "left"}
			"slow"
			)
		$('.menu').show(
			"drop"
			{direction: "left"}
			"slow"
			)

	$(window).resize -> 
		ig.system.resize(window.innerWidth, window.innerHeight) if ig.system
