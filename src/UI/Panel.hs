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
import GI.Gdk.Structs.EventKey
import qualified GI.Gtk as GTK
import UI.Color
import qualified GI.GLib as GLib
import qualified GI.Gio as Gio
import GI.Gdk.Objects.Display(displayGetDefaultScreen,displayGetDefault)
import GI.Gtk.Objects.Widget(widgetGetStyleContext,widgetSetName)


createMainWindow::Application->IO()
createMainWindow app=do
  mainWindow<-applicationWindowNew app
  widgetSetName mainWindow "myWindow"
  css<-cssProviderNew
  display<-displayGetDefault
  d<-case display of
      Just d->return d
      Nothing->error "aaaa"
  screen<-displayGetDefaultScreen  d
  cssProviderLoadFromPath css "resources/css/demo.css"
  context<-widgetGetStyleContext mainWindow
  styleContextAddProvider context css 600
--  parseColor "#c0c0c0" >>=widgetOverrideBackgroundColor mainWindow [StateFlagsNormal]
  windowSetDefaultSize mainWindow 500 500
  windowSetTitle mainWindow "HS2048"
  windowSetPosition mainWindow WindowPositionCenterAlways
  windowSetIconFromFile mainWindow "resources/image/icon.png"
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
  grid<-gridNew
  setGridColumnHomogeneous grid True
  setGridRowHomogeneous grid  True
  gridInsertColumn grid 4
  gridInsertRow grid 4
  containerAdd window grid
  btn<-buttonNewWithLabel "测试按钮"
  gridAttach grid btn 0 0 1 1
  btn1<-buttonNewWithLabel "测试按钮1"
  gridAttach grid btn1 1 1 1 1
  GLib.timeoutAdd GLib.PRIORITY_DEFAULT 1000 $ do
    setButtonXalign btn 0.9
    return True
  GLib.timeoutAdd GLib.PRIORITY_DEFAULT 1500 $ do
      setButtonXalign btn 0.5
      return False
  -- register key event on window
  onWidgetKeyPressEvent window doKeyPressed
  return ()

doKeyPressed::EventKey->IO Bool
doKeyPressed event=do
  keyString<-getEventKeyString event
  mapM_ print keyString
  return False


