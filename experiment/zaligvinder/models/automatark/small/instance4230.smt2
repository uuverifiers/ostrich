(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\$?([A-Za-z]{0,2})\$?([0-9]{0,5}):?\$?([A-Za-z]{0,2})\$?([0-9]{0,5})$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) ((_ re.loop 0 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.opt (str.to_re "$")) ((_ re.loop 0 5) (re.range "0" "9")) (re.opt (str.to_re ":")) (re.opt (str.to_re "$")) ((_ re.loop 0 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.opt (str.to_re "$")) ((_ re.loop 0 5) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Spaccio Moncler,Piumini Moncler,Moncler Piumino,Moncler Giubbotti,Moncler Negozio,Moncler 2011
(assert (not (str.in_re X (str.to_re "Spaccio Moncler,Piumini Moncler,Moncler Piumino,Moncler Giubbotti,Moncler Negozio,Moncler 2011\u{0a}"))))
; hotbar\s+ocllceclbhs\u{2f}gthftpquickbruteUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "hotbar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ocllceclbhs/gthftpquickbruteUser-Agent:\u{0a}")))))
; (\[a url=\"[^\[\]\"]*\"\])([^\[\]]+)(\[/a\])
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re "[") (str.to_re "]"))) (str.to_re "[/a]\u{0a}[a url=\u{22}") (re.* (re.union (str.to_re "[") (str.to_re "]") (str.to_re "\u{22}"))) (str.to_re "\u{22}]"))))
; /filename=[^\n]*\u{2e}pict/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pict/i\u{0a}"))))
(check-sat)
