(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^([a-z0-9])(([\-.]|[_]+)?([a-z0-9]+))*(@)([a-z0-9])((([-]+)?([a-z0-9]+))?)*((.[a-z]{2,3})?(.[a-z]{2,6}))$/i
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (re.range "a" "z") (re.range "0" "9")) (re.* (re.++ (re.opt (re.union (re.+ (str.to_re "_")) (str.to_re "-") (str.to_re "."))) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))))) (str.to_re "@") (re.union (re.range "a" "z") (re.range "0" "9")) (re.* (re.opt (re.++ (re.opt (re.+ (str.to_re "-"))) (re.+ (re.union (re.range "a" "z") (re.range "0" "9")))))) (str.to_re "/i\u{0a}") (re.opt (re.++ re.allchar ((_ re.loop 2 3) (re.range "a" "z")))) re.allchar ((_ re.loop 2 6) (re.range "a" "z")))))
; /filename=[^\n]*\u{2e}tte/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".tte/i\u{0a}"))))
; /\u{2e}motn([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.motn") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(check-sat)
