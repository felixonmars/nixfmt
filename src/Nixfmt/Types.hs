module Nixfmt.Types where

import           Data.Text       hiding (concat, map)
import           Data.Void
import           Text.Megaparsec (Parsec)

type Parser = Parsec Void Text

data Trivium = EmptyLine
             | LineComment     Text
             | BlockComment    [Text]
             deriving (Eq, Show)

type Trivia = [Trivium]

data AST n l = Node n [AST n l]
             -- | A token followed by an optional trailing comment
             | Leaf l (Maybe Text)
             | Trivia Trivia
             deriving (Eq)

type NixAST = AST NodeType NixToken

data NodeType
    = Abstraction
    | Apply
    | Assert
    | Assignment
    | ContextParameter
    | FieldParameter
    | File
    | IfElse
    | Inherit
    | Let
    | List
    | Set
    | SetParameter
    | With
    deriving (Eq, Show)

data NixToken
    = EnvPath    Text
    | Identifier Text
    | NixFloat   Text
    | NixInt     Int
    | NixText    Text
    | NixURI     Text

    | TAssert
    | TElse
    | TIf
    | TIn
    | TInherit
    | TLet
    | TRec
    | TThen
    | TWith

    | TBraceOpen
    | TBraceClose
    | TBrackOpen
    | TBrackClose
    | TParenOpen
    | TParenClose

    | TAssign
    | TAt
    | TColon
    | TComma
    | TDot
    | TEllipsis
    | TQuestion
    | TSemicolon

    | TConcat
    | TNegate
    | TMerge

    | TAdd
    | TSub
    | TMul
    | TDiv

    | TAnd
    | TEqual
    | TImplies
    | TLess
    | TLessOrEqual
    | TGreater
    | TGreaterOrEqual
    | TNotEqual
    | TOr

    | TEOF
    deriving (Eq)

instance (Show n, Show l) => Show (AST n l) where
    show (Leaf l Nothing)  = show l
    show (Leaf l (Just c)) = show l <> show "/*" <> show c <> show "*/"
    show (Trivia ts)       = show ts
    show (Node n xs)       = concat
        [ show n
        , "("
        , concat $ map show xs
        , ")"
        ]

instance Show NixToken where
    show (Identifier s) = show s
    show (EnvPath p)    = show p
    show (NixFloat f)   = show f
    show (NixInt i)     = show i
    show (NixURI uri)   = show uri
    show (NixText text) = show text

    show TAssert        = "assert"
    show TElse          = "else"
    show TIf            = "if"
    show TIn            = "in"
    show TInherit       = "inherit"
    show TLet           = "let"
    show TRec           = "rec"
    show TThen          = "then"
    show TWith          = "with"

    show TBraceOpen     = "{"
    show TBraceClose    = "}"
    show TBrackOpen     = "["
    show TBrackClose    = "]"
    show TParenOpen     = "("
    show TParenClose    = ")"

    show TComma         = ","
    show TAssign        = "="
    show TAt            = "@"
    show TColon         = ":"
    show TComma         = ","
    show TDot           = "."
    show TEllipsis      = "..."
    show TQuestion      = "?"
    show TSemicolon     = ";"

    show TEOF           = ""