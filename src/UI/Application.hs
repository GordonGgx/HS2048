{-#LANGUAGE OverloadedStrings#-}

module UI.Application(run2048) where

import GI.Gio.Objects.Application hiding(applicationNew,Application)
import GI.Gio.Flags
import qualified GI.Gtk.Functions as Gtk
import GI.Gtk.Objects.Application
import UI.Panel(createMain)

run2048::IO()
run2048=do
  Gtk.init Nothing
  --create application
  application<-applicationNew (Just "com.ggx.game") [ApplicationFlagsFlagsNone]
  case application of
    Nothing->error "application created failed"
    Just app->initApp app

initApp::Application->IO()
initApp app=do
  onApplicationActivate app $ createMain  app
  onApplicationShutdown app $ print "Application is Destroy"
  applicationRun app Nothing
  return ()
