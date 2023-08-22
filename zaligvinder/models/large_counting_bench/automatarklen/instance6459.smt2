(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}bmp/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".bmp/i\u{0a}"))))
; ^([0-9]|0[0-9]|1[0-9]|2[0-3]):([0-9]|[0-5][0-9])$
(assert (not (str.in_re X (re.++ (re.union (re.range "0" "9") (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":") (re.union (re.range "0" "9") (re.++ (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}exe/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".exe/i\u{0a}")))))
; /\u{2f}[A-F0-9]{158}/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 158 158) (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
(assert (< 200 (str.len X)))
(check-sat)
