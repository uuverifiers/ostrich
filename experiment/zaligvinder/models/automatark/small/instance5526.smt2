(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]+(,[0-9]+)*$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.* (re.++ (str.to_re ",") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^(\d{2,3}|\(\d{2,3}\))[ ]?\d{3,4}[-]?\d{3,4}$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 2 3) (re.range "0" "9")) (re.++ (str.to_re "(") ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ")"))) (re.opt (str.to_re " ")) ((_ re.loop 3 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 3 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}pls/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pls/i\u{0a}"))))
(check-sat)
