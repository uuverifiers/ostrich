(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}tif/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".tif/i\u{0a}"))))
; /^\d+$/P
(assert (str.in_re X (re.++ (str.to_re "/") (re.+ (re.range "0" "9")) (str.to_re "/P\u{0a}"))))
; /^\/([a-zA-Z0-9-&+ ]+[^\/?]=){5}/Ui
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 5 5) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "&") (str.to_re "+") (str.to_re " "))) (re.union (str.to_re "/") (str.to_re "?")) (str.to_re "="))) (str.to_re "/Ui\u{0a}"))))
(check-sat)
