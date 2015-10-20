ig.module(
  'game.entities.healthbar'
)
.requires(
    'impact.game',
    'impact.entity',
    'impact.background-map'
)
.defines =>
  @EntityHealthbar = ig.Entity.extend
    size: {x: 210, y: 210}
    animSheet: new ig.AnimationSheet( 'media/HealthBar.png', 32, 5 ),
    Unit:0,

    init: (x, y, settings) ->
        @addAnim( 'Full', 1, [0] )
        @addAnim( 'Ninety', 1, [1] )
        @addAnim( 'Eighty', 5, [2] )
        @addAnim( 'Seventy', 1, [3] )
        @addAnim( 'Sixty', 1, [4] )
        @addAnim( 'Fifty', 1, [5] )
        @addAnim( 'Fourty', 1, [6] )
        @addAnim( 'Thirty', 1, [7] )
        @addAnim( 'Twenty', 1, [8] )
        @addAnim( 'Ten', 1, [9] )
        @addAnim( 'NearDeath', 1, [10] )

        @parent( x, y, settings )
        @zIndex = 6
 
    update: () ->
        @pos.x = @Unit.pos.x
        @pos.y = @Unit.pos.y
 
        if(@Unit.health == @Unit.MaxHealth)
            @currentAnim = @anims.Full
        else if(@Unit.health >= (@Unit.MaxHealth * .9) && @Unit.health < @Unit.MaxHealth)
            @currentAnim = @anims.Ninety
        else if(@Unit.health >= (@Unit.MaxHealth * .8) && @Unit.health < (@Unit.MaxHealth * .9))
            @currentAnim = @anims.Eighty
        else if(@Unit.health >= (@Unit.MaxHealth * .7) && @Unit.health < (@Unit.MaxHealth * .8))
            @currentAnim = @anims.Seventy
        else if(@Unit.health >= (@Unit.MaxHealth * .6) && @Unit.health < (@Unit.MaxHealth * .7))
            @currentAnim = @anims.Sixty
        else if(@Unit.health >= (@Unit.MaxHealth * .5) && @Unit.health < (@Unit.MaxHealth * .6))
            @currentAnim = @anims.Fifty
        else if(@Unit.health >= (@Unit.MaxHealth * .4) && @Unit.health < (@Unit.MaxHealth * .5))
            @currentAnim = @anims.Fourty
        else if(@Unit.health >= (@Unit.MaxHealth * .3) && @Unit.health < (@Unit.MaxHealth * .4))
            @currentAnim = @anims.Thirty
        else if(@Unit.health >= (@Unit.MaxHealth * .2) && @Unit.health < (@Unit.MaxHealth * .3))
            @currentAnim = @anims.Twenty
        else if(@Unit.health >= (@Unit.MaxHealth * .1) && @Unit.health < (@Unit.MaxHealth * .2))
            @currentAnim = @anims.Ten
        else if(@Unit.health > 0 && @Unit.health < (@Unit.MaxHealth * .1))
            @currentAnim = @anims.NearDeath
        else if (@Unit.health <= 0 )
            @kill()
