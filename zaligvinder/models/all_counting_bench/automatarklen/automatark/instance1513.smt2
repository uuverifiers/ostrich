(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^5[1-5][0-9]{14}$
(assert (not (str.in_re X (re.++ (str.to_re "5") (re.range "1" "5") ((_ re.loop 14 14) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}sum/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".sum/i\u{0a}"))))
; /filename=[^\n]*\u{2e}dvr-ms/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".dvr-ms/i\u{0a}")))))
; /^\/[\w-]{48}\.[a-z]{2,8}[0-9]?$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 48 48) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") ((_ re.loop 2 8) (re.range "a" "z")) (re.opt (re.range "0" "9")) (str.to_re "/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
