{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

import Database.MongoDB
import Control.Monad.Trans
import Control.Monad.IO.Class
import Control.Monad.Trans.Reader

main = do
   pipe <- connect (host "192.168.1.61")
   e <- access pipe master "baseball" run
   close pipe
   let e' = map (valueAt "name") e
   print e

run :: ReaderT MongoContext IO [Document]
run = do
   clearTeams
   insertTeams
   upsertTeams
   allTeams

   
clearTeams :: Action IO ()
clearTeams = delete (select [] "team")

upsertTeams :: Action IO ()
upsertTeams = upsert (select ["league" =: "National"] "team") ["$set" =: ["name" =: "andes"]]

insertTeams :: Action IO [Value]
insertTeams = insertMany "team" [
   ["name" =: "Yankees", "home" =: ["city" =: "New York", "state" =: 1], "league" =: "American"],
   ["name" =: "Mets", "home" =: ["city" =: "New York", "state" =: 2], "league" =: "National"],
   ["name" =: "Phillies", "home" =: ["city" =: "Philadelphia", "state" =: 3], "league" =: "National"],
   ["name" =: "Red Sox", "home" =: ["city" =: "Boston", "state" =: 4], "league" =: "American"] ]

allTeams :: ReaderT MongoContext IO [Document]
allTeams = rest =<< find (select [] "team") {sort = ["home.city" =: 1]}
              
nationalLeagueTeams :: ReaderT MongoContext IO [Document]
nationalLeagueTeams = rest =<< find (select ["league" =: "National"] "team") {sort = ["home.city" =: 1]}

newYorkTeams :: ReaderT MongoContext IO [Document]
newYorkTeams = rest =<< find (select ["home.state" =: "NY"] "team") {project = ["name" =: 1, "league" =: 1]}


