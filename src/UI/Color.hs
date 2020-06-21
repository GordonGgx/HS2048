module UI.Color where

import Data.Text
import GI.Gdk.Structs.RGBA (RGBA,rGBAParse,newZeroRGBA)

parseColor::Text ->IO (Maybe RGBA)
parseColor color=do
  rgba<-newZeroRGBA
  rGBAParse rgba color
  return (Just rgba)
