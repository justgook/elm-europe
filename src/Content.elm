module Content exposing (all, intro, tools)

import Html exposing (..)
import Html.Attributes exposing (alt, class, height, href, src, style, target)
import Slide exposing (Slide)


dimension =
    { x = 550, y = 450 }


startPoint =
    { x = 10, y = 100 }


space =
    580


slidePos i =
    { startPoint | x = startPoint.x + (dimension.x + space) * i }


all : List (Slide.Slide a msg)
all =
    pixelPerfect
        :: [ jsonParser
           , spelunky
           , pixelPerfect
           , pixelSnapping
           , entityComponentSystem
           , patterns
           , resources
           ]
        ++ [ intro
           , game
           , graphics
           , htmlPlusCss
           , svg
           , webGL
           , extraCredit
           , tools
           , jsonParser
           , spelunky
           , pixelPerfect
           , pixelSnapping
           , entityComponentSystem
           , patterns
           , resources
           ]
        |> List.indexedMap (\i -> Slide.slide (slidePos (toFloat i)) dimension)


type alias Content msg =
    List (Html msg)


extraCredit =
    [ section [ class "bg-black slide-bottom" ]
        [ span
            [ class "background"
            , style "background-image" "url('./slides/extra-credit.jpg')"
            , style "background-color" "#317947"
            , style "background-size" "100%"
            , style "background-position" "center bottom"
            ]
            []
        , blockquote [ class "text-quote" ]
            [ p []
                [ text "Game writing isn't about making up a story and then attaching gameplay to it. To be a great game writer, you have to also be a good game designer, and recognize how the gameplay is inseparable from the narrative design process." ]
            , p []
                [ cite []
                    [ a [ target "_blank", href "https://www.youtube.com/watch?v=22HoViH4vOU" ]
                        [ text "Extra Credits" ]
                    ]
                ]
            ]
        ]
    ]


webGL =
    [ h3 [ class "aligncenter" ]
        [ strong [] [ text "WebGL" ]
        ]
    , hr []
        []
    , div [ class "bg-white content-left" ]
        [ h2 []
            [ text "Advantages " ]
        , ul [ class "flexblock reasons" ]
            [ li []
                [ h2 [] [ text "Low Level" ]
                , p []
                    [ text "Everything works "
                    , strong [] [ text "much" ]
                    , text " faster"
                    ]
                ]
            , li []
                [ h2 [] [ text "Float" ]
                , p [] [ text "all space is relative from -1 to 1" ]
                ]
            , li []
                [ h2 [] [ text "Shaders" ]
                , p [] [ text "Have control over each pixel on screen" ]
                ]
            ]
        ]
    , div [ class "bg-white content-right" ]
        [ h2 []
            [ text "Disadvantages" ]
        , ul [ class "flexblock reasons" ]
            [ li []
                [ h2 [] [ text "Low Level" ]
                , p [] [ text "Not have debugger" ]
                ]
            , li []
                [ h2 [] [ text "Float" ]
                , p [] [ text "Different video cards can have different optimizations" ]
                ]
            , li []
                [ h2 [] [ text "Shapes" ]
                , p [] [ text "Need to lear new language GLSL" ]
                ]
            ]
        ]
    ]


svg =
    [ h3 [ class "aligncenter" ]
        [ strong [] [ text "Scalable Vector Graphics" ]
        ]
    , hr []
        []
    , div [ class "bg-white content-left" ]
        [ h2 []
            [ text "Advantages " ]
        , ul [ class "flexblock reasons" ]
            [ li []
                [ h2 [] [ text "DOM" ]
                , p [] [ text "It is just other DOM element" ]
                ]
            , li []
                [ h2 [] [ text "CSS" ]
                , p [] [ text "css + additional properties" ]
                ]
            , li []
                [ h2 [] [ text "Shapes" ]
                , p [] [ text "can draw curves" ]
                ]
            ]
        ]
    , div [ class "bg-white content-right" ]
        [ h2 []
            [ text "Disadvantages" ]
        , ul [ class "flexblock reasons" ]
            [ li []
                [ h2 [] [ text "DOM" ]
                , p [] [ text "Each svg is LOT of elements" ]
                ]
            , li []
                [ h2 [] [ text "CSS" ]
                , p [] [ text "made for webApps, not games" ]
                ]
            , li []
                [ h2 [] [ text "Shapes" ]
                , p [] [ text "Need to be rasterized" ]
                ]
            ]
        ]
    ]


