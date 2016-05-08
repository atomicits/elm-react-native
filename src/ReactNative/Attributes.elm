module ReactNative.Attributes exposing (..)

{-| Helper functions for HTML attributes. They are organized roughly by
category. Each attribute is labeled with the HTML tags it can be used with, so
just search the page for `video` if you want video stuff.

If you cannot find what you are looking for, go to the [Custom
Attributes](#custom-attributes) section to learn how to create new helpers.

# Special Attributes
-- @docs style

# Super Common Attributes
@docs class, classList, hidden


# Custom Attributes

When using HTML and JS, there are two ways to specify parts of a DOM node.

  1. Attributes &mdash; You can set things in HTML itself. So the `class`
     in `<div class="greeting"></div>` is called an *attribute*.

  2. Properties &mdash; You can also set things in JS. So the `className`
     in `div.className = 'greeting'` is called a *property*.

So the `class` attribute corresponds to the `className` property. At first
glance, perhaps this distinction is defensible, but it gets much crazier.
*There is not always a one-to-one mapping between attributes and properties!*
Yes, that is a true fact. Sometimes an attribute exists, but there is no
corresponding property. Sometimes changing an attribute does not change the
underlying property. For example, as of this writing the `webkit-playsinline`
attribute can be used in HTML, but there is no corresponding property!

Pretty much all of the functions in `Html.Attributes` are defined with
`property` and that is generally the preferred approach.

@docs property, attribute


@docs Bottom, ImageSource, Latitude, LatitudeDelta, Left, Longitude
@docs LongitudeDelta, Right, Top, accessibilityLabel, accessibilityLiveRegion
@docs accessible, active, activeOpacity, allowFontScaling
@docs allowsInlineMediaPlayback, alwaysBounceHorizontal, alwaysBounceVertical
@docs animated, animating, annotations, autoCapitalize, autoCorrect, autoFocus
@docs automaticallyAdjustContentInsets, badgeString, barStyle, barTintColor
@docs blurOnSubmit, blurRadius, boolProperty, bounces, bouncesZoom
@docs canCancelContentTouches, capInsets, centerContent, clearButtonMode
@docs clearTextOnFocus, collapsable, color, colors, contentInset
@docs contentInsetEnd, contentInsetStart, date, datePickerMode
@docs decelerationRate, decelerationRateNum, defaultSource, defaultValue
@docs delayLongPress, delayPressIn, delayPressOut, directionalLockEnabled
@docs disabled, domStorageEnabled, drawerLockMode, drawerPosition, drawerWidth
@docs editable, enableEmptySections, enabled, enablesReturnKeyAutomatically
@docs endFillColor, followUserLocation, hidesWhenStopped, hitSlop, horizontal
@docs icon, importantForAccessibility, indicatorStyle, initialListSize
@docs initialPage, initialRoute, injectedJavaScript, javaScriptEnabled
@docs keyboardAppearance, keyboardDismissMode, keyboardShouldPersistTaps
@docs keyboardType, legalLabelInsets, logo, mapType, maxDelta, maxLength
@docs maximumDate, maximumTrackImage, maximumTrackTintColor, maximumValue
@docs maximumZoomScale, mediaPlaybackRequiresUserAction, minDelta, minimumDate
@docs minimumTrackTintColor, minimumValue, minimumZoomScale, minuteInterval
@docs momentary, multiline, navIcon, navigationBarHidden, navigator
@docs needsOffscreenAlphaCompositing, networkActivityIndicatorVisible
@docs numberOfLines, overflowIcon, overlays, pageSize, pagingEnabled
@docs pickerMode, pitchEnabled, placeholder, placeholderTextColor
@docs pointerEvents, pressRetentionOffset, progress, progressBackgroundColor
@docs progressImage, progressTintColor, progressViewStyle, prompt, propBool
@docs propEnum, propEnumInt, propFloat, propImageSource, propInt, propLatLong
@docs propString, propTlbr, propUri, refreshing, region, removeClippedSubviews
@docs renderError, renderFooter, renderHeader, renderLoading
@docs renderNavigationView, renderRow, renderScene, renderScrollComponent
@docs renderSectionHeader, renderSeparator, renderToHardwareTextureAndroid
@docs resizeMode, returnKeyType, rotateEnabled, rtl, scalesPageToFit
@docs scrollEnabled, scrollEventThrottle, scrollIndicatorInsets
@docs scrollRenderAheadDistance, scrollsToTop, secureTextEntry
@docs selectTextOnFocus, selectedIcon, selectedIndex, selectedValue
@docs selectionColor, sendMomentumEvents, shadowHidden, shouldRasterizeIOS
@docs showHideTransition, showsCompass, showsHorizontalScrollIndicator
@docs showsPointsOfInterest, showsUserLocation, showsVerticalScrollIndicator
@docs size, sliderValue, snapToAlignment, snapToInterval, source
@docs startInLoadingState, statusBarBackgroundColor, step, stickyHeaderIndices
@docs stringProperty, styleAttr, subtitle, suppressHighlighting, systemIcon
@docs testID, thumbImage, thumbTintColor, timeZoneOffsetInMinutes, tintColor
@docs title, titleColor, titleTextColor, trackImage, trackTintColor
@docs translucent, transparent, underlayColor, underlineColorAndroid, value
@docs values, zoomEnabled, zoomScale
-}

-- module ReactNative.Attributes exposing (style, class, classList, hidden, property, attribute)

import ReactNative exposing (..)
import Json.Encode as Json
import String
import Json.Encode
import ReactNative exposing (..)
import ReactNative.Enum.DatePicker as Dpe
import ReactNative.Enum.ImageResize as Ire
import ReactNative.Enum.ActivityIndicator as Aie
import ReactNative.Enum.MapView as MapType
import ReactNative.Enum.Picker as PickerMode
import ReactNative.Enum.ProgressView as ProgressViewStyle
import ReactNative.Enum.ScrollView as ScrollViewEnum
import ReactNative.Enum.DrawerLayoutAndroid as DrawerLayoutEnum
import ReactNative.Enum.StatusBar as StatusBarEnum
import ReactNative.Enum.TextInput as TextInputEnum
import ReactNative.Enum.TextInputKA as TextInputKAEnum
import ReactNative.Enum.ReturnKeyType as ReturnKeyTypeEnum
import ReactNative.Enum.View as ViewEnum
import ReactNative.Enum.Pointer as PointerEnum
import ReactNative.Enum.DatePickerIos as DatePickerIosEnum
import ReactNative.Enum.ProgressBarAndroid as ProgressBarAndroidEnum
import ReactNative.Enum.TabBarIos as TabBarIosEnum


-- This library does not include low, high, or optimum because the idea of a
-- `meter` is just too crazy.
-- SPECIAL ATTRIBUTES
-- {-| Specify a list of styles.
--
--     myStyle : Attribute msg
--     myStyle =
--       style
--         [ ("backgroundColor", "red")
--         , ("height", "90px")
--         , ("width", "100%")
--         ]
--
--     greeting : Html
--     greeting =
--       div [ myStyle ] [ text "Hello!" ]
--
-- There is no `Html.Styles` module because best practices for working with HTML
-- suggest that this should primarily be specified in CSS files. So the general
-- recommendation is to use this function lightly.
-- -}
-- style : List ( String, String ) -> Property msg
-- style =
--   ReactNative.style


{-| This function makes it easier to build a space-separated class attribute.
Each class can easily be added and removed depending on the boolean value it
is paired with.

    renderMessage : Msg -> Html
    renderMessage msg =
      div
        [
          classList [
            ("message", True),
            ("message-important", msg.isImportant),
            ("message-read", msg.isRead)
          ]
        ]
        [ text msg.content ]
-}
classList : List ( String, Bool ) -> Property msg
classList list =
  list
    |> List.filter snd
    |> List.map fst
    |> String.join " "
    |> class



-- CUSTOM ATTRIBUTES


{-| Create arbitrary *properties*.

    import Json.Encode as Json

    greeting : Html
    greeting =
        div [ property "className" (Json.string "greeting") ] [
          text "Hello!"
        ]

Notice that you must give the *property* name, so we use `className` as it
would be in JavaScript, not `class` as it would appear in HTML.
-}
property : String -> Json.Value -> Property msg
property =
  ReactNative.property


{-| -}
stringProperty : String -> String -> Property msg
stringProperty name string =
  property name (Json.string string)


{-| -}
boolProperty : String -> Bool -> Property msg
boolProperty name bool =
  property name (Json.bool bool)


{-| Create arbitrary HTML *attributes*. Maps onto JavaScript&rsquo;s
`setAttribute` function under the hood.

    greeting : Html
    greeting =
        div [ attribute "class" "greeting" ] [
          text "Hello!"
        ]

Notice that you must give the *attribute* name, so we use `class` as it would
be in HTML, not `className` as it would appear in JS.
-}
attribute : String -> String -> Property msg
attribute =
  ReactNative.attribute



-- GLOBAL ATTRIBUTES


{-| Often used with CSS to style elements with common properties.
-}
class : String -> Property msg
class name =
  stringProperty "className" name


{-| Indicates the relevance of an element.
-}
hidden : Bool -> Property msg
hidden bool =
  boolProperty "hidden" bool


{-| -}
propEnumInt : String -> Int -> a -> Property msg
propEnumInt name dc val =
  val
    |> enumToString
    |> String.dropLeft dc
    |> String.toInt
    |> Result.withDefault 0
    |> propInt name


{-| -}
propInt : String -> Int -> Property msg
propInt name val =
  property name (Json.Encode.int val)


{-| -}
propEnum : String -> a -> Property msg
propEnum name val =
  propString name (enumToString val)


{-| -}
type alias Top =
  Int


{-| -}
type alias Left =
  Int


{-| -}
type alias Bottom =
  Int


{-| -}
type alias Right =
  Int


{-| -}
propTlbr : String -> Top -> Left -> Bottom -> Right -> Property msg
propTlbr name top left bottom right =
  property
    name
    (Json.Encode.object
      [ ( "top", Json.Encode.int top )
      , ( "left", Json.Encode.int left )
      , ( "bottom", Json.Encode.int bottom )
      , ( "right", Json.Encode.int right )
      ]
    )


{-| -}
type alias Latitude =
  Float


{-| -}
type alias Longitude =
  Float


{-| -}
type alias LatitudeDelta =
  Float


{-| -}
type alias LongitudeDelta =
  Float


{-| -}
propLatLong : String -> Latitude -> Longitude -> LatitudeDelta -> LongitudeDelta -> Property msg
propLatLong name a b c d =
  property
    name
    (Json.Encode.object
      [ ( "latitude", Json.Encode.float a )
      , ( "longitude", Json.Encode.float b )
      , ( "latitudeDelta", Json.Encode.float c )
      , ( "longitudeDelta", Json.Encode.float d )
      ]
    )


{-| -}
propFloat : String -> Float -> Property msg
propFloat name val =
  property name (Json.Encode.float val)


{-| -}
propString : String -> String -> Property msg
propString name val =
  property name (Json.Encode.string val)


{-| -}
propBool : String -> Bool -> Property msg
propBool name val =
  property name (Json.Encode.bool val)


{-| -}
propUri : String -> String -> Property msg
propUri name uri =
  property name (Json.Encode.object [ ( "uri", Json.Encode.string uri ) ])


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
numberOfLines : Int -> Property msg
numberOfLines =
  propInt "numberOfLines"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
suppressHighlighting : Bool -> Property msg
suppressHighlighting =
  propBool "suppressHighlighting"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
testID : String -> Property msg
testID =
  propString "testID"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
allowFontScaling : Bool -> Property msg
allowFontScaling =
  propBool "allowFontScaling"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
source : ImageSource -> Property msg
source =
  propImageSource "source"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
defaultSource : ImageSource -> Property msg
defaultSource =
  propImageSource "defaultSource"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
accessible : Bool -> Property msg
accessible =
  propBool "accessible"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
accessibilityLabel : String -> Property msg
accessibilityLabel =
  propString "accessibilityLabel"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
resizeMode : Ire.Mode -> Property msg
resizeMode =
  propEnum "resizeMode"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
animating : Bool -> Property msg
animating =
  propBool "animating"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
color : String -> Property msg
color =
  propString "color"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
hidesWhenStopped : Bool -> Property msg
hidesWhenStopped =
  propBool "hidesWhenStopped"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
size : Aie.Size -> Property msg
size =
  propEnum "size"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
showsUserLocation : Bool -> Property msg
showsUserLocation =
  propBool "showsUserLocation"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
followUserLocation : Bool -> Property msg
followUserLocation =
  propBool "followUserLocation"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
showsPointsOfInterest : Bool -> Property msg
showsPointsOfInterest =
  propBool "showsPointsOfInterest"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
showsCompass : Bool -> Property msg
showsCompass =
  propBool "showsCompass"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
zoomEnabled : Bool -> Property msg
zoomEnabled =
  propBool "zoomEnabled"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
rotateEnabled : Bool -> Property msg
rotateEnabled =
  propBool "rotateEnabled"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
pitchEnabled : Bool -> Property msg
pitchEnabled =
  propBool "pitchEnabled"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
scrollEnabled : Bool -> Property msg
scrollEnabled =
  propBool "scrollEnabled"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
mapType : MapType.MapType -> Property msg
mapType =
  propEnum "mapType"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
maxDelta : Float -> Property msg
maxDelta =
  propFloat "maxDelta"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
minDelta : Float -> Property msg
minDelta =
  propFloat "minDelta"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
active : Bool -> Property msg
active =
  propBool "active"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
enabled : Bool -> Property msg
enabled =
  propBool "enabled"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
pickerMode : PickerMode.Mode -> Property msg
pickerMode =
  propEnum "mode"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
prompt : String -> Property msg
prompt =
  propString "prompt"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
progress : Float -> Property msg
progress =
  propFloat "progress"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
progressViewStyle : ProgressViewStyle.Style -> Property msg
progressViewStyle =
  propEnum "progressViewStyle"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
progressTintColor : String -> Property msg
progressTintColor =
  propString "progressTintColor"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
trackTintColor : String -> Property msg
trackTintColor =
  propString "trackTintColor"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
refreshing : Bool -> Property msg
refreshing =
  propBool "refreshing"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
title : String -> Property msg
title =
  propString "title"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
automaticallyAdjustContentInsets : Bool -> Property msg
automaticallyAdjustContentInsets =
  propBool "automaticallyAdjustContentInsets"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
bounces : Bool -> Property msg
bounces =
  propBool "bounces"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
bouncesZoom : Bool -> Property msg
bouncesZoom =
  propBool "bouncesZoom"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
alwaysBounceHorizontal : Bool -> Property msg
alwaysBounceHorizontal =
  propBool "alwaysBounceHorizontal"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
alwaysBounceVertical : Bool -> Property msg
alwaysBounceVertical =
  propBool "alwaysBounceVertical"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
centerContent : Bool -> Property msg
centerContent =
  propBool "centerContent"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
horizontal : Bool -> Property msg
horizontal =
  propBool "horizontal"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
indicatorStyle : ScrollViewEnum.IndicatorStyle -> Property msg
indicatorStyle =
  propEnum "indicatorStyle"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
directionalLockEnabled : Bool -> Property msg
directionalLockEnabled =
  propBool "directionalLockEnabled"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
canCancelContentTouches : Bool -> Property msg
canCancelContentTouches =
  propBool "canCancelContentTouches"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
keyboardDismissMode : ScrollViewEnum.KeyboardDismissMode -> Property msg
keyboardDismissMode =
  propEnum "keyboardDismissMode"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
keyboardShouldPersistTaps : Bool -> Property msg
keyboardShouldPersistTaps =
  propBool "keyboardShouldPersistTaps"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
maximumZoomScale : Float -> Property msg
maximumZoomScale =
  propFloat "maximumZoomScale"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
minimumZoomScale : Float -> Property msg
minimumZoomScale =
  propFloat "minimumZoomScale"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
pagingEnabled : Bool -> Property msg
pagingEnabled =
  propBool "pagingEnabled"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
scrollEventThrottle : Float -> Property msg
scrollEventThrottle =
  propFloat "scrollEventThrottle"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
scrollsToTop : Bool -> Property msg
scrollsToTop =
  propBool "scrollsToTop"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
sendMomentumEvents : Bool -> Property msg
sendMomentumEvents =
  propBool "sendMomentumEvents"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
showsHorizontalScrollIndicator : Bool -> Property msg
showsHorizontalScrollIndicator =
  propBool "showsHorizontalScrollIndicator"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
showsVerticalScrollIndicator : Bool -> Property msg
showsVerticalScrollIndicator =
  propBool "showsVerticalScrollIndicator"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
snapToInterval : Float -> Property msg
snapToInterval =
  propFloat "snapToInterval"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
snapToAlignment : ScrollViewEnum.SnapToAlignment -> Property msg
snapToAlignment =
  propEnum "snapToAlignment"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
removeClippedSubviews : Bool -> Property msg
removeClippedSubviews =
  propBool "removeClippedSubviews"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
zoomScale : Float -> Property msg
zoomScale =
  propFloat "zoomScale"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
selectedIndex : Float -> Property msg
selectedIndex =
  propFloat "selectedIndex"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
tintColor : String -> Property msg
tintColor =
  propString "tintColor"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
momentary : Bool -> Property msg
momentary =
  propBool "momentary"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
sliderValue : Float -> Property msg
sliderValue =
  propFloat "sliderValue"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
step : Float -> Property msg
step =
  propFloat "step"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
minimumValue : Float -> Property msg
minimumValue =
  propFloat "minimumValue"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
maximumValue : Float -> Property msg
maximumValue =
  propFloat "maximumValue"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
minimumTrackTintColor : String -> Property msg
minimumTrackTintColor =
  propString "minimumTrackTintColor"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
maximumTrackTintColor : String -> Property msg
maximumTrackTintColor =
  propString "maximumTrackTintColor"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
disabled : Bool -> Property msg
disabled =
  propBool "disabled"



-- {-| A node in the virtual View Tree that forms the basis of the UI for your app.
-- -}
-- hidden : Bool -> Property msg
-- hidden =
--   propBool "hidden"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
animated : Bool -> Property msg
animated =
  propBool "animated"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
translucent : Bool -> Property msg
translucent =
  propBool "translucent"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
barStyle : StatusBarEnum.BarStyle -> Property msg
barStyle =
  propEnum "barStyle"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
networkActivityIndicatorVisible : Bool -> Property msg
networkActivityIndicatorVisible =
  propBool "networkActivityIndicatorVisible"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
showHideTransition : StatusBarEnum.ShowHideTransition -> Property msg
showHideTransition =
  propEnum "showHideTransition"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
autoCapitalize : TextInputEnum.AutoCapitalize -> Property msg
autoCapitalize =
  propEnum "autoCapitalize"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
autoCorrect : Bool -> Property msg
autoCorrect =
  propBool "autoCorrect"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
autoFocus : Bool -> Property msg
autoFocus =
  propBool "autoFocus"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
editable : Bool -> Property msg
editable =
  propBool "editable"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
keyboardType : TextInputEnum.KeyboardType -> Property msg
keyboardType =
  propEnum "keyboardType"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
keyboardAppearance : TextInputKAEnum.KeyboardAppearance -> Property msg
keyboardAppearance =
  propEnum "keyboardAppearance"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
returnKeyType : ReturnKeyTypeEnum.ReturnKeyType -> Property msg
returnKeyType =
  propEnum "returnKeyType"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
maxLength : Float -> Property msg
maxLength =
  propFloat "maxLength"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
enablesReturnKeyAutomatically : Bool -> Property msg
enablesReturnKeyAutomatically =
  propBool "enablesReturnKeyAutomatically"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
multiline : Bool -> Property msg
multiline =
  propBool "multiline"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
placeholder : String -> Property msg
placeholder =
  propString "placeholder"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
placeholderTextColor : String -> Property msg
placeholderTextColor =
  propString "placeholderTextColor"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
secureTextEntry : Bool -> Property msg
secureTextEntry =
  propBool "secureTextEntry"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
selectionColor : String -> Property msg
selectionColor =
  propString "selectionColor"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
value : String -> Property msg
value =
  propString "value"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
defaultValue : String -> Property msg
defaultValue =
  propString "defaultValue"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
clearButtonMode : TextInputEnum.ClearButtonMode -> Property msg
clearButtonMode =
  propEnum "clearButtonMode"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
clearTextOnFocus : Bool -> Property msg
clearTextOnFocus =
  propBool "clearTextOnFocus"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
selectTextOnFocus : Bool -> Property msg
selectTextOnFocus =
  propBool "selectTextOnFocus"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
blurOnSubmit : Bool -> Property msg
blurOnSubmit =
  propBool "blurOnSubmit"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
underlineColorAndroid : String -> Property msg
underlineColorAndroid =
  propString "underlineColorAndroid"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
subtitle : String -> Property msg
subtitle =
  propString "subtitle"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
contentInsetStart : Float -> Property msg
contentInsetStart =
  propFloat "contentInsetStart"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
contentInsetEnd : Float -> Property msg
contentInsetEnd =
  propFloat "contentInsetEnd"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
rtl : Bool -> Property msg
rtl =
  propBool "rtl"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
accessibilityLiveRegion : ViewEnum.AccessibilityLiveRegion -> Property msg
accessibilityLiveRegion =
  propEnum "accessibilityLiveRegion"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
importantForAccessibility : ViewEnum.ImportantForAccessibility -> Property msg
importantForAccessibility =
  propEnum "importantForAccessibility"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
pointerEvents : PointerEnum.PointerEvents -> Property msg
pointerEvents =
  propEnum "pointerEvents"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
renderToHardwareTextureAndroid : Bool -> Property msg
renderToHardwareTextureAndroid =
  propBool "renderToHardwareTextureAndroid"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
shouldRasterizeIOS : Bool -> Property msg
shouldRasterizeIOS =
  propBool "shouldRasterizeIOS"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
collapsable : Bool -> Property msg
collapsable =
  propBool "collapsable"


{-| A node in the virtual View Tree that forms the basis of the UI for your app.
-}
needsOffscreenAlphaCompositing : Bool -> Property msg
needsOffscreenAlphaCompositing =
  propBool "needsOffscreenAlphaCompositing"


{-| -}
date : String -> Property msg
date =
  propString "date"


{-| -}
maximumDate : String -> Property msg
maximumDate =
  propString "maximumDate"


{-| -}
minimumDate : String -> Property msg
minimumDate =
  propString "minimumDate"


{-| -}
minuteInterval : DatePickerIosEnum.MinuteInterval -> Property msg
minuteInterval =
  propEnumInt "minuteInterval" 2


{-| -}
datePickerMode : Dpe.Mode -> Property msg
datePickerMode =
  propEnum "mode"


{-| -}
timeZoneOffsetInMinutes : Int -> Property msg
timeZoneOffsetInMinutes =
  propInt "timeZoneOffsetInMinutes"


{-| -}
drawerLockMode : DrawerLayoutEnum.DrawerLockMode -> Property msg
drawerLockMode =
  propEnum "drawerLockMode"


{-| -}
drawerPosition : DrawerLayoutEnum.DrawerPosition -> Property msg
drawerPosition =
  propEnum "drawerPosition"


{-| -}
drawerWidth : Int -> Property msg
drawerWidth =
  propInt "drawerWidth"


{-| -}
renderNavigationView : Json.Encode.Value -> Property msg
renderNavigationView f =
  property "drawerWidth" f


{-| -}
statusBarBackgroundColor : String -> Property msg
statusBarBackgroundColor =
  propString "statusBarBackgroundColor"


{-| -}
blurRadius : Int -> Property msg
blurRadius =
  propInt "blurRadius"


{-| -}
capInsets : Int -> Int -> Int -> Int -> Property msg
capInsets =
  propTlbr "capInsets"


{-| -}
enableEmptySections : Bool -> Property msg
enableEmptySections =
  propBool "enableEmptySections"


{-| -}
initialListSize : Int -> Property msg
initialListSize =
  propInt "initialListSize"


{-| -}
pageSize : Int -> Property msg
pageSize =
  propInt "pageSize"


{-| -}
renderFooter : Json.Encode.Value -> Property msg
renderFooter f =
  property "renderFooter" f


{-| -}
renderHeader : Json.Encode.Value -> Property msg
renderHeader f =
  property "renderHeader" f


{-| -}
renderRow : Json.Encode.Value -> Property msg
renderRow f =
  property "renderRow" f


{-| -}
renderScrollComponent : Json.Encode.Value -> Property msg
renderScrollComponent f =
  property "renderScrollComponent" f


{-| -}
renderSectionHeader : Json.Encode.Value -> Property msg
renderSectionHeader f =
  property "renderSectionHeader" f


{-| -}
renderSeparator : Json.Encode.Value -> Property msg
renderSeparator f =
  property "renderSeparator" f


{-| -}
scrollRenderAheadDistance : Int -> Property msg
scrollRenderAheadDistance =
  propInt "scrollRenderAheadDistance"


{-| -}
stickyHeaderIndices : List Int -> Property msg
stickyHeaderIndices val =
  property "stickyHeaderIndices" (Json.Encode.list (List.map Json.Encode.int val))


{-| -}
transparent : Bool -> Property msg
transparent =
  propBool "transparent"


{-| -}
barTintColor : String -> Property msg
barTintColor =
  propString "barTintColor"


{-| -}
navigationBarHidden : Bool -> Property msg
navigationBarHidden =
  propBool "navigationBarHidden"


{-| -}
shadowHidden : Bool -> Property msg
shadowHidden =
  propBool "shadowHidden"


{-| -}
titleTextColor : String -> Property msg
titleTextColor =
  propString "titleTextColor"


{-| -}
allowsInlineMediaPlayback : Bool -> Property msg
allowsInlineMediaPlayback =
  propBool "allowsInlineMediaPlayback"


{-| -}
javaScriptEnabled : Bool -> Property msg
javaScriptEnabled =
  propBool "javaScriptEnabled"


{-| -}
domStorageEnabled : Bool -> Property msg
domStorageEnabled =
  propBool "domStorageEnabled"


{-| -}
startInLoadingState : Bool -> Property msg
startInLoadingState =
  propBool "startInLoadingState"


{-| -}
scalesPageToFit : Bool -> Property msg
scalesPageToFit =
  propBool "scalesPageToFit"


{-| -}
mediaPlaybackRequiresUserAction : Bool -> Property msg
mediaPlaybackRequiresUserAction =
  propBool "mediaPlaybackRequiresUserAction"


{-| -}
injectedJavaScript : String -> Property msg
injectedJavaScript =
  propString "injectedJavaScript"


{-| -}
activeOpacity : Int -> Property msg
activeOpacity =
  propInt "activeOpacity"


{-| -}
delayLongPress : Int -> Property msg
delayLongPress =
  propInt "delayLongPress"


{-| -}
delayPressIn : Int -> Property msg
delayPressIn =
  propInt "delayPressIn"


{-| -}
delayPressOut : Int -> Property msg
delayPressOut =
  propInt "delayPressOut"


{-| -}
initialPage : Int -> Property msg
initialPage =
  propInt "initialPage"


{-| -}
hitSlop : Int -> Int -> Int -> Int -> Property msg
hitSlop =
  propTlbr "hitSlop"


{-| -}
contentInset : Int -> Int -> Int -> Int -> Property msg
contentInset =
  propTlbr "contentInset"


{-| -}
legalLabelInsets : Int -> Int -> Int -> Int -> Property msg
legalLabelInsets =
  propTlbr "legalLabelInsets"


{-| -}
scrollIndicatorInsets : Int -> Int -> Int -> Int -> Property msg
scrollIndicatorInsets =
  propTlbr "scrollIndicatorInsets"


{-| -}
pressRetentionOffset : Int -> Int -> Int -> Int -> Property msg
pressRetentionOffset =
  propTlbr "pressRetentionOffset"


{-| -}
initialRoute : Json.Encode.Value -> Property msg
initialRoute f =
  property "initialRoute" f


{-| -}
renderError : Json.Encode.Value -> Property msg
renderError f =
  property "renderError" f


{-| -}
renderLoading : Json.Encode.Value -> Property msg
renderLoading f =
  property "renderLoading" f


{-| -}
navigator : Json.Encode.Value -> Property msg
navigator f =
  property "navigator" f


{-| -}
renderScene : Json.Encode.Value -> Property msg
renderScene f =
  property "renderScene" f


{-| -}
progressBackgroundColor : String -> Property msg
progressBackgroundColor =
  propString "progressBackgroundColor"


{-| -}
endFillColor : String -> Property msg
endFillColor =
  propString "endFillColor"


{-| -}
thumbTintColor : String -> Property msg
thumbTintColor =
  propString "thumbTintColor"


{-| -}
titleColor : String -> Property msg
titleColor =
  propString "titleColor"


{-| -}
underlayColor : String -> Property msg
underlayColor =
  propString "underlayColor"


{-| -}
region : Float -> Float -> Float -> Float -> Property msg
region =
  propLatLong "region"


{-| -}
overlays : Int -> Int -> Int -> Int -> Property msg
overlays =
  propTlbr "overlays"


{-| -}
annotations : Int -> Int -> Int -> Int -> Property msg
annotations =
  propTlbr "annotations"


{-| -}
badgeString : String -> Property msg
badgeString =
  propString "badgeString"


{-| -}
decelerationRate : ScrollViewEnum.DecelerationRate -> Property msg
decelerationRate =
  propEnum "decelerationRate"


{-| -}
decelerationRateNum : Int -> Property msg
decelerationRateNum =
  propInt "decelerationRate"


{-| -}
selectedValue : Json.Encode.Value -> Property msg
selectedValue f =
  property "selectedValue" f


{-| -}
styleAttr : ProgressBarAndroidEnum.StyleAttr -> Property msg
styleAttr =
  propEnum "styleAttr"


{-| -}
progressImage : ImageSource -> Property msg
progressImage =
  propImageSource "progressImage"


{-| -}
trackImage : ImageSource -> Property msg
trackImage =
  propImageSource "trackImage"


{-| -}
logo : ImageSource -> Property msg
logo =
  propImageSource "logo"


{-| -}
navIcon : ImageSource -> Property msg
navIcon =
  propImageSource "navIcon"


{-| -}
overflowIcon : ImageSource -> Property msg
overflowIcon =
  propImageSource "overflowIcon"


{-| -}
type ImageSource
  = Uri String
  | Num Int


{-| -}
propImageSource : String -> ImageSource -> Property msg
propImageSource name imgSrc =
  case imgSrc of
    Uri str ->
      propUri name str

    Num n ->
      propInt name n


{-| -}
icon : ImageSource -> Property msg
icon =
  propImageSource "icon"


{-| -}
selectedIcon : ImageSource -> Property msg
selectedIcon =
  propImageSource "selectedIcon"


{-| -}
maximumTrackImage : ImageSource -> Property msg
maximumTrackImage =
  propImageSource "maximumTrackImage"


{-| -}
thumbImage : ImageSource -> Property msg
thumbImage =
  propImageSource "thumbImage"



--


{-| -}
systemIcon : TabBarIosEnum.SystemIcon -> Property msg
systemIcon =
  propEnum "systemIcon"


{-| -}
values : List String -> Property msg
values lst =
  property "values" (Json.Encode.list (List.map Json.Encode.string lst))


{-| -}
colors : List String -> Property msg
colors lst =
  property "colors" (Json.Encode.list (List.map Json.Encode.string lst))



-- {-| Turns a list of `Style`s into a property you can attach to a `NativeUi` node.
-- -}
-- contentContainerStyle : List Style.Style -> Property msg
-- contentContainerStyle styles =
--   Style.encode styles
--     |> property "contentContainerStyle"
-- {-| Turns a list of `Style`s into a property you can attach to a `NativeUi` node.
-- -}
-- itemStyle : List Style.Style -> Property msg
-- itemStyle styles =
--   Style.encode styles
--     |> property "itemStyle"
-- {-| Turns a list of `Style`s into a property you can attach to a `NativeUi` node.
-- -}
-- contentOffset : Int -> Int -> Property msg
-- contentOffset x y =
--   property
--     "contentOffset"
--     (Json.Encode.object
--       ([ ( "x", Json.Encode.int x )
--        , ( "y", Json.Encode.int y )
--        ]
--       )
--     )
