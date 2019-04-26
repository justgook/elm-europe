module Cinematic exposing (bossAnimation, cinemascope, screenBlink, viewportOffsetShake)

import Array
import Defaults exposing (default)
import Ease
import Layer.Common exposing (Common, Individual, Layer(..), Uniform, mesh, vertexShader)
import Math.Vector2 as Vec2 exposing (Vec2)
import Math.Vector4 as Vec4 exposing (Vec4, vec4)
import Random
import WebGL exposing (Shader)


bossAnimation frameStart currentFrame ( common, { camera } as ecs ) =
    let
        now =
            toFloat <| (currentFrame - frameStart)

        ratio =
            remap 100 160 0 1 now
                |> Ease.inOutExpo

        ratio2 =
            remap 120 160 0 1 now
                |> Ease.inOutExpo

        ratio3 =
            remap 50 100 1 0 now
                |> Ease.inOutExpo

        entity =
            cinemascope
                { widthRatio = common.env.widthRatio
                , newRatio = ratio * 1.39 + 1
                }

        pixelsPerUnit =
            ratio2 * -260 + 600

        border =
            cinemascopeBorder { widthRatio = common.env.widthRatio, newRatio = ratio * 1.39 + 1 }
                |> Vec4.getZ
                |> (*) pixelsPerUnit

        offsetX =
            410 * ratio2

        offsetY =
            -border

        viewportOffset =
            camera.viewportOffset
                |> Vec2.toRecord

        newesc =
            { ecs
                | camera =
                    { camera
                        | pixelsPerUnit = pixelsPerUnit
                        , viewportOffset =
                            { viewportOffset
                                | x = viewportOffset.x + offsetX
                                , y = viewportOffset.y + offsetY
                            }
                                |> Vec2.fromRecord
                    }
                , slideOpacity = ratio3
            }
    in
    ( newesc, [ entity ] )


seed0 : Random.Seed
seed0 =
    Random.initialSeed 42


seed1 : Random.Seed
seed1 =
    Random.initialSeed 111


cinemascope :
    { a | widthRatio : Float, newRatio : Float }
    -> WebGL.Entity
cinemascope { widthRatio, newRatio } =
    WebGL.entityWith default.entitySettings
        vertexShader
        cinemascopeFragmentShader
        mesh
        { widthRatio = widthRatio, border = cinemascopeBorder { widthRatio = widthRatio, newRatio = newRatio } }


cinemascopeBorder { widthRatio, newRatio } =
    let
        viewPort =
            if widthRatio < newRatio then
                { x = widthRatio, y = widthRatio / newRatio }

            else
                { x = newRatio, y = 1.0 }

        width =
            (widthRatio - viewPort.x) * 0.5

        height =
            (1 - viewPort.y) * 0.5
    in
    vec4 width (widthRatio - width) height (1.0 - height)


screenBlink :
    { a | widthRatio : Float }
    -> WebGL.Entity
screenBlink =
    WebGL.entityWith default.entitySettings vertexShader blinkFragmentShader mesh


cinemascopeFragmentShader =
    [glsl|
        precision mediump float;
        varying vec2 vcoord;
        uniform vec4 border;
        uniform float widthRatio;
        void main( void )
        {
            gl_FragColor.a = float( border.r > vcoord.x || border.g < vcoord.x || border.b > vcoord.y || border.a < vcoord.y);
        }
    |]


blinkFragmentShader =
    [glsl|
        precision mediump float;
        varying vec2 vcoord;
        void main( void )
        {
        	gl_FragColor.a = vec4(1.,0.,0.,1.);
        }
    |]


viewportOffsetShake common ({ camera } as esc) =
    let
        --        offset =
        --            modBy 100 common.frame
        --                |> toFloat
        --                |> sin
        --                |> remap -1 1 -10 10
        offset =
            shake seed0 1 60 3 common.runtime_
                |> (+) (shake seed1 1 70 5.5 common.runtime_)

        offset2 =
            shake seed1 1 60 3 common.runtime_
                |> (+) (shake seed0 1 70 5.5 common.runtime_)

        viewportOffset =
            camera.viewportOffset
                |> Vec2.toRecord
    in
    { esc
        | camera =
            { camera
                | viewportOffset =
                    { viewportOffset
                        | x = viewportOffset.x + offset
                        , y = viewportOffset.y + offset2
                    }
                        |> Vec2.fromRecord
            }
    }


shake seed_ duration frequency startTime t =
    --    https://jonny.morrill.me/en/blog/gamedev-how-to-implement-a-camera-shake-effect/
    let
        decay t_ =
            if t_ >= duration then
                0

            else
                (duration - t_) / duration

        amplitude t_ =
            let
                s =
                    t_ * frequency

                s0 =
                    floor s

                s1 =
                    s0 + 1

                k =
                    decay t_

                noise =
                    noise_ seed_ sampleCount
            in
            (noise s0 + (s - toFloat s0) * (noise s1 - noise s0)) * k

        sampleCount =
            (duration * frequency)
                |> floor
    in
    amplitude (t - startTime) * 16


noise_ seed sampleCount s =
    let
        samples =
            seed
                |> Random.step (Random.list sampleCount (Random.float -1 1))
                |> Tuple.first
                |> Array.fromList
    in
    Array.get s samples
        |> Maybe.withDefault 0


remap : Float -> Float -> Float -> Float -> Float -> Float
remap start1 stop1 start2 stop2 n =
    let
        newVal =
            (n - start1) / (stop1 - start1) * (stop2 - start2) + start2
    in
    if start2 < stop2 then
        max start2 <| min newVal stop2

    else
        max stop2 <| min newVal start2
