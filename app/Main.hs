{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultiWayIf        #-}

module Main where

import           AskWeatherFromServer ( askWeather )
import           CheckDateAndCity     ( getCityFromUser,
                                        getDateFromUser, reportAboutProblem
                                      )

import           Data.Text
import           Data.Text.IO         as TIO
import           Data.Time.Clock
import           System.FilePath.Posix
import qualified Data.ByteString      as B
import qualified Data.Yaml            as Y
import           Types.UserPhrases    ( UserPhrase (..) )
import           System.Directory
import           System.Exit

import           DecodeYaml
import           PrepareAnswer        ( prepareAnswer )

main :: IO ()
main = do
  currentDir <- getCurrentDirectory
  let langFile    = currentDir </> "i18n" </> "ru.yaml"
      langFolder  = currentDir </> "i18n"
  con <- B.readFile $ langFolder </> langFile
  let parsedContent = Y.decodeThrow con :: Maybe UserPhrase
  case parsedContent of
    Nothing -> die "Sorry,we cant Decode this file!"
    Just phrase -> do
      let cityNames = (takeCityNames $ phrase)
          allCities = takeFstElem $ cityNames
      TIO.putStrLn allCities
      fileNames <- listDirectory langFolder
      print fileNames
      language <- TIO.getLine
      if (Data.Text.toLower $ language) == "ru"
        then do
          TIO.putStrLn (choosDate $ phrase)
  --        TIO.putStrLn (takeFstElem $ cityNames)
          currentTime <- getCurrentTime
          dateFromUser <- Prelude.getLine
          let date = getDateFromUser currentTime dateFromUser phrase
          case date of
            Left problemWithDate -> TIO.putStrLn problemWithDate
            Right correctDate -> do
              TIO.putStrLn $ (choosCity $ phrase)
    --          print (takeCityNames $ phrase)
              cityFromUser <- TIO.getLine
              let city = getCityFromUser cityNames cityFromUser
              case city of
                Nothing -> reportAboutProblem phrase 
                Just correctCity -> do
                  response <- askWeather (correctDate, correctCity)
                  let answer = prepareAnswer response correctDate correctCity phrase
                  TIO.putStrLn answer
                  else TIO.putStrLn "Please select one of the suggested languages!"
