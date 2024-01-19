(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[-+]?\d+(\.\d{2})?$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}xcf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xcf/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
