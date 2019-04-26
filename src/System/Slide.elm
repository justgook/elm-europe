module System.Slide exposing (applyInput)

import AltMath.Vector2 as Vec2 exposing (vec2)
import Logic.Component as Component
import Logic.Entity
import Logic.System
import Physic.AABB
import Physic.Narrow.AABB as AABB


applyInput inputSpec physicsSpec ( common, { slideStops } as ecs ) =
    let
        engine =
            physicsSpec.get ecs

        ( newEngine, newSlideStops ) =
            Maybe.map2
                (\body key ->
                    let
                        distance_ =
                            Vec2.distanceSquared ecs.slideStops.target pos

                        ( slideStops_, distance ) =
                            if distance_ < 1 && key.x > 0 then
                                let
                                    slideStops__ =
                                        slideStops.next
                                            |> List.head
                                            |> Maybe.map
                                                (\next ->
                                                    { slideStops
                                                        | target = next
                                                        , prev = slideStops.target :: slideStops.prev
                                                        , next = List.drop 1 slideStops.next
                                                    }
                                                )
                                            |> Maybe.withDefault slideStops
                                in
                                ( slideStops__, Vec2.distanceSquared slideStops__.target pos )

                            else if distance_ < 1 && key.x < 0 then
                                let
                                    slideStops__ =
                                        slideStops.prev
                                            |> List.head
                                            |> Maybe.map
                                                (\prev ->
                                                    { slideStops
                                                        | target = prev
                                                        , prev = List.drop 1 slideStops.prev
                                                        , next = slideStops.target :: slideStops.next
                                                    }
                                                )
                                            |> Maybe.withDefault slideStops
                                in
                                ( slideStops__, Vec2.distanceSquared slideStops__.target pos )

                            else
                                ( ecs.slideStops, distance_ )

                        pos =
                            AABB.getPosition body

                        dir =
                            Vec2.direction slideStops_.target pos

                        newBody =
                            AABB.updateVelocity
                                (\v ->
                                    if distance < 1 then
                                        { x = 0, y = 0 }

                                    else if distance < Vec2.lengthSquared v then
                                        dir |> Vec2.scale (distance / Vec2.lengthSquared v)

                                    else
                                        dir
                                            |> Vec2.scale 0.3
                                            |> Vec2.add v
                                )
                                body
                    in
                    ( Physic.AABB.setById ecs.camera.id newBody engine, slideStops_ )
                )
                (Physic.AABB.byId ecs.camera.id engine)
                (inputSpec.get ecs |> Component.get ecs.camera.id)
                |> Maybe.withDefault ( engine, ecs.slideStops )

        newEcs =
            physicsSpec.set newEngine ecs
    in
    ( common, { newEcs | slideStops = newSlideStops } )



--bindSpecFirst =
--    { get = Tuple.first
--    , set = \comps ( a, b ) -> ( comps, b )
--    }
--
--
--bindSpecSecond spec =
--    { get = Tuple.second >> spec.get
--    , set = \comps ( a, world ) -> ( a, spec.set comps world )
--    }
--
--
--bindCreate a world =
--    ( a, world )
