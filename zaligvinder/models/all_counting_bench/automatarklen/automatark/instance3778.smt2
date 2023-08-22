(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; S\u{3a}Users\u{5c}IterenetSend=User-Agent\x3A
(assert (not (str.in_re X (str.to_re "S:Users\u{5c}IterenetSend=User-Agent:\u{0a}"))))
; (\w+?@\w+?\x2E.+)
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") (re.+ re.allchar)))))
; /\/jdb\/inf\.php\?id=[a-f0-9]{32}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//jdb/inf.php?id=") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}"))))
; ^((\D*[a-z]\D*[A-Z]\D*)|(\D*[A-Z]\D*[a-z]\D*)|(\D*\W\D*[a-z])|(\D*\W\D*[A-Z])|(\D*[a-z]\D*\W)|(\D*[A-Z]\D*\W))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.* (re.comp (re.range "0" "9"))) (re.range "a" "z") (re.* (re.comp (re.range "0" "9"))) (re.range "A" "Z") (re.* (re.comp (re.range "0" "9")))) (re.++ (re.* (re.comp (re.range "0" "9"))) (re.range "A" "Z") (re.* (re.comp (re.range "0" "9"))) (re.range "a" "z") (re.* (re.comp (re.range "0" "9")))) (re.++ (re.* (re.comp (re.range "0" "9"))) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.comp (re.range "0" "9"))) (re.range "a" "z")) (re.++ (re.* (re.comp (re.range "0" "9"))) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.comp (re.range "0" "9"))) (re.range "A" "Z")) (re.++ (re.* (re.comp (re.range "0" "9"))) (re.range "a" "z") (re.* (re.comp (re.range "0" "9"))) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")))) (re.++ (re.* (re.comp (re.range "0" "9"))) (re.range "A" "Z") (re.* (re.comp (re.range "0" "9"))) (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re "\u{0a}")))))
; ^(((\+{1})|(0{2}))98|(0{1}))9[1-9]{1}\d{8}\Z$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union ((_ re.loop 1 1) (str.to_re "+")) ((_ re.loop 2 2) (str.to_re "0"))) (str.to_re "98")) ((_ re.loop 1 1) (str.to_re "0"))) (str.to_re "9") ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
