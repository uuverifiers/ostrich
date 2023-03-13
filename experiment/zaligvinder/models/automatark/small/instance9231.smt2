(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((0?[1-9])|((1)[0-1]))?((\.[0-9]{0,2})?|0(\.[0-9]{0,2}))$
(assert (not (str.in_re X (re.++ (re.opt (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "1")))) (re.union (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9")))) (re.++ (str.to_re "0.") ((_ re.loop 0 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^~/[0-9a-zA-Z_][0-9a-zA-Z/_-]*\.[0-9a-zA-Z_-]+$
(assert (str.in_re X (re.++ (str.to_re "~/") (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "_")) (re.* (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "/") (str.to_re "_") (str.to_re "-"))) (str.to_re ".") (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "_") (str.to_re "-"))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}psd/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".psd/i\u{0a}"))))
; [0-9]{3}P[A-Z][0-9]{7}[0-9X]
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "P") (re.range "A" "Z") ((_ re.loop 7 7) (re.range "0" "9")) (re.union (re.range "0" "9") (str.to_re "X")) (str.to_re "\u{0a}"))))
; /\u{2e}dcr([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.dcr") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(check-sat)
