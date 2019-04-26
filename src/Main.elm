port module Main exposing (main)

import AltMath.Vector2 exposing (Vec2, vec2)
import Cinematic exposing (cinemascope, viewportOffsetShake)
import Content
import Defaults exposing (default)
import Develop exposing (World, document)
import Layer
import Logic.Entity
import Physic.AABB as AABB
import Physic.Narrow.AABB as AABB
import Slide
import System.Slide
import VirtualDom
import WebGL
import World.Component as Component
import World.Component.Camera
import World.Component.Physics
import World.RenderSystem
import World.Subscription exposing (keyboard)
import World.System.AnimationChange
import World.System.Camera
import World.System.Physics


main =
    document
        { world = world
        , system = system
        , read = read
        , view = view
        , subscriptions = keyboard
        }



--https://opengameart.org/content/terrain-transitions


aabb =
    let
        empty =
            World.Component.Physics.aabb.empty
    in
    { spec = World.Component.Physics.aabb.spec
    , view = World.RenderSystem.debugPhysicsAABB
    , empty = { empty | gravity = { x = 0, y = -1 } }
    , system = World.System.Physics.aabb World.Component.Physics.aabb.spec
    , read = World.Component.Physics.aabb.read
    , getPosition = AABB.getPosition
    , compsExtracter = \ecs -> ecs.physics |> AABB.getIndexed |> Logic.Entity.fromList
    }


read =
    [ Component.positions.read
    , Component.dimensions.read
    , Component.sprites.read
    , Component.direction.read
    , Component.animations.read
    , aabb.read
    , World.Component.Camera.target.read
    ]


world =
    let
        slideStopsNext =
            Content.all
                |> List.indexedMap
                    (\i _ ->
                        vec2 (289 + (550 + 580) * toFloat i) 61
                    )

        --                |> Debug.log "Content.all"
    in
    { positions = Component.positions.empty
    , dimensions = Component.dimensions.empty
    , direction = Component.direction.empty
    , sprites = Component.sprites.empty
    , animations = Component.animations.empty
    , physics = aabb.empty
    , camera = World.Component.Camera.target.empty
    , cinematic = Regular
    , slideOpacity = 1
    , slideStops =
        { prev = []
        , target = vec2 289 61
        , next = slideStopsNext
        }
    }


type alias SlideStops =
    { prev : List Vec2
    , target : Vec2
    , next : List Vec2
    }


type Cinematic
    = Regular
    | Boss
    | EnterBossRoom Int


system world_ =
    world_
        |> System.Slide.applyInput Component.direction.spec aabb.spec
        --        |> World.System.Physics.applyInput (vec2 13 15) Component.direction.spec aabb.spec
        |> aabb.system
        |> World.System.AnimationChange.sideScroll aabb.spec Component.sprites.spec Component.animations.spec
        |> World.System.Camera.followX World.Component.Camera.target.spec getPosById


getPosById id =
    aabb.spec.get
        >> AABB.byId id
        >> Maybe.map AABB.getPosition
        >> Maybe.withDefault (vec2 0 0)


view style common ({ cinematic } as ecs) =
    case cinematic of
        Regular ->
            let
                entity =
                    cinemascope
                        { widthRatio = common.env.widthRatio
                        , newRatio = 1
                        }
            in
            [ (Layer.view objRender common ecs ++ [ entity ])
                |> WebGL.toHtmlWith default.webGLOption style
            ]
                ++ slides ecs.slideOpacity style common ecs

        Boss ->
            [ Layer.view objRender common ecs |> WebGL.toHtmlWith default.webGLOption style ]

        EnterBossRoom fameStart ->
            let
                ( escWithBossAnimation, entities ) =
                    Cinematic.bossAnimation fameStart common.frame ( common, ecs )
            in
            [ (Layer.view objRender common escWithBossAnimation
                ++ entities
              )
                |> WebGL.toHtmlWith default.webGLOption style
            ]
                ++ (if escWithBossAnimation.slideOpacity > 0 then
                        slides escWithBossAnimation.slideOpacity style common ecs

                    else
                        []
                   )


slides opacity style_ common ecs =
    let
        px =
            toFloat common.env.height / ecs.camera.pixelsPerUnit

        style =
            style_ ++ [ VirtualDom.style "opacity" <| String.fromFloat opacity ]
    in
    [ List.map (\a -> a ecs.camera px) Content.all |> Slide.view style ]


objRender common ( ecs, objLayer ) =
    []
        --        |> aabb.view common ( ecs, objLayer )
        |> World.RenderSystem.viewSprite aabb.compsExtracter aabb.getPosition common ( ecs, objLayer )
