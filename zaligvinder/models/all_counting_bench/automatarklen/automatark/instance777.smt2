(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[a-z]+\.jat/
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.+ (re.range "a" "z")) (str.to_re ".jat/\u{0a}"))))
; doarauzeraqf\u{2f}vvv\.ul
(assert (not (str.in_re X (str.to_re "doarauzeraqf/vvv.ul\u{0a}"))))
; HTTPwwwProbnymomspyo\u{2f}zowy
(assert (not (str.in_re X (str.to_re "HTTPwwwProbnymomspyo/zowy\u{0a}"))))
; \A(.*?)\s+(\d+[a-zA-Z]{0,1}\s{0,1}[-]{1}\s{0,1}\d*[a-zA-Z]{0,1}|\d+[a-zA-Z-]{0,1}\d*[a-zA-Z]{0,1})
(assert (str.in_re X (re.++ (re.* re.allchar) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.++ (re.+ (re.range "0" "9")) (re.opt (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 1) (str.to_re "-")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.range "0" "9")) (re.opt (re.union (re.range "a" "z") (re.range "A" "Z")))) (re.++ (re.+ (re.range "0" "9")) (re.opt (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "-"))) (re.* (re.range "0" "9")) (re.opt (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
