import 'bootstrap'
import css from "../css/app.scss"
import "phoenix_html"
import "awesomplete"
// import socket from "./socket"

import "./item_adder"
import { Elm } from "../elm/src/Main.elm"

const elmDiv = document.getElementById("elm-landing-pad")
Elm.Main.init({ node: elmDiv })
