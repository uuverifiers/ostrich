(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [A-Z][a-z]+
(assert (str.in_re X (re.++ (re.range "A" "Z") (re.+ (re.range "a" "z")) (str.to_re "\u{0a}"))))
; ^(\w+([_.]{1}\w+)*@\w+([_.]{1}\w+)*\.[A-Za-z]{2,3}[;]?)*$
(assert (str.in_re X (re.++ (re.* (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.++ ((_ re.loop 1 1) (re.union (str.to_re "_") (str.to_re "."))) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re "@") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.++ ((_ re.loop 1 1) (re.union (str.to_re "_") (str.to_re "."))) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re ".") ((_ re.loop 2 3) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.opt (str.to_re ";")))) (str.to_re "\u{0a}"))))
; /\/fnts\.html$/U
(assert (str.in_re X (str.to_re "//fnts.html/U\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
