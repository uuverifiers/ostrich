(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}swf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".swf/i\u{0a}"))))
; \d{2,4}
(assert (not (str.in_re X (re.++ ((_ re.loop 2 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; gpstool\u{2e}globaladserver\u{2e}com\daction\x2E\w+data2\.activshopper\.com
(assert (not (str.in_re X (re.++ (str.to_re "gpstool.globaladserver.com") (re.range "0" "9") (str.to_re "action.") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "data2.activshopper.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
