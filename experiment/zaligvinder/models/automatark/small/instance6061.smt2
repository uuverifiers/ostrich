(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; toolbarplace\x2Ecom.*Host\x3A\dgpstool\u{2e}globaladserver\u{2e}com
(assert (not (str.in_re X (re.++ (str.to_re "toolbarplace.com") (re.* re.allchar) (str.to_re "Host:") (re.range "0" "9") (str.to_re "gpstool.globaladserver.com\u{0a}")))))
; /(^|&)filename=[^&]*?(\u{2e}|%2e){2}([\u{2f}\u{5c}]|%2f|%5c)/Pmi
(assert (not (str.in_re X (re.++ (str.to_re "/&filename=") (re.* (re.comp (str.to_re "&"))) ((_ re.loop 2 2) (re.union (str.to_re ".") (str.to_re "%2e"))) (re.union (str.to_re "%2f") (str.to_re "%5c") (str.to_re "/") (str.to_re "\u{5c}")) (str.to_re "/Pmi\u{0a}")))))
(check-sat)
