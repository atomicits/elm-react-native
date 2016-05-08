module ReactNative exposing (..)

{-| API to the core diffing algorithm. Can serve as a foundation for libraries
that expose more helper functions for HTML or SVG.

# Create
@docs Node, text, node, view

# Declare Properties and Attributes
@docs Property, property, attribute, attributeNS

# Styles
@docs style

# Events
@docs on, onWithOptions, Options, defaultOptions

# Routing Messages
@docs map

# Optimizations
@docs lazy, lazy2, lazy3

# Programs
@docs programWithFlags


@docs activityIndicatorIos, datePickerIos, drawerLayoutAndroid, image, listView, mapView
@docs modal ,navigator, navigatorIos, picker ,pickerIos ,progressBar ,progressBarAndroid
@docs progressView, progressViewIos, refreshControl ,scrollView, segmentedControl
@docs segmentedControlIos ,slider, sliderIos, statusBar, switch, tabBar, tabBarIos
@docs tabBarIosItem , text ,textInput ,toolbar, toolbarAndroid ,touchableHighlight
@docs touchableNativeFeedback ,touchableOpacity, touchableWithoutFeedback ,view
@docs viewPagerAndroid, webView


@docs hack

# Styles
@docs Style, stringStyle, numberStyle, valueStyle

@docs AlignSelfEnum, BorderStyleEnum, DirectionEnum, FlexDirectionEnum
@docs FlexWrapEnum, FontStyleEnum, FontWeightEnum, JustifyContentEnum
@docs PositionEnum, TextAlignEnum, TextDecorationLine, Transform
@docs VisibilityEnum, alignItems, alignSelf, backfaceVisibility, backgroundColor
@docs borderBottomColor, borderBottomLeftRadius, borderBottomRightRadius
@docs borderBottomWidth, borderColor, borderLeftColor, borderLeftWidth
@docs borderRadius, borderRightColor, borderRightWidth, borderStyle
@docs borderTopColor, borderTopLeftRadius, borderTopRightRadius, borderTopWidth
@docs borderWidth, bottom, color, defaultTransform, enumToString, enumToStringd
@docs firstLower, flex, flexDirection, flexWrap, floatStyle, fontFamily
@docs fontSize, fontStyle, fontWeight, height, justifyContent, left
@docs letterSpacing, lineHeight, margin, marginBottom, marginHorizontal
@docs marginLeft, marginRight, marginTop, marginVertical, opacity, overflow
@docs padding, paddingBottom, paddingHorizontal, paddingLeft, paddingRight
@docs paddingTop, paddingVertical, position, resizeMode, right, shadowColor
@docs shadowOpacity, shadowRadius, textAlign, textDecorationColor
@docs textDecorationLine, textDecorationStyle, tintColor
@docs toHyphenated, top, width, writingDirection
-}

-- module ReactNative exposing (Node, text, node, view, Property, property, attribute, attributeNS, style, on, onWithOptions, Options, defaultOptions, map, lazy, lazy2, lazy3, programWithFlags)

import Native.Platform
import Native.ReactNative
import Json.Decode as Json
import Char
import String


{-| An immutable chunk of data representing a DOM node. This can be HTML or SVG.
-}
type Node msg
  = Node


{-| Create a DOM node with a tag name, a list of HTML properties that can
include styles and event listeners, a list of CSS properties like `color`, and
a list of child nodes.

    import Json.Encode as Json

    hello : Node msg
    hello =
      node "div" [] [ text "Hello!" ]

    greeting : Node msg
    greeting =
      node "div"
        [ property "id" (Json.string "greeting") ]
        [ text "Hello!" ]
-}
node : String -> List (Property msg) -> List (Node msg) -> Node msg
node =
  Native.ReactNative.node


{-|
-}
view : List (Property msg) -> List (Node msg) -> Node msg
view =
  Native.ReactNative.node "View"


