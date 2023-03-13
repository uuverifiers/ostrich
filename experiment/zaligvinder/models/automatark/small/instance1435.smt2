(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \b[A-z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "A" "z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "%") (str.to_re "-"))) (str.to_re "@") (re.+ (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "-"))) (str.to_re ".") ((_ re.loop 2 4) (re.range "A" "Z")) (str.to_re "\u{0a}")))))
; ^([4]{1})([0-9]{12,15})$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "4")) ((_ re.loop 12 15) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^((http://)|(https://))((([a-zA-Z0-9_-]*).?([a-zA-Z0-9_-]*))|(([a-zA-Z0-9_-]*).?([a-zA-Z0-9_-]*).?([a-zA-Z0-9_-]*)))/?([a-zA-Z0-9_/?%=&+#.-~]*)$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "http://") (str.to_re "https://")) (re.union (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (re.opt re.allchar) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-")))) (re.++ (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (re.opt re.allchar) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (re.opt re.allchar) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))))) (re.opt (str.to_re "/")) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "/") (str.to_re "?") (str.to_re "%") (str.to_re "=") (str.to_re "&") (str.to_re "+") (str.to_re "#") (re.range "." "~"))) (str.to_re "\u{0a}")))))
; /\/home\/index.asp\?typeid\=[0-9]{1,3}/Ui
(assert (str.in_re X (re.++ (str.to_re "//home/index") re.allchar (str.to_re "asp?typeid=") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "/Ui\u{0a}"))))
(check-sat)
