(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([9]{1})+(6|3|2|1{1})+([0-9]{7})$
(assert (not (str.in_re X (re.++ (re.+ ((_ re.loop 1 1) (str.to_re "9"))) (re.+ (re.union (str.to_re "6") (str.to_re "3") (str.to_re "2") ((_ re.loop 1 1) (str.to_re "1")))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}m4r/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".m4r/i\u{0a}")))))
; /\/click\?sid=\w{40}\&cid=/Ui
(assert (str.in_re X (re.++ (str.to_re "//click?sid=") ((_ re.loop 40 40) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "&cid=/Ui\u{0a}"))))
(check-sat)
