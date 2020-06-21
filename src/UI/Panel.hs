{-#LANGUAGE OverloadedStrings#-}

module UI.Panel where

import GI.Gtk.Objects
import GI.Gtk.Functions
import GI.Gtk.Enums
import GI.Gtk.Objects.ApplicationWindow
import GI.Gtk.Objects.Application
import GI.Gtk.Objects.Window
import GI.Gtk.Objects.Container(containerAdd)

createMain::Application->IO()
createMain app=do
  mainWindow<-applicationWindowNew app
  windowSetDefaultSize mainWindow 500 500
  windowSetTitle mainWindow "HS2048"
  windowSetPosition mainWindow WindowPositionCenterAlways
  windowSetIconFromFile mainWindow "./resources/icon.png"
  onWidgetDestroy mainWindow mainQuit
  box<-hButtonBoxNew
  containerAdd mainWindow box
  widgetShowAll mainWindow
  main
