(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}otf([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.otf") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; /filename=[^\n]*\u{2e}ppt/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ppt/i\u{0a}"))))
; ^(20|21|22|23|[01]\d|\d)(([:.][0-5]\d){1,2})$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "20") (str.to_re "21") (str.to_re "22") (str.to_re "23") (re.++ (re.union (str.to_re "0") (str.to_re "1")) (re.range "0" "9")) (re.range "0" "9")) ((_ re.loop 1 2) (re.++ (re.union (str.to_re ":") (str.to_re ".")) (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; isSAH\*Agentwww\.raxsearch\.comHost\x3A-~-\u{22}The
(assert (not (str.in_re X (str.to_re "isSAH*Agentwww.raxsearch.comHost:-~-\u{22}The\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
