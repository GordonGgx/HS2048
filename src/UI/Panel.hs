{-#LANGUAGE OverloadedStrings#-}

module UI.Panel(createMainWindow) where

import GI.Gtk.Objects
import GI.Gtk.Functions
import GI.Gtk.Enums
import GI.Gtk.Flags
import GI.Gtk.Objects.ApplicationWindow
import GI.Gtk.Objects.Application
import GI.Gtk.Objects.Window
import GI.Gtk.Objects.Container(containerAdd)
import UI.Color

createMainWindow::Application->IO()
createMainWindow app=do
  mainWindow<-applicationWindowNew app
  parseColor "#c0c0c0" >>=widgetOverrideBackgroundColor mainWindow [StateFlagsNormal]
  windowSetDefaultSize mainWindow 500 500
  windowSetTitle mainWindow "HS2048"
  windowSetPosition mainWindow WindowPositionCenterAlways
  windowSetIconFromFile mainWindow "resources/icon.png"
  onWidgetDestroy mainWindow mainQuit
  initMainPan mainWindow
  widgetShowAll mainWindow
  main

initMainPan::ApplicationWindow->IO()
initMainPan window=do
  -- first create headerBar
  headerBar<-headerBarNew
  headerBarSetShowCloseButton headerBar True
  headerBarSetTitle headerBar $ Just "2048"
  setHeaderBarHasSubtitle headerBar True
  setHeaderBarSubtitle headerBar "ggx"
  headerBarSetDecorationLayout headerBar $ Just "icon:minimize,maximize,close"
  startGame<-buttonNewWithLabel "New Game"
  score<-labelNew $ Just "0"
  headerBarPackStart headerBar startGame
  headerBarPackEnd headerBar score
  windowSetTitlebar window $ Just headerBar
  -- Create Game Pane

