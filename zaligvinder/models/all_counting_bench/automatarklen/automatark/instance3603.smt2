(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\$( )*\d*(.\d{1,2})?$
(assert (not (str.in_re X (re.++ (str.to_re "$") (re.* (str.to_re " ")) (re.* (re.range "0" "9")) (re.opt (re.++ re.allchar ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^[0-9a-zA-Z]+([0-9a-zA-Z]*[-._+])*[0-9a-zA-Z]+@[0-9a-zA-Z]+([-.][0-9a-zA-Z]+)*([0-9a-zA-Z]*[.])[a-zA-Z]{2,6}$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.++ (re.* (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (re.union (str.to_re "-") (str.to_re ".") (str.to_re "_") (str.to_re "+")))) (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "@") (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.++ (re.union (str.to_re "-") (str.to_re ".")) (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))))) ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}") (re.* (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "."))))
; /filename=[^\n]*\u{2e}flac/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".flac/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