htmlPlusCss =
    [ h3 [ class "aligncenter" ]
        [ strong [] [ text "HTML + CSS" ]
        ]
    , hr []
        []
    , div [ class "bg-white content-left" ]
        [ h2 []
            [ text "Advantages " ]
        , ul [ class "flexblock reasons" ]
            [ li []
                [ h2 [] [ text "DOM" ]
                , p [] [ text "Already in all browsers" ]
                ]
            , li []
                [ h2 [] [ text "CSS" ]
                , p [] [ text "Lot of tutorials" ]
                ]
            , li []
                [ h2 [] [ text "Browser Support" ]
                , p [] [ text "Lot of tutorials" ]
                ]
            ]
        ]
    , div [ class "bg-white content-right" ]
        [ h2 []
            [ text "Disadvantages" ]
        , ul [ class "flexblock reasons" ]
            [ li []
                [ h2 [] [ text "DOM" ]
                , p [] [ text "can not handle lot of nodes" ]
                ]
            , li []
                [ h2 [] [ text "CSS" ]
                , p [] [ text "made for webApps, not games" ]
                ]
            , li []
                [ h2 [] [ text "Browser Support" ]
                , p [] [ text "And each have difference" ]
                ]
            ]
        ]
    ]


graphics =
    [ h3 [ class "aligncenter" ]
        [ strong [] [ text "Graphics" ]
        ]
    , hr []
        []
    , div [ class "bg-white shadow" ]
        [ ul [ class "flexblock reasons" ]
            [ li []
                [ h2 []
                    [ text "HTML + CSS" ]
                , p []
                    [ text "You can use DOM and CSS to creating games, like i did in "
                    , a [ target "_blank", href "http://sokoban.z0.lv" ] [ text "Sokoban (React)" ]
                    , text " or "
                    , a [ target "_blank", href "http://bomberman-elm.z0.lv" ] [ text "Bomberman clone (Elm)" ]
                    ]
                ]
            , li []
                [ h2 []
                    [ text "SVG" ]
                , p []
                    [ strong [] [ text "Scalable Vector Graphics" ]
                    , text """ - same DOM - but now you can create not only rectangles with rounded corners,
                     but mor complicated shapes and use some graphical software ("""
                    , a [ target "_blank", href "https://inkscape.org/" ] [ text "Inkscape" ]
                    , text ") to draw"
                    ]
                ]
            , li []
                [ h2 []
                    [ text "WebGL" ]
                , p []
                    [ strong [] [ text "Web Graphics Library" ]
                    , text " is a JavaScript API for rendering interactive 3D and 2D graphics within any "
                    , a [ target "_blank", href "https://caniuse.com/#feat=webgl" ] [ text "compatible web browser" ]
                    , text " without the use of plug-ins. WebGL does so by introducing an API that closely conforms to "
                    , a [ target "_blank", href "https://www.khronos.org/registry/OpenGL-Refpages/es2.0/" ] [ text "OpenGL ES 2.0" ]
                    , text " that can be used in HTML5 <canvas> elements."
                    ]
                ]
            ]
        ]
    ]


game =
    [ h3 [ class "aligncenter" ]
        [ text "What is needed to create good "
        , strong [] [ text "Game?" ]
        ]
    , hr []
        []
    , div [ class "bg-white shadow" ]
        [ ul [ class "flexblock reasons" ]
            [ li []
                [ h2 []
                    [ text "Graphics" ]
                , p []
                    [ text "A variety of computer graphic techniques have been used to display video game content throughout the history of video games." ]
                ]
            , li []
                [ h2 []
                    [ text "Mechanics" ]
                , p []
                    [ text "Game mechanics are methods invoked by agents designed for interaction with the game state, thus providing gameplay."
                    ]
                ]
            , li []
                [ h2 []
                    [ text "Narrative" ]
                , p []
                    [ text "Unlike the plot of a film or a book, the game scenario implies the presence of interactive elements and direct participation of the player."
                    ]
                ]
            ]
        ]
    ]


