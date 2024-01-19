(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}m4p/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".m4p/i\u{0a}")))))
; /\/jdb\/inf\.php\?id=[a-f0-9]{32}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//jdb/inf.php?id=") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}"))))
; .+\.([^.]+)$
(assert (str.in_re X (re.++ (re.+ re.allchar) (str.to_re ".") (re.+ (re.comp (str.to_re "."))) (str.to_re "\u{0a}"))))
; /\u{2e}slk([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.slk") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^[{|\(]?[0-9a-fA-F]{8}[-]?([0-9a-fA-F]{4}[-]?){3}[0-9a-fA-F]{12}[\)|}]?$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "{") (str.to_re "|") (str.to_re "("))) ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (re.opt (str.to_re "-")) ((_ re.loop 3 3) (re.++ ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (re.opt (str.to_re "-")))) ((_ re.loop 12 12) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (re.opt (re.union (str.to_re ")") (str.to_re "|") (str.to_re "}"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
