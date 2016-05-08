module ReactNative.Events exposing (..)

{-|
It is often helpful to create an [Union Type][] so you can have many different kinds
of events as seen in the [TodoMVC][] example.

[Union Type]: http://elm-lang.org/learn/Union-Types.elm
[TodoMVC]: https://github.com/evancz/elm-todomvc/blob/master/Todo.elm

# Mouse Helpers
@docs onClick, onDoubleClick,
      onMouseDown, onMouseUp,
      onMouseEnter, onMouseLeave,
      onMouseOver, onMouseOut

# Form Helpers
@docs onInput, onCheck, onSubmit

# Focus Helpers
@docs onBlur, onFocus

# Custom Event Handlers
@docs on, onWithOptions, Options, defaultOptions

# Custom Decoders
@docs targetValue, targetChecked, keyCode

@docs onAccessibilityTap, onActionSelected, onAnnotationPress, onChange
@docs onChangeText, onChangeVisibleRows, onContentSizeChange, onDateChange
@docs onDidFocus, onDrawerClose, onDrawerOpen, onDrawerSlide
@docs onDrawerStateChanged, onEndEditing, onEndReached, onError
@docs onHideUnderlay, onIconClicked, onKeyPress, onLayout, onLoad, onLoadEnd
@docs onLoadStart, onLongPress, onMagicTap, onMoveShouldSetResponder
@docs onMoveShouldSetResponderCapture, onNavigationStateChange, onPageScroll
@docs onPageScrollStateChanged, onPageSelected, onPickerValueChange, onPress
@docs onPressIn, onPressOut, onProgress, onRefresh, onRegionChange
@docs onRegionChangeComplete, onRequestClose, onResponderGrant, onResponderMove
@docs onResponderReject, onResponderRelease, onResponderTerminate
@docs onResponderTerminationRequest, onScroll, onScrollAnimationEnd
@docs onSegmentedControlValueChange, onSelectionChange
@docs onShouldStartLoadWithRequest, onShow, onShowUnderlay, onSliderValueChange
@docs onSlidingComplete, onStartShouldSetResponder
@docs onStartShouldSetResponderCapture, onSubmitEditing, onSubmitOptions
@docs onSwitchValueChange, onTintColor, onValueChange, onWillFocus
-}

import ReactNative exposing (..)
import Json.Decode as Json exposing ((:=))


-- MOUSE EVENTS


{-| -}
onClick : msg -> Property msg
onClick msg =
  on "click" (Json.succeed msg)


{-| -}
onDoubleClick : msg -> Property msg
onDoubleClick msg =
  on "dblclick" (Json.succeed msg)


{-| -}
onMouseDown : msg -> Property msg
onMouseDown msg =
  on "mousedown" (Json.succeed msg)


{-| -}
onMouseUp : msg -> Property msg
onMouseUp msg =
  on "mouseup" (Json.succeed msg)


{-| -}
onMouseEnter : msg -> Property msg
onMouseEnter msg =
  on "mouseenter" (Json.succeed msg)


{-| -}
onMouseLeave : msg -> Property msg
onMouseLeave msg =
  on "mouseleave" (Json.succeed msg)


{-| -}
onMouseOver : msg -> Property msg
onMouseOver msg =
  on "mouseover" (Json.succeed msg)


{-| -}
onMouseOut : msg -> Property msg
onMouseOut msg =
  on "mouseout" (Json.succeed msg)



-- FORM EVENTS


