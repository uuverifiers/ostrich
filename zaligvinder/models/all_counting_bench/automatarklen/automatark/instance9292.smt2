(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1][12]|[0]?[1-9])[\/-]([3][01]|[12]\d|[0]?[1-9])[\/-](\d{4}|\d{2})$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.union (str.to_re "1") (str.to_re "2"))) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9"))) (re.union (str.to_re "/") (str.to_re "-")) (re.union (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1"))) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (re.opt (str.to_re "0")) (re.range "1" "9"))) (re.union (str.to_re "/") (str.to_re "-")) (re.union ((_ re.loop 4 4) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; ^(100([\.\,]0{1,2})?)|(\d{1,2}[\.\,]\d{1,2})|(\d{0,2})$
(assert (not (str.in_re X (re.union (re.++ (str.to_re "100") (re.opt (re.++ (re.union (str.to_re ".") (str.to_re ",")) ((_ re.loop 1 2) (str.to_re "0"))))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (re.union (str.to_re ".") (str.to_re ",")) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; ([^\w]+)|([^A-Za-z])|(\b[^aeiouy]+\b)|(\b(\w{2})\b)
(assert (not (str.in_re X (re.union (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.+ (re.union (str.to_re "a") (str.to_re "e") (str.to_re "i") (str.to_re "o") (str.to_re "u") (str.to_re "y"))) (re.++ ((_ re.loop 2 2) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")) (re.range "A" "Z") (re.range "a" "z")))))
; ^[A-Z].*$
(assert (str.in_re X (re.++ (re.range "A" "Z") (re.* re.allchar) (str.to_re "\u{0a}"))))
; /\/vic\.aspx\?ver=\d\.\d\.\d+\.\d\u{26}rnd=\d{5}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//vic.aspx?ver=") (re.range "0" "9") (str.to_re ".") (re.range "0" "9") (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re ".") (re.range "0" "9") (str.to_re "&rnd=") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
