(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d+(\.\d{2})?$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}k3g/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".k3g/i\u{0a}"))))
; ^((\d{5}-\d{4})|(\d{5})|([A-Z]\d[A-Z]\s\d[A-Z]\d))$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (re.range "A" "Z") (re.range "0" "9") (re.range "A" "Z") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.range "0" "9") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; ^[0-9]*$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
; (")([0-9]*)(",")([0-9]*)("\))
(assert (not (str.in_re X (re.++ (str.to_re "\u{22}") (re.* (re.range "0" "9")) (str.to_re "\u{22},\u{22}") (re.* (re.range "0" "9")) (str.to_re "\u{22})\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