{-| Just put plain text in the DOM. It will escape the string so that it appears
exactly as you specify.

    text "Hello World!"
-}
text : String -> Node msg
text =
  Native.ReactNative.text


{-| This function is useful when nesting components with [the Elm
Architecture](https://github.com/evancz/elm-architecture-tutorial/). It lets
you transform the messages produced by a subtree.

Say you have a node named `button` that produces `()` values when it is
clicked. To get your model updating properly, you will probably want to tag
this `()` value like this:

    type Msg = Click | ...

    update msg model =
      case msg of
        Click ->
          ...

    view model =
      map (\_ -> Click) button

So now all the events produced by `button` will be transformed to be of type
`Msg` so they can be handled by your update function!
-}
map : (a -> msg) -> Node a -> Node msg
map =
  Native.ReactNative.map



-- PROPERTIES


{-| When using HTML and JS, there are two ways to specify parts of a DOM node.

  1. Attributes &mdash; You can set things in HTML itself. So the `class`
     in `<div class="greeting"></div>` is called an *attribute*.

  2. Properties &mdash; You can also set things in JS. So the `className`
     in `div.className = 'greeting'` is called a *property*.

So the `class` attribute corresponds to the `className` property. At first
glance, perhaps this distinction is defensible, but it gets much crazier.
*There is not always a one-to-one mapping between attributes and properties!*
Yes, that is a true fact. Sometimes an attribute exists, but there is no
corresponding property. Sometimes changing an attribute does not change the
underlying property. For example, as of this writing, the `webkit-playsinline`
attribute can be used in HTML, but there is no corresponding property!
-}
type Property msg
  = Property


{-| Create arbitrary *properties*.

    import JavaScript.Encode as Json

    greeting : Html
    greeting =
        node "div" [ property "className" (Json.string "greeting") ] [
          text "Hello!"
        ]

Notice that you must give the *property* name, so we use `className` as it
would be in JavaScript, not `class` as it would appear in HTML.
-}
property : String -> Json.Value -> Property msg
property =
  Native.ReactNative.property


{-| Create arbitrary HTML *attributes*. Maps onto JavaScript’s `setAttribute`
function under the hood.

    greeting : Html
    greeting =
        node "div" [ attribute "class" "greeting" ] [
          text "Hello!"
        ]

Notice that you must give the *attribute* name, so we use `class` as it would
be in HTML, not `className` as it would appear in JS.
-}
attribute : String -> String -> Property msg
attribute =
  Native.ReactNative.attribute


{-| Would you believe that there is another way to do this?! This corresponds
to JavaScript's `setAttributeNS` function under the hood. It is doing pretty
much the same thing as `attribute` but you are able to have "namespaced"
attributes. This is used in some SVG stuff at least.
-}
attributeNS : String -> String -> String -> Property msg
attributeNS =
  Native.ReactNative.attributeNS


{-| -}
type Style
  = Style


{-| Specify a list of styles.

    myStyle : Property msg
    myStyle =
      style
        [ ("backgroundColor", "red")
        , ("height", "90px")
        , ("width", "100%")
        ]

    greeting : Node msg
    greeting =
      node "div" [ myStyle ] [ text "Hello!" ]

-}
style : List Style -> Property msg
style =
  Native.ReactNative.style


{-| -}
stringStyle : String -> String -> Style
stringStyle =
  Native.ReactNative.property


{-| -}
numberStyle : String -> Int -> Style
numberStyle =
  Native.ReactNative.property


{-| -}
floatStyle : String -> Float -> Style
floatStyle =
  Native.ReactNative.property


{-| -}
valueStyle : String -> Json.Value -> Style
valueStyle =
  Native.ReactNative.property



-- EVENTS


{-| Create a custom event listener.

    import Json.Decode as Json

    onClick : msg -> Property msg
    onClick msg =
      on "click" (Json.succeed msg)

You first specify the name of the event in the same format as with JavaScript’s
`addEventListener`. Next you give a JSON decoder, which lets you pull
information out of the event object. If the decoder succeeds, it will produce
a message and route it to your `update` function.
-}
on : String -> Json.Decoder msg -> Property msg
on eventName decoder =
  onWithOptions eventName defaultOptions decoder


{-| Same as `on` but you can set a few options.
-}
onWithOptions : String -> Options -> Json.Decoder msg -> Property msg
onWithOptions =
  Native.ReactNative.on


{-| Options for an event listener. If `stopPropagation` is true, it means the
event stops traveling through the DOM so it will not trigger any other event
listeners. If `preventDefault` is true, any built-in browser behavior related
to the event is prevented. For example, this is used with touch events when you
want to treat them as gestures of your own, not as scrolls.
-}
type alias Options =
  { stopPropagation : Bool
  , preventDefault : Bool
  }


{-| Everything is `False` by default.

    defaultOptions =
        { stopPropagation = False
        , preventDefault = False
        }
-}
defaultOptions : Options
defaultOptions =
  { stopPropagation = False
  , preventDefault = False
  }



-- OPTIMIZATION


{-| A performance optimization that delays the building of virtual DOM nodes.

Calling `(view model)` will definitely build some virtual DOM, perhaps a lot of
it. Calling `(lazy view model)` delays the call until later. During diffing, we
can check to see if `model` is referentially equal to the previous value used,
and if so, we just stop. No need to build up the tree structure and diff it,
we know if the input to `view` is the same, the output must be the same!
-}
lazy : (a -> Node msg) -> a -> Node msg
lazy =
  Native.ReactNative.lazy


{-| Same as `lazy` but checks on two arguments.
-}
lazy2 : (a -> b -> Node msg) -> a -> b -> Node msg
lazy2 =
  Native.ReactNative.lazy2


{-| Same as `lazy` but checks on three arguments.
-}
lazy3 : (a -> b -> c -> Node msg) -> a -> b -> c -> Node msg
lazy3 =
  Native.ReactNative.lazy3



-- PROGRAMS


{-| The most generic way to create a [`Program`][program]. It is the primitive
behind things like `beginnerProgram` and `program` in [the `Html.App` module][app].
Read about it there if you'd like to learn more about this.

[program]: http://package.elm-lang.org/packages/elm-lang/core/latest/Platform#Program
[app]: http://package.elm-lang.org/packages/elm-lang/html/latest/Html-App
-}
programWithFlags :
  { init : flags -> ( model, Cmd msg )
  , update : msg -> model -> ( model, Cmd msg )
  , subscriptions : model -> Sub msg
  , view : model -> Node msg
  }
  -> Program flags
programWithFlags =
  Native.ReactNative.programWithFlags


{-| -}
hack : Bool
hack =
  Native.Platform.succeed


{-| -}
image : List (Property msg) -> List (Node msg) -> Node msg
image =
  node "Image"


{-| -}
activityIndicatorIos : List (Property msg) -> List (Node msg) -> Node msg
activityIndicatorIos =
  node "ActivityIndicatorIOS"


{-| -}
datePickerIos : List (Property msg) -> List (Node msg) -> Node msg
datePickerIos =
  node "DatePickerIOS"


{-| -}
drawerLayoutAndroid : List (Property msg) -> List (Node msg) -> Node msg
drawerLayoutAndroid =
  node "DrawerLayoutAndroid"


{-| -}
mapView : List (Property msg) -> List (Node msg) -> Node msg
mapView =
  node "MapView"


{-| -}
picker : List (Property msg) -> List (Node msg) -> Node msg
picker =
  node "Picker"


{-| -}
progressBar : List (Property msg) -> List (Node msg) -> Node msg
progressBar =
  node "ProgressBar"


{-| -}
progressView : List (Property msg) -> List (Node msg) -> Node msg
progressView =
  node "ProgressView"


{-| -}
refreshControl : List (Property msg) -> List (Node msg) -> Node msg
refreshControl =
  node "RefreshControl"


{-| -}
scrollView : List (Property msg) -> List (Node msg) -> Node msg
scrollView =
  node "ScrollView"


{-| -}
segmentedControl : List (Property msg) -> List (Node msg) -> Node msg
segmentedControl =
  node "SegmentedControl"


{-| -}
slider : List (Property msg) -> List (Node msg) -> Node msg
slider =
  node "Slider"


{-| -}
statusBar : List (Property msg) -> List (Node msg) -> Node msg
statusBar =
  node "StatusBar"


{-| -}
switch : List (Property msg) -> List (Node msg) -> Node msg
switch =
  node "Switch"


{-| -}
tabBar : List (Property msg) -> List (Node msg) -> Node msg
tabBar =
  node "TabBar"


{-| -}
textInput : List (Property msg) -> List (Node msg) -> Node msg
textInput =
  node "TextInput"


{-| -}
toolbar : List (Property msg) -> List (Node msg) -> Node msg
toolbar =
  node "Toolbar"


{-| -}
listView : List (Property msg) -> List (Node msg) -> Node msg
listView =
  node "ListView"


{-| -}
modal : List (Property msg) -> List (Node msg) -> Node msg
modal =
  node "Modal"


{-| -}
navigator : List (Property msg) -> List (Node msg) -> Node msg
navigator =
  node "Navigator"


{-| -}
navigatorIos : List (Property msg) -> List (Node msg) -> Node msg
navigatorIos =
  node "NavigatorIOS"


{-| -}
pickerIos : List (Property msg) -> List (Node msg) -> Node msg
pickerIos =
  node "PickerIOS"


{-| -}
progressBarAndroid : List (Property msg) -> List (Node msg) -> Node msg
progressBarAndroid =
  node "ProgressBarAndroid"


{-| -}
progressViewIos : List (Property msg) -> List (Node msg) -> Node msg
progressViewIos =
  node "ProgressViewIOS"


{-| -}
segmentedControlIos : List (Property msg) -> List (Node msg) -> Node msg
segmentedControlIos =
  node "SegmentedControlIOS"


{-| -}
sliderIos : List (Property msg) -> List (Node msg) -> Node msg
sliderIos =
  node "SliderIOS"


{-| -}
tabBarIos : List (Property msg) -> List (Node msg) -> Node msg
tabBarIos =
  node "TabBarIOS"


{-| -}
tabBarIosItem : List (Property msg) -> List (Node msg) -> Node msg
tabBarIosItem =
  node "TabBarIOS.Item"


{-| -}
toolbarAndroid : List (Property msg) -> List (Node msg) -> Node msg
toolbarAndroid =
  node "ToolbarAndroid"


{-| -}
touchableHighlight : List (Property msg) -> List (Node msg) -> Node msg
touchableHighlight =
  node "TouchableHighlight"


{-| -}
touchableNativeFeedback : List (Property msg) -> List (Node msg) -> Node msg
touchableNativeFeedback =
  node "TouchableNativeFeedback"


{-| -}
touchableOpacity : List (Property msg) -> List (Node msg) -> Node msg
touchableOpacity =
  node "TouchableOpacity"


{-| -}
touchableWithoutFeedback : List (Property msg) -> List (Node msg) -> Node msg
touchableWithoutFeedback =
  node "TouchableWithoutFeedback"


{-| -}
viewPagerAndroid : List (Property msg) -> List (Node msg) -> Node msg
viewPagerAndroid =
  node "ViewPagerAndroid"


{-| -}
webView : List (Property msg) -> List (Node msg) -> Node msg
webView =
  node "WebView"



-- Utils


{-| -}
firstLower : List Char -> List Char
firstLower lst =
  case lst of
    [] ->
      []

    x :: xs ->
      Char.toLower (x) :: xs


{-| -}
toHyphenated : List Char -> List Char
toHyphenated x =
  case x of
    [] ->
      []

    x' :: xs ->
      case (Char.isUpper x') of
        True ->
          '-' :: Char.toLower x' :: toHyphenated xs

        False ->
          x' :: toHyphenated xs


{-| -}
enumToString : a -> String
enumToString o =
  o
    |> toString
    |> String.toList
    |> firstLower
    |> toHyphenated
    |> String.fromList


{-| -}
enumToStringd : Int -> a -> String
enumToStringd d o =
  enumToString o
    |> String.dropLeft d



-- Styles come here
-- Text Styles


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
color : String -> Style
color =
  stringStyle "color"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
fontFamily : String -> Style
fontFamily =
  stringStyle "fontFamily"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
fontSize : Float -> Style
fontSize =
  floatStyle "fontSize"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
type FontStyleEnum
  = Normal
  | Italic


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
fontStyle : FontStyleEnum -> Style
fontStyle fs =
  stringStyle "fontStyle" (enumToString fs)


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
type FontWeightEnum
  = FontWeightNormal
  | FontWeightBold
  | FontWeight100
  | FontWeight200
  | FontWeight300
  | FontWeight400
  | FontWeight500
  | FontWeight600
  | FontWeight700
  | FontWeight800
  | FontWeight900


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
fontWeight : FontWeightEnum -> Style
fontWeight fw =
  stringStyle "fontWeight" (enumToStringd 10 fw)


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
letterSpacing : Float -> Style
letterSpacing =
  floatStyle "letterSpacing"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
lineHeight : Float -> Style
lineHeight =
  floatStyle "lineHeight"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
type TextAlignEnum
  = TextAlignAuto
  | TextAlignLeft
  | TextAlignRight
  | TextAlignCenter
  | TextAlignJustify


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
textAlign : TextAlignEnum -> Style
textAlign styl =
  stringStyle "textAlign" (enumToStringd 9 styl)



--enum("none", 'underline', 'line-through', 'underline line-through')


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
type TextDecorationLine
  = DecNone
  | DecUnderline
  | DecLineThrough
  | DecUnderline'LineThrough


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
textDecorationLine : TextDecorationLine -> Style
textDecorationLine dec =
  stringStyle "textDecorationLine" (enumToStringd 3 dec)


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
textDecorationStyle : BorderStyleEnum -> Style
textDecorationStyle styl =
  stringStyle "textDecorationStyle" (enumToString styl)


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
textDecorationColor : String -> Style
textDecorationColor =
  stringStyle "textDecorationColor"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
type DirectionEnum
  = DirAuto
  | DirLtr
  | DirRtl


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
writingDirection : DirectionEnum -> Style
writingDirection dir =
  stringStyle "writingDirection" (enumToStringd 3 dir)



--View Styles


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
backfaceVisibility : VisibilityEnum -> Style
backfaceVisibility vis =
  stringStyle "backfaceVisibility" (enumToString vis)


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
backgroundColor : String -> Style
backgroundColor =
  stringStyle "backgroundColor"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
borderColor : String -> Style
borderColor =
  stringStyle "borderColor"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
borderTopColor : String -> Style
borderTopColor =
  stringStyle "borderTopColor"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
borderRightColor : String -> Style
borderRightColor =
  stringStyle "borderRightColor"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
borderBottomColor : String -> Style
borderBottomColor =
  stringStyle "borderBottomColor"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
borderLeftColor : String -> Style
borderLeftColor =
  stringStyle "borderLeftColor"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
borderRadius : Float -> Style
borderRadius =
  floatStyle "borderRadius"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
borderTopLeftRadius : Float -> Style
borderTopLeftRadius =
  floatStyle "borderTopLeftRadius"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
borderTopRightRadius : Float -> Style
borderTopRightRadius =
  floatStyle "borderTopRightRadius"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
borderBottomLeftRadius : Float -> Style
borderBottomLeftRadius =
  floatStyle "borderBottomLeftRadius"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
borderBottomRightRadius : Float -> Style
borderBottomRightRadius =
  floatStyle "borderBottomRightRadius"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
type BorderStyleEnum
  = Solid
  | Dotted
  | Dashed
  | Double


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
borderStyle : BorderStyleEnum -> Style
borderStyle styl =
  stringStyle "borderStyle" (enumToString styl)


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
borderWidth : Float -> Style
borderWidth =
  floatStyle "borderWidth"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
borderTopWidth : Float -> Style
borderTopWidth =
  floatStyle "borderTopWidth"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
borderRightWidth : Float -> Style
borderRightWidth =
  floatStyle "borderRightWidth"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
borderBottomWidth : Float -> Style
borderBottomWidth =
  floatStyle "borderBottomWidth"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
borderLeftWidth : Float -> Style
borderLeftWidth =
  floatStyle "borderLeftWidth"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
opacity : Float -> Style
opacity =
  floatStyle "opacity"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
type VisibilityEnum
  = Visible
  | Hidden


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
overflow : VisibilityEnum -> Style
overflow ovrfl =
  stringStyle "overflow" (enumToString ovrfl)


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
shadowColor : String -> Style
shadowColor =
  stringStyle "shadowColor"



-- {-| A node in the virtual View Tree that forms the basis of the UI for your app.
-- -}
-- shadowOffset : Float -> Float -> Style
-- shadowOffset width height =
--   objectStyle
--     "shadowOffset"
--     [ numberDeclaration "width" width
--     , numberDeclaration "height" height
--     ]


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
shadowOpacity : Float -> Style
shadowOpacity =
  floatStyle "shadowOpacity"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
shadowRadius : Float -> Style
shadowRadius =
  floatStyle "shadowRadius"



--Image Styles
--enum('cover', 'contain', 'stretch')


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
resizeMode : String -> Style
resizeMode =
  stringStyle "resizeMode"



--backgroundColor : String -> Style
-- str = stringStyle "backgroundColor"
--borderColor : String -> Style
--borderColor = stringStyle "borderColor"
--borderWidth : Float -> Style
--borderWidth = numberStyle "borderWidth"
--borderRadius : Float -> Style
--borderRadius = numberStyle "borderRadius"
--overflow : String -> Style --enum('visible', 'hidden')
--overflow = stringStyle "overflow"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
tintColor : String -> Style
tintColor =
  stringStyle "tintColor"



-- opacity : Float -> Style
-- opacity =
--   numberStyle "opacity"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
alignItems : AlignSelfEnum -> Style
alignItems aligns =
  stringStyle "alignItems" (enumToString aligns)



--TODO
--Drop Align and then use the rest


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
type AlignSelfEnum
  = AlignAuto
  | AlignFlexStart
  | AlignFlexEnd
  | AlignCenter
  | AlignStretch


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
alignSelf : AlignSelfEnum -> Style
alignSelf aligns =
  stringStyle "alignSelf" (enumToStringd 5 aligns)



-- borderBottomWidth : Float -> Style
-- borderBottomWidth = numberStyle "borderBottomWidth"
--borderLeftWidth : Float -> Style
--borderLeftWidth = numberStyle "borderLeftWidth"
--borderRightWidth : Float -> Style
--borderRightWidth = numberStyle "borderRightWidth"
--borderTopWidth : Float -> Style
--borderTopWidth = numberStyle "borderTopWidth"
--borderWidth : Float -> Style
--borderWidth = numberStyle "borderWidth"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
bottom : Float -> Style
bottom =
  floatStyle "bottom"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
flex : Float -> Style
flex =
  floatStyle "flex"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
type FlexDirectionEnum
  = Row
  | Column


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
flexDirection : FlexDirectionEnum -> Style
flexDirection dir =
  stringStyle "flexDirection" (enumToString dir)


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
type FlexWrapEnum
  = Wrap
  | Nowrap


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
flexWrap : FlexWrapEnum -> Style
flexWrap wrp =
  stringStyle "flexWrap" (enumToString wrp)


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
height : Float -> Style
height =
  floatStyle "height"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
type JustifyContentEnum
  = FlexStart
  | FlexEnd
  | Center
  | SpaceBetween
  | SpaceAround


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
justifyContent : JustifyContentEnum -> Style
justifyContent jc =
  stringStyle "justifyContent" (enumToString jc)


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
left : Float -> Style
left =
  floatStyle "left"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
margin : Float -> Style
margin =
  floatStyle "margin"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
marginBottom : Float -> Style
marginBottom =
  floatStyle "marginBottom"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
marginHorizontal : Float -> Style
marginHorizontal =
  floatStyle "marginHorizontal"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
marginLeft : Float -> Style
marginLeft =
  floatStyle "marginLeft"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
marginRight : Float -> Style
marginRight =
  floatStyle "marginRight"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
marginTop : Float -> Style
marginTop =
  floatStyle "marginTop"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
marginVertical : Float -> Style
marginVertical =
  floatStyle "marginVertical"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
padding : Float -> Style
padding =
  floatStyle "padding"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
paddingBottom : Float -> Style
paddingBottom =
  floatStyle "paddingBottom"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
paddingHorizontal : Float -> Style
paddingHorizontal =
  floatStyle "paddingHorizontal"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
paddingLeft : Float -> Style
paddingLeft =
  floatStyle "paddingLeft"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
paddingRight : Float -> Style
paddingRight =
  floatStyle "paddingRight"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
paddingTop : Float -> Style
paddingTop =
  floatStyle "paddingTop"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
paddingVertical : Float -> Style
paddingVertical =
  floatStyle "paddingVertical"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
type PositionEnum
  = Absolute
  | Relative


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
position : PositionEnum -> Style
position pos =
  stringStyle "position" (enumToString pos)


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
right : Float -> Style
right =
  floatStyle "right"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
top : Float -> Style
top =
  floatStyle "top"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
width : Float -> Style
width =
  floatStyle "width"



--Transform Styles


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
type alias Transform =
  { perspective : Maybe Float
  , rotate : Maybe String
  , rotateX : Maybe String
  , rotateY : Maybe String
  , rotateZ : Maybe String
  , scale : Maybe Float
  , scaleX : Maybe Float
  , scaleY : Maybe Float
  , translateX : Maybe Float
  , translateY : Maybe Float
  , skewX : Maybe String
  , skewY : Maybe String
  }


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
defaultTransform : Transform
defaultTransform =
  { perspective = Nothing
  , rotate = Nothing
  , rotateX = Nothing
  , rotateY = Nothing
  , rotateZ = Nothing
  , scale = Nothing
  , scaleX = Nothing
  , scaleY = Nothing
  , translateX = Nothing
  , translateY = Nothing
  , skewX = Nothing
  , skewY = Nothing
  }



-- {-| A node in the virtual View Tree that forms the basis of the UI for your app.
-- -}
-- transform : Transform -> Style
-- transform options =
--   listStyle
--     "transform"
--     [ Maybe.map (numberDeclaration "perspective") options.perspective
--     , Maybe.map (stringDeclaration "rotate") options.rotate
--     , Maybe.map (stringDeclaration "rotateX") options.rotateX
--     , Maybe.map (stringDeclaration "rotateY") options.rotateY
--     , Maybe.map (stringDeclaration "rotateZ") options.rotateZ
--     , Maybe.map (numberDeclaration "scale") options.scale
--     , Maybe.map (numberDeclaration "scaleX") options.scaleX
--     , Maybe.map (numberDeclaration "scaleY") options.scaleY
--     , Maybe.map (numberDeclaration "translateX") options.translateX
--     , Maybe.map (numberDeclaration "translateY") options.translateY
--     , Maybe.map (stringDeclaration "skewX") options.skewX
--     , Maybe.map (stringDeclaration "skewY") options.skewY
--     ]
--TODO
--transformMatrix : TransformMatrixPropType -> Style
