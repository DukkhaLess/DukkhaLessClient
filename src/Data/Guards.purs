module Data.Guards where

guardMap :: forall a b. (a -> Boolean) -> b -> (a -> b) -> a -> b
guardMap p b f original = if p original then f original else b
