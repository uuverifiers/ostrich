(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\s*
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; ^\$?([A-Za-z]{0,2})\$?([0-9]{0,5}):?\$?([A-Za-z]{0,2})\$?([0-9]{0,5})$
(assert (str.in_re X (re.++ (re.opt (str.to_re "$")) ((_ re.loop 0 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.opt (str.to_re "$")) ((_ re.loop 0 5) (re.range "0" "9")) (re.opt (str.to_re ":")) (re.opt (str.to_re "$")) ((_ re.loop 0 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.opt (str.to_re "$")) ((_ re.loop 0 5) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}dae/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".dae/i\u{0a}")))))
; /filename=[^\n]*\u{2e}aif/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".aif/i\u{0a}"))))
(check-sat)
