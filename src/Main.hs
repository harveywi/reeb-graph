module Main where

import qualified Data.ByteString as B
import qualified Data.Text       as T
import qualified Data.Text.Encoding as E
import Data.Text.Encoding.Error (lenientDecode)
import System.Environment
import Off
import Algorithm

main :: IO ()
main = 
  do 
    args <- getArgs
    case args of
      coordFlag : inputFilePath : [] ->
        case parseFunctionCoordinate coordFlag of
          Left err        -> putStrLn err
          Right funcCoord ->
            do
              inputLines <- readInputFile inputFilePath
              case parseOffFile inputLines funcCoord of
                Left err        -> putStrLn err
                Right triangles -> putStrLn $ show $ reebGraph triangles
      otherwise    -> putStrLn usage

usage :: [Char]
usage = 
  "Usage: reeb-graph (-x|-y|-z) input-file.off\n\
  \  \n\
  \  The first argument (required) indicates which coordinate of a\n\
  \  vertex will be treated as its function value.\n\
  \  \n\
  \  The second argument (required) specifies the OFF-format input\n\
  \  file to process."

parseFunctionCoordinate :: [Char] -> Either [Char] FunctionCoordinate
parseFunctionCoordinate str =
  case str of
    "-x" -> Right X
    "-y" -> Right Y
    "-z" -> Right Z
    _    -> Left $ "Invalid command-line argument: Expected (-x|-y|-z) but found '" ++ str ++ "'"

readInputFile :: FilePath -> IO [[Char]]
readInputFile filePath = 
  do
    byteString <- B.readFile filePath
    return $ lines $ T.unpack $ E.decodeUtf8With lenientDecode byteString