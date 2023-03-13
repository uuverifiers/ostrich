(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /(^|&)filename=[^&]*?(\u{2e}|%2e){2}([\u{2f}\u{5c}]|%2f|%5c)/Pmi
(assert (not (str.in_re X (re.++ (str.to_re "/&filename=") (re.* (re.comp (str.to_re "&"))) ((_ re.loop 2 2) (re.union (str.to_re ".") (str.to_re "%2e"))) (re.union (str.to_re "%2f") (str.to_re "%5c") (str.to_re "/") (str.to_re "\u{5c}")) (str.to_re "/Pmi\u{0a}")))))
; ^[13][a-zA-Z0-9]{26,33}$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "1") (str.to_re "3")) ((_ re.loop 26 33) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}pjpeg/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".pjpeg/i\u{0a}")))))
(check-sat)