{-| Capture [input](https://developer.mozilla.org/en-US/docs/Web/Events/input)
events for things like text fields or text areas.

It grabs the **string** value at `event.target.value`, so it will not work if
need some other type of information. For example, if you want to track inputs
on a range slider, make a custom handler with [`on`](#on).

For more details on how `onInput` works, check out [targetValue](#targetValue).
-}
onInput : (String -> msg) -> Property msg
onInput tagger =
  on "input" (Json.map tagger targetValue)


{-| Capture [change](https://developer.mozilla.org/en-US/docs/Web/Events/change)
events on checkboxes. It will grab the boolean value from `event.target.checked`
on any input event.

Check out [targetChecked](#targetChecked) for more details on how this works.
-}
onCheck : (Bool -> msg) -> Property msg
onCheck tagger =
  on "change" (Json.map tagger targetChecked)


{-| Capture a [submit](https://developer.mozilla.org/en-US/docs/Web/Events/submit)
event with [`preventDefault`](https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault)
in order to prevent the form from changing the page’s location. If you need
different behavior, use `onWithOptions` to create a customized version of
`onSubmit`.
-}
onSubmit : msg -> Property msg
onSubmit msg =
  onWithOptions "submit" onSubmitOptions (Json.succeed msg)


{-| -}
onSubmitOptions : Options
onSubmitOptions =
  { defaultOptions | preventDefault = True }



-- FOCUS EVENTS


{-| -}
onBlur : msg -> Property msg
onBlur msg =
  on "blur" (Json.succeed msg)


{-| -}
onFocus : msg -> Property msg
onFocus msg =
  on "focus" (Json.succeed msg)



-- CUSTOM EVENTS


{-| Create a custom event listener. Normally this will not be necessary, but
you have the power! Here is how `onClick` is defined for example:

    import Json.Decode as Json

    onClick : msg -> Attribute msg
    onClick message =
      on "click" (Json.succeed message)

The first argument is the event name in the same format as with JavaScript's
[`addEventListener`][aEL] function.

The second argument is a JSON decoder. Read more about these [here][decoder].
When an event occurs, the decoder tries to turn the event object into an Elm
value. If successful, the value is routed to your `update` function. In the
case of `onClick` we always just succeed with the given `message`.

If this is confusing, work through the [Elm Architecture Tutorial][tutorial].
It really does help!

[aEL]: https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener
[decoder]: http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Decode
[tutorial]: https://github.com/evancz/elm-architecture-tutorial/
-}
on : String -> Json.Decoder msg -> Property msg
on =
  ReactNative.on


{-| Same as `on` but you can set a few options.
-}
onWithOptions : String -> Options -> Json.Decoder msg -> Property msg
onWithOptions =
  ReactNative.onWithOptions


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
  ReactNative.defaultOptions



-- COMMON DECODERS


{-| A `Json.Decoder` for grabbing `event.target.value`. We use this to define
`onInput` as follows:

    import Json.Decoder as Json

    onInput : (String -> msg) -> Attribute msg
    onInput tagger =
      on "input" (Json.map tagger targetValue)

You probably will never need this, but hopefully it gives some insights into
how to make custom event handlers.
-}
targetValue : Json.Decoder String
targetValue =
  Json.at [ "target", "value" ] Json.string


{-| A `Json.Decoder` for grabbing `event.target.checked`. We use this to define
`onCheck` as follows:

    import Json.Decoder as Json

    onCheck : (Bool -> msg) -> Attribute msg
    onCheck tagger =
      on "input" (Json.map tagger targetChecked)
-}
targetChecked : Json.Decoder Bool
targetChecked =
  Json.at [ "target", "checked" ] Json.bool


{-| A `Json.Decoder` for grabbing `event.keyCode`. This helps you define
keyboard listeners like this:

    import Json.Decoder as Json

    onKeyUp : (Int -> msg) -> Attribute msg
    onKeyUp tagger =
      on "keyup" (Json.map tagger keyCode)

**Note:** It looks like the spec is moving away from `event.keyCode` and
towards `event.key`. Once this is supported in more browsers, we may add
helpers here for `onKeyUp`, `onKeyDown`, `onKeyPress`, etc.
-}
keyCode : Json.Decoder Int
keyCode =
  ("keyCode" := Json.int)



-- All Events for React Native


{-| -}
onLayout : msg -> Property msg
onLayout msg =
  on "Layout" (Json.succeed msg)


{-| -}
onPress : msg -> Property msg
onPress msg =
  on "Press" (Json.succeed msg)


{-| -}
onLoadStart : msg -> Property msg
onLoadStart msg =
  on "LoadStart" (Json.succeed msg)


{-| -}
onProgress : msg -> Property msg
onProgress msg =
  on "Progress" (Json.succeed msg)


{-| -}
onError : msg -> Property msg
onError msg =
  on "Error" (Json.succeed msg)


{-| -}
onLoad : msg -> Property msg
onLoad msg =
  on "Load" (Json.succeed msg)


{-| -}
onLoadEnd : msg -> Property msg
onLoadEnd msg =
  on "LoadEnd" (Json.succeed msg)


{-| -}
onRegionChange : msg -> Property msg
onRegionChange msg =
  on "RegionChange" (Json.succeed msg)


{-| -}
onRegionChangeComplete : msg -> Property msg
onRegionChangeComplete msg =
  on "RegionChangeComplete" (Json.succeed msg)


{-| -}
onAnnotationPress : msg -> Property msg
onAnnotationPress msg =
  on "AnnotationPress" (Json.succeed msg)


{-| -}
onPickerValueChange : msg -> Property msg
onPickerValueChange msg =
  on "PickerValueChange" (Json.succeed msg)


{-| -}
onRefresh : msg -> Property msg
onRefresh msg =
  on "Refresh" (Json.succeed msg)


{-| -}
onScroll : msg -> Property msg
onScroll msg =
  on "Scroll" (Json.succeed msg)


{-| -}
onScrollAnimationEnd : msg -> Property msg
onScrollAnimationEnd msg =
  on "ScrollAnimationEnd" (Json.succeed msg)


{-| -}
onContentSizeChange : msg -> Property msg
onContentSizeChange msg =
  on "ContentSizeChange" (Json.succeed msg)


{-| -}
onSegmentedControlValueChange : msg -> Property msg
onSegmentedControlValueChange msg =
  on "SegmentedControlValueChange" (Json.succeed msg)


{-| -}
onChange : msg -> Property msg
onChange msg =
  on "Change" (Json.succeed msg)


{-| -}
onSliderValueChange : msg -> Property msg
onSliderValueChange msg =
  on "SliderValueChange" (Json.succeed msg)


{-| -}
onSlidingComplete : msg -> Property msg
onSlidingComplete msg =
  on "SlidingComplete" (Json.succeed msg)


{-| -}
onSwitchValueChange : msg -> Property msg
onSwitchValueChange msg =
  on "SwitchValueChange" (Json.succeed msg)



-- {-| -}
-- onBlur : msg -> Property msg
-- onBlur msg =
--   on "Blur" (Json.succeed msg)
-- {-| -}
-- onFocus : msg -> Property msg
-- onFocus msg =
--   on "Focus" (Json.succeed msg)


{-| -}
onChangeText : msg -> Property msg
onChangeText msg =
  on "ChangeText" (Json.succeed msg)


{-| -}
onEndEditing : msg -> Property msg
onEndEditing msg =
  on "EndEditing" (Json.succeed msg)


{-| -}
onSelectionChange : msg -> Property msg
onSelectionChange msg =
  on "SelectionChange" (Json.succeed msg)


{-| -}
onSubmitEditing : msg -> Property msg
onSubmitEditing msg =
  on "SubmitEditing" (Json.succeed msg)


{-| -}
onKeyPress : msg -> Property msg
onKeyPress msg =
  on "KeyPress" (Json.succeed msg)


{-| -}
onActionSelected : msg -> Property msg
onActionSelected msg =
  on "ActionSelected" (Json.succeed msg)


{-| -}
onIconClicked : msg -> Property msg
onIconClicked msg =
  on "IconClicked" (Json.succeed msg)


{-| -}
onAccessibilityTap : msg -> Property msg
onAccessibilityTap msg =
  on "AccessibilityTap" (Json.succeed msg)


{-| -}
onMagicTap : msg -> Property msg
onMagicTap msg =
  on "MagicTap" (Json.succeed msg)


{-| -}
onResponderGrant : msg -> Property msg
onResponderGrant msg =
  on "ResponderGrant" (Json.succeed msg)


{-| -}
onResponderMove : msg -> Property msg
onResponderMove msg =
  on "ResponderMove" (Json.succeed msg)


{-| -}
onResponderReject : msg -> Property msg
onResponderReject msg =
  on "ResponderReject" (Json.succeed msg)


{-| -}
onResponderRelease : msg -> Property msg
onResponderRelease msg =
  on "ResponderRelease" (Json.succeed msg)


{-| -}
onResponderTerminate : msg -> Property msg
onResponderTerminate msg =
  on "ResponderTerminate" (Json.succeed msg)


{-| -}
onResponderTerminationRequest : msg -> Property msg
onResponderTerminationRequest msg =
  on "ResponderTerminationRequest" (Json.succeed msg)


{-| -}
onStartShouldSetResponder : msg -> Property msg
onStartShouldSetResponder msg =
  on "StartShouldSetResponder" (Json.succeed msg)


{-| -}
onStartShouldSetResponderCapture : msg -> Property msg
onStartShouldSetResponderCapture msg =
  on "StartShouldSetResponderCapture" (Json.succeed msg)


{-| -}
onMoveShouldSetResponder : msg -> Property msg
onMoveShouldSetResponder msg =
  on "MoveShouldSetResponder" (Json.succeed msg)


{-| -}
onMoveShouldSetResponderCapture : msg -> Property msg
onMoveShouldSetResponderCapture msg =
  on "MoveShouldSetResponderCapture" (Json.succeed msg)


{-| -}
onDateChange : msg -> Property msg
onDateChange msg =
  on "DateChange" (Json.succeed msg)


{-| -}
onDrawerClose : msg -> Property msg
onDrawerClose msg =
  on "DrawerClose" (Json.succeed msg)


{-| -}
onDrawerOpen : msg -> Property msg
onDrawerOpen msg =
  on "DrawerOpen" (Json.succeed msg)


{-| -}
onDrawerSlide : msg -> Property msg
onDrawerSlide msg =
  on "DrawerSlide" (Json.succeed msg)


{-| -}
onDrawerStateChanged : msg -> Property msg
onDrawerStateChanged msg =
  on "DrawerStateChanged" (Json.succeed msg)


{-| -}
onChangeVisibleRows : msg -> Property msg
onChangeVisibleRows msg =
  on "ChangeVisibleRows" (Json.succeed msg)


{-| -}
onEndReached : msg -> Property msg
onEndReached msg =
  on "EndReached" (Json.succeed msg)


{-| -}
onRequestClose : msg -> Property msg
onRequestClose msg =
  on "RequestClose" (Json.succeed msg)


{-| -}
onShow : msg -> Property msg
onShow msg =
  on "Show" (Json.succeed msg)


{-| -}
onDidFocus : msg -> Property msg
onDidFocus msg =
  on "DidFocus" (Json.succeed msg)


{-| -}
onWillFocus : msg -> Property msg
onWillFocus msg =
  on "WillFocus" (Json.succeed msg)


{-| -}
onValueChange : msg -> Property msg
onValueChange msg =
  on "ValueChange" (Json.succeed msg)


{-| -}
onTintColor : msg -> Property msg
onTintColor msg =
  on "TintColor" (Json.succeed msg)


{-| -}
onHideUnderlay : msg -> Property msg
onHideUnderlay msg =
  on "HideUnderlay" (Json.succeed msg)


{-| -}
onShowUnderlay : msg -> Property msg
onShowUnderlay msg =
  on "ShowUnderlay" (Json.succeed msg)


{-| -}
onLongPress : msg -> Property msg
onLongPress msg =
  on "LongPress" (Json.succeed msg)


{-| -}
onPressIn : msg -> Property msg
onPressIn msg =
  on "PressIn" (Json.succeed msg)


{-| -}
onPressOut : msg -> Property msg
onPressOut msg =
  on "PressOut" (Json.succeed msg)


{-| -}
onPageScroll : msg -> Property msg
onPageScroll msg =
  on "PageScroll" (Json.succeed msg)


{-| -}
onPageScrollStateChanged : msg -> Property msg
onPageScrollStateChanged msg =
  on "PageScrollStateChanged" (Json.succeed msg)


{-| -}
onPageSelected : msg -> Property msg
onPageSelected msg =
  on "PageSelected" (Json.succeed msg)


{-| -}
onNavigationStateChange : msg -> Property msg
onNavigationStateChange msg =
  on "NavigationStateChange" (Json.succeed msg)


{-| -}
onShouldStartLoadWithRequest : msg -> Property msg
onShouldStartLoadWithRequest msg =
  on "ShouldStartLoadWithRequest" (Json.succeed msg)
