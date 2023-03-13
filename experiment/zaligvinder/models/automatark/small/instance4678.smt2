(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Z]\d{2}(\.\d){0,1}$
(assert (not (str.in_re X (re.++ (re.range "A" "Z") ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^(100([\.\,]0{1,2})?)|(\d{1,2}[\.\,]\d{1,2})|(\d{0,2})$
(assert (str.in_re X (re.union (re.++ (str.to_re "100") (re.opt (re.++ (re.union (str.to_re ".") (str.to_re ",")) ((_ re.loop 1 2) (str.to_re "0"))))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.union (str.to_re ".") (str.to_re ",")) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}gif/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".gif/i\u{0a}"))))
; Host\x3A\dMicrosoft\w+\+Version\+
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "Microsoft") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "+Version+\u{0a}"))))
(check-sat)
