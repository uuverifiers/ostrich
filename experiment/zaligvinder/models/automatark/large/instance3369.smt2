(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([0-1]?[0-9])|([2][0-3])):([0-5][0-9])$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (re.range "0" "1")) (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":\u{0a}") (re.range "0" "5") (re.range "0" "9"))))
; /(^|&)filename=[^&]*?(\u{2e}|%2e){2}([\u{2f}\u{5c}]|%2f|%5c)/Pmi
(assert (str.in_re X (re.++ (str.to_re "/&filename=") (re.* (re.comp (str.to_re "&"))) ((_ re.loop 2 2) (re.union (str.to_re ".") (str.to_re "%2e"))) (re.union (str.to_re "%2f") (str.to_re "%5c") (str.to_re "/") (str.to_re "\u{5c}")) (str.to_re "/Pmi\u{0a}"))))
; ^\(?[\d]{3}\)?[\s-]?[\d]{3}[\s-]?[\d]{4}$
(assert (str.in_re X (re.++ (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^(\d|\d{1,9}|1\d{1,9}|20\d{8}|213\d{7}|2146\d{6}|21473\d{5}|214747\d{4}|2147482\d{3}|21474835\d{2}|214748364[0-7])$
(assert (str.in_re X (re.++ (re.union (re.range "0" "9") ((_ re.loop 1 9) (re.range "0" "9")) (re.++ (str.to_re "1") ((_ re.loop 1 9) (re.range "0" "9"))) (re.++ (str.to_re "20") ((_ re.loop 8 8) (re.range "0" "9"))) (re.++ (str.to_re "213") ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (str.to_re "2146") ((_ re.loop 6 6) (re.range "0" "9"))) (re.++ (str.to_re "21473") ((_ re.loop 5 5) (re.range "0" "9"))) (re.++ (str.to_re "214747") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "2147482") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "21474835") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "214748364") (re.range "0" "7"))) (str.to_re "\u{0a}"))))
; www\x2Eslinkyslate.*Redirector\u{22}.*Host\x3Atoolbarplace\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "www.slinkyslate") (re.* re.allchar) (str.to_re "Redirector\u{22}") (re.* re.allchar) (str.to_re "Host:toolbarplace.com\u{0a}")))))
(check-sat)
