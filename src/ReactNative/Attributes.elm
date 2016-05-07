module ReactNative.Attributes exposing (style, class, classList, hidden, property, attribute)

{-| Helper functions for HTML attributes. They are organized roughly by
category. Each attribute is labeled with the HTML tags it can be used with, so
just search the page for `video` if you want video stuff.

If you cannot find what you are looking for, go to the [Custom
Attributes](#custom-attributes) section to learn how to create new helpers.

# Special Attributes
@docs style

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

-}

import ReactNative exposing (..)
import Json.Encode as Json
import String


-- This library does not include low, high, or optimum because the idea of a
-- `meter` is just too crazy.
-- SPECIAL ATTRIBUTES


{-| Specify a list of styles.

    myStyle : Attribute msg
    myStyle =
      style
        [ ("backgroundColor", "red")
        , ("height", "90px")
        , ("width", "100%")
        ]

    greeting : Html
    greeting =
      div [ myStyle ] [ text "Hello!" ]

There is no `Html.Styles` module because best practices for working with HTML
suggest that this should primarily be specified in CSS files. So the general
recommendation is to use this function lightly.
-}
style : List ( String, String ) -> Property msg
style =
  ReactNative.style


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


stringProperty : String -> String -> Property msg
stringProperty name string =
  property name (Json.string string)


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
