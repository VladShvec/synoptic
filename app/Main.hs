{-# LANGUAGE MultiWayIf        #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import           AskWeatherFromServer  ( askWeather )
import           CheckDateAndCity      ( UserError (..), getCityFromUser,
                                         getDateFromUser, messageForUser,
                                         reportAboutProblem )
import           Data.Aeson
import qualified Data.ByteString.Char8 as BS
import           Data.Text
import           Data.Text.IO          as TIO
import           Data.Time.Clock
--import           System.FilePath.Posix
import           System.Directory
import qualified Data.ByteString as B

import qualified Data.Yaml             as Y

import           Types.UserPhrases     ( MessageForUser (..))
import           ConversionWithCities  ( supportedCities )
import           I18n.CheckLanguage    ( checkLanguage )
import           PrepareAnswer         ( prepareAnswer )
import           Types.Lang            ( Language (..), MessageForUser (..) )

main :: IO ()
main = do
    fileNames <- listDirectory "/home/ashot/synoptic/i18n"
    print fileNames
    TIO.putStrLn $ messageForUser En MessageChooseLanguage
    lang <- TIO.getLine
    if (Data.Text.toLower $ lang) == (Data.Text.toLower $ "ru" )
      then do
        content <- B.readFile "/home/ashot/Рабочий стол/ru.yaml"
        let parsedContent = Y.decodeEither' content :: Either Y.ParseException Types.UserPhrases.MessageForUser
        case parsedContent of
          Left err -> error "Could not parse config file."
          Right val -> do
             --  
          --TIO.putStrLn $ messageForUser En MessageChooseLanguage
  --  language <- TIO.getLine
  --  let lang = checkLanguage language
--   case lang of
--      Left problemWithLang -> TIO.putStrLn problemWithLang
--      Right triedLanguage -> do
            TIO.putStrLn $ messageForUser lang MessageChooseForecastDate
            currentTime <- getCurrentTime
            dateFromUser <- Prelude.getLine
            let date = getDateFromUser currentTime dateFromUser triedLanguage
            case date of
              Left problemWithDate -> TIO.putStrLn problemWithDate
              Right correctDate -> do
                TIO.putStrLn $ messageForUser triedLanguage MessageChooseForecastCity
                TIO.putStrLn $ Data.Text.intercalate ", " $ supportedCities triedLanguage
                cityFromUser <- TIO.getLine
                let city = getCityFromUser cityFromUser triedLanguage
                case city of
                  Nothing -> reportAboutProblem triedLanguage InvalidCity
                  Just correctCity -> do
                    response <- askWeather (correctDate, correctCity)
                    let answer = prepareAnswer triedLanguage response correctDate correctCity
                    TIO.putStrLn answer
                    else return ()
