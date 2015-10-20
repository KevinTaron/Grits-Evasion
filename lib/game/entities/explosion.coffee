ig.module(
    'game.entities.explosion'
)
.requires(
   'impact.entity'
)
.defines =>
  @EntityExplosion = ig.Entity.extend
    size: {x: 84, y: 80}
    animSheet: new ig.AnimationSheet( 'media/explosion.png', 84, 80)
    sound: new ig.Sound( 'sound/explode0.ogg' )

    init: (x, y, settings) ->
        @angle = settings.angle if settings.angle
        @parent(x,y, settings)
        @addAnim( 'explosion', 0.1, [0,1,2,2,2])
        @sound.volume = 0.2
        @sound.play()

    update: () ->
        if @currentAnim.frame == 4
            @kill()
        @parent()

