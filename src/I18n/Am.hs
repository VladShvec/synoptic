{-# LANGUAGE OverloadedStrings #-}

module I18n.Am where

import           Data.Text

import           Types.Lang

showMessageInArmenian :: MessageForUser -> Text
showMessageInArmenian MessageChooseForecastDate = "Նշեք կանխատեսման ամսաթիվը"
showMessageInArmenian MessageChooseForecastCity = "Նշեք քաղաքը կանխատեսման համար"
showMessageInArmenian MessageForecast           = "Եղանակի մասին տեղեկություններ: "
showMessageInArmenian On                        = ""
showMessageInArmenian MessageAboutTemperature   = "Ջերմաստիճանը: "
showMessageInArmenian MessageAboutPressure      = " Ճնշումը: "
showMessageInArmenian PressureDesignation       = " տոր "
showMessageInArmenian Humidity                  = "Խոնավությունը: "
showMessageInArmenian MessageErrorWrongDate     = "Դուք անվավեր ամսաթիվ եք մուտքագրել, ուղղեք այն:"
showMessageInArmenian MessageErrorWrongCity     = "Դուք մուտքագրել եք անվավեր քաղաք"
showMessageInArmenian MessageUnexpectedError    = "Ինչ որ բան այնպես չգնաց"
