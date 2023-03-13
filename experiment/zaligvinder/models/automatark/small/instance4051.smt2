(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}manifest([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.manifest") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; (?i:[aeiou]+)\B
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re "a") (str.to_re "e") (str.to_re "i") (str.to_re "o") (str.to_re "u"))) (str.to_re "\u{0a}"))))
; ^[-+]?\d+([.,]\d{0,2}){0,1}$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.+ (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re ".") (str.to_re ",")) ((_ re.loop 0 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}reg/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".reg/i\u{0a}")))))
; IPOblivionhoroscopefowclxccdxn\u{2f}uxwn\.ddy
(assert (str.in_re X (str.to_re "IPOblivionhoroscopefowclxccdxn/uxwn.ddy\u{0a}")))
(check-sat)