spelunky : Content msg
spelunky =
    let
        inner =
            [ style "position" "absolute"
            , style "top" "0"
            , style "left" "0"
            , style "bottom" "0"
            , style "right" "0"
            ]
    in
    [ section [ class "bg-light aligncenter" ]
        [ h3 []
            [ text "Tile maps on the GPU" ]
        , ul [ class "flexblock gallery" ]
            [ li []
                [ a [ target "_blank", href "#" ]
                    [ figure []
                        [ img [ alt "Thumbnail ", src "/slides/spelunky/spelunky-tiles.png" ]
                            []
                        , div [ class "overlay" ]
                            [ h2 []
                                [ text "Tiles" ]
                            ]
                        ]
                    ]
                ]
            , li []
                [ a [ target "_blank", href "#" ]
                    [ figure []
                        [ img [ alt "Thumbnail", src "/slides/spelunky/spelunky0.png" ]
                            []
                        , div [ class "overlay" ]
                            [ h2 []
                                [ text "Look up Table" ]
                            ]
                        ]
                    ]
                ]
            , li []
                [ a [ target "_blank", href "#" ]
                    [ figure inner
                        [ div [ class "spelunky-anim" ]
                            []
                        , div [ class "overlay" ]
                            [ h2 []
                                [ text "Result" ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]


pixelPerfect : Content msg
pixelPerfect =
    [ section [ class "bg-light aligncenter" ]
        [ h2 [] [ text "Pixel Perfect graphics" ]
        , pre [ style "position" "relative" ]
            [ code [ class "glsl" ]
                [ text """vec2 point = ((vcoord / (1.0 / tilesPerUnit))) + (viewportOffset / tileSize) * scrollRatio;
vec2 look = floor(point);
//(2i + 1)/(2N) Pixel center
vec2 coordinate = (look + 0.5) / lutSize;
float tileIndex = color2float(texture2D(lut, coordinate));
vec2 grid = tileSetSize / tileSize;
// tile indexes in tileset starts from zero, but in lut zero is used for "none" placeholder
vec2 tile = vec2(modI((tileIndex - 1.), grid.x), int(tileIndex - 1.) / int(grid.x));
// inverting reading botom to top
tile.y = grid.y - tile.y - 1.;
vec2 fragmentOffsetPx = floor((point - look) * tileSize);
//(2i + 1)/(2N) Pixel center
vec2 pixel = (floor(tile * tileSize + fragmentOffsetPx) + 0.5) / tileSetSize;"""
                ]
            , img
                [ src "./slides/pixel_perfect.png"
                , style "position" "absolute"

                --                , style "padding" "2.4rem"
                --                , style "padding-bottom" "-2.4rem"
                , style "left" "0"
                , style "bottom" "0"
                ]
                []
            ]
        ]
    ]


pixelSnapping : Content msg
pixelSnapping =
    [ section [ class "bg-light aligncenter" ]
        [ h2 [] [ text "Pixel Perfect Snapping" ]
        , pre [] [ code [ class "glsl" ] [ text """
//(2i + 1)/(2N) Pixel center
vec2 pixel = (floor(vcoord * pixelsPerUnit + viewportOffset * scrollRatio) + 0.5 ) / size;
         """ ] ]
        ]
    ]


intro : Content msg
intro =
    [ section [ class "aligncenter" ]
        [ div []
            [ h2 [ class "fps60" ] []
            , h2 [ class "text-intro" ]
                [ strong
                    [ style "color" "rgb(250,244,234)"

                    --                    , style "text-shadow" "0 0 3px rgba(203,118,48,1)"
                    , style "text-shadow" "0 0 3px #000"
                    ]
                    [ text "is performance enough in Elm to create full fledged video games" ]
                ]
            ]
        , ul [ class "bg-light description", style "text-align" "left" ]
            [ li []
                [ span [ class "text-label" ]
                    [ text "" ]
                , text "Romāns Potašovs"
                ]
            , li []
                [ span [ class "text-label" ]
                    [ text "GitHub:" ]
                , a [ target "_blank", href "https://github.com/justgook/" ]
                    [ text "@justgook" ]
                ]
            , li []
                [ span [ class "text-label" ]
                    [ text "Twitter:" ]
                , a [ target "_blank", href "https://twitter.com/justgook" ]
                    [ text "@justgook" ]
                ]
            ]
        ]
    ]


tools : Content msg
tools =
    let
        container =
            [ style "width" "100%"
            , style "padding-top" "50%"
            , style "position" "relative"
            ]

        --/* If you want text inside of it */
        --    }
        --
        --    /* If you want text inside of the container */
        inner =
            [ style "position" "absolute"
            , style "top" "0"
            , style "left" "0"
            , style "bottom" "0"
            , style "right" "0"
            ]

        imgWrap src_ =
            div container [ div inner [ img [ alt "Thumbnail ", src src_ ] [] ] ]

        figureStretch =
            [ style "position" "absolute"
            , style "height" "100%"
            , style "top" "0"
            , style "left" "0"
            , style "bottom" "0"
            , style "right" "0"
            , style "display" "flex"
            , style "flex-flow" "column"
            ]
    in
    [ section [ class "bg-light aligncenter" ]
        [ h2 []
            [ text "Develop Development Tools" ]
        , ul [ class "flexblock gallery" ]
            [ li []
                [ a [ target "_blank", href "https://pyxeledit.com/" ]
                    [ figure figureStretch
                        [ imgWrap "/slides/pyxel-screenshot.png"
                        , figcaption [ style "flex" "1" ]
                            [ h2 []
                                [ text "Pyxel Edit" ]
                            , p []
                                [ text "A pixel art drawing application especially designed for working with tiles." ]
                            ]
                        ]
                    ]
                ]
            , li []
                [ a [ target "_blank", href "https://www.aseprite.org/" ]
                    [ figure figureStretch
                        [ imgWrap "./slides/aseprite-screenshot.jpg"
                        , figcaption [ style "flex" "1" ]
                            [ h2 []
                                [ text "aseprite" ]
                            , p []
                                [ text "Animated Sprite Editor & Pixel Art Tool" ]
                            ]
                        ]
                    ]
                ]
            , li []
                [ a [ target "_blank", href "https://www.mapeditor.org/" ]
                    [ figure []
                        [ imgWrap "/slides/tiled-screenshot.png"
                        , figcaption [ style "flex" "1" ]
                            [ h2 []
                                [ text "Tiled" ]
                            , p []
                                [ text "General purpose tile map editor for all tile-based games, such as RPGs, platformers or Breakout clones." ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]


jsonParser : Content msg
jsonParser =
    --    https://doc.mapeditor.org/en/stable/reference/json-map-format/#object
    [ section [ class "bg-light aligncenter" ]
        [ h3 [] [ text "Json Parser & Tiled Json Format" ]
        , pre [] [ code [ class "glsl" ] [ text """{
  "height":6,
  "infinite":false,
  "layers":[
    {
      "data":[117, 118, 119, 120, 121, 175, 176, 177, 178, 179,...],
      "height":6,
      "id":1,
      "name":"Layer",
      "opacity":1,
      "type":"tilelayer",
      "visible":true,
      "width":5,
      "x":0,
      "y":0
    }
    ....
  ],
  "width": 6,
...
}""" ] ]
        ]
    ]



--delme : Content msg
--delme =
--    [ figure [ class "browser" ]
--        [ a [ target "_blank",href "#" ]
--            [ img [ alt "Screenshot", src "https://justgook.github.io/p2pElm/preview.png" ]
--                []
--            ]
--        ]
--    ]


entityComponentSystem : Content msg
entityComponentSystem =
    [ section [ class "bg-light aligncenter" ]
        [ h3 [] [ text "ECS" ]
        , p [ class "text-subtitle" ] [ text "Some more text" ]
        ]
    ]


patterns : Content msg
patterns =
    [ section [ class "bg-light aligncenter" ]
        [ h3 [] [ text "Patterns and Antipatterns" ]
        , p [ class "text-subtitle" ] [ text "Some more text" ]
        ]
    ]


resources : Content msg
resources =
    [ section [ class "bg-light aligncenter" ]
        [ h3 [] [ text "Resources" ]
        , p [ class "text-subtitle" ]
            [ text "https://sparklinlabs.itch.io/superpowers"
            , text "https://webslides.tv/"
            , text "https://cooltext.com/"
            ]
        ]
    ]
